Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1CVLIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:08:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50024 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1CVLIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:08:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/5] oom: create oom autogroup
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110322194721.B05E.A69D9226@jp.fujitsu.com>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com> <20110322194721.B05E.A69D9226@jp.fujitsu.com>
Message-Id: <20110322200759.B067.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Mar 2011 20:08:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When plenty processes (eg fork bomb) are running, the TIF_MEMDIE task
never exit, at least, human feel it's never. therefore kernel become
hang-up.

"perf sched" tell us a hint.

 ------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Average delay ms | Maximum delay ms |
 ------------------------------------------------------------------------------
  python:1754           |      0.197 ms | avg: 1731.727 ms | max: 3433.805 ms |
  python:1843           |      0.489 ms | avg: 1707.433 ms | max: 3622.955 ms |
  python:1715           |      0.220 ms | avg: 1707.125 ms | max: 3623.246 ms |
  python:1818           |      2.127 ms | avg: 1527.331 ms | max: 3622.553 ms |
  ...
  ...

Processes flood makes crazy scheduler delay. and then the victim process
can't run enough. Grr. Should we do?

Fortunately, we already have anti process flood framework, autogroup!
This patch reuse this framework and avoid kernel live lock.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/oom.h      |    1 +
 include/linux/sched.h    |    4 ++++
 init/main.c              |    2 ++
 kernel/sched_autogroup.c |    4 ++--
 mm/oom_kill.c            |   23 +++++++++++++++++++++++
 5 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 5e3aa83..86bcea3 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -67,6 +67,7 @@ extern unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
 		      const nodemask_t *nodemask, unsigned long uptime);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
+extern void oom_init(void);
 
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 98fc7ed..bdaad3f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1947,6 +1947,8 @@ int sched_rt_handler(struct ctl_table *table, int write,
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 
+extern struct autogroup *autogroup_create(void);
+extern void autogroup_move_group(struct task_struct *p, struct autogroup *ag);
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
 extern void sched_autogroup_fork(struct signal_struct *sig);
@@ -1956,6 +1958,8 @@ extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_fil
 extern int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice);
 #endif
 #else
+extern struct autogroup *autogroup_create(void) { return NULL; }
+extern void autogroup_move_group(struct task_struct *p, struct autogroup *ag) {}
 static inline void sched_autogroup_create_attach(struct task_struct *p) { }
 static inline void sched_autogroup_detach(struct task_struct *p) { }
 static inline void sched_autogroup_fork(struct signal_struct *sig) { }
diff --git a/init/main.c b/init/main.c
index 4a9479e..2c6e8da 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+#include <linux/oom.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -549,6 +550,7 @@ asmlinkage void __init start_kernel(void)
 	gfp_allowed_mask = __GFP_BITS_MASK;
 
 	kmem_cache_init_late();
+	oom_init();
 
 	/*
 	 * HACK ALERT! This is early. We're enabling the console before
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 5946ac5..6a1a2c4 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -63,7 +63,7 @@ static inline struct autogroup *autogroup_task_get(struct task_struct *p)
 static void free_rt_sched_group(struct task_group *tg);
 #endif
 
-static inline struct autogroup *autogroup_create(void)
+struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
 	struct task_group *tg;
@@ -143,7 +143,7 @@ autogroup_task_group(struct task_struct *p, struct task_group *tg)
 	return tg;
 }
 
-static void
+void
 autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 {
 	struct autogroup *prev;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 739dee4..2519e6a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -38,6 +38,28 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+struct autogroup *oom_ag;
+
+void __init oom_init(void)
+{
+	oom_ag = autogroup_create();
+}
+
+static void oom_move_oom_ag(struct task_struct *p)
+{
+	autogroup_move_group(p, oom_ag);
+}
+#else
+void __init oom_init(void)
+{
+}
+
+static void oom_move_oom_ag(struct task_struct *p)
+{
+}
+#endif
+
 #ifdef CONFIG_NUMA
 /**
  * has_intersects_mems_allowed() - check task eligiblity for kill
@@ -432,6 +454,7 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
+	oom_move_oom_ag(p);
 	force_sig(SIGKILL, p);
 
 	return 0;
-- 
1.6.5.2



