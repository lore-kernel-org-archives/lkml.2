Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2AXT55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:57:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49402 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2AXT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:57:56 -0500
Message-ID: <1327435069.2767.1.camel@edumazet-laptop>
Subject: Re: [GIT PULL] RCU changes for v3.3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 24 Jan 2012 20:57:49 +0100
In-Reply-To: <20120124194140.GB2381@linux.vnet.ibm.com>
References: <20120105135432.GA31450@elte.hu>
	 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120124165312.GG2531@linux.vnet.ibm.com>
	 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120124194140.GB2381@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 11:41 -0800, Paul E. McKenney a écrit :

> Ah, I see...  I need to find one of trace_power_start(),
> trace_power_frequency(), or trace_power_end().  I would have to guess
> that this is either the trace_power_start() or the trace_power_end()
> called from drivers/cpuidle/cpuidle.c lines 97 and 102.  Those are
> within cpuidle_idle_call(), which are called from cpu_idle() in
> arch/x86/kernel/process_32.c and arch/x86/kernel/process_64.c, so this
> sounds plausible.
> 
> And they are indeed busted -- RCU believes the CPU is idle at the point
> that cpuidle_idle_call() is invoked.
> 
> A hacky patch is below.  Here are some of my concerns with it:
> 
> 1.	Is there a configuration in which the scheduler clock gets
> 	turned off, but in which cpuidle_idle_call() always returns
> 	zero?  If so, we either really need RCU to consider the entire
> 	inner loop to be idle (thus needing to snapshot the value of
> 	cpuidle_idle_call() in the outer loop) or we need explicit calls
> 	to rcu_sched_qs() and friends.
> 
> 	Yes, we could momentarily exit RCU idleness mode, but I would
> 	need to think that one through...
> 
> 2.	I am not totally confident that I have the order of operations
> 	surrounding the call to pm_idle() correct.
> 
> 3.	This only addresses x86, and it looks like a few other architectures
> 	have this same problem.
> 
> 4.	Probably other things that I haven't thought of.
> 
> That said, the patch does seem to compile, at least on my 32-bit
> laptop...
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> idle: Avoid using RCU when RCU thinks the CPU is idle
> 
> The x86 idle loops invoke cpuidle_idle_call() which uses tracing
> which uses RCU.  Unfortunately, these idle loops have already
> told RCU to ignore this CPU when they call it.  This patch hacks
> the idle loops to avoid this problem, but probably causing several
> other problems in the process.
> 
> Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

Hi Paul

Just tested it on my x86_64 machine, but warnings are still here

Thanks !

[   61.111559] 
[   61.111563] ===============================
[   61.111565] [ INFO: suspicious RCU usage. ]
[   61.111567] 3.3.0-rc1+ #572 Not tainted
[   61.111569] -------------------------------
[   61.111571] include/trace/events/power.h:102 suspicious rcu_dereference_check() usage!
[   61.111573] 
[   61.111574] other info that might help us debug this:
[   61.111575] 
[   61.111577] 
[   61.111577] rcu_scheduler_active = 1, debug_locks = 1
[   61.111579] RCU used illegally from extended quiescent state!
[   61.111582] no locks held by swapper/0/0.
[   61.111583] 
[   61.111584] stack backtrace:
[   61.111587] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc1+ #572
[   61.111589] Call Trace:
[   61.111598]  [<ffffffff810949ba>] lockdep_rcu_suspicious+0xca/0xf0
[   61.111604]  [<ffffffff8100abb9>] mwait_idle+0x499/0x4c0
[   61.111609]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.111615]  [<ffffffff8174f49f>] rest_init+0x133/0x144
[   61.111618]  [<ffffffff8174f3e5>] ? rest_init+0x79/0x144
[   61.111623]  [<ffffffff81cc2b51>] start_kernel+0x35b/0x366
[   61.111627]  [<ffffffff81cc2321>] x86_64_start_reservations+0x131/0x135
[   61.111631]  [<ffffffff81cc2415>] x86_64_start_kernel+0xf0/0xf7
[   61.111743] ------------[ cut here ]------------
[   61.111750] WARNING: at include/linux/rcupdate.h:242 __perf_event_overflow+0x27c/0x2c0()
[   61.111754] Hardware name: ProLiant BL460c G6
[   61.111756] Modules linked in: ipmi_devintf nfsd exportfs hpilo ipmi_si bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[   61.111770] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc1+ #572
[   61.111772] Call Trace:
[   61.111777]  [<ffffffff81038eaf>] warn_slowpath_common+0x7f/0xc0
[   61.111781]  [<ffffffff81038f0a>] warn_slowpath_null+0x1a/0x20
[   61.111784]  [<ffffffff810f8ebc>] __perf_event_overflow+0x27c/0x2c0
[   61.111788]  [<ffffffff817711ae>] ? printk+0x41/0x43
[   61.111794]  [<ffffffff810a1f86>] ? __module_text_address+0x16/0x80
[   61.111798]  [<ffffffff810f8fa9>] perf_swevent_overflow+0xa9/0xc0
[   61.111801]  [<ffffffff810f902f>] perf_swevent_event+0x6f/0x90
[   61.111804]  [<ffffffff810f90c6>] perf_tp_event+0x76/0xf0
[   61.111809]  [<ffffffff810f14ce>] perf_trace_power+0xbe/0xe0
[   61.111812]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[   61.111815]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[   61.111819]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.111822]  [<ffffffff8174f49f>] rest_init+0x133/0x144
[   61.111825]  [<ffffffff8174f3e5>] ? rest_init+0x79/0x144
[   61.111828]  [<ffffffff81cc2b51>] start_kernel+0x35b/0x366
[   61.111831]  [<ffffffff81cc2321>] x86_64_start_reservations+0x131/0x135
[   61.111834]  [<ffffffff81cc2415>] x86_64_start_kernel+0xf0/0xf7
[   61.111837] ---[ end trace 18a36211154afbbb ]---
[   61.111839] ------------[ cut here ]------------
[   61.111843] WARNING: at include/linux/rcupdate.h:242 perf_output_begin+0x2f6/0x330()
[   61.111845] Hardware name: ProLiant BL460c G6
[   61.111848] Modules linked in: ipmi_devintf nfsd exportfs hpilo ipmi_si bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[   61.111859] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc1+ #572
[   61.111861] Call Trace:
[   61.111864]  [<ffffffff81038eaf>] warn_slowpath_common+0x7f/0xc0
[   61.111868]  [<ffffffff81038f0a>] warn_slowpath_null+0x1a/0x20
[   61.111871]  [<ffffffff810fc286>] perf_output_begin+0x2f6/0x330
[   61.111875]  [<ffffffff81076975>] ? sched_clock_cpu+0xc5/0x120
[   61.111879]  [<ffffffff8109371d>] ? trace_hardirqs_off+0xd/0x10
[   61.111882]  [<ffffffff81076a1f>] ? local_clock+0x4f/0x60
[   61.111886]  [<ffffffff810f21cd>] ? __perf_event_header__init_id+0xad/0xf0
[   61.111889]  [<ffffffff810f8b93>] ? perf_prepare_sample+0x63/0x110
[   61.111892]  [<ffffffff810f8dcd>] __perf_event_overflow+0x18d/0x2c0
[   61.111895]  [<ffffffff810f8d85>] ? __perf_event_overflow+0x145/0x2c0
[   61.111898]  [<ffffffff817711ae>] ? printk+0x41/0x43
[   61.111901]  [<ffffffff810f8fa9>] perf_swevent_overflow+0xa9/0xc0
[   61.111904]  [<ffffffff810f902f>] perf_swevent_event+0x6f/0x90
[   61.111907]  [<ffffffff810f90c6>] perf_tp_event+0x76/0xf0
[   61.111911]  [<ffffffff810f14ce>] perf_trace_power+0xbe/0xe0
[   61.111915]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[   61.111918]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[   61.111922]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.111926]  [<ffffffff8174f49f>] rest_init+0x133/0x144
[   61.111929]  [<ffffffff8174f3e5>] ? rest_init+0x79/0x144
[   61.111933]  [<ffffffff81cc2b51>] start_kernel+0x35b/0x366
[   61.111937]  [<ffffffff81cc2321>] x86_64_start_reservations+0x131/0x135
[   61.111940]  [<ffffffff81cc2415>] x86_64_start_kernel+0xf0/0xf7
[   61.111943] ---[ end trace 18a36211154afbbc ]---
[   61.111946] 
[   61.111947] ===============================
[   61.111949] [ INFO: suspicious RCU usage. ]
[   61.111950] 3.3.0-rc1+ #572 Tainted: G        W   
[   61.111952] -------------------------------
[   61.111954] kernel/events/ring_buffer.c:120 suspicious rcu_dereference_check() usage!
[   61.111956] 
[   61.111957] other info that might help us debug this:
[   61.111958] 
[   61.111960] 
[   61.111960] rcu_scheduler_active = 1, debug_locks = 1
[   61.111962] RCU used illegally from extended quiescent state!
[   61.111964] 2 locks held by swapper/0/0:
[   61.111966]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f8d85>] __perf_event_overflow+0x145/0x2c0
[   61.111974]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810fbfcf>] perf_output_begin+0x3f/0x330
[   61.111980] 
[   61.111980] stack backtrace:
[   61.111982] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc1+ #572
[   61.111984] Call Trace:
[   61.111987]  [<ffffffff810949ba>] lockdep_rcu_suspicious+0xca/0xf0
[   61.111990]  [<ffffffff810fc1f8>] perf_output_begin+0x268/0x330
[   61.111993]  [<ffffffff810fbfcf>] ? perf_output_begin+0x3f/0x330
[   61.111997]  [<ffffffff81076975>] ? sched_clock_cpu+0xc5/0x120
[   61.111999]  [<ffffffff8109371d>] ? trace_hardirqs_off+0xd/0x10
[   61.112003]  [<ffffffff81076a1f>] ? local_clock+0x4f/0x60
[   61.112006]  [<ffffffff810f21cd>] ? __perf_event_header__init_id+0xad/0xf0
[   61.112009]  [<ffffffff810f8b93>] ? perf_prepare_sample+0x63/0x110
[   61.112013]  [<ffffffff810f8dcd>] __perf_event_overflow+0x18d/0x2c0
[   61.112015]  [<ffffffff810f8d85>] ? __perf_event_overflow+0x145/0x2c0
[   61.112019]  [<ffffffff817711ae>] ? printk+0x41/0x43
[   61.112022]  [<ffffffff810f8fa9>] perf_swevent_overflow+0xa9/0xc0
[   61.112024]  [<ffffffff810f902f>] perf_swevent_event+0x6f/0x90
[   61.112028]  [<ffffffff810f90c6>] perf_tp_event+0x76/0xf0
[   61.112031]  [<ffffffff810f14ce>] perf_trace_power+0xbe/0xe0
[   61.112034]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[   61.112038]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[   61.112041]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.112044]  [<ffffffff8174f49f>] rest_init+0x133/0x144
[   61.112047]  [<ffffffff8174f3e5>] ? rest_init+0x79/0x144
[   61.112050]  [<ffffffff81cc2b51>] start_kernel+0x35b/0x366
[   61.112053]  [<ffffffff81cc2321>] x86_64_start_reservations+0x131/0x135
[   61.112057]  [<ffffffff81cc2415>] x86_64_start_kernel+0xf0/0xf7
[   61.112059] ------------[ cut here ]------------
[   61.112062] WARNING: at include/linux/rcupdate.h:248 perf_output_end+0x5b/0x70()
[   61.112064] Hardware name: ProLiant BL460c G6
[   61.112065] Modules linked in: ipmi_devintf nfsd exportfs hpilo ipmi_si bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[   61.112076] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc1+ #572
[   61.112078] Call Trace:
[   61.112081]  [<ffffffff81038eaf>] warn_slowpath_common+0x7f/0xc0
[   61.112085]  [<ffffffff81038f0a>] warn_slowpath_null+0x1a/0x20
[   61.112088]  [<ffffffff810fc31b>] perf_output_end+0x5b/0x70
[   61.112091]  [<ffffffff810f8e6c>] __perf_event_overflow+0x22c/0x2c0
[   61.112094]  [<ffffffff810f8d85>] ? __perf_event_overflow+0x145/0x2c0
[   61.112097]  [<ffffffff810f8fa9>] perf_swevent_overflow+0xa9/0xc0
[   61.112101]  [<ffffffff810f902f>] perf_swevent_event+0x6f/0x90
[   61.112104]  [<ffffffff810f90c6>] perf_tp_event+0x76/0xf0
[   61.112107]  [<ffffffff810f14ce>] perf_trace_power+0xbe/0xe0
[   61.112110]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[   61.112113]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[   61.112116]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.112120]  [<ffffffff8174f49f>] rest_init+0x133/0x144
[   61.112122] ------------[ cut here ]------------
[   61.112126] WARNING: at include/linux/rcupdate.h:248 perf_output_end+0x5b/0x70()
[   61.112128] Hardware name: ProLiant BL460c G6
[   61.112129] Modules linked in: ipmi_devintf nfsd exportfs hpilo [<ffffffff8174f3e5>] ? rest_init+0x79/0x144
[   61.112137]  [<ffffffff81cc2b51>] start_kernel+0x35b/0x366
[   61.112138]  ipmi_si bnx2x [<ffffffff81cc2321>] x86_64_start_reservations+0x131/0x135
[   61.112143]  crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[   61.112148] Pid: 0, comm: swapper/2 Tainted: G        W    3.3.0-rc1+ #572
[   61.112150]  [<ffffffff81cc2415>] x86_64_start_kernel+0xf0/0xf7
[   61.112152] ---[ end trace 18a36211154afbbd ]---
[   61.112153] ------------[ cut here ]------------
[   61.112155] WARNING: at include/linux/rcupdate.h:248 __perf_event_overflow+0x2a6/0x2c0()
[   61.112156] Hardware name: ProLiant BL460c G6
[   61.112157] Modules linked in: ipmi_devintf nfsd exportfs hpilo ipmi_si bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
[   61.112165] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc1+ #572
[   61.112166] Call Trace:
[   61.112168]  [<ffffffff81038eaf>] warn_slowpath_common+0x7f/0xc0
[   61.112170] Call Trace:
[   61.112172]  [<ffffffff81038f0a>] warn_slowpath_null+0x1a/0x20
[   61.112176]  [<ffffffff81038eaf>] warn_slowpath_common+0x7f/0xc0
[   61.112178]  [<ffffffff810f8ee6>] __perf_event_overflow+0x2a6/0x2c0
[   61.112182]  [<ffffffff81038f0a>] warn_slowpath_null+0x1a/0x20
[   61.112184]  [<ffffffff810f8d85>] ? __perf_event_overflow+0x145/0x2c0
[   61.112186]  [<ffffffff810f8fa9>] perf_swevent_overflow+0xa9/0xc0
[   61.112189]  [<ffffffff810fc31b>] perf_output_end+0x5b/0x70
[   61.112191]  [<ffffffff810f902f>] perf_swevent_event+0x6f/0x90
[   61.112193]  [<ffffffff810f90c6>] perf_tp_event+0x76/0xf0
[   61.112196]  [<ffffffff810f8e6c>] __perf_event_overflow+0x22c/0x2c0
[   61.112199]  [<ffffffff810f14ce>] perf_trace_power+0xbe/0xe0
[   61.112202]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[   61.112205]  [<ffffffff810f8d85>] ? __perf_event_overflow+0x145/0x2c0
[   61.112207]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[   61.112209]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.112212]  [<ffffffff8174f49f>] rest_init+0x133/0x144
[   61.112214]  [<ffffffff810f8fa9>] perf_swevent_overflow+0xa9/0xc0
[   61.112217]  [<ffffffff810f902f>] perf_swevent_event+0x6f/0x90
[   61.112219]  [<ffffffff8174f3e5>] ? rest_init+0x79/0x144
[   61.112222]  [<ffffffff810f90c6>] perf_tp_event+0x76/0xf0
[   61.112227]  [<ffffffff8102009d>] ? lapic_next_event+0x1d/0x30
[   61.112229]  [<ffffffff81cc2b51>] start_kernel+0x35b/0x366
[   61.112232]  [<ffffffff81cc2321>] x86_64_start_reservations+0x131/0x135
[   61.112235]  [<ffffffff810f14ce>] perf_trace_power+0xbe/0xe0
[   61.112238]  [<ffffffff81cc2415>] x86_64_start_kernel+0xf0/0xf7
[   61.112239] ---[ end trace 18a36211154afbbe ]---
[   61.112242]  [<ffffffff8100ab2f>] ? mwait_idle+0x40f/0x4c0
[   61.112245]  [<ffffffff8100ab2f>] mwait_idle+0x40f/0x4c0
[   61.112248]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.112252]  [<ffffffff8176baee>] start_secondary+0x1df/0x1e3
[   61.112254] ---[ end trace 18a36211154afbbf ]---
[   61.114605] 
[   61.114608] ===============================
[   61.114611] [ INFO: suspicious RCU usage. ]
[   61.114614] 3.3.0-rc1+ #572 Tainted: G        W   
[   61.114616] -------------------------------
[   61.114620] include/trace/events/power.h:127 suspicious rcu_dereference_check() usage!
[   61.114625] 
[   61.114626] other info that might help us debug this:
[   61.114628] 
[   61.114630] 
[   61.114630] rcu_scheduler_active = 1, debug_locks = 1
[   61.114633] RCU used illegally from extended quiescent state!
[   61.114635] no locks held by swapper/2/0.
[   61.114637] 
[   61.114638] stack backtrace:
[   61.114641] Pid: 0, comm: swapper/2 Tainted: G        W    3.3.0-rc1+ #572
[   61.114645] Call Trace:
[   61.114650]  [<ffffffff810949ba>] lockdep_rcu_suspicious+0xca/0xf0
[   61.114655]  [<ffffffff8100a9cd>] mwait_idle+0x2ad/0x4c0
[   61.114660]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
[   61.114664]  [<ffffffff8176baee>] start_secondary+0x1df/0x1e3


