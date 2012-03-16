Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031459Ab2CPDph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:45:37 -0400
Received: from ozlabs.org ([203.10.76.45]:33195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031090Ab2CPDpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:45:32 -0400
Date: Fri, 16 Mar 2012 14:45:27 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Isolation groups
Message-ID: <20120316034527.GJ24916@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	aik@ozlabs.ru, dwmw2@infradead.org,
	iommu@lists.linux-foundation.org, benh@kernel.crashing.org,
	qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120312220109.30321.83419.stgit@bling.home>
 <20120312223254.30321.74405.stgit@bling.home>
 <20120313143340.GT24916@truffala.fritz.box>
 <1331657387.2969.79.camel@bling.home>
 <20120314095808.GX24916@truffala.fritz.box>
 <1331842501.22038.58.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331842501.22038.58.camel@ul30vt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 02:15:01PM -0600, Alex Williamson wrote:
> On Wed, 2012-03-14 at 20:58 +1100, David Gibson wrote:
> > On Tue, Mar 13, 2012 at 10:49:47AM -0600, Alex Williamson wrote:
> > > On Wed, 2012-03-14 at 01:33 +1100, David Gibson wrote:
> > > > On Mon, Mar 12, 2012 at 04:32:54PM -0600, Alex Williamson wrote:
> > > > > +/*
> > > > > + * Add a device to an isolation group.  Isolation groups start empty and
> > > > > + * must be told about the devices they contain.  Expect this to be called
> > > > > + * from isolation group providers via notifier.
> > > > > + */
> > > > 
> > > > Doesn't necessarily have to be from a notifier, particularly if the
> > > > provider is integrated into host bridge code.
> > > 
> > > Sure, a provider could do this on it's own if it wants.  This just
> > > provides some infrastructure for a common path.  Also note that this
> > > helps to eliminate all the #ifdef CONFIG_ISOLATION in the provider.  Yet
> > > to be seen whether that can reasonably be the case once isolation groups
> > > are added to streaming DMA paths.
> > 
> > Right, but other than the #ifdef safety, which could be achieved more
> > simply, I'm not seeing what benefit the infrastructure provides over
> > directly calling the bus notifier function.  The infrastructure groups
> > the notifiers by bus type internally, but AFAICT exactly one bus
> > notifier call would become exactly one isolation notifier call, and
> > the notifier callback itself would be almost identical.
> 
> I guess I don't see this as a fundamental design point of the proposal,
> it's just a convenient way to initialize groups as a side-band addition
> until isolation groups become a more fundamental part of the iommu
> infrastructure.  If you want to do that level of integration in your
> provider, do it and make the callbacks w/o the notifier.  If nobody ends
> up using them, we'll remove them.  Maybe it will just end up being a
> bootstrap.  In the typical case, yes, one bus notifier is one isolation
> notifier.  It does however also allow one bus notifier to become
> multiple isolation notifiers, and includes some filtering that would
> just be duplicated if every provider decided to implement their own bus
> notifier.

Uh.. I didn't notice any filtering?  That's why I'm asking.

> > > > > +int isolation_group_add_dev(struct isolation_group *group, struct device *dev)
> > > > > +{
> > > > > +	struct isolation_device *device;
> > > > > +	int ret = 0;
> > > > > +
> > > > > +	mutex_lock(&isolation_lock);
> > > > > +
> > > > > +	if (dev->isolation_group) {
> > > > > +		ret = -EBUSY;
> > > > > +		goto out;
> > > > 
> > > > This should probably be a BUG_ON() - the isolation provider shouldn't
> > > > be putting the same device into two different groups.
> > > 
> > > Yeah, probably.
> > > 
> > > > > +	}
> > > > > +
> > > > > +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> > > > > +	if (!device) {
> > > > > +		ret = -ENOMEM;
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	device->dev = dev;
> > > > > +
> > > > > +	/* Cross link the device in sysfs */
> > > > > +	ret = sysfs_create_link(&dev->kobj, &group->kobj,
> > > > > +				"isolation_group");
> > > > > +	if (ret) {
> > > > > +		kfree(device);
> > > > > +		goto out;
> > > > > +	}
> > > > > +	
> > > > > +	ret = sysfs_create_link(group->devices_kobj, &dev->kobj,
> > > > > +				kobject_name(&dev->kobj));
> > > > 
> > > > So, a problem both here and in my version is what to name the device
> > > > links.  Because they could be potentially be quite widely scattered,
> > > > I'm not sure that kobject_name() is guaranteed to be sufficiently
> > > > unique.
> > > 
> > > Even if the name is not, we're pointing to a unique sysfs location.  I
> > > expect the primary user of this will be when userspace translates a
> > > device to a group (via the isolation_group link below), then tries to
> > > walk all the devices in the group to determine effected host devices and
> > > manager driver status.  So it would probably be traversing the link back
> > > rather than relying solely on the name of the link.  Right?
> > 
> > Yes, but if we get a duplicate kobject_name() we could get duplicate
> > link names within the same directory so we're still in trouble.  We
> > could replace the names with just an index number.
> 
> This seems exceptionally unlikely, doesn't it?

Hmm, I don't think I have enough data to judge it particularly
unlikely.  Just that it's possible.

>  Maybe
> sysfs_create_link() will fail in such a case as we can append some
> identifier to the name?

That could work.

> > > > > +	if (ret) {
> > > > > +		sysfs_remove_link(&dev->kobj, "isolation_group");
> > > > > +		kfree(device);
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	list_add(&device->list, &group->devices);
> > > > > +
> > > > > +	dev->isolation_group = group;
> > > > > +
> > > > > +	if (group->iommu_domain) {
> > > > > +		ret = group->iommu_ops->attach_dev(group->iommu_domain, dev);
> > > > > +		if (ret) {
> > > > > +			/* XXX fail device? */
> > > > > +		}
> > > > 
> > > > So, I presume the idea is that this is a stop-gap until iommu_ops is
> > > > converted to be in terms of groups rather than indivdual devices?
> > > 
> > > Yes, I thought we could just back it by the iommu api for now so we can
> > > implement managers, but eventually domain_init and attach_dev would
> > > probably be a single callback in some kind of group aware iommu api.
> > 
> > Makes sense.
> > 
> > > > > +	}
> > > > > +
> > > > > +	/* XXX signal manager? */
> > > > 
> > > > Uh, what did you have in mind here?
> > > 
> > > Another notifier?  Maybe just a callback struct registered when a
> > > manager is added to a group.  On one hand, maybe it's not necessary
> > > because adding a device to a managed group already restricts driver
> > > matching, but on the other, the manager may want to be informed about
> > > new devices and try to actively bind a driver to it.  For instance, if
> > > assigning an entire PE to a guest, which might include empty slots,
> > > would the manager want to be informed about the addition of a device so
> > > it could mirror the addition to the guest assigned the PE?
> > 
> > Oh, right, I was misinterpreting the comment.  Instead of reading it
> > as "notify the isolation group manager that something is happening" I
> > read it as "do something to manage when some process is given a Unix
> > signal".  Hence my complete confusion.
> > 
> > > > > +out:
> > > > > +	mutex_unlock(&isolation_lock);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Remove a device from an isolation group, likely because the device
> > > > > + * went away.
> > > > > + */
> > > > > +int isolation_group_del_dev(struct device *dev)
> > > > > +{
> > > > > +	struct isolation_group *group = dev->isolation_group;
> > > > > +	struct isolation_device *device;
> > > > > +
> > > > > +	if (!group)
> > > > > +		return -ENODEV;
> > > > > +
> > > > > +	mutex_lock(&isolation_lock);
> > > > > +
> > > > > +	list_for_each_entry(device, &group->devices, list) {
> > > > > +		if (device->dev == dev) {
> > > > > +			/* XXX signal manager? */
> > > > > +
> > > > > +			if (group->iommu_domain)
> > > > > +				group->iommu_ops->detach_dev(
> > > > > +					group->iommu_domain, dev);
> > > > > +			list_del(&device->list);
> > > > > +			kfree(device);
> > > > > +			dev->isolation_group = NULL;
> > > > > +			sysfs_remove_link(group->devices_kobj,
> > > > > +					  kobject_name(&dev->kobj));
> > > > > +			sysfs_remove_link(&dev->kobj, "isolation_group");
> > > > > +			break;
> > > > > +		}
> > > > > +	}
> > > > > +			
> > > > > +	mutex_unlock(&isolation_lock);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Filter and call out to our own notifier chains
> > > > > + */
> > > > 
> > > > So, I haven't quite worked out what this isolation notifier
> > > > infrastructure gives you, as opposed to having isolation providers
> > > > directly register bus notifiers.
> > > 
> > > For now, it nicely separates CONFIG_ISOLATION code so I don't litter
> > > intel-iommu with #ifdefs.  It also embraces that devices are always
> > > being added and removed and supports that with very little change to
> > > existing code paths.
> > 
> > Well, I get the first bit, but it's a long way from the minimum needed
> > to de-#ifdef.  I still haven't seen what it's giving the provider that
> > wouldn't be just as simple with direct bus_notifier calls.
> 
> I think this is covered above.
> 
> > > > > +static int isolation_bus_notify(struct notifier_block *nb,
> > > > > +				unsigned long action, void *data)
> > > > > +{
> > > > > +	struct isolation_notifier *notifier =
> > > > > +		container_of(nb, struct isolation_notifier, nb);
> > > > > +	struct device *dev = data;
> > > > > +
> > > > > +	switch (action) {
> > > > > +	case BUS_NOTIFY_ADD_DEVICE:
> > > > > +		if (!dev->isolation_group)
> > > > > +			blocking_notifier_call_chain(&notifier->notifier,
> > > > > +					ISOLATION_NOTIFY_ADD_DEVICE, dev);
> > > > > +		break;
> > > > > +	case BUS_NOTIFY_DEL_DEVICE:
> > > > > +		if (dev->isolation_group)
> > > > > +			blocking_notifier_call_chain(&notifier->notifier,
> > > > > +					ISOLATION_NOTIFY_DEL_DEVICE, dev);
> > > > > +		break;
> > > > > +	}
> > > > > +
> > > > > +	return NOTIFY_DONE;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Wrapper for manual playback of BUS_NOTIFY_ADD_DEVICE when we add
> > > > > + * a new notifier.
> > > > > + */
> > > > > +static int isolation_do_add_notify(struct device *dev, void *data)
> > > > > +{
> > > > > +	struct notifier_block *nb = data;
> > > > > +
> > > > > +	if (!dev->isolation_group)
> > > > > +		nb->notifier_call(nb, ISOLATION_NOTIFY_ADD_DEVICE, dev);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Register a notifier.  This is for isolation group providers.  It's
> > > > > + * possible we could have multiple isolation group providers for the same
> > > > > + * bus type,
> > > > 
> > > > So the bit above doesn't seem to connect to the bit below.  We can
> > > > indeed have multiple isolation providers for one bus type, but the
> > > > below seems to be covering the (also possible, but different) case of
> > > > one isolation provider covering multiple bus types.
> > > 
> > > It covers both.  If a provider covers multiple buses it will call this
> > > function once for each bus.  Each new bus creates a new struct
> > > isolation_notifier and does a bus_register_notifier (using
> > > isolation_bus_notify).  The provider notifier block is added to our own
> > > notifier call chain for that struct isolation_notifier.  This way we
> > > only ever register a single notifier per bus, but support multiple
> > > providers for the bus.
> > 
> > Um, right, but what would be the problem with registering multiple
> > notifiers per bus.
> 
> It's a minor optimization, but this way we can stop when one of the
> providers decides it "owns" the device.  As noted, I'm not stuck to this
> notifier and in the end, it doesn't gate creating groups using the
> isolation functions directly.

Hm, ok.

> > > > > so we create a struct isolation_notifier per bus_type, each
> > > > > + * with a notifier block.  Providers are therefore welcome to register
> > > > > + * as many buses as they can handle.
> > > > > + */
> > > > > +int isolation_register_notifier(struct bus_type *bus, struct notifier_block *nb)
> > > > > +{
> > > > > +	struct isolation_notifier *notifier;
> > > > > +	bool found = false;
> > > > > +	int ret;
> > > > > +
> > > > > +	mutex_lock(&isolation_lock);
> > > > > +	list_for_each_entry(notifier, &isolation_notifiers, list) {
> > > > > +		if (notifier->bus == bus) {
> > > > > +			found = true;
> > > > > +			break;
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > > +	if (!found) {
> > > > > +		notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
> > > > > +		if (!notifier) {
> > > > > +			mutex_unlock(&isolation_lock);
> > > > > +			return -ENOMEM;	
> > > > > +		}
> > > > > +		notifier->bus = bus;
> > > > > +		notifier->nb.notifier_call = isolation_bus_notify;
> > > > > +		BLOCKING_INIT_NOTIFIER_HEAD(&notifier->notifier);
> > > > > +		bus_register_notifier(bus, &notifier->nb);
> > > > > +		list_add(&notifier->list, &isolation_notifiers);
> > > > > +	}
> > > > > +
> > > > > +	ret = blocking_notifier_chain_register(&notifier->notifier, nb);
> > > > > +	if (ret) {
> > > > > +		if (notifier->refcnt == 0) {
> > > > > +			bus_unregister_notifier(bus, &notifier->nb);
> > > > > +			list_del(&notifier->list);
> > > > > +			kfree(notifier);
> > > > > +		}
> > > > > +		mutex_unlock(&isolation_lock);
> > > > > +		return ret;
> > > > > +	}
> > > > > +	notifier->refcnt++;
> > > > > +
> > > > > +	mutex_unlock(&isolation_lock);
> > > > > +
> > > > > +	bus_for_each_dev(bus, NULL, nb, isolation_do_add_notify);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > 
> > > > So, somewhere, I think we need a fallback path, but I'm not sure
> > > > exactly where.  If an isolation provider doesn't explicitly put a
> > > > device into a group, the device should go into the group of its parent
> > > > bridge.  This covers the case of a bus with IOMMU which has below it a
> > > > bridge to a different type of DMA capable bus (which the IOMMU isn't
> > > > explicitly aware of).  DMAs from devices on the subordinate bus can be
> > > > translated by the top-level IOMMU (assuming it sees them as coming
> > > > from the bridge), but they all need to be treated as one group.
> > > 
> > > Why would the top level IOMMU provider not set the isolation group in
> > > this case.
> > 
> > Because it knows nothing about the subordinate bus.  For example
> > imagine a VT-d system, with a wacky PCI card into which you plug some
> > other type of DMA capable device.  The PCI card is acting as a bridge
> > from PCI to this, let's call it FooBus.  Obviously the VT-d code won't
> > have a FooBus notifier, since it knows nothing about FooBus.  But the
> > FooBus devices still need to end up in the group of the PCI bridge
> > device, since their DMA operations will appear as coming from the PCI
> > bridge card to the IOMMU, and can be isolated from the rest of the
> > system (but not each other) on that basis.
> 
> I guess I was imagining that it's ok to have devices without an
> isolation group.

It is, but having NULL isolation group has a pretty specific meaning -
it means it's never safe to give that device to userspace, but it also
means that normal kernel driver operation of that device must not
interfere with anything in any iso group (otherwise we can never no
that those iso groups _are_ safe to hand out).  Likewise userspace
operation of any isolation group can't mess with no-group devices.

None of these conditions is true for the hypothetical Foobus case.
The bus as a whole could be safely given to userspace, the devices on
it *could* mess with an existing isolation group (suppose the group
consisted of a PCI segment with the FooBus bridge plus another PCI
card - FooBus DMAs would be bridged onto the PCI segment and might
target the other card's MMIO space).  And other grouped devices can
certainly mess with the FooBus devices (if userspace grabs the bridge
and manipulates its IOMMU mappings, that would clearly screw up any
kernel drivers doing DMA from FooBus devices behind it).

Oh.. and I just thought of an existing-in-the-field case with the same
problem.  I'm pretty sure for devices that can appear on PCI but also
have "dumb-bus" versions used on embedded systems, at least some of
the kernel drivers are structured so that there is a separate struct
device for the PCI "wrapper" and the device inside.  If the inner
driver is initiating DMA, as it usually would, it has to be in the
same iso group as it's PCI device parent.

>  When that happens we can traverse up the bus to find a
> higher level isolation group.

Well, that's one possible answer to my "where should the hook be
question": rather than an initialization hook, when we look up a
device's isolation group, if it doesn't say one explicitly, we try
it's bridge parent and so forth up the tree.  I wonder about the
overhead of having to walk all the way up the bus heirarchy before
returning NULL whenever we ask about the group of a device that
doesn't have one.

>  It would probably make sense to have some
> kind of top-most isolation group that contains everything as it's an
> easy proof that if you own everything, you're isolated.

Hrm, no.  Things that have no IOMMU above them will have ungated
access to system RAM, and so can never be safely isolated for
userspace purposes, even if userspace owned every _device_ in the
system (not that you could do that in practice, anyway).

>  Potentially
> though, wackyPCIcard can also register isolation groups for each of it's
> FooBus devices if it's able to provide that capability.  Thanks,

It could, but why should it.  It doesn't know anything about IOMMUs or
isolation, and it doesn't need to.  Even less so for PCI devices which
create subordinate non-PCI struct devices for internal reasons.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
