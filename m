Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2ARSLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:11:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53542 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932327Ab2ARSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:10:58 -0500
Date: Wed, 18 Jan 2012 13:10:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Luck, Tony" <tony.luck@intel.com>
cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: RE: [PATCH] mce: fix warning messages about static struct mce_device
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, Luck, Tony wrote:

> Greg said:
> > It was already fixed that way, but the problem is that you can not have
> > statically allocated 'struct device' objects in the system.
> 
> and then Alan said:
> > There's an additional requirement: Device structures may not be reused.  
> > Not even if the caller clears all the fields to 0 in between.  That was
> > the real bug in the original code -- and adding a dummy release routine
> > wouldn't fix it.
> 
> There seems to be some curious logic happening here which I don't understand
> at all. How can the code that deals with 'struct device' tell whether it was
> statically declared or dynamically allocated? Why would it care?
> 
> What happens if we play by the rules using a dynamic structure and do
> 
>  device_register() + device_create_file(dev)
>    ...
>  device_remove_file(dev) + device_unregister()
> 
> then later come back to re-add this and by pure random fluke kzalloc()
> gives us back the exact same block of memory that we used for dev before?

Okay, that's a reasonable question.

> By Alan's logic we are screwed - we are re-using the same device structure
> (unless kfree() + kzalloc() does some magic pixie dust thing so that this
> same block of memory is now not the same device structure we had before, even
> though it has the same address).

No, it's a new structure that just happens to occupy the same address
as the old structure.  :-)  The real point is that kzalloc() won't give
you that address for the new structure before kfree() has deallocated
the old one.

Normally kfree() would be called by the release routine.  Therefore if
kzalloc() gives you the same address, you can be sure that the release
routine has run.  The problem with statically allocated device
structures is that they generally don't have release routines (as in
this MCE case).

Now if you had a static structure and you gave it a release routine
then yes -- you could reuse it _provided_ you waited for the release
routine to be called first.  But that's not under your control; the
release routine won't be called until all the references have been
dropped, which can take an arbitrarily long time.  It's better to avoid 
the whole issue by not using static allocation.

> In summary - I can totally buy the argument that you must start with a zeroed
> struct device (and that it is just fine that device_unregister() doesn't waste
> cpu cycles cleaning up the structure just in case someone will re-use it, because
> that isn't going to be the common case).
> 
> I just don't understand the magical difference between a static structure that
> has been memset() to all zero, and a dynamic block returned from kzalloc().

The difference is that a block returned from kzalloc() is _known_ not
to have any pre-existing references.  A static structure that has been
reset to all zero may still have some; in general you can't know.

There's nothing special about the driver model code in this respect.  
The same restriction applies wherever object lifetimes are controlled
by reference counting.

Alan Stern

