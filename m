Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1LUEo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:44:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1LUEoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:44:24 -0500
Message-ID: <1324442660.29699.42.camel@bling.home>
Subject: Re: [PATCH v2 2/2] kvm: Device assignment permission checks
From: Alex Williamson <alex.williamson@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Tue, 20 Dec 2011 21:44:20 -0700
In-Reply-To: <1324421976.4380.2.camel@lappy>
References: <20111220142907.30073.63730.stgit@bling.home>
	 <20111220143025.30073.36120.stgit@bling.home>
	 <1324421976.4380.2.camel@lappy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 00:59 +0200, Sasha Levin wrote:
> On Tue, 2011-12-20 at 07:30 -0700, Alex Williamson wrote:
> > Only allow KVM device assignment to attach to devices which:
> > 
> >  - Are not bridges
> >  - Have BAR resources (assume others are special devices)
> >  - The user has permissions to use
> > 
> > Assigning a bridge is a configuration error, it's not supported, and
> > typically doesn't result in the behavior the user is expecting anyway.
> > Devices without BAR resources are typically chipset components that
> > also don't have host drivers.  We don't want users to hold such devices
> > captive or cause system problems by fencing them off into an iommu
> > domain.  We determine "permission to use" by testing whether the user
> > has access to the PCI sysfs resource files.  By default a normal user
> > will not have access to these files, so it provides a good indication
> > that an administration agent has granted the user access to the device.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  Documentation/virtual/kvm/api.txt |    4 +++
> >  virt/kvm/assigned-dev.c           |   55 ++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 58 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index ee2c96b..4df9af4 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1154,6 +1154,10 @@ following flags are specified:
> >  The KVM_DEV_ASSIGN_ENABLE_IOMMU flag is a mandatory option to ensure
> >  isolation of the device.  Usages not specifying this flag are deprecated.
> >  
> > +Only PCI header type 0 devices with PCI BAR resources are supported by
> > +device assignment.  The user requesting this ioctl must have read/write
> > +access to the PCI sysfs resource files associated with the device.
> > +
> >  4.49 KVM_DEASSIGN_PCI_DEVICE
> >  
> >  Capability: KVM_CAP_DEVICE_DEASSIGNMENT
> > diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> > index a251a28..faec641 100644
> > --- a/virt/kvm/assigned-dev.c
> > +++ b/virt/kvm/assigned-dev.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/slab.h>
> > +#include <linux/namei.h>
> >  #include "irq.h"
> >  
> >  static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
> > @@ -483,9 +484,11 @@ out:
> >  static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
> >  				      struct kvm_assigned_pci_dev *assigned_dev)
> >  {
> > -	int r = 0, idx;
> > +	int r = 0, idx, i;
> >  	struct kvm_assigned_dev_kernel *match;
> >  	struct pci_dev *dev;
> > +	u8 header_type;
> > +	bool bar_found = false;
> >  
> >  	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
> >  		return -EINVAL;
> > @@ -516,6 +519,56 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
> >  		r = -EINVAL;
> >  		goto out_free;
> >  	}
> > +
> > +	/* Don't allow bridges to be assigned */
> > +	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
> > +	if ((header_type & PCI_HEADER_TYPE) != PCI_HEADER_TYPE_NORMAL) {
> > +		r = -EPERM;
> > +		goto out_put;
> > +	}
> > +
> > +	/* We want to test whether the caller has been granted permissions to
> > +	 * use this device.  To be able to configure and control the device,
> > +	 * the user needs access to PCI configuration space and BAR resources.
> > +	 * These are accessed through PCI sysfs.  PCI config space is often
> > +	 * passed to the process calling this ioctl via file descriptor, so we
> > +	 * can't rely on access to that file.  We can check for permissions
> > +	 * on each of the BAR resource files, which is a pretty clear
> > +	 * indicator that the user has been granted access to the device. */
> > +	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++) {
> > +		char buf[64];
> > +		struct path path;
> > +		struct inode *inode;
> > +
> > +		if (!pci_resource_len(dev, i))
> > +			continue;
> > +
> > +		/* Per sysfs-rules, sysfs is always at /sys */
> > +		snprintf(buf, sizeof(buf), "/sys/bus/pci/devices/%04x:%02x:"
> > +			 "%02x.%d/resource%d", pci_domain_nr(dev->bus),
> > +			 dev->bus->number, PCI_SLOT(dev->devfn),
> > +			 PCI_FUNC(dev->devfn), i);
> 
> This should probably be done by grabbing devname out of
> 'dev' (kobject_get_path(&dev->dev.kobj, GFP_KERNEL) ) instead of
> formatting it ourselves. This is also mentioned to be always correct in
> sysfs-rules while this method isn't.

Ok, we end up with a lot more dynamic allocations this way, but better
to use well defined methods.

> > +
> > +		r = kern_path(buf, LOOKUP_FOLLOW, &path);
> > +		if (r)
> > +			goto out_put;
> > +
> > +		inode = path.dentry->d_inode;
> > +
> > +		r = inode_permission(inode, MAY_READ | MAY_WRITE | MAY_ACCESS);
> > +		path_put(&path);
> > +		if (r)
> > +			goto out_put;
> > +
> > +		bar_found = true;
> > +	}
> > +
> > +	/* If no resources, probably something special */
> > +	if (!bar_found) {
> > +		r = -EPERM;
> > +		goto out_put;
> > +	}
> 
> Maybe it's also worth it to move this block out to a helped function and
> wrap it by CONFIG_SYSFS. I'm not sure what can happen when sysfs doesn't
> exist, but it's best to just avoid any of these corner cases.

I'll add this, but I'm going to assume there aren't any valid use cases
without sysfs, so the alternate path gets a static -EINVAL.  Thanks,

Alex

