Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0DZUbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:31:47 -0400
Received: from isilmar.linta.de ([213.133.102.198]:43781 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753222Ab0DZUbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:31:45 -0400
Date: Mon, 26 Apr 2010 22:31:36 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] nohz/sched: disable ilb on !mc_capable()
Message-ID: <20100426203136.GA1539@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Thu, 8 Apr 2010 21:51:18 +0200
Subject: [PATCH] nohz/sched: disable ilb on !mc_capable()

On my dual-core, !mc_capbale() CPU, the idle load balancer (ilb) is one
of the main reasons ticks are not stopped: Under moderate load (~98 % idle),
upt o half of the calls to tick_nohz_top_sched_tick() are aborted due
to calls to select_nohz_load_balancer(1).

I suspect this is caused by the following phenomenon:

    CPU0				CPU1
    <active>				<active>
    tick_nohz_stop_sched_tick(1)
    select_nohz_load_balancer(1)
     => CPU0 becomes ilb owner,		<CPU1 becomes idle a bit later>
        tick is not stopped,		tick_nohz_stop_sched_tick(1)
        CPU0 goes to sleep for		 => CPU1 isn't the ilb owner,
        exactly 1 tick.			    tick is stopped.
    <short sleep>			<long sleep>
    ---> scheduler_tick()
    tick_nohz_stop_sched_tick(0)
    tick_nohz_stop_sched_tick(1)
     => is ilb owner, all CPUs are
        idle, CPU0 may go to sleep.

If all CPU cores have hardly anything to do, letting the active CPU do
idle load balancing allows us to enter deep sleep states earlier, and for
longer periods of time. Furthermore, on !mc_capable() systems, it seems that
the ilb algorithm isn't needed at all. Let's show this for a 2-core system:

- if both cores are active, ilb is deactivated
- if no core is active, ilb is deactivated
- if only one core is active, it attempts to balance its load off to other
  CPUs on each tick anyway. ilb wouldn't act quicker.

This patch decreases the amount of wakeups on my completely idle notebook by
about two thirds.

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
