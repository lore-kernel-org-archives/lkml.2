Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2AYXp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:45:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2AYXp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:45:26 -0500
Message-ID: <1327535093.26484.190.camel@bling.home>
Subject: Re: [Qemu-devel] [RFC] Device isolation infrastructure v2
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Joerg Roedel <joerg.roedel@amd.com>, aik@ozlabs.ru,
        benh@kernel.crashing.org, dwmw2@infradead.org, chrisw@redhat.com,
        agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
        rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, joro@8bytes.org
Date: Wed, 25 Jan 2012 16:44:53 -0700
In-Reply-To: <20120125031328.GC13830@truffala.fritz.box>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
	 <1323972307.2437.19.camel@x201.home> <20111216145353.GA29877@amd.com>
	 <20111219001125.GA30390@truffala.fritz.box>
	 <20111219154156.GG29877@amd.com> <20111221033235.GA4537@truffala.fritz.box>
	 <1324441837.29699.38.camel@bling.home>
	 <20120125031328.GC13830@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 14:13 +1100, David Gibson wrote:
> On Tue, Dec 20, 2011 at 09:30:37PM -0700, Alex Williamson wrote:
> > On Wed, 2011-12-21 at 14:32 +1100, David Gibson wrote:
> > > On Mon, Dec 19, 2011 at 04:41:56PM +0100, Joerg Roedel wrote:
> > > > On Mon, Dec 19, 2011 at 11:11:25AM +1100, David Gibson wrote:
> > > > > Well.. that's not where it is in Alex's code either.  The iommu layer
> > > > > (to the extent that there is such a "layer") supplies the group info,
> > > > > but the group management is in vfio, not the iommu layer.  With mine
> > > > > it is in the driver core because the struct device seemed the logical
> > > > > place for the group id.
> > > > 
> > > > Okay, seems we have different ideas of what the 'grouping code' is. I
> > > > talked about the group enumeration code only. But group handling code is
> > > > certainly important to some degree too. But before we argue about the
> > > > right place of the code we should agree on the semantics such code
> > > > should provide.
> > > > 
> > > > For me it is fine when the code is in VFIO for now, since VFIO is the
> > > > only user at the moment. When more users pop up we can easily move it
> > > > out to somewhere else. But the semantics influence the interface to
> > > > user-space too, so it is more important now. It splits up into a number
> > > > of sub problems:
> > > > 
> > > > 	1) How userspace detects the device<->group relationship?
> > > > 	2) Do we want group-binding/unbinding to device drivers?
> > > > 	3) Group attach/detach to iommu-domains?
> > > > 	4) What to do with hot-added devices?
> > > > 
> > > > For 1) I think the current solution with the iommu_group file is fine.
> > > > It is somewhat expensive for user-space to figure out the per-group
> > > > device-sets, but that is a one-time effort so it doesn't really matter.
> > > > Probably we can rename 'iommu_group' to 'isolation_group' or
> > > > something.
> > > 
> > > Hrm.  Alex's group code also provides no in-kernel way to enumerate a
> > > group, short of walking every device in the system.  And it provides
> > > no way to attach information to a group.  It just seems foolish to me
> > > to have this concept without some kind of in-kernel handle on it, and
> > 
> > Who else needs to enumerate groups right now?  Who else needs to attach
> > data to a group.  We seem to be caught in this loop of arguing that we
> > need driver core based group management, but we don't have any plans to
> > make use of it, so it just bloats the kernel for most of the users that
> > don't care about it.
> 
> So, Ben and I discussed this with David Woodhouse during
> linux.conf.au.  He does want to update the core iommu_ops and dma_ops
> handling to be group aware, and is willing to do the work for that.
> So I will be doing another spin of my isolation code as a basis for
> that work of his.  So there's our other user.

Hmm...

> > > if you're managing the in-kernel representation you might as well
> > > expose it to userspace there as well.
> > 
> > Unfortunately this is just the start a peeling back layers of the onion.
> > We manage groups in the driver core, so the driver core should expose
> > them to userspace.  The driver core exposes them to userspace, so now it
> > needs to manage permissions for userspace.
> 
> That doesn't necessarily follow.  The current draft has the core group
> code export character devices on which permissions are managed, but
> I'm also considering options where it only exports sysfs and something
> else does the character device and permissions.

Let's start to define it then.  A big problem I have with the isolation
infrastructure you're proposing is that it doesn't have well defined
bounds or interfaces.  It pulls devices out of the normal driver model,
and even goes so far as to start exposing chardevs for groups to
userspace.  The former feels like completely the wrong approach and the
latter oversteps the bounds of a core interface for a very niche usage,
IMO.

Your argument for making groups more pervasive is that the iommu drivers
need to know about them already and we should make use of groups in the
dma_ops and iommu_ops interfaces.  Fine, that seems reasonable and I
assume is what Woodhouse has agreed to work on.  I don't however see
that as an argument for creating a group driver class or isolation API.
In fact, we could probably layer a fairly similar version of vfio on top
of "group enlightened" driver core with minimal changes.

> >  Then we add permissions and
> > now we need to provide group access, then we need a channel to an actual
> > userspace device driver, zing! we add a whole API there,
> 
> And the other option I was looking add had the core providing the char
> device but having it's fops get passed straight through to the binder.

I'm not a fan of that idea.  Core driver code should not be creating
chardevs and I doubt anyone is onboard with the idea of a chardev with
an arbitrary API bound behind it.

> > then we need
> > group driver binding, then we need group device driver binding, blam!
> > another API, then we need...  I don't see a clear end marker that
> > doesn't continue to bloat the core and add functionality that nobody
> > else needs and we don't even have plans of integrating more pervasively.
> > This appears to end with 80 to 90% of the vfio core code moving into the
> > driver core.
> 
> I don't agree.  Working out the right boundary isn't totally obvious,
> certainly, but that doesn't mean a reasonable boundary can't be found.

So let's define it.  Why do you think the driver core should expose
anything more than a sysfs representation of groups to userspace?

> > 
> > > > Regarding 2), I think providing user-space a way to unbind groups of
> > > > devices from their drivers is a horrible idea.
> > > 
> > > Well, I'm not wed to unbinding all the drivers at once.  But what I
> > > *do* think is essential is that we can atomically switch off automatic
> > > driver matching for the whole group.  Without that nothing really
> > > stops a driver reattaching to the things you've unbound, so you end up
> > > bailing a leakey boat.
> > 
> > Huh?  There is no issue with removing a device from one driver and
> > attaching it to another.  This happens all the time.  If you're talking
> > about hotplug, all we have to do is sit on the bus notifier chain and we
> > get called when devices are added, before the driver has a chance to
> > attach.  We can then force a vfio driver to attach when needed.
> 
> But what is the transition point at which you know force attaching a
> vfio driver is the right thing?

It's quite simple.  The vfio bus driver does a bus_register_notifier()
and watches for BUS_NOTIFY_ADD_DEVICE.  At that point it registers the
device with the vfio core.  The vfio core retrieves the group
information for the device and matches it to a struct vfio_group.  When
the user makes use of the vfio group they get file descriptors for each
device and another for the iommu.  vfio therefore simply needs to check
if there are any open file descriptors for devices or iommu to determine
the newly added device needs to be bound to vfio.  There is actually
code for this, feel free to find it in my trees.

> My draft does that atomically with
> unbinding the existing drivers.  But you have a fair point about that
> causing devices to disappear surprisingly, so I think I'll change that
> so that it instead becomes 3 step: first prevent new drivers
> auto-binding to things in the group, then explicitly unbind existing
> drivers, then grab the group for userspace access.

This is where I get confused, even if there are uses in the driver core
for understanding groups, what business does the driver core have for
exposed groups for userspace access?  I think that crosses the logical
boundary and where we start peeling back layers of the onion for
everything that entails.

> >  Hell,
> > we can just set dev->driver to something to prevent standard driver
> > probing.
> 
> > > > It makes it too easy for
> > > > the user to shoot himself in the foot. For example when the user wants
> > > > to assign a network card to a guest, but that card is in the same group
> > > > as the GPU and the screen wents blank when the guest is started.
> > > > Requiring devices to be unbound one-by-one is better because this way
> > > > the user always needs to know what he is doing.
> > > 
> > > Ok, that's not the usage model I had in mind.  What I'm thinking here
> > > is that the admin removes groups that will be used in guests from the
> > > host kernel (probably via boot-time scripts).  The guests will pick
> > > them up later, so that when a guest quits then restarts, we don't have
> > > devices appearing transiently in the host.
> > 
> > I don't think that model is dynamic enough for our existing use cases.
> > A user shouldn't need to decide at boot time which devices are going to
> > be used for what purpose.  It's entirely valid for a user to start up a
> > VM, decide they want more network performance and reassign a NIC from
> > host use to guest use.  When they shutdown the VM or hot-unplug it, they
> > should be able to easily put it back to work on the host.
> 
> Well, sure, you can do that too.  But I bet you the more common usage
> model for production will be to have most of the hardware assigned to
> a particular guest on a long term basis.

I don't doubt that that's the common usage, but it's a very poor model
to aim for and call "good enough".

> [snip]
> > > > So what does this mean for point 3? I think we can implement attaching
> > > > and detaching groups in the iommu-api. This interface is not exposed to
> > > > userspace and can help VFIO and possible future users. Semantic is, that
> > > > domain_attach_group() only works when all devices in the group are in
> > > > their default domain and domain_detach_group() puts them back into the
> > > > default domain.
> > > 
> > > The domain_{attach,detach} functions absolutely should be group based
> > > not device based.  That's what it means to be a group.
> > 
> > Yet we have no plans to make that change...
> 
> David Woodhouse does now.

Great, let's see it.

Thanks,

Alex


