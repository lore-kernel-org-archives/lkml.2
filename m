Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1IGStM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:49:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1IGStK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:49:10 -0400
Date: Wed, 7 Sep 2011 11:47:50 -0700
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110907184750.GA920@suse.de>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 05:41:45PM +0200, Joerg Roedel wrote:
> This is the starting point to make the iommu_ops used for
> the iommu-api a per-bus-type structure. It is required to
> easily implement bus-specific setup in the iommu-layer.
> The first user will be the iommu-group attribute in sysfs.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/base/bus.c     |   16 ++++++++++++++++
>  drivers/iommu/iommu.c  |    4 ++++
>  include/linux/device.h |    9 +++++++++
>  include/linux/iommu.h  |    2 ++
>  4 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 000e7b2..34ac706 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -1028,6 +1028,22 @@ void bus_sort_breadthfirst(struct bus_type *bus,
>  }
>  EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
>  
> +#ifdef CONFIG_IOMMU_API
> +int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
> +{
> +	if (bus->iommu_ops != NULL)
> +		return -EBUSY;

Busy?

> +
> +	bus->iommu_ops = ops;
> +
> +	/* Do IOMMU specific setup for this bus-type */
> +	iommu_bus_init(bus, ops);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(bus_set_iommu);

I don't understand what this function is for, and who would call it.

Please provide kerneldoc that explains this.


> +#endif
> +
>  int __init buses_init(void)
>  {
>  	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 30b0644..3b24a5b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -34,6 +34,10 @@ void register_iommu(struct iommu_ops *ops)
>  	iommu_ops = ops;
>  }
>  
> +void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
> +{
> +}
> +
>  bool iommu_found(void)
>  {
>  	return iommu_ops != NULL;
> diff --git a/include/linux/device.h b/include/linux/device.h
> index c20dfbf..8240b2a 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -22,6 +22,7 @@
>  #include <linux/types.h>
>  #include <linux/module.h>
>  #include <linux/pm.h>
> +#include <linux/iommu.h>
>  #include <linux/atomic.h>
>  #include <asm/device.h>
>  
> @@ -67,6 +68,9 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
>   * @resume:	Called to bring a device on this bus out of sleep mode.
>   * @pm:		Power management operations of this bus, callback the specific
>   *		device driver's pm-ops.
> + * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
> + *              driver implementations to a bus and allow the driver to do
> + *              bus-specific setup

So why is this just not set by the bus itself, making the above function
not needed at all?

confused,

greg k-h
