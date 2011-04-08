Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1DHOxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:53:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756418Ab1DHOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:53:00 -0400
Date: Fri, 8 Apr 2011 10:52:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joerg Roedel <joerg.roedel@amd.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH v4] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <1302272804-3309-1-git-send-email-joerg.roedel@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104081041270.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Joerg Roedel wrote:

> Booting 2.6.38 on my test machine produces a lockdep warning
> from the usb_amd_find_chipset_info() function:
> 
>  WARNING: at /data/lemmy/linux.trees.git/kernel/lockdep.c:2465 lockdep_trace_alloc+0x95/0xc2()
>  Hardware name: Snook
>  Modules linked in:
>  Pid: 959, comm: work_for_cpu Not tainted 2.6.39-rc2+ #22
>  Call Trace:
>   [<ffffffff8103c0d4>] warn_slowpath_common+0x80/0x98
>   [<ffffffff812387e6>] ? T.492+0x24/0x26
>   [<ffffffff8103c101>] warn_slowpath_null+0x15/0x17
>   [<ffffffff81068667>] lockdep_trace_alloc+0x95/0xc2
>   [<ffffffff810ed9ac>] slab_pre_alloc_hook+0x18/0x3b
>   [<ffffffff810ef227>] kmem_cache_alloc_trace+0x25/0xba
>   [<ffffffff812387e6>] T.492+0x24/0x26
>   [<ffffffff81238816>] pci_get_subsys+0x2e/0x73
>   [<ffffffff8123886c>] pci_get_device+0x11/0x13
>   [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
> ...
> 
> It turns out that this function calls pci_get_device under a spin_lock
> with irqs disabled, but the pci_get_device function is only allowed in
> preemptible context.
> 
> This patch fixes the warning by making all data-structure
> modifications on temporal storage and commiting this back
> into the visible structure at the end. While at it, this
> patch also moves the pci_dev_put calls out of the spinlocks
> because this function might sleep too.

I see only a couple of small flaws...

> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 1d586d4..dfc639a 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -84,65 +84,91 @@ int usb_amd_find_chipset_info(void)
>  {
>  	u8 rev = 0;
>  	unsigned long flags;
> +	struct amd_chipset_info info;
> +	int ret;
>  
>  	spin_lock_irqsave(&amd_lock, flags);
>  
> -	amd_chipset.probe_count++;
>  	/* probe only once */
> -	if (amd_chipset.probe_count > 1) {
> +	if (amd_chipset.probe_count > 0) {

You need to increment probe_count here.

>  		spin_unlock_irqrestore(&amd_lock, flags);
>  		return amd_chipset.probe_result;
>  	}
> +	info = amd_chipset;

What's the point of this line?  You're just going to write over all the 
data in info anyway, so it doesn't matter what amd_chipset contains.  A 
memset would work just as well.

> @@ -284,8 +310,10 @@ EXPORT_SYMBOL_GPL(usb_amd_quirk_pll_enable);
>  
>  void usb_amd_dev_put(void)
>  {
> +	struct pci_dev *nb, *smbus;
>  	unsigned long flags;
>  
> +

Why add an extra blank line?

>  	spin_lock_irqsave(&amd_lock, flags);
>  
>  	amd_chipset.probe_count--;
> @@ -294,20 +322,23 @@ void usb_amd_dev_put(void)
>  		return;
>  	}
>  
> -	if (amd_chipset.nb_dev) {
> -		pci_dev_put(amd_chipset.nb_dev);
> -		amd_chipset.nb_dev = NULL;
> -	}
> -	if (amd_chipset.smbus_dev) {
> -		pci_dev_put(amd_chipset.smbus_dev);
> -		amd_chipset.smbus_dev = NULL;
> -	}
> +	/* save them to pci_dev_put outside of spinlock */
> +	nb    = amd_chipset.nb_dev;
> +	smbus = amd_chipset.smbus_dev;
> +
> +	amd_chipset.nb_dev = NULL;
> +	amd_chipset.smbus_dev = NULL;
>  	amd_chipset.nb_type = 0;
>  	amd_chipset.sb_type = 0;
>  	amd_chipset.isoc_reqs = 0;
>  	amd_chipset.probe_result = 0;

You could use memset instead.  However, in reality it shouldn't be
necessary to set any of these things to 0.

>  
>  	spin_unlock_irqrestore(&amd_lock, flags);
> +
> +	if (nb)
> +		pci_dev_put(nb);
> +	if (smbus)
> +		pci_dev_put(amd_chipset.smbus_dev);
>  }
>  EXPORT_SYMBOL_GPL(usb_amd_dev_put);

Alan Stern


