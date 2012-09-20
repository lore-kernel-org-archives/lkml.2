Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2ITVt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:49:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55172 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2ITVtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:49:23 -0400
From: "Bruce, Becky" <bbruce@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Thread-Topic: rcu self-detected stall messages on OMAP3, 4 boards
Thread-Index: AQHNlsN7frxYPZrEKkCUD0Qz+VBf1ZeTMQ2AgADovgA=
Date: Thu, 20 Sep 2012 21:49:13 +0000
Message-ID: <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com>
 <20120913011208.GT4257@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com>
 <20120920000351.GI2455@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D75E071618FA04B9A1F0C2A52680F96@owa.mail.ti.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 20, 2012, at 2:56 AM, Paul Walmsley wrote:

> Hi,
> 
> On Wed, 19 Sep 2012, Paul E. McKenney wrote:
> 
>> On Thu, Sep 13, 2012 at 06:52:10PM +0000, Paul Walmsley wrote:
>> 
>>> On Wed, 12 Sep 2012, Paul E. McKenney wrote:
>> 
>>>> Subodh Nijsure (also CCed) reported something that might be similar on
>>>> ARM, and also reported that setting the following got rid of the stalls:
>>>> 
>>>> 	CONFIG_CPU_IDLE=y
>>>> 	CONFIG_CPU_IDLE_GOV_LADDER=y
>>>> 	CONFIG_CPU_IDLE_GOV_MENU=y
>>>> 
>>>> At which point he was happy, which was good, but which also left the
>>>> underlying problem unsolved.  Do these affect your system?  If so,
>>>> do they cause a different ARM idle loop to be executed?
>>> 
>>> Will give this a try.  What board was Subodh using?
>> 
>> Any news on trying the above settings?
> 
> Sorry, haven't had the chance to try it yet due to the impending merge 
> window opening.  Once things settle down I'll give it a try -- or maybe 
> someone else can test it in the meantime.
> 

OK, people, you can stop heckling me about "sent from my iPhone" - I'm in the wilds of rural Louisiana with really bad internet service and was trying to work on my phone (but, alas, did not notice the CC list included the entire universe).   Shame on me.

With the above set, I don't seem to see any stalls with the RCU timeout set to 60s (the default).  I left the board running for 25 minutes; I will fire it up again later and let it run for a bit longer, but usually I end up seeing the problem pretty quickly so I don't expect that to result in anything.  I also didn't see any stalls on Paul's RCU tree as of a week ago at 60s, so as far as I can tell the CPU_IDLE stuff didn't have any impact (it wasn't on when I tested Paul's tree).

If I drop the timeout to 5s as Paul M. suggested for debug a while back, I do see stalls (both with CPU_IDLE stuff and without). 

I'm using the default omap2plus config, with RCU stall info enabled and the cpu idle stuff turned on (console dump below).  This is a Panda ES 1.1 (OMAP4460)

root@omap4430-panda:~# zcat /proc/config/gz. .. .. ..gz | grep RCU
# RCU Subsystem
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=5
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
root@omap4430-panda:~# zcat /proc/config.gz | grep IDLE
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED=y

Paul, let me know if you want me to try anything else.  My internet connection is spotty today but (obviously :) I will see emails on my phone and will test when I can.

Cheers,
B

Console output:

root@omap4430-panda:~# [  377.495361] INFO: rcu_sched self-detected stall on CPU
[  377.500762] .1: (1 ticks this GP) idle=dcd/1/0 
[  377.505523] . (t=761 jiffies)
[  377.508666] [<c0019da0>] (unwind_backtrace+0x0/0xf8) from [<c009b138>] (rcu_check_callbacks+0x204/0x790)
[  377.518615] [<c009b138>] (rcu_check_callbacks+0x204/0x790) from [<c0045890>] (update_process_times+0x38/0x68)
[  377.529022] [<c0045890>] (update_process_times+0x38/0x68) from [<c007d47c>] (tick_sched_timer+0x80/0xec)
[  377.538970] [<c007d47c>] (tick_sched_timer+0x80/0xec) from [<c005a2fc>] (__run_hrtimer+0x7c/0x218)
[  377.548339] [<c005a2fc>] (__run_hrtimer+0x7c/0x218) from [<c005b040>] (hrtimer_interrupt+0x130/0x2d8)
[  377.558013] [<c005b040>] (hrtimer_interrupt+0x130/0x2d8) from [<c0018998>] (twd_handler+0x30/0x44)
[  377.567413] [<c0018998>] (twd_handler+0x30/0x44) from [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158)
[  377.577270] [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158) from [<c00929ac>] (generic_handle_irq+0x30/0x44)
[  377.587768] [<c00929ac>] (generic_handle_irq+0x30/0x44) from [<c0013bd8>] (handle_IRQ+0x4c/0xac)
[  377.596984] [<c0013bd8>] (handle_IRQ+0x4c/0xac) from [<c0008470>] (gic_handle_irq+0x24/0x58)
[  377.605834] [<c0008470>] (gic_handle_irq+0x24/0x58) from [<c0487604>] (__irq_svc+0x44/0x58)
[  377.614593] Exception stack(0xee06ff08 to 0xee06ff50)
[  377.619873] ff00:                   00000001 00000001 00000000 3b9aca00 c608bc44 00000057
[  377.628448] ff20: c146a4f0 00000002 c54e3b8f 00000056 c048fb3c c0c47654 00000001 ee06ff50
[  377.637023] ff40: c0084774 c0390fac 20000113 ffffffff
[  377.642333] [<c0487604>] (__irq_svc+0x44/0x58) from [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4)
[  377.651458] [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4) from [<c0390a80>] (cpuidle_enter_state+0x14/0x68)
[  377.661499] [<c0390a80>] (cpuidle_enter_state+0x14/0x68) from [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0)
[  377.672515] [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0) from [<c0390c48>] (cpuidle_idle_call+0x174/0x308)
[  377.683563] [<c0390c48>] (cpuidle_idle_call+0x174/0x308) from [<c0014098>] (cpu_idle+0x54/0x12c)
[  377.692779] [<c0014098>] (cpu_idle+0x54/0x12c) from [<8047c6f4>] (0x8047c6f4)
root@omap4430-panda:~# [  821.495361] INFO: rcu_sched self-detected stall on CPU
[  821.500762] .1: (1 ticks this GP) idle=0ad/1/0 
[  821.505523] . (t=755 jiffies)
[  821.508666] [<c0019da0>] (unwind_backtrace+0x0/0xf8) from [<c009b138>] (rcu_check_callbacks+0x204/0x790)
[  821.518615] [<c009b138>] (rcu_check_callbacks+0x204/0x790) from [<c0045890>] (update_process_times+0x38/0x68)
[  821.529022] [<c0045890>] (update_process_times+0x38/0x68) from [<c007d47c>] (tick_sched_timer+0x80/0xec)
[  821.538940] [<c007d47c>] (tick_sched_timer+0x80/0xec) from [<c005a2fc>] (__run_hrtimer+0x7c/0x218)
[  821.548339] [<c005a2fc>] (__run_hrtimer+0x7c/0x218) from [<c005b040>] (hrtimer_interrupt+0x130/0x2d8)
[  821.558013] [<c005b040>] (hrtimer_interrupt+0x130/0x2d8) from [<c0018998>] (twd_handler+0x30/0x44)
[  821.567413] [<c0018998>] (twd_handler+0x30/0x44) from [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158)
[  821.577270] [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158) from [<c00929ac>] (generic_handle_irq+0x30/0x44)
[  821.587768] [<c00929ac>] (generic_handle_irq+0x30/0x44) from [<c0013bd8>] (handle_IRQ+0x4c/0xac)
[  821.596984] [<c0013bd8>] (handle_IRQ+0x4c/0xac) from [<c0008470>] (gic_handle_irq+0x24/0x58)
[  821.605834] [<c0008470>] (gic_handle_irq+0x24/0x58) from [<c0487604>] (__irq_svc+0x44/0x58)
[  821.614593] Exception stack(0xee06ff08 to 0xee06ff50)
[  821.619873] ff00:                   00000001 00000001 00000000 3b9aca00 267f1536 000000bf
[  821.628448] ff20: c146a4f0 00000002 7da95560 000000be c048fb3c c0c47654 00000000 ee06ff50
[  821.637023] ff40: c0084774 c0390fac 20000113 ffffffff
[  821.642333] [<c0487604>] (__irq_svc+0x44/0x58) from [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4)
[  821.651458] [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4) from [<c0390a80>] (cpuidle_enter_state+0x14/0x68)
[  821.661468] [<c0390a80>] (cpuidle_enter_state+0x14/0x68) from [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0)
[  821.672515] [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0) from [<c0390c48>] (cpuidle_idle_call+0x174/0x308)
[  821.683563] [<c0390c48>] (cpuidle_idle_call+0x174/0x308) from [<c0014098>] (cpu_idle+0x54/0x12c)
[  821.692749] [<c0014098>] (cpu_idle+0x54/0x12c) from [<8047c6f4>] (0x8047c6f4)
[  827.495361] INFO: rcu_sched self-detected stall on CPU
[  827.500762] .1: (1 ticks this GP) idle=0d1/1/0 
[  827.505523] . (t=733 jiffies)
[  827.508636] [<c0019da0>] (unwind_backtrace+0x0/0xf8) from [<c009b138>] (rcu_check_callbacks+0x204/0x790)
[  827.518585] [<c009b138>] (rcu_check_callbacks+0x204/0x790) from [<c0045890>] (update_process_times+0x38/0x68)
[  827.528991] [<c0045890>] (update_process_times+0x38/0x68) from [<c007d47c>] (tick_sched_timer+0x80/0xec)
[  827.538940] [<c007d47c>] (tick_sched_timer+0x80/0xec) from [<c005a2fc>] (__run_hrtimer+0x7c/0x218)
[  827.548339] [<c005a2fc>] (__run_hrtimer+0x7c/0x218) from [<c005b040>] (hrtimer_interrupt+0x130/0x2d8)
[  827.558013] [<c005b040>] (hrtimer_interrupt+0x130/0x2d8) from [<c0018998>] (twd_handler+0x30/0x44)
[  827.567382] [<c0018998>] (twd_handler+0x30/0x44) from [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158)
[  827.577239] [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158) from [<c00929ac>] (generic_handle_irq+0x30/0x44)
[  827.587738] [<c00929ac>] (generic_handle_irq+0x30/0x44) from [<c0013bd8>] (handle_IRQ+0x4c/0xac)
[  827.596954] [<c0013bd8>] (handle_IRQ+0x4c/0xac) from [<c0008470>] (gic_handle_irq+0x24/0x58)
[  827.605804] [<c0008470>] (gic_handle_irq+0x24/0x58) from [<c0487604>] (__irq_svc+0x44/0x58)
[  827.614562] Exception stack(0xee06ff08 to 0xee06ff50)
[  827.619842] ff00:                   00000001 00000001 00000000 3b9aca00 8c1fd142 000000c0
[  827.628417] ff20: c146a4f0 00000002 a8004dd7 000000bf c048fb3c c0c47654 00000000 ee06ff50
[  827.636993] ff40: c0084774 c0390fac 20000113 ffffffff
[  827.642303] [<c0487604>] (__irq_svc+0x44/0x58) from [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4)
[  827.651428] [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4) from [<c0390a80>] (cpuidle_enter_state+0x14/0x68)
[  827.661437] [<c0390a80>] (cpuidle_enter_state+0x14/0x68) from [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0)
[  827.672485] [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0) from [<c0390c48>] (cpuidle_idle_call+0x174/0x308)
[  827.683502] [<c0390c48>] (cpuidle_idle_call+0x174/0x308) from [<c0014098>] (cpu_idle+0x54/0x12c)
[  827.692718] [<c0014098>] (cpu_idle+0x54/0x12c) from [<8047c6f4>] (0x8047c6f4)
[  833.495391] INFO: rcu_sched self-detected stall on CPU
[  833.500793] .1: (3 GPs behind) idle=0d9/1/0 
[  833.505279] . (t=733 jiffies)
[  833.508392] [<c0019da0>] (unwind_backtrace+0x0/0xf8) from [<c009b138>] (rcu_check_callbacks+0x204/0x790)
[  833.518341] [<c009b138>] (rcu_check_callbacks+0x204/0x790) from [<c0045890>] (update_process_times+0x38/0x68)
[  833.528747] [<c0045890>] (update_process_times+0x38/0x68) from [<c007d47c>] (tick_sched_timer+0x80/0xec)
[  833.538696] [<c007d47c>] (tick_sched_timer+0x80/0xec) from [<c005a2fc>] (__run_hrtimer+0x7c/0x218)
[  833.548095] [<c005a2fc>] (__run_hrtimer+0x7c/0x218) from [<c005b040>] (hrtimer_interrupt+0x130/0x2d8)
[  833.557769] [<c005b040>] (hrtimer_interrupt+0x130/0x2d8) from [<c0018998>] (twd_handler+0x30/0x44)
[  833.567138] [<c0018998>] (twd_handler+0x30/0x44) from [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158)
[  833.576995] [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158) from [<c00929ac>] (generic_handle_irq+0x30/0x44)
[  833.587493] [<c00929ac>] (generic_handle_irq+0x30/0x44) from [<c0013bd8>] (handle_IRQ+0x4c/0xac)
[  833.596710] [<c0013bd8>] (handle_IRQ+0x4c/0xac) from [<c0008470>] (gic_handle_irq+0x24/0x58)
[  833.605560] [<c0008470>] (gic_handle_irq+0x24/0x58) from [<c0487604>] (__irq_svc+0x44/0x58)
[  833.614318] Exception stack(0xee06ff08 to 0xee06ff50)
[  833.619598] ff00:                   00000001 00000001 00000000 3b9aca00 f1c10484 000000c1
[  833.628173] ff20: c146a4f0 00000002 d257bd83 000000c0 c048fb3c c0c47654 00000001 ee06ff50
[  833.636749] ff40: c0084774 c0390fac 20000113 ffffffff
[  833.642059] [<c0487604>] (__irq_svc+0x44/0x58) from [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4)
[  833.651184] [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4) from [<c0390a80>] (cpuidle_enter_state+0x14/0x68)
[  833.661193] [<c0390a80>] (cpuidle_enter_state+0x14/0x68) from [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0)
[  833.672241] [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0) from [<c0390c48>] (cpuidle_idle_call+0x174/0x308)
[  833.683288] [<c0390c48>] (cpuidle_idle_call+0x174/0x308) from [<c0014098>] (cpu_idle+0x54/0x12c)
[  833.692474] [<c0014098>] (cpu_idle+0x54/0x12c) from [<8047c6f4>] (0x8047c6f4)
[  839.495422] INFO: rcu_sched self-detected stall on CPU
[  839.500823] .1: (1 ticks this GP) idle=0fd/1/0 
[  839.505554] . (t=733 jiffies)
[  839.508697] [<c0019da0>] (unwind_backtrace+0x0/0xf8) from [<c009b138>] (rcu_check_callbacks+0x204/0x790)
[  839.518646] [<c009b138>] (rcu_check_callbacks+0x204/0x790) from [<c0045890>] (update_process_times+0x38/0x68)
[  839.529052] [<c0045890>] (update_process_times+0x38/0x68) from [<c007d47c>] (tick_sched_timer+0x80/0xec)
[  839.538970] [<c007d47c>] (tick_sched_timer+0x80/0xec) from [<c005a2fc>] (__run_hrtimer+0x7c/0x218)
[  839.548370] [<c005a2fc>] (__run_hrtimer+0x7c/0x218) from [<c005b040>] (hrtimer_interrupt+0x130/0x2d8)
[  839.558044] [<c005b040>] (hrtimer_interrupt+0x130/0x2d8) from [<c0018998>] (twd_handler+0x30/0x44)
[  839.567443] [<c0018998>] (twd_handler+0x30/0x44) from [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158)
[  839.577301] [<c00960cc>] (handle_percpu_devid_irq+0x90/0x158) from [<c00929ac>] (generic_handle_irq+0x30/0x44)
[  839.587799] [<c00929ac>] (generic_handle_irq+0x30/0x44) from [<c0013bd8>] (handle_IRQ+0x4c/0xac)
[  839.597015] [<c0013bd8>] (handle_IRQ+0x4c/0xac) from [<c0008470>] (gic_handle_irq+0x24/0x58)
[  839.605865] [<c0008470>] (gic_handle_irq+0x24/0x58) from [<c0487604>] (__irq_svc+0x44/0x58)
[  839.614593] Exception stack(0xee06ff08 to 0xee06ff50)
[  839.619903] ff00:                   00000001 00000001 00000000 3b9aca00 576237c7 000000c3
[  839.628479] ff20: c146a4f0 00000002 284df8f1 000000c3 c048fb3c c0c47654 00000000 ee06ff50
[  839.637054] ff40: c0084774 c0390fac 20000113 ffffffff
[  839.642333] [<c0487604>] (__irq_svc+0x44/0x58) from [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4)
[  839.651458] [<c0390fac>] (cpuidle_wrap_enter+0x4c/0xa4) from [<c0390a80>] (cpuidle_enter_state+0x14/0x68)
[  839.661499] [<c0390a80>] (cpuidle_enter_state+0x14/0x68) from [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0)
[  839.672546] [<c0392890>] (cpuidle_enter_state_coupled+0x210/0x2a0) from [<c0390c48>] (cpuidle_idle_call+0x174/0x308)
[  839.683563] [<c0390c48>] (cpuidle_idle_call+0x174/0x308) from [<c0014098>] (cpu_idle+0x54/0x12c)
[  839.692779] [<c0014098>] (cpu_idle+0x54/0x12c) from [<8047c6f4>] (0x8047c6f4)

....... ad infinitum