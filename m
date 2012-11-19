Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2KSFdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:25 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50284 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2KSFdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:22 -0500
X-Originating-IP: 217.70.178.149
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 58/58] sched: Move stubs for CONFIG_RT_GROUP_SCHED=n to sched.h
Date: Sun, 18 Nov 2012 21:28:37 -0800
Message-Id: <1353302917-13995-59-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched/rt.c defines stub versions of free_rt_sched_group and
alloc_rt_sched_group, for use when CONFIG_RT_GROUP_SCHED=n.  However,
sched.h only declares the prototypes of those functions when
CONFIG_CGROUP_SCHED=y, since the scheduler core only calls those
functions when CONFIG_CGROUP_SCHED=y.  Rather than complicating the
ifdef logic around the stub functions to only define them in that case,
move the empty stubs to sched.h as static inlines, only defined when
needed.  That allows the compiler to throw away the calls entirely
rather than calling empty stubs, and also satisfies GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/sched/rt.c:220:6: warning: no previous prototype for ‘free_rt_sched_group’ [-Wmissing-prototypes]
kernel/sched/rt.c:222:5: warning: no previous prototype for ‘alloc_rt_sched_group’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/rt.c    |    7 -------
 kernel/sched/sched.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..9ef9d0e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -216,13 +216,6 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 	return &rq->rt;
 }
-
-void free_rt_sched_group(struct task_group *tg) { }
-
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc5b8b8..ae190e1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -199,8 +199,19 @@ extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
 extern void free_rt_sched_group(struct task_group *tg);
 extern int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent);
+#else
+static inline void free_rt_sched_group(struct task_group *tg) { }
+
+static inline int alloc_rt_sched_group(struct task_group *tg,
+				struct task_group *parent)
+{
+	return 1;
+}
+#endif
+
 extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);
-- 
1.7.10.4

