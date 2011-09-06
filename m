Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1IFAOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 20:14:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53143 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1IFAO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 20:14:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] cgroups: Add a task counter subsystem
Date: Tue,  6 Sep 2011 02:13:03 +0200
Message-Id: <1315267986-28937-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new subsystem to limit the number of running tasks,
similar to the NR_PROC rlimit but in the scope of a cgroup.

This is a step to be able to isolate a bit more a cgroup against
the rest of the system and limit the global impact of a fork bomb
inside a given cgroup.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h        |    9 ++
 include/linux/cgroup_subsys.h |    8 ++
 init/Kconfig                  |    7 ++
 kernel/Makefile               |    1 +
 kernel/cgroup_task_counter.c  |  199 +++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                 |    4 +
 6 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 kernel/cgroup_task_counter.c

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index be66470..5e39341 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -659,4 +659,13 @@ static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 
 #endif /* !CONFIG_CGROUPS */
 
+#ifdef CONFIG_CGROUP_TASK_COUNTER
+int cgroup_task_counter_fork(struct task_struct *child);
+#else
+static inline int cgroup_task_counter_fork(struct task_struct *child)
+{
+	return 0;
+}
+#endif /* CONFIG_CGROUP_TASK_COUNTER */
+
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ac663c1..5425822 100644
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
+#ifdef CONFIG_CGROUP_TASK_COUNTER
+SUBSYS(tasks)
+#endif
+
+/* */
diff --git a/init/Kconfig b/init/Kconfig
index d627783..c337ebd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -690,6 +690,13 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then swapaccount=0 does the trick).
 
+config CGROUP_TASK_COUNTER
+	bool "Control number of tasks in a cgroup"
+	depends on RESOURCE_COUNTERS
+	help
+	  Let the user set up an upper bound allowed number of tasks running
+	  in a cgroup.
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff --git a/kernel/Makefile b/kernel/Makefile
index eca595e..5598a7f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_TASK_COUNTER) += cgroup_task_counter.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_task_counter.c b/kernel/cgroup_task_counter.c
new file mode 100644
index 0000000..2ca7f41
--- /dev/null
+++ b/kernel/cgroup_task_counter.c
@@ -0,0 +1,199 @@
+/*
+ * Limits on number of tasks subsystem for cgroups
+ *
+ * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Thanks to Andrew Morton, Johannes Weiner, Li Zefan, Oleg Nesterov and Paul Menage
+ * for their suggestions.
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
+ * The root task counter doesn't exist as it's not part of the
+ * whole task counting in order to optimize the trivial case
+ * of only one root cgroup living.
+ */
+static struct cgroup_subsys_state root_css;
+
+
+static inline struct task_counter *cgroup_task_counter(struct cgroup *cgrp)
+{
+	if (!cgrp->parent)
+		return NULL;
+
+	return container_of(cgroup_subsys_state(cgrp, tasks_subsys_id),
+			    struct task_counter, css);
+}
+
+static inline struct res_counter *cgroup_task_counter_res(struct cgroup *cgrp)
+{
+	struct task_counter *cnt;
+
+	cnt = cgroup_task_counter(cgrp);
+	if (!cnt)
+		return NULL;
+
+	return &cnt->res;
+}
+
+static struct cgroup_subsys_state *
+task_counter_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt;
+	struct res_counter *parent_res;
+
+	if (!cgrp->parent)
+		return &root_css;
+
+	cnt = kzalloc(sizeof(*cnt), GFP_KERNEL);
+	if (!cnt)
+		return ERR_PTR(-ENOMEM);
+
+	parent_res = cgroup_task_counter_res(cgrp->parent);
+
+	res_counter_init(&cnt->res, parent_res);
+
+	return &cnt->css;
+}
+
+static void task_counter_post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	/* cgrp can't be root, so cgroup_task_counter_res() can't return NULL */
+	res_counter_inherit(cgroup_task_counter_res(cgrp), RES_LIMIT);
+}
+
+static void task_counter_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct task_counter *cnt = cgroup_task_counter(cgrp);
+
+	kfree(cnt);
+}
+
+static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			      struct cgroup *old_cgrp, struct task_struct *task)
+{
+	/* Optimize for the root cgroup case */
+	if (old_cgrp->parent)
+		res_counter_uncharge(cgroup_task_counter_res(old_cgrp), 1);
+}
+
+/* Protected amongst can_attach_task/attach_task/cancel_attach_task by cgroup mutex */
+static struct res_counter *common_ancestor;
+
+static int task_counter_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+					struct task_struct *tsk)
+{
+	struct res_counter *res = cgroup_task_counter_res(cgrp);
+	struct res_counter *old_res = cgroup_task_counter_res(old_cgrp);
+	int err;
+
+	/*
+	 * When moving a task from a cgroup to another, we don't want
+	 * to charge the common ancestors, even though they will be
+	 * uncharged later from attach_task(), because during that
+	 * short window between charge and uncharge, a task could fork
+	 * in the ancestor and spuriously fail due to the temporary
+	 * charge.
+	 */
+	common_ancestor = res_counter_common_ancestor(res, old_res);
+
+	/*
+	 * If cgrp is the root then res is NULL, however in this case
+	 * the common ancestor is NULL as well, making the below a NOP.
+	 */
+	err = res_counter_charge_until(res, common_ancestor, 1, NULL);
+	if (err)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void task_counter_cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+{
+	res_counter_uncharge_until(cgroup_task_counter_res(cgrp), common_ancestor, 1);
+}
+
+static void task_counter_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				     struct task_struct *tsk)
+{
+	res_counter_uncharge_until(cgroup_task_counter_res(old_cgrp), common_ancestor, 1);
+}
+
+static u64 task_counter_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	int type = cft->private;
+
+	return res_counter_read_u64(cgroup_task_counter_res(cgrp), type);
+}
+
+static int task_counter_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	int type = cft->private;
+
+	res_counter_write_u64(cgroup_task_counter_res(cgrp), type, val);
+
+	return 0;
+}
+
+static struct cftype files[] = {
+	{
+		.name		= "limit",
+		.read_u64	= task_counter_read_u64,
+		.write_u64	= task_counter_write_u64,
+		.private	= RES_LIMIT,
+	},
+
+	{
+		.name		= "usage",
+		.read_u64	= task_counter_read_u64,
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
+int cgroup_task_counter_fork(struct task_struct *child)
+{
+	struct cgroup_subsys_state *css = child->cgroups->subsys[tasks_subsys_id];
+	struct cgroup *cgrp = css->cgroup;
+	int err;
+
+	/* Optimize for the root cgroup case, which doesn't have a limit */
+	if (!cgrp->parent)
+		return 0;
+
+	err = res_counter_charge(cgroup_task_counter_res(cgrp), 1, NULL);
+	if (err)
+		return -EAGAIN;
+
+	return 0;
+}
+
+struct cgroup_subsys tasks_subsys = {
+	.name			= "tasks",
+	.subsys_id		= tasks_subsys_id,
+	.create			= task_counter_create,
+	.post_clone		= task_counter_post_clone,
+	.destroy		= task_counter_destroy,
+	.exit			= task_counter_exit,
+	.can_attach_task	= task_counter_can_attach_task,
+	.cancel_attach_task	= task_counter_cancel_attach_task,
+	.attach_task		= task_counter_attach_task,
+	.populate		= task_counter_populate,
+};
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..f716436 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1309,6 +1309,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
+	retval = cgroup_task_counter_fork(p);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-- 
1.7.5.4

