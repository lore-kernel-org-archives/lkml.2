Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab2DZSOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:14:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52871 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754270Ab2DZSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:14:32 -0400
Date: Thu, 26 Apr 2012 14:14:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <m162cmewmy.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.1204261153320.1530-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, Eric W. Biederman wrote:

> Tejun Heo <tj@kernel.org> writes:
> 
> > Hello, Alan.
> >
> > On Wed, Apr 25, 2012 at 02:58:28PM -0400, Alan Stern wrote:
> >> Peter and Tejun:
> >> 
> >> Here's my problem, which affects several sysfs attribute methods in the 
> >> USB subsystem:
> >> 
> >> Sysfs attribute A is attached to a USB device D.  When the user writes
> >> to A, the corresponding store method unregisters D's children (it does
> >> not unregister D, though).
> >> 
> >> Now, some of these children may also be USB devices (i.e., if D is a
> >> hub), and therefore may have the same set of sysfs attributes.  As a
> >> result, A's store method for D will end up removing the A attribute for
> >> device E, where E is a child of D.
> 
> Before we get too far getting lockdep to shut up let me ask.  Is this
> really safe?  The code looks like it tries to be safe but in the case
> of recursion I don't buy it.  You should be having this same problem
> with other locks and I don't see the use of mutex_lock_nested anywhere.

You're right, of course.  In the USB subsystem, configuration changes
(which are what I was talking about above) and device unregistration
are protected by the mutex of the underlying struct device.  Thus,
you're not allowed to change a device's configuration (which in the
case of a hub would end up unregistering all the children) unless you
already hold the device's lock, and you're not allowed to unregister a
USB device unless you already hold its parent's lock.

The reason this doesn't provoke any objections from lockdep is very 
simple: The mutex in struct device is explicitly set to the 
"novalidate" class in device_initialize().  Therefore lockdep 
essentially ignores it.

We did this because after a fair amount of back-and-forth discussion,
Peter and I were unable to come up with a good way of treating the
tree-structured locks in the device hierarchy.  (Actually it's a
forest, not a tree, which makes the situation even worse.)

I don't know of any other locks using the "novalidate" class, but I
haven't looked to see.  In any case, the locks used by sysfs do _not_
belong to this class, which is a good thing because we really do want
to catch cases where an attribute's method tries to remove that same
attribute -- so-called "suicidal" attributes.

But that's not what's happening here.  In this situation, attribute A
for device D wants to remove attribute A for device E, not for D.  
This is safe, not suicidal, but there's currently no way to tell 
lockdep.

Does this answer your question?  I'm not quite certain what you were 
asking.

> I looked into this a couple years ago with regards to pci devices, and
> my conclusion at the time was that the device core nor the pci
> code was multi-thread hotplug safe, and that the easiest fix was
> to use a single threaded workqueue.

As far as I know, the device core and the USB core are both
multi-thread hotplug safe.  I'm not as familiar with the PCI core.

> What I see right now with the device_lock and usb looks better but
> I'm not at all certain I believe that if you attempt to remove different
> levels of the hierarchy at the same time from different processes
> that this code is really safe.  Could you explain to me how the
> locking works in the usb layer to prevent problems with different
> processes removing different layers of the same hierarchy?
> 
> Especially having it work without having having to do something
> interesting with lockdep.

The locking rules are explained above.

Let's consider an example.  Suppose we have A - B - C, where A is the 
parent of B and B is the parent of C.  Suppose thread 1 tries to remove 
B and concurrently, thread 2 tries to remove C.

The resulting course of events depends on which thread acquires B's
mutex first.  Here's one possibility:

	Thread 1			Thread 2
	--------			--------
	usb_lock_device(A)		usb_lock_device(B)
	usb_disconnect(B)		usb_disconnect(C)
	  usb_lock_device(B) (blocks)	  usb_lock_device(C)
					  ... various housekeeping ...
					  usb_unlock_device(C)
					  device_del(&C->dev)
					  put_device(&C->dev)
					usb_unlock_device(B)
	  (acquires B's mutex)
	  ... various housekeeping, including:
	    remove any children of B (but C is
	    not a child of B any more)
	  ... end of housekeeping
	  usb_unlock_device(B)
	  device_del(&B->dev)
	  put_device(&B->dev)
	usb_unlock_device(A)

Here's the other:

	Thread 1			Thread 2
	--------			--------
	usb_lock_device(A)
	usb_disconnect(B)
	  usb_lock_device(B)
	  ... various housekeeping, including:
	    usb_set_device_state(B, USB_STATE_NOTATTACHED)
	    usb_disconnect(C) (recursive call)
	      usb_lock_device(C)
	      ... various housekeeping ...
	      usb_unlock_device(C)	usb_lock_device(B) (blocks)
	      device_del(&C->dev)
	      put_device(&C->dev)
	  ... end of housekeeping
	  usb_unlock_device(B)
					(acquires B's mutex)
	  device_del(&B->dev)		Sees that B's state is now
					USB_STATE_NOTATTACHED, so does
					not try to do anything about C
					usb_unlock_device(B)
	  put_device(&B->dev)
	usb_unlock_device(A)	

Note that device_del() internally grabs the device's mutex, so thread
1's put_device(&B->dev) doesn't occur until after thread 2 unlocks B.

> >> This causes lockdep to complain.  When A's method is called, sysfs
> >> tells lockdep that it holds a readlock for the s_active "rwsem"
> >> associated with the A attribute for D.  However the sysfs routine that
> >> removes attributes tells lockdep that it is going to get a writelock
> >> for the s_active associated with the A attribute for E, which is in the
> >> same lockdep class since it belongs to the same attribute.
> >
> > Hmmm.... This happens because, by default, sysfs_dirents for the same
> > attr share the same lockdep key.  This happens from
> > sysfs_dirent_init_lockdep().  Hmm.... we can,
> >
> > * Somehow assign different keys to sysfs_dirents for the specific
> >   attr.  Use array of attrs indexed by bus depth?
> 
> Possible with sysfs_attr_init but pretty ugly.  Especially since it
> sounds like this is a situation that does not presuppose a maximum
> depth.  I do remember that the lockdep keys must be statically allocated
> which makes this a challenge.

I agree; this doesn't seem like a good approach.

> Or it might be a remote possibility to adapt things a little bit.
> What makes this different from most of the recursing lock strategies
> that I know of is that we are actually in fact taking the same
> "lock" in the same place, and performing the same action.

Well, not exactly the same place.  The readlock is acquired in 
sysfs_get_active() and the writelock is acquired in sysfs_deactivate().

> > * Add a flag / whatever to attr indicating that the files of the
> >   attribute may be removed recursively (lockdep-wise) and update
> >   either read or write path to use subclass.
> >
> > Any better ideas?
> 
> I'm not going to worry about it too much until someone explains to me
> how usb hotplug is really safe and how of all the locks taken to
> make it happen somehow only the sysfs lock triggers a lockdep warning
> because we are recursing.  We should be seeing the same issue with
> the device lock if the device lock actually provides sufficient
> protection to be useful.

Another idea is to have A's method temporarily drop the sysfs readlock.  
Of course that would put the onus on the USB core of guaranteeing that
A cannot be removed while this happens, but we can handle that.

Alan Stern

