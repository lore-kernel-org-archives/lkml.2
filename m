Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2ALGQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:16:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40667 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab2ALGQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:16:04 -0500
Date: Thu, 12 Jan 2012 07:15:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120112061552.GA2869@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: bced76aeaca03b45e3b4bdb868cada328e497847 sched: Fix lockup by limiting load-balance retries on lock-break

 Thanks,

	Ingo

------------------>
Fabio Estevam (1):
      sched: Fix CONFIG_CGROUP_SCHED dependency

Hiroshi Shimamoto (1):
      sched: Remove empty #ifdefs

Peter Zijlstra (1):
      sched: Fix lockup by limiting load-balance retries on lock-break


 init/Kconfig        |    1 -
 kernel/sched/core.c |    7 -------
 kernel/sched/fair.c |   10 +++++++---
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 82b6a4c..a34cd17 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -702,7 +702,6 @@ config CGROUP_PERF
 
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL
 	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4dbfd04..457c881 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7136,10 +7136,6 @@ void set_curr_task(int cpu, struct task_struct *p)
 
 #endif
 
-#ifdef CONFIG_RT_GROUP_SCHED
-#else /* !CONFIG_RT_GROUP_SCHED */
-#endif /* CONFIG_RT_GROUP_SCHED */
-
 #ifdef CONFIG_CGROUP_SCHED
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
@@ -7248,9 +7244,6 @@ void sched_move_task(struct task_struct *tsk)
 }
 #endif /* CONFIG_CGROUP_SCHED */
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-#endif
-
 #if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e42de9..84adb2d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3130,8 +3130,10 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 }
 
 #define LBF_ALL_PINNED	0x01
-#define LBF_NEED_BREAK	0x02
-#define LBF_ABORT	0x04
+#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
+#define LBF_HAD_BREAK	0x04
+#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
+#define LBF_ABORT	0x10
 
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
@@ -4508,7 +4510,9 @@ redo:
 			goto out_balanced;
 
 		if (lb_flags & LBF_NEED_BREAK) {
-			lb_flags &= ~LBF_NEED_BREAK;
+			lb_flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
+			if (lb_flags & LBF_ABORT)
+				goto out_balanced;
 			goto redo;
 		}
 
