Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1LNEbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:31:18 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52757 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1LNEbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:31:16 -0500
Date: Tue, 13 Dec 2011 21:31:13 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Checking pci conf reading to new added device
	instead of sleep 1s
Message-ID: <20111214043113.GC20129@parisc-linux.org>
References: <1323767154-6859-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323767154-6859-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 01:05:54AM -0800, Yinghai Lu wrote:
> +static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
> +{
> +	u32 l;
> +	int count = 0;
> +	u32 lx[50];
> +	int delay = 1000, step = 20;
> +	bool found = false;
> +
> +again:
> +	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l))
> +		goto wait;
> +
> +	lx[count++] = l;
> +
> +	/* some broken boards return 0 or ~0 if a slot is empty: */
> +	if (l == 0xffffffff || l == 0x00000000 ||
> +	    l == 0x0000ffff || l == 0xffff0000)
> +		goto wait;
> +
> +	/* Configuration request Retry Status */
> +	if (l == 0xffff0001)
> +		goto wait;
> +
> +	found = true;
> +	goto printout;
> +
> +wait:
> +	msleep(step);
> +	delay -= step;
> +	if (delay > 0)
> +		goto again;

This code looks similar to (but not identical to) the code in
pci_scan_device().  Please make that code a common function that can be
called from all PCI hotplug drivers, not just this one.

> +printout:
> +	if (count > 1) {
> +		int i;
> +		printk(KERN_DEBUG "pci %04x:%02x:%02x.%d id reading try %d times with interval %d ms\n",
> +			pci_domain_nr(bus), bus->number, PCI_SLOT(devfn),
> +			PCI_FUNC(devfn), count, step);
> +		for (i = 0; i < count; i++)
> +			printk(KERN_DEBUG "  [%02d]=%08x\n", i, lx[i]);
> +	}
> +
> +	return found;
> +}
> +
>  int pciehp_check_link_status(struct controller *ctrl)
>  {
>  	u16 lnk_status;
> @@ -280,13 +325,9 @@ int pciehp_check_link_status(struct cont
>          else
>                  msleep(1000);
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
>  
>  	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
>  	if (retval) {
> @@ -302,14 +343,6 @@ int pciehp_check_link_status(struct cont
>  		return retval;
>  	}
>  
> -	/*
> -	 * If the port supports Link speeds greater than 5.0 GT/s, we
> -	 * must wait for 100 ms after Link training completes before
> -	 * sending configuration request.
> -	 */
> -	if (ctrl->pcie->port->subordinate->max_bus_speed > PCIE_SPEED_5_0GT)
> -		msleep(100);
> -
>  	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
>  
>  	return retval;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
