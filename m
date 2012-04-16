Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2DPDiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:38:13 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48435 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DPDiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:38:09 -0400
Message-ID: <4F8B941A.8020401@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:38:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [RFC PATCH 3/4] linsched: avoid invoke "tick_nohz_idle_enter" when
 cpu in idle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-5816-0000-0000-000002260150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

In real world, "tick_nohz_idle_enter" will be invoked by idle thread 
when the cpu change from active to idle, and will only be invoked
again after "tick_nohz_idle_exit" was invoked by idle thread when
cpu going to recover.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 tools/linsched/hrtimer.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/linsched/hrtimer.c b/tools/linsched/hrtimer.c
index de88b25..1981bc9 100644
--- a/tools/linsched/hrtimer.c
+++ b/tools/linsched/hrtimer.c
@@ -149,6 +149,15 @@ void linsched_check_idle_cpu(void)
 	}
 }

+void linsched_enter_idle_cpu(void)
+{
+	int cpu = smp_processor_id();
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (!ts->inidle && idle_cpu(cpu))
+		tick_nohz_idle_enter();
+}
+
 /* Run a simulation for some number of ticks. Each tick,
  * scheduling and load balancing decisions are made. Obviously, we
  * could create tasks, change priorities, etc., at certain ticks
@@ -210,7 +219,7 @@ void linsched_run_sim(int sim_ticks)

 			BUG_ON(irqs_disabled());
 			if (idle_cpu(active_cpu) && !need_resched()) {
-				tick_nohz_idle_enter();
+				linsched_enter_idle_cpu();
 			} else {
 				linsched_current_handler();
 			}
-- 
1.7.1

