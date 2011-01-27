Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1A0PAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:06 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40913 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752829Ab1A0PAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:02 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX187wZoxD987BQ3DJGvEyjD1Hf79N45fUHeralhp+o
	/CLmRdlu7Pff9+
Subject: [PATCH v2 13/20] ia64: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:56 +0100
Message-ID: <20110127145956.23248.49107.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

local_cpu_data->itm_next = new_itm;  does not need to be protected
by this lock. and xtime_update() takes the lock itself.


Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/ia64/kernel/time.c |   19 +++++--------------
 arch/ia64/xen/time.c    |   13 +++++--------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9702fa9..156ad80 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -190,19 +190,10 @@ timer_interrupt (int irq, void *dev_id)
 
 		new_itm += local_cpu_data->itm_delta;
 
-		if (smp_processor_id() == time_keeper_id) {
-			/*
-			 * Here we are in the timer irq handler. We have irqs locally
-			 * disabled, but we don't know if the timer_bh is running on
-			 * another CPU. We need to avoid to SMP race by acquiring the
-			 * xtime_lock.
-			 */
-			write_seqlock(&xtime_lock);
-			do_timer(1);
-			local_cpu_data->itm_next = new_itm;
-			write_sequnlock(&xtime_lock);
-		} else
-			local_cpu_data->itm_next = new_itm;
+		if (smp_processor_id() == time_keeper_id)
+			xtime_update(1);
+
+		local_cpu_data->itm_next = new_itm;
 
 		if (time_after(new_itm, ia64_get_itc()))
 			break;
@@ -222,7 +213,7 @@ skip_process_time_accounting:
 		 * comfort, we increase the safety margin by
 		 * intentionally dropping the next tick(s).  We do NOT
 		 * update itm.next because that would force us to call
-		 * do_timer() which in turn would let our clock run
+		 * xtime_update() which in turn would let our clock run
 		 * too fast (with the potentially devastating effect
 		 * of losing monotony of time).
 		 */
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..1f8244a 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -139,14 +139,11 @@ consider_steal_time(unsigned long new_itm)
 		run_posix_cpu_timers(p);
 		delta_itm += local_cpu_data->itm_delta * (stolen + blocked);
 
-		if (cpu == time_keeper_id) {
-			write_seqlock(&xtime_lock);
-			do_timer(stolen + blocked);
-			local_cpu_data->itm_next = delta_itm + new_itm;
-			write_sequnlock(&xtime_lock);
-		} else {
-			local_cpu_data->itm_next = delta_itm + new_itm;
-		}
+		if (cpu == time_keeper_id)
+			xtime_update(stolen + blocked);
+
+		local_cpu_data->itm_next = delta_itm + new_itm;
+
 		per_cpu(xen_stolen_time, cpu) += NS_PER_TICK * stolen;
 		per_cpu(xen_blocked_time, cpu) += NS_PER_TICK * blocked;
 	}

