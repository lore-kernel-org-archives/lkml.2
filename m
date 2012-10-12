Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2JLL0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:26:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55632 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2JLL0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:26:03 -0400
Date: Fri, 12 Oct 2012 04:25:49 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-q93t6n7j1jaz36yh056msb5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Introduce alternative wakeup bias
Git-Commit-ID: 52a30f1fa3b9f0c0d1270b4e34be865e83b3e31b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:25:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52a30f1fa3b9f0c0d1270b4e34be865e83b3e31b
Gitweb:     http://git.kernel.org/tip/52a30f1fa3b9f0c0d1270b4e34be865e83b3e31b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Oct 2012 15:57:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:16 +0200

sched/numa: Introduce alternative wakeup bias

Rename NUMA_BIAS to NUMA_TTWU_BIAS to clarify what it does.

Also, disable by default, it seems too agressive. Also provide an
alternative to play with, instead of altering the prev cpu, alter
the waking cpu, maybe that's less agressive.

No clear data either way for the moment.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-q93t6n7j1jaz36yh056msb5d@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c     |    7 +++++--
 kernel/sched/features.h |    3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f586f17..62d77ef 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3009,7 +3009,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	rcu_read_lock();
-	if (sched_feat_numa(NUMA_BIAS) && node != -1) {
+	if (sched_feat_numa(NUMA_TTWU_BIAS) && node != -1) {
 		/*
 		 * For fork,exec find the idlest cpu in the home-node.
 		 */
@@ -3031,7 +3031,10 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			if (node_cpu < 0)
 				goto find_sd;
 
-			prev_cpu = node_cpu;
+			if (sched_feat_numa(NUMA_TTWU_TO))
+				cpu = node_cpu;
+			else
+				prev_cpu = node_cpu;
 		}
 	}
 
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 845b838..3293af4 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -66,7 +66,8 @@ SCHED_FEAT(LB_MIN, false)
 SCHED_FEAT(NUMA,           true)
 SCHED_FEAT(NUMA_FORCE_BIG, false)
 SCHED_FEAT(NUMA_HOT,       true)
-SCHED_FEAT(NUMA_BIAS,      true)
+SCHED_FEAT(NUMA_TTWU_BIAS, false)
+SCHED_FEAT(NUMA_TTWU_TO,   false)
 SCHED_FEAT(NUMA_PULL,      true)
 SCHED_FEAT(NUMA_PULL_BIAS, true)
 #endif
