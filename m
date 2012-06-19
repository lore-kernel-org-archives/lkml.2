Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2FSMWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:22:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40433 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2FSMWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:22:35 -0400
Message-ID: <4FE06EEF.2090709@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 17:52:07 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: reset loop counters if all tasks are pinned and we
 need to redo load balance
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061912-7408-0000-0000-000005FC71C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While load balancing, if all tasks on the source runqueue are pinned,
we retry after excluding the corresponding source cpu. However, loop counters
env.loop and env.loop_break are not reset before retrying, which can lead
to failure in moving the tasks. In this patch we reset env.loop and
env.loop_break to their inital values before we retry.

Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 939fd63..60f8b66 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4520,8 +4520,11 @@ more_balance:
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
-			if (!cpumask_empty(cpus))
+			if (!cpumask_empty(cpus)) {
+				env.loop = 0;
+				env.loop_break = sched_nr_migrate_break;
 				goto redo;
+			}
 			goto out_balanced;
 		}
 	}

