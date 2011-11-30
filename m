Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1K3D6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 22:58:06 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54806 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1K3D6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 22:58:02 -0500
Date: Wed, 30 Nov 2011 13:42:05 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com, benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Message-ID: <20111130024205.GF5435@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com,
	benh@kernel.crashing.org
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195605.8438.81609.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021195605.8438.81609.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112917-5490-0000-0000-00000039D104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 01:56:05PM -0600, Alex Williamson wrote:
> An IOMMU group is a set of devices for which the IOMMU cannot
> distinguish transactions.  For PCI devices, a group often occurs
> when a PCI bridge is involved.  Transactions from any device
> behind the bridge appear to be sourced from the bridge itself.
> We leave it to the IOMMU driver to define the grouping restraints
> for their platform.
> 
> Using this new interface, the group for a device can be retrieved
> using the iommu_device_group() callback.  Users will compare the
> value returned against the value returned for other devices to
> determine whether they are part of the same group.  Devices with
> no group are not translated by the IOMMU.  There should be no
> expectations about the group numbers as they may be arbitrarily
> assigned by the IOMMU driver and may not be persistent across boots.
> 
> We also provide a sysfs interface to the group numbers here so
> that userspace can understand IOMMU dependencies between devices
> for managing safe, userspace drivers.

Finally giving these patches a close read.  Sorry it's been so long.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/iommu/iommu.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iommu.h |    7 ++++++
>  2 files changed, 68 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2fb2963..10615ad 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -25,8 +25,60 @@
>  #include <linux/errno.h>
>  #include <linux/iommu.h>
>  
> +static ssize_t show_iommu_group(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	unsigned int groupid;
> +
> +	if (iommu_device_group(dev, &groupid))
> +		return 0;
> +
> +	return sprintf(buf, "%u", groupid);
> +}
> +static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);

Hrm.  Assuming the group is is an unsigned int seems dangerous to me.
More seriously, we really want these to be unique across the whole
system, but they're allocated by the iommu driver which can't
guarantee that if it's not the only one present.  Seems to me it would
be safer to have an actual iommu_group structure allocated for each
group, and use the pointer to it as the ID to hand around (with NULL
meaning "no iommu" / untranslated).  The structure could contain a
more human readable - or more relevant to platform documentation - ID
where appropriate.

> +static int add_remove_iommu_group(struct device *dev, void *data)
> +{
> +	unsigned int groupid;
> +	int add = *(int *)data;
> +
> +	if (iommu_device_group(dev, &groupid) == 0) {
> +		if (add)
> +			return device_create_file(dev, &dev_attr_iommu_group);
> +		else
> +			device_remove_file(dev, &dev_attr_iommu_group);
> +	}
> +
> +	return 0;
> +}

Multiplexing add and remove together seems pointlessly obfuscated.

> +static int iommu_device_notifier(struct notifier_block *nb,
> +				 unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +	int add;
> +
> +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> +		add = 1;
> +		return add_remove_iommu_group(dev, &add);
> +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> +		add = 0;
> +		return add_remove_iommu_group(dev, &add);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct notifier_block iommu_device_nb = {
> +	.notifier_call = iommu_device_notifier,
> +};
> +
>  static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
>  {

I don't know of any current examples, but I do worry that makin this
per bus-type rather than bus-instance might bite us in the arse later
on.

> +	int add = 1;
> +
> +	bus_register_notifier(bus, &iommu_device_nb);
> +	bus_for_each_dev(bus, NULL, &add, add_remove_iommu_group);
>  }
>  
>  /**
> @@ -186,3 +238,12 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
>  	return domain->ops->unmap(domain, iova, gfp_order);
>  }
>  EXPORT_SYMBOL_GPL(iommu_unmap);
> +
> +int iommu_device_group(struct device *dev, unsigned int *groupid)
> +{
> +	if (iommu_present(dev->bus) && dev->bus->iommu_ops->device_group)
> +		return dev->bus->iommu_ops->device_group(dev, groupid);
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(iommu_device_group);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 432acc4..93617e7 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -61,6 +61,7 @@ struct iommu_ops {
>  				    unsigned long iova);
>  	int (*domain_has_cap)(struct iommu_domain *domain,
>  			      unsigned long cap);
> +	int (*device_group)(struct device *dev, unsigned int *groupid);
>  };
>  
>  extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
> @@ -81,6 +82,7 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
>  				unsigned long cap);
>  extern void iommu_set_fault_handler(struct iommu_domain *domain,
>  					iommu_fault_handler_t handler);
> +extern int iommu_device_group(struct device *dev, unsigned int *groupid);
>  
>  /**
>   * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
> @@ -179,6 +181,11 @@ static inline void iommu_set_fault_handler(struct iommu_domain *domain,
>  {
>  }
>  
> +static inline int iommu_device_group(struct device *dev, unsigned int *groupid);
> +{
> +	return -ENODEV;
> +}
> +
>  #endif /* CONFIG_IOMMU_API */
>  
>  #endif /* __LINUX_IOMMU_H */
> 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

