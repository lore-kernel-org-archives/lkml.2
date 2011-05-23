Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1EWIaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:30:25 -0400
Received: from linux-sh.org ([111.68.239.195]:53230 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1EWIaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:30:23 -0400
Date: Mon, 23 May 2011 17:30:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] clocksource: sh_tmu: Runtime PM support
Message-ID: <20110523083005.GA11986@linux-sh.org>
References: <20110425134026.4249.13858.sendpatchset@t400s>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425134026.4249.13858.sendpatchset@t400s>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:40:26PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add Runtime PM support to the TMU driver.
> 
> The hardware device is enabled as long as the clocksource
> or the clockevent portion of the driver is used.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  Tested on the sh7372 Mackerel board with TMU00 and TMU01.
> 
Blows up on SMP or with spinlock debugging:

 sh_tmu.0: used for periodic clock events
BUG: spinlock trylock failure on UP on CPU#0, swapper/0
 lock: 804d5198, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Stack: (0x804cde00 to 0x804ce000)
de00: 8038e31c 804cde10 00000000 804d5198 80230142 804cde18 8047b698 80230396
de20: 804cde34 9f000ea0 804d5198 804d51a8 00000000 80391780 804cde40 802807cc
de40: 802807cc 804cde5c 00000000 9f000ea0 00000001 804d50f8 804d5198 00000004
de60: 802ec0c8 804cde74 00000001 00000002 9f000e60 802ec23a 804cde8c 9f000ea0
de80: 00000001 00000002 9f000e60 9f000e60 80499d18 802ec390 804cdeac 8038e4c0
dea0: ffffffff 00000002 9f000e60 8004990e 804cdebc 00000002 9f000ea0 80049f1e
dec0: 804cdecc 000000f0 9f000ea0 00000000 00000000 8004a0f2 804cdef4 00000000
dee0: 00000000 8038e4c0 ffffffff 000000f0 9f000ea0 8003ef84 804cdf14 80036aa0
df00: 00008000 8038e4c0 ffffffff 00000000 ffffffff 804e2530 9f000ea0 00000000
df20: 00000000 00000000 8003f02c 804cdf4c 000000c8 9f803c80 00000000 8004958c
df40: 804e2508 804e2500 00000000 800495b0 804cdf54 8004961e 804cdf5c 8038cebc
df60: 804cdf74 9f000ea0 804d50f0 804d50f8 9f000e60 804d7918 80661046 804cdf98
df80: 00000001 00000000 00000000 00000000 806758a4 804d50f0 00000000 8027c96a
dfa0: 80673850 00000000 00000002 00000002 80453acc 80650f9a 804cdfd4 80223500
dfc0: 806790b0 8066aa90 000000f0 8000376c 8038e4c0 8064f6fc 804cdfdc 8066af30
dfe0: 40002132 804cde10 000001bc 000002c0 ff000100 00000010 00000090 40000198
[    0.000000]
Call trace:
 [<8038e31c>] dump_stack+0x20/0x2c
 [<80230142>] spin_bug+0x8a/0xb8
 [<80230396>] do_raw_spin_trylock+0x3a/0x50
 [<80391780>] _raw_spin_lock_irqsave+0x5c/0xac
 [<802807cc>] __pm_runtime_resume+0x44/0x7c
 [<802807cc>] __pm_runtime_resume+0x44/0x7c
 [<802ec0c8>] sh_tmu_enable+0x2c/0xb8
 [<802ec23a>] sh_tmu_clock_event_start+0x2e/0xbc
 [<802ec390>] sh_tmu_clock_event_mode+0x70/0x9c
 [<8038e4c0>] printk+0x0/0x40
 [<8004990e>] clockevents_set_mode+0x2e/0x4e
 [<80049f1e>] tick_setup_periodic+0x42/0xf4
 [<8004a0f2>] tick_notify+0x122/0x238
 [<8038e4c0>] printk+0x0/0x40
 [<8003ef84>] notifier_call_chain+0x64/0xb8
 [<80036aa0>] func_ptr_is_kernel_text+0x0/0x40
 [<8038e4c0>] printk+0x0/0x40
 [<8003f02c>] raw_notifier_call_chain+0x24/0x30
 [<8004958c>] clockevents_do_notify+0x0/0x34
 [<800495b0>] clockevents_do_notify+0x24/0x34
 [<8004961e>] clockevents_register_device+0x5e/0xb0
 [<8038cebc>] sh_tmu_probe+0x164/0x2a0
 [<80661046>] early_platform_driver_probe+0x15e/0x1f4
 [<8027c96a>] platform_match+0x0/0x78
 [<80650f9a>] sh_late_time_init+0x16/0x2c
 [<80223500>] strlen+0x0/0x58
 [<8066aa90>] boot_command_line+0x0/0x200
 [<8000376c>] arch_local_irq_restore+0x0/0x2a
 [<8038e4c0>] printk+0x0/0x40
 [<8064f6fc>] start_kernel+0x310/0x4e4

> @@ -109,10 +110,12 @@ static int sh_tmu_enable(struct sh_tmu_p
>  {
>  	int ret;
>  
> -	/* enable clock */
> +	/* wake up device and enable clock */
> +	pm_runtime_get_sync(&p->pdev->dev);
>  	ret = clk_enable(p->clk);
>  	if (ret) {
>  		dev_err(&p->pdev->dev, "cannot enable clock\n");
> +		pm_runtime_put_sync(&p->pdev->dev);
>  		return ret;
>  	}
>  
At this point the spinlock hasn't been initialized yet, so any of the
pm_runtime calls are pretty much unsafe. We could manually test
pm_runtime_enabled() before any of the get/put_sync() calls, but that gets to
be a bit ugly.
