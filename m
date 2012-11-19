Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2KSFdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:52 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42934 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2KSFdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:20 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 57/58] sched: Move stubs for CONFIG_FAIR_GROUP_SCHED=n to sched.h
Date: Sun, 18 Nov 2012 21:28:36 -0800
Message-Id: <1353302917-13995-58-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched/fair.c defines stub versions of free_fair_sched_group,
alloc_fair_sched_group, and unregister_fair_sched_group, for use when
CONFIG_FAIR_GROUP_SCHED=n.  However, sched.h only declares the
prototypes of those functions when CONFIG_CGROUP_SCHED=y, since the
scheduler core only calls those functions when CONFIG_CGROUP_SCHED=y.
Rather than complicating the ifdef logic around the stub functions to
only define them in that case, move the empty stubs to sched.h as static
inlines, only defined when needed.  That allows the compiler to throw
away the calls entirely rather than calling empty stubs, and also
satisfies GCC (-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/sched/fair.c:5277:6: warning: no previous prototype for ‘free_fair_sched_group’ [-Wmissing-prototypes]
kernel/sched/fair.c:5279:5: warning: no previous prototype for ‘alloc_fair_sched_group’ [-Wmissing-prototypes]
kernel/sched/fair.c:5284:6: warning: no previous prototype for ‘unregister_fair_sched_group’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/fair.c  |   11 -----------
 kernel/sched/sched.h |   13 +++++++++++++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0f03bf1..971657f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5272,17 +5272,6 @@ done:
 	mutex_unlock(&shares_mutex);
 	return 0;
 }
-#else /* CONFIG_FAIR_GROUP_SCHED */
-
-void free_fair_sched_group(struct task_group *tg) { }
-
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
-
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..fc5b8b8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -173,9 +173,22 @@ static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
 
 extern int tg_nop(struct task_group *tg, void *data);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
 extern void unregister_fair_sched_group(struct task_group *tg, int cpu);
+#else
+static inline void free_fair_sched_group(struct task_group *tg) { }
+
+static inline int alloc_fair_sched_group(struct task_group *tg,
+					struct task_group *parent)
+{
+        return 1;
+}
+
+static inline void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
+#endif
+
 extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 			struct sched_entity *se, int cpu,
 			struct sched_entity *parent);
-- 
1.7.10.4

