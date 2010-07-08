Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab0GHMEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:04:25 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:32889 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0GHMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:04:23 -0400
Date: Thu, 8 Jul 2010 21:04:21 +0900
From: Norbert Preining <preining@logic.at>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at> <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org> <1278590303.1900.91.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278590303.1900.91.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 08 Jul 2010, Peter Zijlstra wrote:
> then wth is "[kernel scheduler] load balancing tick"?
> and for that matter, what is "[extra timer interrupt]", surely the timer
> hardware doesn't generate spurious interrupts?

Just one more point, searching a bit more in the net I found the following
patch (forgot who wrote it) which I merged into my current git:
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..f26efba 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3248,6 +3248,9 @@ int select_nohz_load_balancer(int stop_tick)
        if (stop_tick) {
                cpu_rq(cpu)->in_nohz_recently = 1;
 
+               if (!mc_capable())
+                       return 0;
+
                if (!cpu_active(cpu)) {
                        if (atomic_read(&nohz.load_balancer) != cpu)
                                return 0;
@@ -3297,6 +3300,9 @@ int select_nohz_load_balancer(int stop_tick)
                if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
                        return 0;
 
+               if (!mc_capable())
+                       return 0;
+
                cpumask_clear_cpu(cpu, nohz.cpu_mask);
 
                if (atomic_read(&nohz.load_balancer) == cpu)

Now the output looks like:
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 2.7%)       Turbo Mode     0.2%
C0                0.0ms ( 0.0%)         2.54 Ghz     0.0%
C1 mwait          0.8ms ( 0.0%)         1.60 Ghz     0.0%
C2 mwait          0.4ms ( 1.4%)          800 Mhz    99.8%
C6 mwait          4.9ms (95.9%)

Wakeups-from-idle per second : 228.4    interval: 10.0s
Power usage (ACPI estimate): 11.7W (7.3 hours)

Top causes for wakeups:
  22.4% ( 55.4)   [kernel scheduler] Load balancing tick
  16.6% ( 41.2)   [iwlagn] <interrupt>
  16.0% ( 39.7)   [extra timer interrupt]
  15.2% ( 37.7)   [kernel core] hrtimer_start (tick_sched_timer)
  13.7% ( 33.9)   firefox-bin
   2.4% (  5.9)   [ahci] <interrupt>
   2.0% (  5.0)   syndaemon


which looks better

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
OSWALDTWISTLE (n. Old Norse)
Small brass wind instrument used for summoning Vikings to lunch when
they're off on their longships, playing.
			--- Douglas Adams, The Meaning of Liff
