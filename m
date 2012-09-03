Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2ICD6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:58:20 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54585 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICD6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:58:18 -0400
Message-ID: <50442AD2.6060109@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 11:58:10 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 3/4] linsched: avoid invoke tick_nohz_idle_enter() multiple
 times in idle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090303-5490-0000-0000-00000210812D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

In real world, tick_nohz_idle_enter() will be invoked by idle thread 
when the cpu change from active to idle, and will only be invoked
again after tick_nohz_idle_exit() was invoked by idle thread when
cpu is going to recover, invoke it multiple times in one idle may
cause unexpected troubles.

The patch add a check to avoid invoke tick_nohz_idle_enter() again
after idle.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 tools/linsched/hrtimer.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/linsched/hrtimer.c b/tools/linsched/hrtimer.c
index de88b25..3203253 100644
--- a/tools/linsched/hrtimer.c
+++ b/tools/linsched/hrtimer.c
@@ -149,6 +149,15 @@ void linsched_check_idle_cpu(void)
        } 
 }
 
+void linsched_enter_idle(void)
+{
+       int cpu = smp_processor_id();
+       struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+       if (!ts->inidle && idle_cpu(cpu))
+               tick_nohz_idle_enter();
+}              
+
 /* Run a simulation for some number of ticks. Each tick,
  * scheduling and load balancing decisions are made. Obviously, we
  * could create tasks, change priorities, etc., at certain ticks
@@ -210,7 +219,7 @@ void linsched_run_sim(int sim_ticks)
 
                        BUG_ON(irqs_disabled());
                        if (idle_cpu(active_cpu) && !need_resched()) {
-                               tick_nohz_idle_enter();
+                               linsched_enter_idle();
                        } else {
                                linsched_current_handler();
                        }
-- 
1.7.1

