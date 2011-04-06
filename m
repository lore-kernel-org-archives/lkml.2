Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab1DFPQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:16:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50967 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756422Ab1DFPQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:16:08 -0400
Date: Wed, 6 Apr 2011 11:16:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joerg Roedel <joerg.roedel@amd.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011, Joerg Roedel wrote:

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
> the lockdep warning for me.
> 
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/usb/host/pci-quirks.c |   67 +++++++++++++++++++++++-----------------
>  1 files changed, 38 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 1d586d4..d3e5cf3 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -84,64 +84,73 @@ int usb_amd_find_chipset_info(void)
>  {
>  	u8 rev = 0;
>  	unsigned long flags;
> +	struct pci_dev *nb_dev, *smbus_dev;
> +	int nb_type, sb_type;
>  
>  	spin_lock_irqsave(&amd_lock, flags);
> -
>  	amd_chipset.probe_count++;
>  	/* probe only once */
>  	if (amd_chipset.probe_count > 1) {
>  		spin_unlock_irqrestore(&amd_lock, flags);
>  		return amd_chipset.probe_result;
>  	}

The counter really should be a bool: Has the chipset already been
probed or not?  After all, nobody cares how many times this routine was 
called.

> +	spin_unlock_irqrestore(&amd_lock, flags);

This code now contains a bug: You incremented the probe_count _before_
doing the probe.  If another thread calls this routine right now, it
will get an incorrect result.

Fixing this up should be fairly easy.

Alan Stern

