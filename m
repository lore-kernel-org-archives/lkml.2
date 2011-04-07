Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1DGJ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:58:19 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.183]:1874
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab1DGJ6R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:58:17 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zzbb2cK9371O542M1432N4015Lzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJA10Z-02-6LV-02
X-M-MSG: 
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Date: Thu, 7 Apr 2011 17:58:14 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0B013084C4@sshaexmb1.amd.com>
In-Reply-To: <1302164789-31887-1-git-send-email-joerg.roedel@amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Thread-Index: Acv0/Yd3ACQ1K7VuSx27Ed/bPbZj8gAC2RuQ
References: <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org> <1302164789-31887-1-git-send-email-joerg.roedel@amd.com>
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>, <stable@kernel.org>,
        "He, Alex" <Alex.He@amd.com>
X-OriginalArrivalTime: 07 Apr 2011 09:58:11.0323 (UTC) FILETIME=[4DC204B0:01CBF50A]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joerg Roedel [mailto:joerg.roedel@amd.com]
> Sent: Thursday, April 07, 2011 4:26 PM
> To: Greg Kroah-Hartman; Sarah Sharp; Xu, Andiry
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Roedel,
Joerg;
> stable@kernel.org
> Subject: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
> 
> Booting 2.6.38 on my test machine produces a lockdep warning
> from the usb_amd_find_chipset_info() function:
> 
>  WARNING: at /data/lemmy/linux.trees.git/kernel/lockdep.c:2465
> lockdep_trace_alloc+0x95/0xc2()
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
>  sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
>   [<ffffffff8123886c>] pci_get_device+0x11/0x13
>   [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
> ...
> 
> It turns out that this function calls pci_get_device under a spin_lock
> with irqs disabled, but the pci_get_device function is only allowed in
> preemptible context.
> 
> This patch fixes this by using temporary variables in the quirk
> algorithm and commiting them later to the struct under the lock. This
> moves all pci_get_device() invocations out of the spin_lock and fixes
> the lockdep warning.
> 
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/usb/host/pci-quirks.c |   86
+++++++++++++++++++++++++-----------
> -----
>  1 files changed, 52 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c
b/drivers/usb/host/pci-quirks.c
> index 1d586d4..b5802f6 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -84,65 +84,83 @@ int usb_amd_find_chipset_info(void)
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
>  		spin_unlock_irqrestore(&amd_lock, flags);
>  		return amd_chipset.probe_result;
>  	}
> +	info = amd_chipset;
> +	spin_unlock_irqrestore(&amd_lock, flags);
> 
> -	amd_chipset.smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI,
0x4385,
> NULL);
> -	if (amd_chipset.smbus_dev) {
> -		rev = amd_chipset.smbus_dev->revision;
> +	info.smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385,
NULL);
> +	if (info.smbus_dev) {
> +		rev = info.smbus_dev->revision;
>  		if (rev >= 0x40)
> -			amd_chipset.sb_type = 1;
> +			info.sb_type = 1;
>  		else if (rev >= 0x30 && rev <= 0x3b)
> -			amd_chipset.sb_type = 3;
> +			info.sb_type = 3;
>  	} else {
> -		amd_chipset.smbus_dev =
pci_get_device(PCI_VENDOR_ID_AMD,
> -							0x780b, NULL);
> -		if (!amd_chipset.smbus_dev) {
> -			spin_unlock_irqrestore(&amd_lock, flags);
> -			return 0;
> +		info.smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
> +						0x780b, NULL);
> +		if (!info.smbus_dev) {
> +			ret = 0;
> +			goto commit;
>  		}
> -		rev = amd_chipset.smbus_dev->revision;
> +
> +		rev = info.smbus_dev->revision;
>  		if (rev >= 0x11 && rev <= 0x18)
> -			amd_chipset.sb_type = 2;
> +			info.sb_type = 2;
>  	}
> 
> -	if (amd_chipset.sb_type == 0) {
> -		if (amd_chipset.smbus_dev) {
> -			pci_dev_put(amd_chipset.smbus_dev);
> -			amd_chipset.smbus_dev = NULL;
> +	if (info.sb_type == 0) {
> +		if (info.smbus_dev) {
> +			pci_dev_put(info.smbus_dev);
> +			info.smbus_dev = NULL;
>  		}
> -		spin_unlock_irqrestore(&amd_lock, flags);
> -		return 0;
> +		ret = 0;
> +		goto commit;
>  	}
> 
> -	amd_chipset.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x9601,
NULL);
> -	if (amd_chipset.nb_dev) {
> -		amd_chipset.nb_type = 1;
> +	info.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x9601, NULL);
> +	if (info.nb_dev) {
> +		info.nb_type = 1;
>  	} else {
> -		amd_chipset.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
> -							0x1510, NULL);
> -		if (amd_chipset.nb_dev) {
> -			amd_chipset.nb_type = 2;
> -		} else  {
> -			amd_chipset.nb_dev =
pci_get_device(PCI_VENDOR_ID_AMD,
> -								0x9600,
NULL);
> -			if (amd_chipset.nb_dev)
> -				amd_chipset.nb_type = 3;
> +		info.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x1510,
NULL);
> +		if (info.nb_dev) {
> +			info.nb_type = 2;
> +		} else {
> +			info.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
> +						     0x9600, NULL);
> +			if (info.nb_dev)
> +				info.nb_type = 3;
>  		}
>  	}
> 
> -	amd_chipset.probe_result = 1;
> +	ret = info.probe_result = 1;
>  	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
> 
> +commit:
> +
> +	spin_lock_irqsave(&amd_lock, flags);
> +	if (amd_chipset.probe_count > 0) {
> +		/* race - someone else was faster - drop devices */
> +		if (info.nb_dev)
> +			pci_dev_put(info.nb_dev);
> +		if (info.smbus_dev)
> +			pci_dev_put(info.smbus_dev);

You need to increase info.probe_count here and set
amd_chipset.probe_count with it, because it's decreased during every
host controller stop routine.


> +	} else {
> +		/* no race - commit the result */
> +		info.probe_count++;
> +		amd_chipset = info;
> +	}
>  	spin_unlock_irqrestore(&amd_lock, flags);
> -	return amd_chipset.probe_result;
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
> 
> --
> 1.7.1

The original design target is to probe the chipset only once, so other
host controllers will not probe the chipset again. This patch allows
multiple threads to probe the chipset at the same time, and only one
thread is doing the valid work. It may add unnecessary cost.

Thanks,
Andiry

