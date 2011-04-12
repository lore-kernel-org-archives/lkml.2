Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1DLLBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:01:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48271 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab1DLLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:01:04 -0400
Message-ID: <4DA4308F.6060601@ru.mvista.com>
Date: Tue, 12 Apr 2011 14:59:27 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Borislav Petkov <bp@alien8.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] USB host: Fix lockdep warning in AMD PLL quirk
References: <20110411163711.GA20607@amd.com> <Pine.LNX.4.44L0.1104111304080.1975-100000@iolanthe.rowland.org> <20110412064128.GC20607@amd.com>
In-Reply-To: <20110412064128.GC20607@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-04-2011 10:41, Roedel, Joerg wrote:

>>> Hmm, I see how it can be done differently, but no real bug.

>> Never mind, you're right.  In the no-race case, the initial count is
>> always going to be 0, and so incrementing info.probe_count is the right
>> thing to do.

> Okay, cool. So now that we have settled on this I removed the last
> occurence of '2.6.38' from the changelog and here is the result. No
> code changes since v5.

    I've pointed out the mistake in the code that you didn't fix... :-(

>  From a6e00d237f20e940afdbcaafb27117fe8730466f Mon Sep 17 00:00:00 2001
> From: Joerg Roedel<joerg.roedel@amd.com>
> Date: Wed, 6 Apr 2011 13:07:53 +0200
> Subject: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk

> Booting latest kernel on my test machine produces a lockdep
> warning from the usb_amd_find_chipset_info() function:

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

    Here it is. This pointer is NULL, it should be 'smbus' instead.

WBR, Sergei
