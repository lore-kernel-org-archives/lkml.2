Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2ASHkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:40:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55155 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2ASHkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:40:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F17C8B9.807@jp.fujitsu.com>
Date: Thu, 19 Jan 2012 16:39:37 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] pciehp: Checking pci conf reading to new added device
 instead of sleep 1s
References: <1324083165-805-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1324083165-805-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/17 9:52), Yinghai Lu wrote:
> During reviewing
> |	PCI: pciehp: wait 1000 ms before Link Training check
> Linus said:
>> ...
>> That's a *long* time, and it's irritating to the user. It makes the
>> user think "the machine is slow".
>> ...
>> And quite frankly, an unconditional one-second delay here seems bad.
>> Two seconds was unacceptable, one second is just bad.
>
> Try to access the pci conf of pci device that is supposed to show up in 1s,
> if could read back valid vender/device id, could bail out early.
>
> Related discussion could be found:
> 	https://lkml.org/lkml/2011/12/6/339
>
> -v2: seperate code to pci_bus_read_dev_vendor_id() from pci_scan_device()
>      and reuse it from pciehp code. Suggested by Matthew Wilcox.
>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>
> ---
>   drivers/pci/hotplug/pciehp_hpc.c |   49 +++++++++++++++++++++++++++------------
>   drivers/pci/pci.h                |    2 +
>   drivers/pci/probe.c              |   44 +++++++++++++++++++++--------------
>   3 files changed, 63 insertions(+), 32 deletions(-)
>
> Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
> +++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
> @@ -272,6 +272,37 @@ static void pcie_wait_link_active(struct
>   	ctrl_dbg(ctrl, "Data Link Layer Link Active not set in 1000 msec\n");
>   }
>
> +static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
> +{
> +	u32 l;
> +	int count = 0;
> +	u32 lx[50];

I don't think it's a good idea to allocate lx[] array on stack.

> +	int delay = 1000, step = 20;
> +	bool found = false;
> +
> +	do {
> +		found = pci_bus_read_dev_vendor_id(bus, devfn,&l, step);
> +		lx[count++] = l;
> +
> +		if (found)
> +			break;
> +
> +		msleep(step);

I don't think msleep() is needed here because pci_bus_read_dev_vendor_id()
has timeout. And even if this msleep() is removed, maximum wait time in
pci_bus_read_dev_vendor_id() looks much longer than 1sec (IIUC, it looks
1ms + 2ms + 4ms + 8ms + ...)


> +		delay -= step;
> +	} while (delay>  0);
> +
> +	if (count>  1&&  pciehp_debug) {
> +		int i;
> +		printk(KERN_DEBUG "pci %04x:%02x:%02x.%d id reading try %d times with interval %d ms\n",
> +			pci_domain_nr(bus), bus->number, PCI_SLOT(devfn),
> +			PCI_FUNC(devfn), count, step);
> +		for (i = 0; i<  count; i++)
> +			printk(KERN_DEBUG "  [%02d]=%08x\n", i, lx[i]);
> +	}

Why not printing the debug message each time in the while() loop?


> +
> +	return found;
> +}
> +
>   int pciehp_check_link_status(struct controller *ctrl)
>   {
>   	u16 lnk_status;
> @@ -287,13 +318,9 @@ int pciehp_check_link_status(struct cont
>           else
>                   msleep(1000);
>
> -	/*
> -	 * Need to wait for 1000 ms after Data Link Layer Link Active
> -	 * (DLLLA) bit reads 1b before sending configuration request.
> -	 * We need it before checking Link Training (LT) bit becuase
> -	 * LT is still set even after DLLLA bit is set on some platform.
> -	 */
> -	msleep(1000);
> +	/* wait 100ms before read pci conf, and try in 1s */
> +	msleep(100);
> +	pci_bus_check_dev(ctrl->pcie->port->subordinate, PCI_DEVFN(0, 0));

We need to check the result of pci_bus_check_dev() and return error if
the the result is false.

Regards,
Kenji Kaneshige



>
>   	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA,&lnk_status);
>   	if (retval) {
> @@ -309,14 +336,6 @@ int pciehp_check_link_status(struct cont
>   		return retval;
>   	}
>
> -	/*
> -	 * If the port supports Link speeds greater than 5.0 GT/s, we
> -	 * must wait for 100 ms after Link training completes before
> -	 * sending configuration request.
> -	 */
> -	if (ctrl->pcie->port->subordinate->max_bus_speed>  PCIE_SPEED_5_0GT)
> -		msleep(100);
> -
>   	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
>
>   	return retval;
> Index: linux-2.6/drivers/pci/probe.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/probe.c
> +++ linux-2.6/drivers/pci/probe.c
> @@ -1119,40 +1119,50 @@ struct pci_dev *alloc_pci_dev(void)
>   }
>   EXPORT_SYMBOL(alloc_pci_dev);
>
> -/*
> - * Read the config data for a PCI device, sanity-check it
> - * and fill in the dev structure...
> - */
> -static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
> +bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
> +				 int crs_timeout)
>   {
> -	struct pci_dev *dev;
> -	u32 l;
>   	int delay = 1;
>
> -	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID,&l))
> -		return NULL;
> +	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, l))
> +		return false;
>
>   	/* some broken boards return 0 or ~0 if a slot is empty: */
> -	if (l == 0xffffffff || l == 0x00000000 ||
> -	    l == 0x0000ffff || l == 0xffff0000)
> -		return NULL;
> +	if (*l == 0xffffffff || *l == 0x00000000 ||
> +	    *l == 0x0000ffff || *l == 0xffff0000)
> +		return false;
>
>   	/* Configuration request Retry Status */
> -	while (l == 0xffff0001) {
> +	while (*l == 0xffff0001) {
>   		msleep(delay);
>   		delay *= 2;
> -		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID,&l))
> -			return NULL;
> +		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, l))
> +			return false;
>   		/* Card hasn't responded in 60 seconds?  Must be stuck. */
> -		if (delay>  60 * 1000) {
> +		if (delay>  crs_timeout) {
>   			printk(KERN_WARNING "pci %04x:%02x:%02x.%d: not "
>   					"responding\n", pci_domain_nr(bus),
>   					bus->number, PCI_SLOT(devfn),
>   					PCI_FUNC(devfn));
> -			return NULL;
> +			return false;
>   		}
>   	}
>
> +	return true;
> +}
> +
> +/*
> + * Read the config data for a PCI device, sanity-check it
> + * and fill in the dev structure...
> + */
> +static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
> +{
> +	struct pci_dev *dev;
> +	u32 l;
> +
> +	if (!pci_bus_read_dev_vendor_id(bus, devfn,&l, 60*1000))
> +		return NULL;
> +
>   	dev = alloc_pci_dev();
>   	if (!dev)
>   		return NULL;
> Index: linux-2.6/drivers/pci/pci.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.h
> +++ linux-2.6/drivers/pci/pci.h
> @@ -208,6 +208,8 @@ enum pci_bar_type {
>   	pci_bar_mem64,		/* A 64-bit memory BAR */
>   };
>
> +bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
> +                                 int crs_timeout);
>   extern int pci_setup_device(struct pci_dev *dev);
>   extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>   				struct resource *res, unsigned int reg);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

