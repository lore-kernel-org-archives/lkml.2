Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1GKOPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:15:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51078 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab1GKOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:15:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH 7/7] cgroups: Add a max number of tasks subsystem
Date: Mon, 11 Jul 2011 16:15:06 +0200
Message-Id: <1310393706-321-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new subsystem to limit the number of running tasks,
similar to the NR_PROC rlimit but in the scope of a cgroup.

This is a step to be able to isolate a bit more a cgroup against
the rest of the system and limit the global impact of a fork bomb
inside a given cgroup.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
---
 include/linux/cgroup.h        |    9 ++
 include/linux/cgroup_subsys.h |    8 ++
 init/Kconfig                  |    7 ++
 kernel/Makefile               |    1 +
 kernel/cgroup_max_tasks.c     |  176 +++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |    4 +
 6 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 kernel/cgroup_max_tasks.c

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 94454143..e6dec8c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -660,4 +660,13 @@ static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 
 #endif /* !CONFIG_CGROUPS */
 
+#ifdef CONFIG_CGROUP_MAX_TASKS
+int cgroup_max_tasks_fork(struct task_struct *child);
+#else
+static inline int cgroup_max_tasks_fork(struct task_struct *child)
+{
+	return 0;
+}
+#endif /* CONFIG_CGROUP_MAX_TASKS */
+
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ac663c1..227540d 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -59,8 +59,16 @@ SUBSYS(net_cls)
 SUBSYS(blkio)
 #endif
 
+/* */
+
 #ifdef CONFIG_CGROUP_PERF
 SUBSYS(perf)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_MAX_TASKS
+SUBSYS(max_tasks)
+#endif
+
+/* */
diff --git a/init/Kconfig b/init/Kconfig
index 412c21b..46e4c03 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -690,6 +690,13 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then noswapaccount does the trick).
 
+config CGROUP_MAX_TASKS
+        bool "Control max number of tasks in a cgroup"
+	depends on RESOURCE_COUNTERS
+	help
+	  This option let the user to set up an upper bound allowed number
+	  of tasks.
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff --git a/kernel/Makefile b/kernel/Makefile
index 2d64cfc..1b5722e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_MAX_TASKS) += cgroup_max_tasks.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_max_tasks.c b/kernel/cgroup_max_tasks.c
new file mode 100644
index 0000000..2c38105
--- /dev/null
+++ b/kernel/cgroup_max_tasks.c
@@ -0,0 +1,176 @@
+/*
+ * Limits on number of tasks subsystem for cgroups
+ *
+ * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Thanks to Johannes Weiner, Li Zefan, Paul Menage for their suggestions.
+ *
+ */
+
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/res_counter.h>
+
+
+struct task_counter {
+	struct res_counter		res;
+	struct cgroup_subsys_state	css;
+};
+
+/*
+ * The root task counter is ignored and is not part of the
+ * whole task counting in order to optimize the trivial case
+ * of only one root cgroup living.
+ */
+static struct task_counter root_counter;
+
+
+static inline struct task_counter *cgroup_task_counter(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, max_tasks_subsys_id),
+			    struct task_counter, css);
+}
+
+static struct cgroup_subsys_state *
+task_counter_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt, *parent_cnt;
+
+	if (!cgrp->parent) {
+		res_counter_init(&root_counter.res, NULL);
+		return &root_counter.css;
+	}
+
+	cnt = kzalloc(sizeof(*cnt), GFP_KERNEL);
+	if (!cnt)
+		return ERR_PTR(-ENOMEM);
+
+	parent_cnt = cgroup_task_counter(cgrp->parent);
+	res_counter_init(&cnt->res, &parent_cnt->res);
+
+	return &cnt->css;
+}
+
+static void task_counter_post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+
+	res_counter_inherit(&cnt->res, RES_LIMIT);
+}
+
+static void task_counter_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct task_counter *cnt = cgroup_task_counter(cont);
+
+	kfree(cnt);
+}
+
+static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			      struct cgroup *old_cgrp, struct task_struct *task)
+{
+	struct task_counter *cnt = cgroup_task_counter(old_cgrp);
+
+	if (cnt != &root_counter)
+		res_counter_uncharge_until(&cnt->res, &root_counter.res, 1);
+}
+
+/* Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup mutex */
+static struct res_counter *common_ancestor;
+
+static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+					struct task_struct *tsk)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+	struct task_counter *old_cnt = cgroup_task_counter(old_cgrp);
+	struct res_counter *limit_fail_at;
+
+	common_ancestor = res_counter_common_ancestor(&cnt->res, &old_cnt->res);
+
+	WARN_ON_ONCE(common_ancestor == NULL);
+
+	return res_counter_charge_until(&cnt->res, common_ancestor, 1, &limit_fail_at);
+}
+
+static void task_counter_cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+
+	res_counter_uncharge_until(&cnt->res, common_ancestor, 1);
+}
+
+static void task_counter_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				     struct task_struct *tsk)
+{
+	struct task_counter *cnt = cgroup_task_counter(old_cgrp);
+
+	res_counter_uncharge_until(&cnt->res, common_ancestor, 1);
+}
+
+static u64 max_proc_read_u64(struct cgroup *cont, struct cftype *cft)
+{
+	struct task_counter *cnt = cgroup_task_counter(cont);
+	int type = cft->private;
+
+	return res_counter_read_u64(&cnt->res, type);
+}
+
+static int max_proc_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+	int type = cft->private;
+
+	res_counter_write_u64(&cnt->res, type, val);
+
+	return 0;
+}
+
+static struct cftype files[] = {
+	{
+		.name		= "max_proc",
+		.read_u64	= max_proc_read_u64,
+		.write_u64	= max_proc_write_u64,
+		.private	= RES_LIMIT,
+	},
+
+	{
+		.name		= "nr_proc",
+		.read_u64	= max_proc_read_u64,
+		.private	= RES_USAGE,
+	},
+};
+
+static int task_counter_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	if (!cgrp->parent)
+		return 0;
+
+	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
+}
+
+int cgroup_max_tasks_fork(struct task_struct *child)
+{
+	struct cgroup_subsys_state *css = child->cgroups->subsys[max_tasks_subsys_id];
+	struct cgroup *cgrp = css->cgroup;
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+	struct res_counter *limit_fail_at;
+
+	/* Ignore root cgroup directory to optimize trivial common case */
+	if (cnt == &root_counter)
+		return 0;
+
+	return res_counter_charge_until(&cnt->res, &root_counter.res, 1, &limit_fail_at);
+}
+
+struct cgroup_subsys max_tasks_subsys = {
+	.name			= "max_tasks",
+	.subsys_id		= max_tasks_subsys_id,
+	.create			= task_counter_create,
+	.post_clone		= task_counter_post_clone,
+	.destroy		= task_counter_destroy,
+	.exit			= task_counter_exit,
+	.can_attach_task	= task_counter_can_attach_task,
+	.cancel_attach_task	= task_counter_cancel_attach_task,
+	.attach_task		= task_counter_attach_task,
+	.populate		= task_counter_populate,
+	.early_init		= 1,
+};
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..feca609 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1295,6 +1295,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
+	retval = cgroup_max_tasks_fork(p);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-- 
1.7.5.4

