Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0KVTsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:48:40 -0500
Received: from kroah.org ([198.145.64.141]:36538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab0KVTsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:48:35 -0500
Date: Mon, 22 Nov 2010 11:48:26 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Allyn <mark.a.allyn@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: linux-next: boot failure in sep driver
Message-ID: <20101122194826.GB29830@kroah.com>
References: <20101122170914.efa10679.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122170914.efa10679.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 05:09:14PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> One of my boot tests failed like this:
> 
> Unable to handle kernel paging request for data at address 0x00000340
> Faulting instruction address: 0xc0000000000b4b98
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=1024 NUMA pSeries
> last sysfs file: 
> Modules linked in:
> NIP: c0000000000b4b98 LR: c00000000094dc60 CTR: 0000000000000000
> REGS: c0000007b121fb00 TRAP: 0300   Not tainted  (2.6.37-rc3-autokern1)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000082  XER: 0000000d
> DAR: 0000000000000340, DSISR: 0000000042000000
> TASK = c0000007b1208330[1] 'swapper' THREAD: c0000007b121c000 CPU: 4
> GPR00: 0000000000000338 c0000007b121fd80 c000000000f1bb80 0000000000000330 
> GPR04: c000000001475350 c000000000871d70 c0000007aa5ffbc0 0000000000000001 
> GPR08: 0000000000000000 0000000000000000 0000000000006c73 c0000007aa5ffbd0 
> GPR12: 0000000024000082 c00000000ff60a00 0000000003680000 0000000000677c00 
> GPR16: 0000000003680000 0000000002180000 0000000000c894b8 0000000002ad93e0 
> GPR20: 0000000000000000 0000000002ad8f60 0000000002ad8eb8 0000000002180000 
> GPR24: 000000008b909c7e c0000007b121fe90 0000000002180000 0000000000000000 
> GPR28: c000000001475350 0000000000000000 c000000000ec20b0 0000000000000000 
> NIP [c0000000000b4b98] .__init_waitqueue_head+0x8/0x20
> LR [c00000000094dc60] .sep_init+0x7c/0x3c0
> Call Trace:
> [c0000007b121fd80] [c00000000094dc24] .sep_init+0x40/0x3c0 (unreliable)
> [c0000007b121fe20] [c000000000009894] .do_one_initcall+0x1a4/0x1e0
> [c0000007b121fee0] [c0000000009104c4] .kernel_init+0x254/0x310
> [c0000007b121ff90] [c0000000000312a4] .kernel_thread+0x54/0x70
> Instruction dump:
> eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020 7c0004ac 9bad0214 4bffff64 
> 60000000 60000000 38030008 39200000 <f8030010> 91230000 f8030008 4e800020 
> ---[ end trace ee7a73365e284457 ]---
> Kernel panic - not syncing: Attempted to kill init!
> Call Trace:
> [c0000007b121f720] [c0000000000143b4] .show_stack+0x74/0x1c0 (unreliable)
> [c0000007b121f7d0] [c00000000066c05c] .panic+0x9c/0x1f4
> [c0000007b121f870] [c00000000008ed84] .do_exit+0x714/0x870
> [c0000007b121f970] [c00000000002eb64] .die+0x164/0x2c0
> [c0000007b121fa10] [c000000000041614] .bad_page_fault+0xc4/0x110
> [c0000007b121fa90] [c000000000005248] handle_page_fault+0x3c/0x74
> --- Exception: 300 at .__init_waitqueue_head+0x8/0x20
>     LR = .sep_init+0x7c/0x3c0
> [c0000007b121fd80] [c00000000094dc24] .sep_init+0x40/0x3c0 (unreliable)
> [c0000007b121fe20] [c000000000009894] .do_one_initcall+0x1a4/0x1e0
> [c0000007b121fee0] [c0000000009104c4] .kernel_init+0x254/0x310
> [c0000007b121ff90] [c0000000000312a4] .kernel_thread+0x54/0x70
> 
> I don't know why the sep driver was built, but even so, the sep_init
> function does this:
> 
> static struct sep_device *sep_dev;
> 	.
> 	.
> static int __init sep_init(void)
> {
> 	.
> 	.
> 	sep = sep_dev;
> 
>         init_waitqueue_head(&sep->event);
>         init_waitqueue_head(&sep->event_request_daemon);
>         spin_lock_init(&sep->snd_rply_lck);
>         mutex_init(&sep->sep_mutex);
>         mutex_init(&sep->ioctl_mutex);
> 
> And sep_dev is not allocated until probe time ... and it never gets
> probed on my system, of course.

Ick.

Mark seems to be gone until next week or so, so I guess I will just mark
this driver as CONFIG_BROKEN for now to keep this from happening.

thanks,

greg k-h
