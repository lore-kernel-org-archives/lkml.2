Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1FSXvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:51:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55794 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1FSXva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M+GHwiPmyFcmgpO8zB72BbnsM2KHOwsW9L6Y8ORYOY5NYtegieWU64dhHwzkXKNKWS
         s/ziacXuSkBGe0BAt8hDMmeOd6i8RKvys7Aa6Rygtu2iYbI3/kexhgJnYg0wcobC4gn8
         QOCvxLsLM/Pjy6hTDKtGgVI4yLNUXje5l8x4Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
Date: Mon, 20 Jun 2011 01:51:14 +0200
Message-Id: <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new rlimit subsystem with a first support to limit the
number of tasks that can run inside a cgroup.

This is a step to be able to isolate a bit more a cgroup against
the rest of the system and limit the global impact of a fork bomb
or other resource abuse inside a given cgroup.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/cgroup_subsys.h |    8 ++
 init/Kconfig                  |    6 ++
 kernel/Makefile               |    1 +
 kernel/cgroup_rlim.c          |  142 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 kernel/cgroup_rlim.c

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ac663c1..aea8cd5 100644
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
+#ifdef CONFIG_CGROUP_RLIM
+SUBSYS(rlim)
+#endif
+
+/* */
diff --git a/init/Kconfig b/init/Kconfig
index 412c21b..1a48719 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -690,6 +690,12 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  select this option (if, for some reason, they need to disable it
 	  then noswapaccount does the trick).
 
+config CGROUP_RLIM
+        bool "Rlimit on cgroups"
+	depends on RESOURCE_COUNTERS
+	help
+	  This option enables the rlimit settings in the scope of a cgroup.
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff --git a/kernel/Makefile b/kernel/Makefile
index 2d64cfc..6713b38 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_RLIM) += cgroup_rlim.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
diff --git a/kernel/cgroup_rlim.c b/kernel/cgroup_rlim.c
new file mode 100644
index 0000000..af69892
--- /dev/null
+++ b/kernel/cgroup_rlim.c
@@ -0,0 +1,142 @@
+/*
+ * Resource limits subsystem for cgroups
+ *
+ * Copyright (C) 2011 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Thanks to Johannes Weiner for his suggestions on doing this and how to.
+ *
+ */
+
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/res_counter.h>
+
+
+struct rlim {
+	struct res_counter		proc_counter;
+	struct cgroup_subsys_state	css;
+};
+
+static struct rlim root_rlim;
+
+
+static inline struct rlim *cgroup_rlim(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, rlim_subsys_id),
+			    struct rlim, css);
+}
+
+static struct cgroup_subsys_state *
+rlim_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct rlim *rlim, *parent_rlim;
+
+	if (!cgrp->parent) {
+		res_counter_init(&root_rlim.proc_counter, NULL);
+		return &root_rlim.css;
+	}
+
+	rlim = kzalloc(sizeof(*rlim), GFP_KERNEL);
+	if (!rlim)
+		return ERR_PTR(-ENOMEM);
+
+	parent_rlim = cgroup_rlim(cgrp->parent);
+	res_counter_init(&rlim->proc_counter, &parent_rlim->proc_counter);
+
+	return &rlim->css;
+}
+
+static void rlim_post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct rlim *rlim = cgroup_rlim(cgrp);
+
+	res_counter_inherit(&rlim->proc_counter, RES_LIMIT);
+}
+
+static void rlim_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct rlim *rlim = cgroup_rlim(cont);
+
+	kfree(rlim);
+}
+
+static void rlim_remove_proc(struct cgroup *cgrp)
+{
+	struct rlim *rlim = cgroup_rlim(cgrp);
+
+	res_counter_uncharge(&rlim->proc_counter, 1);
+}
+
+static void rlim_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		      struct cgroup *old_cgrp, struct task_struct *task)
+{
+	rlim_remove_proc(old_cgrp);
+}
+
+/*
+ * This is actually where we do the attachment. We need to check if we can
+ * attach and eventually attach all in once.
+ */
+static int rlim_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+{
+	struct rlim *rlim = cgroup_rlim(cgrp);
+	struct res_counter *limit_fail_at;
+
+	return res_counter_charge(&rlim->proc_counter, 1, &limit_fail_at);
+}
+
+static void rlim_cancel_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			       struct task_struct *tsk)
+{
+	rlim_remove_proc(cgrp);
+}
+
+static int rlim_fork(struct cgroup_subsys *ss, struct task_struct *task)
+{
+	struct cgroup_subsys_state *css = task->cgroups->subsys[rlim_subsys_id];
+	struct cgroup *cgrp = css->cgroup;
+
+	return rlim_can_attach_task(cgrp, task);
+}
+
+static u64 max_proc_read_u64(struct cgroup *cont, struct cftype *cft)
+{
+	struct rlim *rlim = cgroup_rlim(cont);
+
+	return res_counter_read_u64(&rlim->proc_counter, RES_LIMIT);
+}
+
+static int max_proc_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	struct rlim *rlim = cgroup_rlim(cgrp);
+
+	res_counter_write_u64(&rlim->proc_counter, RES_LIMIT, val);
+
+	return 0;
+}
+
+static struct cftype cft_max_proc = {
+	.name		= "max_proc",
+	.read_u64	= max_proc_read_u64,
+	.write_u64	= max_proc_write_u64,
+};
+
+static int rlim_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	return cgroup_add_file(cgrp, ss, &cft_max_proc);
+}
+
+struct cgroup_subsys rlim_subsys = {
+	.name			= "rlim",
+	.subsys_id		= rlim_subsys_id,
+	.create			= rlim_cgroup_create,
+	.post_clone		= rlim_post_clone,
+	.destroy		= rlim_cgroup_destroy,
+	.exit			= rlim_cgroup_exit,
+	.can_attach_task	= rlim_can_attach_task,
+	.cancel_attach		= rlim_cancel_attach,
+	.attach			= rlim_cgroup_exit,
+	.fork			= rlim_fork,
+	.populate		= rlim_populate,
+	.early_init		= 1,
+};
-- 
1.7.5.4

