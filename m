Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1LUKen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:34:43 -0500
Received: from david.siemens.de ([192.35.17.14]:16404 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab1LUKej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:34:39 -0500
Message-ID: <4EF1B63A.6050509@siemens.com>
Date: Wed, 21 Dec 2011 11:34:34 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: "avi@redhat.com" <avi@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Subject: Re: [PATCH v3 2/2] kvm: Device assignment permission checks
References: <20111221045636.5773.11289.stgit@bling.home> <20111221045909.5773.78994.stgit@bling.home>
In-Reply-To: <20111221045909.5773.78994.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-21 05:59, Alex Williamson wrote:
> Only allow KVM device assignment to attach to devices which:
> 
>  - Are not bridges
>  - Have BAR resources (assume others are special devices)
>  - The user has permissions to use
> 
> Assigning a bridge is a configuration error, it's not supported, and
> typically doesn't result in the behavior the user is expecting anyway.
> Devices without BAR resources are typically chipset components that
> also don't have host drivers.  We don't want users to hold such devices
> captive or cause system problems by fencing them off into an iommu
> domain.  We determine "permission to use" by testing whether the user
> has access to the PCI sysfs resource files.  By default a normal user
> will not have access to these files, so it provides a good indication
> that an administration agent has granted the user access to the device.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  Documentation/virtual/kvm/api.txt |    4 ++
>  virt/kvm/assigned-dev.c           |   72 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index ee2c96b..4df9af4 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1154,6 +1154,10 @@ following flags are specified:
>  The KVM_DEV_ASSIGN_ENABLE_IOMMU flag is a mandatory option to ensure
>  isolation of the device.  Usages not specifying this flag are deprecated.
>  
> +Only PCI header type 0 devices with PCI BAR resources are supported by
> +device assignment.  The user requesting this ioctl must have read/write
> +access to the PCI sysfs resource files associated with the device.
> +
>  4.49 KVM_DEASSIGN_PCI_DEVICE
>  
>  Capability: KVM_CAP_DEVICE_DEASSIGNMENT
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index a251a28..da9690e 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -17,6 +17,7 @@
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
>  #include <linux/slab.h>
> +#include <linux/namei.h>
>  #include "irq.h"
>  
>  static struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
> @@ -480,12 +481,71 @@ out:
>  	return r;
>  }
>  
> +/* We want to test whether the caller has been granted permissions to
> + * use this device.  To be able to configure and control the device,
> + * the user needs access to PCI configuration space and BAR resources.
> + * These are accessed through PCI sysfs.  PCI config space is often
> + * passed to the process calling this ioctl via file descriptor, so we
> + * can't rely on access to that file.  We can check for permissions
> + * on each of the BAR resource files, which is a pretty clear
> + * indicator that the user has been granted access to the device. */

Minor nit, but

/*
 * Comment
 * block.
 */

would look more appealing.

> +static int probe_sysfs_permissions(struct pci_dev *dev)
> +{
> +#ifdef CONFIG_SYSFS
> +	int i;
> +	bool bar_found = false;
> +
> +	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++) {
> +		char *kpath, *syspath;
> +		struct path path;
> +		struct inode *inode;
> +		int r;
> +
> +		if (!pci_resource_len(dev, i))
> +			continue;
> +
> +		kpath = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
> +		if (!kpath)
> +			return -ENOMEM;
> +
> +		/* Per sysfs-rules, sysfs is always at /sys */
> +		syspath = kasprintf(GFP_KERNEL, "/sys%s/resource%d", kpath, i);
> +		kfree(kpath);
> +		if (!syspath)
> +			return -ENOMEM;
> +
> +		r = kern_path(syspath, LOOKUP_FOLLOW, &path);
> +		kfree(syspath);
> +		if (r)
> +			return r;
> +
> +		inode = path.dentry->d_inode;
> +
> +		r = inode_permission(inode, MAY_READ | MAY_WRITE | MAY_ACCESS);
> +		path_put(&path);
> +		if (r)
> +			return r;
> +
> +		bar_found = true;
> +	}
> +
> +	/* If no resources, probably something special */
> +	if (!bar_found)
> +		return -EPERM;
> +
> +	return 0;
> +#else
> +	return -EINVAL; /* No way to control the device without sysfs */
> +#endif
> +}
> +
>  static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  				      struct kvm_assigned_pci_dev *assigned_dev)
>  {
>  	int r = 0, idx;
>  	struct kvm_assigned_dev_kernel *match;
>  	struct pci_dev *dev;
> +	u8 header_type;
>  
>  	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
>  		return -EINVAL;
> @@ -516,6 +576,18 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  		r = -EINVAL;
>  		goto out_free;
>  	}
> +
> +	/* Don't allow bridges to be assigned */
> +	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
> +	if ((header_type & PCI_HEADER_TYPE) != PCI_HEADER_TYPE_NORMAL) {
> +		r = -EPERM;
> +		goto out_put;
> +	}
> +
> +	r = probe_sysfs_permissions(dev);
> +	if (r)
> +		goto out_put;
> +
>  	if (pci_enable_device(dev)) {
>  		printk(KERN_INFO "%s: Could not enable PCI device\n", __func__);
>  		r = -EBUSY;
> 

Looks good to me otherwise, also patch 1.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
