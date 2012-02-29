Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031170Ab2B2PVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:21:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46922 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2B2PVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:21:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.141.15 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
MIME-Version: 1.0
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty.russell@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] module: debugging check for runaway kthreads
Date: Wed, 29 Feb 2012 19:21:13 +0400
Message-Id: <1330528873-7738-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging option CONFIG_MODULE_KTHREAD_CHECK provides a way to check
whether all kernel threads created by the module and have used module
code as a thread worker function are really exited when the module is
unloaded. The following pseudo-code contains example of an error which
is likely to be catched with this debugging check:

static struct task_struct *tsk;
static DECLARE_COMPLETION(done);

static void *func(void *unused)
{
        while (!kthread_should_stop())
              real_work();
        complete(&done);
}

static int __init modinit(void)
{
        tsk = kthread_run(func, NULL, "func");
        return IS_ERR(tsk) ? PTR_ERR(tsk) : 0;
}

static void __exit modexit(void)
{
        wait_for_completion(&done);
}

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 include/linux/kthread.h |    3 ++
 kernel/kthread.c        |   38 +++++++++++++++++++++++++++++++++++
 kernel/module.c         |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug       |    9 ++++++++
 4 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 0714b24..202fe14 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -13,6 +13,9 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 #define kthread_create(threadfn, data, namefmt, arg...) \
 	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
 
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+unsigned long get_kthread_func(struct task_struct *tsk);
+#endif
 
 /**
  * kthread_run - create and wake a thread.
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3d3de63..e6f7977 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -38,6 +38,13 @@ struct kthread_create_info
 
 struct kthread {
 	int should_stop;
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+	/* 
+	 * Kthread worker function, i.e. first argument
+	 * passed to kthread_create() and kthread_run().
+	 */
+	void *fn;
+#endif
 	void *data;
 	struct completion exited;
 };
@@ -45,6 +52,32 @@ struct kthread {
 #define to_kthread(tsk)	\
 	container_of((tsk)->vfork_done, struct kthread, exited)
 
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+
+/*
+ * Assuming the task is a kernel thread, try to get it's worker
+ * function, i.e. the first argument of kthread_create()/kthread_run().
+ */
+unsigned long get_kthread_func(struct task_struct *tsk)
+{
+	struct kthread *kt;
+	unsigned long addr;
+
+	get_task_struct(tsk);
+	BUG_ON(!(tsk->flags & PF_KTHREAD));
+	kt = to_kthread(tsk);
+	barrier();
+	/*
+	 * Note kt is valid only if vfork_done is initialized.
+	 * See kthread() to check why it's so.
+	 */
+	addr = tsk->vfork_done ? (unsigned long)kt->fn : 0UL;
+	put_task_struct(tsk);
+	return addr;
+}
+
+#endif /* CONFIG_MODULE_KTHREAD_CHECK */
+
 /**
  * kthread_should_stop - should this kthread return now?
  *
@@ -106,8 +139,13 @@ static int kthread(void *_create)
 	int ret;
 
 	self.should_stop = 0;
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+	/* Will be used by get_kthread_func(). */
+	self.fn = threadfn;
+#endif
 	self.data = data;
 	init_completion(&self.exited);
+	/* Setup self so to_kthread() macro may be used. */
 	current->vfork_done = &self.exited;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..7ad8a03 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -45,6 +45,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
+#include <linux/kthread.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -223,6 +224,8 @@ extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
 #endif
 
+static void check_kthreads(struct module *mod);
+
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
 #else
@@ -831,6 +834,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
 	async_synchronize_full();
+	check_kthreads(mod);
 
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
@@ -3274,8 +3278,55 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	}
 	return 0;
 }
+
+#else /* not CONFIG_KALLSYMS */
+
+static inline const char *get_ksymbol(struct module *mod,
+				      unsigned long addr,
+				      unsigned long *size,
+				      unsigned long *offset)
+{
+	return "<unknown>";
+}
+
 #endif /* CONFIG_KALLSYMS */
 
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+
+static void check_kthreads(struct module *mod)
+{
+	unsigned long flags;
+	struct task_struct *g, *p;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+	do_each_thread(g, p) {
+		const char *name;
+		unsigned long addr, offset, size;
+
+		/* Note kthreadd is special. Other kthreads should
+		   have their struct kthread on the stack until
+		   do_exit() calls schedule() for the last time. */
+		if (p->mm || p == kthreadd_task)
+			continue;
+
+		addr = get_kthread_func(p);
+		if (__module_text_address(addr) == mod) {
+			name = get_ksymbol(mod, addr, &size, &offset);
+			printk(KERN_WARNING "kthread %p[%s:%d] running "
+			       "0x%lx(%s) is still alive, fix module %s, "
+			       "crash possible\n", p, p->comm, p->pid,
+			       addr, name, mod->name);
+		}
+	} while_each_thread(g, p);
+	read_unlock_irqrestore(&tasklist_lock, flags);
+}
+
+#else
+
+static void check_kthreads(struct module *mod) {}
+
+#endif /* CONFIG_MODULE_KTHREAD_CHECK */
+
 static char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..f082a76 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1121,6 +1121,15 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config MODULE_KTHREAD_CHECK
+	bool "Check for runaway kernel threads at module unload"
+	depends on MODULE_UNLOAD && EXPERIMENTAL && DEBUG_KERNEL
+	help
+	  This option allows you to check whether all kernel threads created
+	  by the module and have used module code as a thread worker function
+	  are really exited when the module is unloaded. This is mainly for
+	  module developers. If insure, say N.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
-- 
1.7.7.6

