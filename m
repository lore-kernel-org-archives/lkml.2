Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1DKKBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:01:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61273 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1DKKBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:01:51 -0400
Message-ID: <4DA2D12E.6010108@ru.mvista.com>
Date: Mon, 11 Apr 2011 14:00:14 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH v5] USB host: Fix lockdep warning in AMD PLL quirk
References: <2DEEA3AB13739D45A22ADDB5086AEA0B013084C4@sshaexmb1.amd.com> <1302182044-3940-1-git-send-email-joerg.roedel@amd.com> <20110411062559.GA25536@liondog.tnic> <20110411065957.GI23633@amd.com>
In-Reply-To: <20110411065957.GI23633@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-04-2011 10:59, Roedel, Joerg wrote:

>> You mean 2.6.39-rc2 right? I'm asking because I hit the same warning
>> with 39-rc2 now too but it didn't appear with .38 - so it has to have
>> snuck in after the merge window. If so, you don't need the stable tag.

> You were right, just tested plain 2.6.38 and it doesn't happen. So I
> removed the stable tag. Here is the updated patch.

>  From 6b9a9018cf0b847dcd906c269d663668e67a097d Mon Sep 17 00:00:00 2001
> From: Joerg Roedel<joerg.roedel@amd.com>
> Date: Wed, 6 Apr 2011 13:07:53 +0200
> Subject: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk

> Booting 2.6.38 on my test machine produces a lockdep warning

    You've just said that this doesn't happen with plain 2.6.38...

> from the usb_amd_find_chipset_info() function:

>   WARNING: at /data/lemmy/linux.trees.git/kernel/lockdep.c:2465 lockdep_trace_alloc+0x95/0xc2()
>   Hardware name: Snook
>   Modules linked in:
>   Pid: 959, comm: work_for_cpu Not tainted 2.6.39-rc2+ #22
>   Call Trace:
>    [<ffffffff8103c0d4>] warn_slowpath_common+0x80/0x98
>    [<ffffffff812387e6>] ? T.492+0x24/0x26
>    [<ffffffff8103c101>] warn_slowpath_null+0x15/0x17
>    [<ffffffff81068667>] lockdep_trace_alloc+0x95/0xc2
>    [<ffffffff810ed9ac>] slab_pre_alloc_hook+0x18/0x3b
>    [<ffffffff810ef227>] kmem_cache_alloc_trace+0x25/0xba
>    [<ffffffff812387e6>] T.492+0x24/0x26
>    [<ffffffff81238816>] pci_get_subsys+0x2e/0x73
>    [<ffffffff8123886c>] pci_get_device+0x11/0x13
>    [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
> ...

> It turns out that this function calls pci_get_device under a spin_lock
> with irqs disabled, but the pci_get_device function is only allowed in
> preemptible context.

> This patch fixes the warning by making all data-structure
> modifications on temporal storage and commiting this back
> into the visible structure at the end. While at it, this
> patch also moves the pci_dev_put calls out of the spinlocks
> because this function might sleep too.

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>   drivers/usb/host/pci-quirks.c |  117 ++++++++++++++++++++++++++---------------
>   1 files changed, 74 insertions(+), 43 deletions(-)

> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 1d586d4..c6eb69c 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
[...]
> @@ -294,20 +322,23 @@ void usb_amd_dev_put(void)
>   		return;
>   	}
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
>   	amd_chipset.nb_type = 0;
>   	amd_chipset.sb_type = 0;
>   	amd_chipset.isoc_reqs = 0;
>   	amd_chipset.probe_result = 0;
>
>   	spin_unlock_irqrestore(&amd_lock, flags);
> +
> +	if (nb)
> +		pci_dev_put(nb);
> +	if (smbus)
> +		pci_dev_put(amd_chipset.smbus_dev);

    Haven't you just set this to NULL?

WBR, Sergei
