Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2IMSwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:52:13 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:44523 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab2IMSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:52:11 -0400
Date: Thu, 13 Sep 2012 18:52:10 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, bbruce@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@ti.com, santosh.shilimkar@ti.com, jon-hunter@ti.com,
        snijsure@grid-net.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <20120913011208.GT4257@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com> <20120913011208.GT4257@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

thanks for the reply,

On Wed, 12 Sep 2012, Paul E. McKenney wrote:

> Interesting.  I am assuming that the interrupt in the stack below came
> from idle, if not, please let me know what.

According to the exception stack section in the original traceback, it
appears that the serial interrupt took the SoC out of idle.

> Could you please reproduce with CONFIG_RCU_CPU_STALL_INFO=y?  That would
> give me a bit more information about why RCU thought that there was
> a stall.  (CCing Becky Bruce, who saw something similar recently.)

At the bottom of this mail is a series of tracebacks with
CONFIG_RCU_CPU_STALL_INFO=y.  Unlike the traceback that was sent in
the last message, these were not triggered by serial activity.  These
appeared every 300 seconds.

> Subodh Nijsure (also CCed) reported something that might be similar on
> ARM, and also reported that setting the following got rid of the stalls:
> 
> 	CONFIG_CPU_IDLE=y
> 	CONFIG_CPU_IDLE_GOV_LADDER=y
> 	CONFIG_CPU_IDLE_GOV_MENU=y
> 
> At which point he was happy, which was good, but which also left the
> underlying problem unsolved.  Do these affect your system?  If so,
> do they cause a different ARM idle loop to be executed?

Will give this a try.  What board was Subodh using?


- Paul


Debian GNU/Linux wheezy/sid armel ttyO2

armel login: [  305.942108] INFO: rcu_sched self-detected stall on CPU
[  305.944946]  1: (7 GPs behind) idle=57b/1/0 
[  305.947265]   (t=22811 jiffies)
[  305.949066] [<c001b7cc>] (unwind_backtrace+0x0/0xf0) from [<c00acc28>] (rcu_check_callbacks+0x1b0/0x678)
[  305.954223] [<c00acc28>] (rcu_check_callbacks+0x1b0/0x678) from [<c00529e0>] (update_process_times+0x38/0x68)
[  305.959625] [<c00529e0>] (update_process_times+0x38/0x68) from [<c008bf14>] (tick_sched_timer+0x80/0xec)
[  305.964813] [<c008bf14>] (tick_sched_timer+0x80/0xec) from [<c006840c>] (__run_hrtimer+0x7c/0x1e0)
[  305.969696] [<c006840c>] (__run_hrtimer+0x7c/0x1e0) from [<c00691f0>] (hrtimer_interrupt+0x11c/0x2d0)
[  305.974731] [<c00691f0>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a04c>] (twd_handler+0x30/0x44)
[  305.979644] [<c001a04c>] (twd_handler+0x30/0x44) from [<c00a7068>] (handle_percpu_devid_irq+0x90/0x13c)
[  305.984741] [<c00a7068>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a37dc>] (generic_handle_irq+0x30/0x48)
[  305.990234] [<c00a37dc>] (generic_handle_irq+0x30/0x48) from [<c0014c58>] (handle_IRQ+0x4c/0xac)
[  305.995025] [<c0014c58>] (handle_IRQ+0x4c/0xac) from [<c0008478>] (gic_handle_irq+0x28/0x5c)
[  305.999633] [<c0008478>] (gic_handle_irq+0x28/0x5c) from [<c04f8ca4>] (__irq_svc+0x44/0x5c)
[  306.004180] Exception stack(0xde86ff88 to 0xde86ffd0)
[  306.006927] ff80:                   0003c6d0 00000001 00000000 de8660c0 de86e000 c07c23c8
[  306.011383] ffa0: c0504590 c0749e20 00000000 411fc092 c074a040 00000000 00000001 de86ffd0
[  306.015838] ffc0: 0003c6d1 c0014f50 20000113 ffffffff
[  306.018585] [<c04f8ca4>] (__irq_svc+0x44/0x5c) from [<c0014f50>] (default_idle+0x20/0x44)
[  306.023040] [<c0014f50>] (default_idle+0x20/0x44) from [<c001517c>] (cpu_idle+0x9c/0x114)
[  306.027526] [<c001517c>] (cpu_idle+0x9c/0x114) from [<804f1af4>] (0x804f1af4)
[  602.004486] INFO: rcu_sched detected stalls on CPUs/tasks:
[  602.007476]  (detected by 0, t=60707 jiffies)
[  602.009857] INFO: Stall ended before state dump start
[  906.027893] INFO: rcu_sched self-detected stall on CPU
[  906.030700]  1: (6 GPs behind) idle=647/1/0 
[  906.033020]   (t=38379 jiffies)
[  906.034790] [<c001b7cc>] (unwind_backtrace+0x0/0xf0) from [<c00acc28>] (rcu_check_callbacks+0x1b0/0x678)
[  906.039947] [<c00acc28>] (rcu_check_callbacks+0x1b0/0x678) from [<c00529e0>] (update_process_times+0x38/0x68)
[  906.045349] [<c00529e0>] (update_process_times+0x38/0x68) from [<c008bf14>] (tick_sched_timer+0x80/0xec)
[  906.050537] [<c008bf14>] (tick_sched_timer+0x80/0xec) from [<c006840c>] (__run_hrtimer+0x7c/0x1e0)
[  906.055419] [<c006840c>] (__run_hrtimer+0x7c/0x1e0) from [<c00691f0>] (hrtimer_interrupt+0x11c/0x2d0)
[  906.060424] [<c00691f0>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a04c>] (twd_handler+0x30/0x44)
[  906.065307] [<c001a04c>] (twd_handler+0x30/0x44) from [<c00a7068>] (handle_percpu_devid_irq+0x90/0x13c)
[  906.070434] [<c00a7068>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a37dc>] (generic_handle_irq+0x30/0x48)
[  906.075897] [<c00a37dc>] (generic_handle_irq+0x30/0x48) from [<c0014c58>] (handle_IRQ+0x4c/0xac)
[  906.080688] [<c0014c58>] (handle_IRQ+0x4c/0xac) from [<c0008478>] (gic_handle_irq+0x28/0x5c)
[  906.085296] [<c0008478>] (gic_handle_irq+0x28/0x5c) from [<c04f8ca4>] (__irq_svc+0x44/0x5c)
[  906.089843] Exception stack(0xde86ff88 to 0xde86ffd0)
[  906.092590] ff80:                   0003cb06 00000001 00000000 de8660c0 de86e000 c07c23c8
[  906.097045] ffa0: c0504590 c0749e20 00000000 411fc092 c074a040 00000000 00000001 de86ffd0
[  906.101501] ffc0: 0003cb07 c0014f50 20000113 ffffffff
[  906.104278] [<c04f8ca4>] (__irq_svc+0x44/0x5c) from [<c0014f50>] (default_idle+0x20/0x44)
[  906.108734] [<c0014f50>] (default_idle+0x20/0x44) from [<c001517c>] (cpu_idle+0x9c/0x114)
[  906.113189] [<c001517c>] (cpu_idle+0x9c/0x114) from [<804f1af4>] (0x804f1af4)
