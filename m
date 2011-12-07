Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab1LGOnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:43:42 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55628 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1LGOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:43:40 -0500
Date: Thu, 8 Dec 2011 01:22:01 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org
Subject: Re: RFC: Device isolation infrastructure
Message-ID: <20111207142201.GA5696@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	aik@au1.ibm.com, linux-kernel@vger.kernel.org, chrisw@redhat.com,
	agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
	benh@kernel.crashing.org
References: <20111207035816.GC7631@truffala.fritz.box>
 <1323240402.2182.241.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323240402.2182.241.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120704-1618-0000-0000-0000004338DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:46:42PM -0700, Alex Williamson wrote:
> On Wed, 2011-12-07 at 14:58 +1100, David Gibson wrote:
> > 
> > Alex Williamson recently posted some patches adding a new hook to
> > iommu_ops to identify groups of devices which cannot reliably be
> > distinguished by the iommu, and therefore can only safely be assigned
> > as a unit to a guest or userspace driver.
> > 
> > I'm not very fond of that design, because:
> >     - It requires something else to scan the group ids to present the
> > groups in a userspace discoverable manner, rather than handling that
> > in the core.
> 
> The thought was that the vast majority of users won't make use of
> groups, so why bloat the core when the only user is vfio.  

Well, "won't make use of" actually means "are on a system with
all-singleton groups".  And the answer is because it actually doesn't
bloat, but simplifies the core.  We need the group concept _at
minimum_ to handle bridges and buggy multifunction devices.  So it
makes life easier to assume they're always there, even if they're
often singletons.

> We need bus
> specific drivers to expose devices in vfio, so it's fairly natural to
> have the bus drivers enumerate devices on their bus, register them with
> the vfio-core, which then exposes groups in a convenient manner for
> userspace.
> 
> >     - It encorages manipulating devices individually, but only
> > permitting certain actions if the whole group is together.  This seems
> > confusing and arse-backwards to me.
> 
> Hmm, this patch introduces a group level detach and reattach of devices,
> but seems to lack any support for actually making use of devices in the
> detached state, so it's rather hard to compare.

well, yes, that's the next layer up.  Working on it..

>  How does someone
> wanting to interact with a device within the group do so?  This appears
> to put devices entirely outside of the driver model when detached, which
> seems just as awkward.
> 
> >     - It does not provide an obvious means to prevent a kernel
> > driver unsafely binding to a new device which is hotplugged into an
> > iommu group already assigned to a guest.
> 
> I've added this for PCI, triggered via the device add notifier.

Hrm.  Does the notifier run early enough to guarantee that a driver
can't bind before it's complete?

> >     - It is inherently centred arounf the iommu structure, however
> > there might be other platform dependent factors which also affect
> > which devices can be safely isolated from others.
> 
> Yep, MSI isolation being an example.  I tend to think the iommu driver
> is pretty closely tied to the platform (all current examples are), so
> the iommu driver should take those factors into account when advertising
> groups.
> 
> > These could probably each be addressed with various tweaks, but
> > basically, I'm just not convinced that it represents the right
> > structure for handling this.  So, Alexey Kardashevskiy and myself havr
> > made this patches, representing the outline of how I think this should
> > be handled.
> > 
> > 
> > Notes:
> >     * All names are negotiable.  At the moment I'm thinking of this as
> > the "device isolation subsystem" which handles "device isolation
> > groups" (not to be confused with an iommu domain, which could contain
> > one or more groups).  A group is considered "detached" when it has
> > been removed from the normal driver binding process, and therefore
> > ready for assignment to a guest or userspace.  I'm more than open to
> > suggestions of better names.
> >     * This is just the generic infrastructure.  Obviously, platform
> > specific code will be needed as well to create the groups and assign
> > devices to them.  We have a proof of concept implementation for the
> > power p5ioc2 pci host bridge, and I hope to post code for that and the
> > p7ioc bridge shortly.  I'll also be looking at how this would be used
> > by Intel VTd, and AMD iommus.
> >     * isolation groups appear in /sys/isolation.  Isolatable devices
> > have a link to their group.  The group contains links to all their
> > devices, and a "detached" attribute, which can be used to view and
> > control whether the group is detached.
> >     * At present groups are detached manually via sysfs, but the idea
> > is a kernel system like vfio, could also directly request a group to
> > be detached for its use.
> >     * when detached, all kernel drivers are unbound from every device
> > in the group.  No driver will match any device in the group until it
> > is reattached.
> > 
> >     * There are probably stupid bugs, in particular I know some error
> > paths are broken.  By all means point these out to expedite fixing
> > them.
> >     * The isolation_group structure is more or less a stub at this
> > point.  It will probably want a pointer to an iommu_ops and/or its own
> > ops structure.  The 'detached' bool may need to become some sort of
> > state variable.  We'll probably want some sort of "owner" field for
> > what (e.g. vfio) is using the group when its detached.
> 
> This makes me nervous.  One of the flaws I'm trying to correct with vfio
> vs existing kvm PCI device assignment is the driver ownership model.
> KVM will currently try to make use of any device it can and is only
> stopped by drivers having already claimed various resources.  VFIO has a
> strong device-driver-group ownership model.

Right... I'm not sure what aspect makes you nervous.  Exactly what I'm
saying here is that we will need an ownership model for detached groups.

> Isolation groups facilitate ejecting the normal device drivers (which
> actually seems somewhat dangerous)

Why dangerous?  You have to do exactly the same thing in more steps in
order to use a group with vfio.

> but isn't yet introducing any clear
> ownership model to replace *a* device being bound to *a* driver.
> Devices seem to be in limbo once detached.  We're not even outlining
> here how we're going to attach group-drivers to groups or facilitate
> matching individual devices to bus specific drivers, which seems like
> it'll get us back into the individual device manipulation you complain
> about above.

I'm envisaging something like
	struct isolation_group_owner *owner;

in the struct i_g, which is NULL when the group is attached.  It would
be a parameter to the detach call, so a subsystem (like vfio) could
detach and claim ownership atomically.  The struct i_g_o would have
some generic fields and some ops, and the owner code could
container_of it to get private, more detailed info
e.g. uid/gid/pid/mm* or whatever for vfio.

> >     * I've also considered adding an "isolation strength" bitmask to
> > indicate how well isolated the group is - e.g DMA isolated (iommu),
> > irq isolated (irq remapping iommu, or other mechanism), error isolated
> > (bus errors from this device can't affect other devices), ..
> 
> This sounds like a maintenance burden, which is why I've been trying to
> push that iommu drivers should not expose groups that aren't fully
> isolated.  It's easy to add parameters per iommu driver where the user
> can opt-in to certain deficiencies.

True.  In fact the only real way to use such a bitmask, I think, would
be to have it as a global, defining the minimum isolation
characteristics to the iommu drivers.  That might help to unify
configuration of what flaws in isolation are acceptable.

> > Anyway, on with the code..
> > 
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > 
> > ---
> >  drivers/Kconfig                      |    2 +
> >  drivers/Makefile                     |    2 +
> >  drivers/base/base.h                  |    5 +
> >  drivers/base/core.c                  |    7 +
> >  drivers/base/init.c                  |    2 +
> >  drivers/isolation/Kconfig            |    3 +
> >  drivers/isolation/Makefile           |    2 +
> >  drivers/isolation/device_isolation.c |  216 ++++++++++++++++++++++++++++++++++
> >  include/linux/device.h               |    5 +
> >  include/linux/device_isolation.h     |   79 ++++++++++++
> >  10 files changed, 323 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/isolation/Kconfig
> >  create mode 100644 drivers/isolation/Makefile
> >  create mode 100644 drivers/isolation/device_isolation.c
> >  create mode 100644 include/linux/device_isolation.h
> > 
> > diff --git a/drivers/Kconfig b/drivers/Kconfig
> > index 95b9e7e..2ce5717 100644
> > --- a/drivers/Kconfig
> > +++ b/drivers/Kconfig
> > @@ -130,4 +130,6 @@ source "drivers/iommu/Kconfig"
> >  
> >  source "drivers/virt/Kconfig"
> >  
> > +source "drivers/isolation/Kconfig"
> > +
> >  endmenu
> > diff --git a/drivers/Makefile b/drivers/Makefile
> > index 7fa433a..741874a 100644
> > --- a/drivers/Makefile
> > +++ b/drivers/Makefile
> > @@ -127,3 +127,5 @@ obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
> >  
> >  # Virtualization drivers
> >  obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
> > +
> > +obj-$(CONFIG_DEVICE_ISOLATION)	+= isolation/
> > diff --git a/drivers/base/base.h b/drivers/base/base.h
> > index a34dca0..66a4ed2 100644
> > --- a/drivers/base/base.h
> > +++ b/drivers/base/base.h
> > @@ -24,6 +24,9 @@
> >   * bus_type/class to be statically allocated safely.  Nothing outside of the
> >   * driver core should ever touch these fields.
> >   */
> > +
> > +#include <linux/device_isolation.h>
> > +
> >  struct subsys_private {
> >  	struct kset subsys;
> >  	struct kset *devices_kset;
> > @@ -108,6 +111,8 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
> >  static inline int driver_match_device(struct device_driver *drv,
> >  				      struct device *dev)
> >  {
> > +	if (isolation_device_is_detached(dev))
> > +		return 0;
> >  	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
> >  }
> >  
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index bc8729d..45201c5 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/mutex.h>
> >  #include <linux/async.h>
> > +#include <linux/device_isolation.h>
> >  
> >  #include "base.h"
> >  #include "power/power.h"
> > @@ -593,6 +594,10 @@ void device_initialize(struct device *dev)
> >  	lockdep_set_novalidate_class(&dev->mutex);
> >  	spin_lock_init(&dev->devres_lock);
> >  	INIT_LIST_HEAD(&dev->devres_head);
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +	INIT_LIST_HEAD(&dev->isolation_list);
> > +	dev->isolation_group = NULL;
> > +#endif
> >  	device_pm_init(dev);
> >  	set_dev_node(dev, -1);
> >  }
> > @@ -993,6 +998,8 @@ int device_add(struct device *dev)
> >  				class_intf->add_dev(dev, class_intf);
> >  		mutex_unlock(&dev->class->p->class_mutex);
> >  	}
> 
> At this point we've already attached a native driver to a potentially
> in-use isolation group, so we haven't really addressed the hotplug
> issue.  If we're creating groups and adding devices to them via the
> device add notifier, that looks pretty similar to how vfio does it, and
> there we only need the trivial iommu_device_group hook.

Uh, no.  This probably isn't clear without an example iommu
implementation, but the idea is that group_dev_add is called before
device_add, so group membership is established before the device
appears in sysfs, and before a driver will bind.

That works nicely for our iommu structure (built into the host bridge,
essentially).  It's a bit nastier on x86, because the iommus are
initialized relatively late.  I'm still getting my head around that
code, but I think it will work, although it might need slightly
different handling for the boot-time and hotplug cases.

>  I'll give you
> that the "detached" hook in the match function makes it easy to take a
> device out of the driver model, but then what do you replace the driver
> model with?

Other, vfio-like, subsystems explicitly claiming groups for
themselves.

> > +
> > +	isolation_group_update_links(dev);
> >  done:
> >  	put_device(dev);
> >  	return error;
> 
> We'd need something in the device_del path to block removal if the
> device is in use via the group.  The equivalent of the .remove for the
> driver it can no longer attach to.

Good point.  At least for the detach-via-sysfs case (which may not
even be a good idea to keep).  In general, I'd expect reattach() to be
called by the subsystem which detached the group in the first place,
when it's done with it.

> > diff --git a/drivers/base/init.c b/drivers/base/init.c
> > index c8a934e..89f3e94 100644
> > --- a/drivers/base/init.c
> > +++ b/drivers/base/init.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/device.h>
> >  #include <linux/init.h>
> >  #include <linux/memory.h>
> > +#include <linux/device_isolation.h>
> >  
> >  #include "base.h"
> >  
> > @@ -24,6 +25,7 @@ void __init driver_init(void)
> >  	devices_init();
> >  	buses_init();
> >  	classes_init();
> > +	isolation_init();
> >  	firmware_init();
> >  	hypervisor_init();
> >  
> > diff --git a/drivers/isolation/Kconfig b/drivers/isolation/Kconfig
> > new file mode 100644
> > index 0000000..a2a7703
> > --- /dev/null
> > +++ b/drivers/isolation/Kconfig
> > @@ -0,0 +1,3 @@
> > +config DEVICE_ISOLATION
> > +	bool "Enable isolating devices for safe pass-through to guests or user space."
> > +
> > diff --git a/drivers/isolation/Makefile b/drivers/isolation/Makefile
> > new file mode 100644
> > index 0000000..8f1c6ec
> > --- /dev/null
> > +++ b/drivers/isolation/Makefile
> > @@ -0,0 +1,2 @@
> > +obj-$(CONFIG_DEVICE_ISOLATION) := device_isolation.o
> > +
> > diff --git a/drivers/isolation/device_isolation.c b/drivers/isolation/device_isolation.c
> > new file mode 100644
> > index 0000000..2b00ff7
> > --- /dev/null
> > +++ b/drivers/isolation/device_isolation.c
> > @@ -0,0 +1,216 @@
> > +#include <linux/slab.h>
> > +#include <linux/device_isolation.h>
> > +
> > +#define KERN_DEBUG KERN_WARNING
> > +
> > +
> > +static struct kset *isolation_kset;
> > +
> > +#define to_isolation_attr(_attr) container_of(_attr, \
> > +		struct isolation_attribute, attr)
> > +
> > +static ssize_t isolation_attr_show(struct kobject *kobj,
> > +		struct attribute *attr, char *buf)
> > +{
> > +	struct isolation_attribute *isolation_attr = to_isolation_attr(attr);
> > +	struct isolation_group *group = container_of(kobj,
> > +			struct isolation_group, kobj);
> > +	ssize_t ret = -EIO;
> > +
> > +	if (isolation_attr->show)
> > +		ret = isolation_attr->show(group, buf);
> > +	return ret;
> > +}
> > +
> > +static ssize_t isolation_attr_store(struct kobject *kobj,
> > +		struct attribute *attr, const char *buf, size_t count)
> > +{
> > +	struct isolation_attribute *isolation_attr = to_isolation_attr(attr);
> > +	struct isolation_group *group = container_of(kobj,
> > +			struct isolation_group, kobj);
> > +	ssize_t ret = -EIO;
> > +
> > +	if (isolation_attr->store)
> > +		ret = isolation_attr->store(group, buf, count);
> > +	return ret;
> > +}
> > +
> > +static void isolation_release(struct kobject *kobj)
> > +{
> > +	struct isolation_group *group = container_of(kobj,
> > +			struct isolation_group, kobj);
> > +
> > +	pr_debug("isolation : release.\n");
> > +
> > +	kfree(group);
> > +}
> > +
> > +static const struct sysfs_ops isolation_sysfs_ops = {
> > +	.show	= isolation_attr_show,
> > +	.store	= isolation_attr_store,
> > +};
> > +
> > +static struct kobj_type isolation_ktype = {
> > +	.sysfs_ops	= &isolation_sysfs_ops,
> > +	.release	= isolation_release,
> > +};
> > +
> > +static ssize_t group_showdetached(struct isolation_group *group,
> > +		     char *buf)
> > +{
> > +	return sprintf(buf, "%u", !!group->detached);
> > +}
> > +
> > +static ssize_t group_setdetached(struct isolation_group *group,
> > +		     const char *buf, size_t count)
> > +{
> > +	switch (buf[0]) {
> > +	case '0':
> > +		isolation_group_reattach(group);
> > +		break;
> > +	case '1':
> > +		isolation_group_detach(group);
> > +		break;
> > +	default:
> > +		count = -EINVAL;
> > +	}
> > +	return count;
> > +}
> > +
> > +static DEVICE_ISOLATION_ATTR(detached, S_IWUSR | S_IRUSR,
> > +		group_showdetached, group_setdetached);
> > +
> > +struct isolation_group *isolation_group_new(const char *name)
> > +{
> > +	int ret;
> > +	struct isolation_group *group;
> > +
> > +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> > +	if (!group)
> > +		return NULL;
> > +
> > +	spin_lock_init(&group->lock);
> > +
> > +	group->kobj.kset = isolation_kset;
> > +	ret = kobject_init_and_add(&group->kobj, &isolation_ktype, NULL, name);
> > +	if (ret < 0) {
> > +		printk(KERN_ERR "device_isolation: kobject_init_and_add failed "
> > +				"for %s\n", group->kobj.name);
> > +		return NULL;
> > +	}
> > +
> > +	ret = sysfs_create_file(&group->kobj, &isolation_attr_detached.attr);
> > +	if (0 > ret)
> > +		printk(KERN_WARNING "device_isolation: create \"detached\" failed "
> > +			"for %s, errno=%i\n", group->kobj.name, ret);
> > +
> > +	INIT_LIST_HEAD(&group->devices);
> > +	printk(KERN_DEBUG "device_isolation: group %s created\n",
> > +		group->kobj.name);
> > +
> > +	return group;
> > +}
> > +
> > +void isolation_group_dev_add(struct isolation_group *group, struct device *dev)
> > +{
> > +	printk(KERN_DEBUG "device_isolation: adding device %s to group %s\n",
> > +		dev->kobj.name, group->kobj.name);
> > +	spin_lock(&group->lock);
> > +
> > +	list_add_tail(&dev->isolation_list, &group->devices);
> > +	dev->isolation_group = group;
> > +	/* Todo: remove links we already created */
> > +	spin_unlock(&group->lock);
> > +}
> > +
> > +void isolation_group_dev_remove(struct device *dev)
> > +{
> > +	list_del(&dev->isolation_list);
> > +}
> > +
> > +int isolation_group_update_links(struct device *dev)
> > +{
> > +	int error;
> > +	char *buf;
> > +	struct isolation_group *group = dev->isolation_group;
> > +
> > +	if (!group) {
> > +		printk(KERN_DEBUG "device_isolation: no group for %s\n",
> > +				dev->kobj.name);
> > +		return 0;
> > +	}
> > +
> > +	printk(KERN_DEBUG "device_isolation: adding device %s to group %s\n",
> > +		dev->kobj.name, group->kobj.name);
> > +
> > +	spin_lock(&group->lock);
> > +
> > +	error = sysfs_create_link(&dev->kobj, &group->kobj, "isolation_group");
> > +	if (0 > error)
> > +		printk(KERN_WARNING "device_isolation: create isolation_group "
> > +			"link failed for %s -> %s, errno=%i\n",
> > +			dev->kobj.name, group->kobj.name, error);
> > +
> > +	buf = kasprintf(GFP_KERNEL, "%s-%p", dev->kobj.name, dev);
> > +	if (!buf) {
> > +		error = -ENOMEM;
> > +		printk(KERN_ERR "device_isolation: kasprintf failed\n");
> > +		goto out;
> > +	}
> > +
> > +	error = sysfs_create_link(&group->kobj, &dev->kobj, buf);
> > +	kfree(buf);
> > +	if (0 > error)
> > +		printk(KERN_WARNING "device_isolation: create %s "
> > +			"link failed for %s -> %s, errno=%i\n",
> > +			buf, dev->kobj.name, group->kobj.name, error);
> > +
> > +out:
> > +	/* Todo: remove links we already created */
> > +	spin_unlock(&group->lock);
> > +	return error;
> > +}
> > +
> > +int isolation_group_detach(struct isolation_group *group)
> > +{
> > +	int error;
> > +	struct device *dev;
> > +
> > +	spin_lock(&group->lock);
> > +
> > +	group->detached = true;
> > +	list_for_each_entry(dev, &group->devices, isolation_list) {
> > +		error = device_reprobe(dev);
> 
> How do we handle blocking .remove functions?  That's one reason vfio
> doesn't attempt to automatically detach drivers.  We can treat the
> groups as a unit here, but it's hard to get away from the fact that
> potentially several individual devices are being removed from their
> drivers here.

Slowly.  We have to remove all the drivers, so we have to just wait
for them.  I guess we should have a timeout and reattach the group if
we can't unbind the drivers in that time.  And/or figure a way to make
it interruptible, so you can ctrl-c something midway through
triggering a detach, and it will re-attach.

Oh, right, and that means we can't take the lock around it all.  Well
that's fixable with the right rechecks of the list.  we might need to
replace the bool with some sort of state variable; ATTACHED -> DETACHING
-> DETACHED.

> > +	}
> > +
> > +	spin_unlock(&group->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +int isolation_group_reattach(struct isolation_group *group)
> > +{
> > +	int error;
> > +	struct device *dev;
> > +
> > +	spin_lock(&group->lock);
> 
> Obviously some ownership check would have to exist here if we knew how
> to claim a group.
> 
> > +	group->detached = false;
> > +	list_for_each_entry(dev, &group->devices, isolation_list) {
> > +		printk("Reprobing %s\n", dev->kobj.name);
> > +		error = device_reprobe(dev);
> > +	}
> > +
> > +	spin_unlock(&group->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +int __init isolation_init(void)
> > +{
> > +	isolation_kset = kset_create_and_add("isolation", NULL, NULL);
> > +	if (!isolation_kset)
> > +		return -ENOMEM;
> > +	return 0;
> > +}
> > +
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index c20dfbf..6238a13 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -585,6 +585,11 @@ struct device {
> >  
> >  	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
> >  					     override */
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +	struct isolation_group  *isolation_group;
> > +	struct list_head 	isolation_list;
> > +#endif
> > +
> >  	/* arch specific additions */
> >  	struct dev_archdata	archdata;
> >  
> > diff --git a/include/linux/device_isolation.h b/include/linux/device_isolation.h
> > new file mode 100644
> > index 0000000..1dc7e68
> > --- /dev/null
> > +++ b/include/linux/device_isolation.h
> > @@ -0,0 +1,79 @@
> > +#ifndef _DEVICE_ISOLATION_H_
> > +#define _DEVICE_ISOLATION_H_
> > +
> > +#include <linux/kobject.h>
> > +#include <linux/list.h>
> > +#include <linux/device.h>
> > +
> > +struct isolation_group {
> > +	struct kobject 		kobj;
> > +	struct list_head 	devices;
> > +	spinlock_t		lock;
> > +	bool			detached;
> > +};
> > +
> > +struct isolation_attribute {
> > +	struct attribute	attr;
> > +	ssize_t (*show)(struct isolation_group *group, char *buf);
> > +	ssize_t (*store)(struct isolation_group *group, const char *buf,
> > +			size_t count);
> > +};
> > +
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +
> > +int __init isolation_init(void);
> > +
> > +struct isolation_group *isolation_group_new(const char *name);
> > +int isolation_group_delete(struct isolation_group *group);
> > +
> > +void isolation_group_dev_add(struct isolation_group *group,
> > +		struct device *dev);
> > +void isolation_group_dev_remove(struct device *dev);
> > +
> > +int isolation_group_update_links(struct device *dev);
> > +int isolation_group_detach(struct isolation_group *group);
> > +int isolation_group_reattach(struct isolation_group *group);
> > +
> > +#define DEVICE_ISOLATION_ATTR(_name, _mode, _show, _store)	\
> > +	struct isolation_attribute isolation_attr_##_name =	\
> > +		__ATTR(_name, _mode, _show, _store)
> > +
> > +static inline int isolation_device_is_detached(struct device *dev)
> > +{
> > +	return dev->isolation_group && dev->isolation_group->detached;
> > +}
> > +
> > +#else
> > +
> > +static inline int __init isolation_init(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline struct isolation_group *isolation_group_new(const char *name)
> > +{
> > +	return NULL;
> > +}
> > +
> > +/*void isolation_group_dev_add(struct isolation_group *group,
> > +		struct device *dev)
> > +{
> > +}*/
> > +
> > +static inline void isolation_group_dev_remove(struct device *dev)
> > +{
> > +}
> > +
> > +static inline int isolation_group_update_links(struct device *dev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int isolation_is_detached(struct device *dev)
> > +{
> > +	return 0;
> > +}
> > +
> > +#endif
> > +
> > +#endif
> 
> So what this boils down to so far are some group objects with lists of
> devices that allow us to pop off all the native drivers and prevent them
> from reattaching.  And for that convenience, we're going to need a whole
> new group driver model to allow something like vfio to claim the group

Well, we need the group model anyway.  Having just ids at the iommu
level merely pushes the work of tracking and exposing them up to
higher levels.

> and then maybe some group-device model to allow bus specific drivers to
> easily make use of the devices within the group?

Huh?

>  And somehow along the
> way we're going to avoid the group vs device awkwardness?

Groups are there whether we like it or not.  This is just about
exposing it cleanly.

>  And again,
> all for an interface that the vast majority of users won't use.  I'm not
> convinced.  Thanks,

You don't get a choice about whether you use groups.  If you have any
two devices (or functions) that can't be isolated from each other, you
have a group, and the kernel code (and the user code, for that matter)
has to deal with it.  So you have to be able to see the groups, or
things will just mysteriously not work when you discover you had two
not-mutually isolatable devices you hadn't realised you had.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

