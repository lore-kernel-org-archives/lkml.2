Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2ILWvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:51:35 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:41626 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2ILWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:51:32 -0400
Date: Wed, 12 Sep 2012 22:51:30 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>, paulmck@linux.vnet.ibm.com
cc: linux-kernel@vger.kernel.org, bbruce@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        jon-hunter@ti.com
Subject: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Paul

Recently several of us have been seeing "INFO: rcu_sched self-detected
stall on CPU { 0} (t=20611 jiffies)" stack tracebacks on various OMAP3
and 4 board.

I only noticed it during v3.6-rc3, but I suspect it's been happening 
for users at least since May:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg68942.html


The only quasi-reproducible test case that I've found so far 
is to boot the board with serial console enabled to a login prompt, then 
wait for a few minutes, then send a keypress to the board via serial.
The tracebacks I get look like this:

[  467.480712] INFO: rcu_sched self-detected stall on CPU { 0}  (t=20611 jiffies)
[  467.484741] [<c001b7cc>] (unwind_backtrace+0x0/0xf0) from [<c00acc94>] (rcu_check_callbacks+0x180/0x630)
[  467.489929] [<c00acc94>] (rcu_check_callbacks+0x180/0x630) from [<c0052b18>] (update_process_times+0x38/0x68)
[  467.495361] [<c0052b18>] (update_process_times+0x38/0x68) from [<c008c04c>] (tick_sched_timer+0x80/0xec)
[  467.500518] [<c008c04c>] (tick_sched_timer+0x80/0xec) from [<c0068544>] (__run_hrtimer+0x7c/0x1e0)
[  467.505401] [<c0068544>] (__run_hrtimer+0x7c/0x1e0) from [<c0069328>] (hrtimer_interrupt+0x11c/0x2d0)
[  467.510437] [<c0069328>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a04c>] (twd_handler+0x30/0x44)
[  467.515350] [<c001a04c>] (twd_handler+0x30/0x44) from [<c00a71a0>] (handle_percpu_devid_irq+0x90/0x13c)
[  467.520477] [<c00a71a0>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a3914>] (generic_handle_irq+0x30/0x48)
[  467.525939] [<c00a3914>] (generic_handle_irq+0x30/0x48) from [<c0014c58>] (handle_IRQ+0x4c/0xac)
[  467.530731] [<c0014c58>] (handle_IRQ+0x4c/0xac) from [<c0008478>] (gic_handle_irq+0x28/0x5c)
[  467.535339] [<c0008478>] (gic_handle_irq+0x28/0x5c) from [<c04f8ce4>] (__irq_svc+0x44/0x5c)
[  467.539886] Exception stack(0xc0729f58 to 0xc0729fa0)
[  467.542663] 9f40:                                                       00047f2a 00000001
[  467.547119] 9f60: 00000000 c074a940 c0728000 c07c4b08 c05045a0 c074be20 00000000 411fc092
[  467.551574] 9f80: c074c040 00000000 00000001 c0729fa0 00047f2b c0014f50 20000113 ffffffff
[  467.556030] [<c04f8ce4>] (__irq_svc+0x44/0x5c) from [<c0014f50>] (default_idle+0x20/0x44)
[  467.560485] [<c0014f50>] (default_idle+0x20/0x44) from [<c001517c>] (cpu_idle+0x9c/0x114)
[  467.564971] [<c001517c>] (cpu_idle+0x9c/0x114) from [<c06d77b0>] (start_kernel+0x2b4/0x304)

Looks like this message was added as of commit
a858af2875fb291d0f4b0a4419fefbf03c2379c0 ("rcu: Print scheduling-clock
information on RCU CPU stall-warning messages").

Do you have any suggestions for how we can determine what is causing
this?

Here's an example of a kernel config that we use:

http://www.pwsan.com/omap/testlogs/am33xx_hwmod_clock_devel_3.7/20120912092510/build/omap2plus_defconfig/Kconfig

A few observations that may or may not be relevant: we use NO_HZ, and 
we also have a clockevents timer that is relatively slow to program.


regards,

- Paul
