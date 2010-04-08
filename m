Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab0DHT7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:59:54 -0400
Received: from isilmar.linta.de ([213.133.102.198]:45527 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755920Ab0DHT7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:59:51 -0400
Date: Thu, 8 Apr 2010 21:59:41 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC PATCH] nohz/sched: disable ilb on !mc_capable()
Message-ID: <20100408195941.GA5040@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403223328.GA4507@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
>
> 2) dual-core CPU[*] and select_nohz_load_balancer()
> [*] (Intel(R) Core(TM)2 Duo CPU T7250)
> 
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> CONFIG_SCHED_HRTICK=y
> 
> CONFIG_SCHED_MC is igored, as mc_capable() returns 0 on a one-socket,
> dual-core system. Quite surprisingly, even under moderate load (~98.0% idle)
> while writing this bugreport, up to half of the calls to
> tick_nohz_stop_sched_tick() are aborted due to select_nohz_load_balancer(1):
> 
> 		if (atomic_read(&nohz.load_balancer) == -1) {
> 			/* make me the ilb owner */
> 			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
> 				return 1;
> 
> I'm not really sure, but I guess this is caused by the following phenomenon
> under minor load but still, every once in a while, parallel work for both
> CPUs:
> 
> CPU #0					CPU #1
> 
> <active>				<active>
> <idle>					<active>
>   tick_nohz_stop_sched_tick(1)		<active>
>    select_nohz_load_balancer(1)		<active>
>     => becomes ilb owner		<idle>
>    => tick is not stopped		 tick_nohz_stop_sched_tick(1)
>   => CPU goes to sleep for 1 tick	  => as it isn't the ILB owner, tick
>   <sleep for 1 tick>			     is stopped	.
>   ---> scheduler_tick()			  <sleeeeeeeep>
>   tick_nohz_stop_sched_tick(0)
> <still idle>
>   tick_nohz_stop_sched_tick(1)
>    select_nohz_load_balancer(1)
>     => is ilb owner, all CPUs idle,
>        may go to sleep.
> 
> If both CPUs have hardly anything to do, letting the _active_ CPU do ilb
> allows us to enter deep sleep states earlier, and longer:
> 
> current ILB model (* = ILB)
> 
> 	tick ---------- tick -------- tick ----- IRQ
> CPU0:   active|IDLE(C2)--|*|IDLE (C3)             |
> CPU1:   active....| IDLE (C3)                     |
> core:   .......???| C2   |           C3           |
> 
> ILB-by-active-CPU-on-light-load:
> 
> 	tick ---------- tick -------- tick ----- IRQ
> CPU0:   active|IDLE(C3)                           |
> CPU1:   active....*| IDLE (C3)                    |
> core:   .......????|               C3             |

Tested this a bit further, and thought about it a bit further:

On systems like my laptop, which has one physical CPUs with two cores
( = SMP, !mc_capable() ), the "idle load balancing" seems to be _not_
necessary at all:

- if both cores are active, ilb is inactive anyway.

- if no core is active, ilb was inactive anyway

- if only one core is active and busy, it seems to attempt to balance its
  load on each tick anyway. ilb wouldn't act quicker anyways.

The attached patch decreases the amount of wakeups on my completely idle
notebook ( init=/bin/bash ) from ~2 wakeups-per-second[*] to ~0.7. During
normal system usage, the amount of wakeups-per-second seems to decrease as
well, but is less easy to detect. More importantly, over 80 % of all calls
to tick_nohz_stop_sched_tick() succeed immediately[**].

[*] needs an USB-autosuspend bugfix, manual enabling of USB autosuspend, and
    disabling of the blinking fb cursor.

[**] about 10% return due to rcu_needs_cpu(), which often means the CPU can
    go to sleep pretty soon afterwards.

The remaining reports of "tick_sched_timer" in powertop(1) seems to be
related to timer ticks when one CPU is active for at least one jiffy. So
this is probably not a real "wakeup" at all.

Best,
	Dominik


From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Thu, 8 Apr 2010 21:51:18 +0200
Subject: [PATCH] nohz/sched: disable ilb on !mc_capable()

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a5ea2c..8ad8a03 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3290,6 +3290,9 @@ int select_nohz_load_balancer(int stop_tick)
 	if (stop_tick) {
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
+		if (!mc_capable())
+			return 0;
+
 		if (!cpu_active(cpu)) {
 			if (atomic_read(&nohz.load_balancer) != cpu)
 				return 0;
@@ -3339,6 +3342,9 @@ int select_nohz_load_balancer(int stop_tick)
 		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
 			return 0;
 
+		if (!mc_capable())
+			return 0;
+
 		cpumask_clear_cpu(cpu, nohz.cpu_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
