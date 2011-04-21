Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1DUU3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:29:35 -0400
Received: from kroah.org ([198.145.64.141]:39528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1DUU3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:29:33 -0400
Date: Thu, 21 Apr 2011 13:26:32 -0700
From: Greg KH <greg@kroah.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: Export pci device msi table via sysfs
Message-ID: <20110421202631.GE15612@kroah.com>
References: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303412267-1948-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 02:57:47PM -0400, Neil Horman wrote:
> I've been working on some improvements to how we balance irqs for high volume
> interrupt sources.  The consensus so far has been that what would be really
> helpful is a irqbalance mechanism that operates in a one shot mode in response
> to the addition of high volume interrupt sources (i.e. network devices mainly).
> In attempting to implement this, I've found that it would be really useful to
> have 2 bits of information:
> 
> 1) A clear correlation of which interrupts belong to which devices.  Parsing
> /proc/interrupts is an exercize in guessing what naming pattern a given driver
> follows, and requires some amount of stateful information to be kept in user
> space, lest every device addition require a rebalancing of every interrupt in
> the system.
> 
> 2) A indicator as to which kind of interrupts a given device is using.  The irq
> attribute for a pci device is always accurate in that it simply reads whats in
> the appropriate pci config space register, but devices using msi interrupts have
> no use for that register, and never request that interrupt number.
> 
> This patch adds the requisite information.  It creates two per-pci-device irq
> attribute files:
> 
> a) irq_mode - identifies which kind of irqs the device in question is using,
> intx/msi/msix
> 
> b) msi_table - populated only if msi(x) is enabled, it lists the irqs allocated
> to the pci device
> 
> Using this information I can implement a stateless irq one-shot balancer that
> reacts to various udev events quite well
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: linux-pci@vger.kernel.org
> ---
>  drivers/pci/pci-sysfs.c |   33 +++++++++++++++++++++++++++++++++

The reason why this will not work has already been described by Matthew,
but I want to point out that if you ever add/delete/change a sysfs file
in the kernel, you also need to add/delete/change a Documentation/ABI/
file as well.

Writing that file would have shown you how this really isn't going to
work, which is usually a good exercise in itself :)

>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index f8deb3e..1397dfb 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -26,6 +26,7 @@
>  #include <linux/security.h>
>  #include <linux/pci-aspm.h>
>  #include <linux/slab.h>
> +#include <linux/msi.h>
>  #include "pci.h"
>  
>  static int sysfs_initialized;	/* = 0 */
> @@ -71,6 +72,34 @@ static ssize_t broken_parity_status_store(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t irq_mode_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return sprintf(buf, "%s\n", pdev->msix_enabled ? "msix" :
> +				   (pdev->msi_enabled ? "msi" : "intx"));
> +}
> +
> +#ifdef CONFIG_PCI_MSI
> +static ssize_t msi_list_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct msi_desc *entry;
> +	int first, last;
> +	ssize_t count = 0;
> +
> +	if (!(pdev->msi_enabled || pdev->msix_enabled))
> +		return 0;
> +
> +	list_for_each_entry(entry, &pdev->msi_list, list)
> +		count += sprintf(&buf[count], "%d ", entry->irq);

This breaks the "one-item-per-file" sysfs rule, so please never do this.


> +
> +	return count;
> +}
> +#endif
> +
>  static ssize_t local_cpus_show(struct device *dev,
>  			struct device_attribute *attr, char *buf)
>  {		
> @@ -328,6 +357,10 @@ struct device_attribute pci_dev_attrs[] = {
>  	__ATTR_RO(subsystem_device),
>  	__ATTR_RO(class),
>  	__ATTR_RO(irq),
> +	__ATTR_RO(irq_mode),
> +#ifdef CONFIG_PCI_MSI
> +	__ATTR_RO(msi_list),
> +#endif

Curious as to why you added this to the middle of the list?

thanks,

greg k-h
