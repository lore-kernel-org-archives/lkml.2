Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0LHUmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:42:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:34617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab0LHUmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:42:03 -0500
Date: Wed, 8 Dec 2010 20:41:27 GMT
From: tip-bot for Dario Faggioli <raistlin@linux.it>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, raistlin@linux.it, rostedt@goodmis.org,
        tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, raistlin@linux.it, rostedt@goodmis.org,
        tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <1291143093.2697.298.camel@Palantir>
References: <1291143093.2697.298.camel@Palantir>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make pushable_tasks CONFIG_SMP dependant
Message-ID: <tip-806c09a7db457be3758e14b1f152761135d89af5@git.kernel.org>
Git-Commit-ID: 806c09a7db457be3758e14b1f152761135d89af5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:41:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  806c09a7db457be3758e14b1f152761135d89af5
Gitweb:     http://git.kernel.org/tip/806c09a7db457be3758e14b1f152761135d89af5
Author:     Dario Faggioli <raistlin@linux.it>
AuthorDate: Tue, 30 Nov 2010 19:51:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:16:00 +0100

sched: Make pushable_tasks CONFIG_SMP dependant

As noted by Peter Zijlstra at https://lkml.org/lkml/2010/11/10/391
(while reviewing other stuff, though), tracking pushable tasks
only makes sense on SMP systems.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291143093.2697.298.camel@Palantir>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/init_task.h |    9 ++++++++-
 include/linux/sched.h     |    2 ++
 kernel/sched.c            |    2 ++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f8c06c..6ed8812 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -12,6 +12,13 @@
 #include <linux/securebits.h>
 #include <net/net_namespace.h>
 
+#ifdef CONFIG_SMP
+# define INIT_PUSHABLE_TASKS(tsk)					\
+	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO),
+#else
+# define INIT_PUSHABLE_TASKS(tsk)
+#endif
+
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
@@ -137,7 +144,7 @@ extern struct cred init_cred;
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
-	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
+	INIT_PUSHABLE_TASKS(tsk)					\
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9c2d46d..4f92a23 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1240,7 +1240,9 @@ struct task_struct {
 #endif
 
 	struct list_head tasks;
+#ifdef CONFIG_SMP
 	struct plist_node pushable_tasks;
+#endif
 
 	struct mm_struct *mm, *active_mm;
 #if defined(SPLIT_RSS_COUNTING)
diff --git a/kernel/sched.c b/kernel/sched.c
index b646dad..3925a1b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2595,7 +2595,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
+#ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
+#endif
 
 	put_cpu();
 }
