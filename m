Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2BCGhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:37:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34269 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2BCGhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:37:36 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Dumazat <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] module: debugging check for runaway kthreads
Date: Fri,  3 Feb 2012 10:37:31 +0400
Message-Id: <1328251051-14533-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging option CONFIG_MODULE_KTHREAD_CHECK provides a way to check
whether all kernel threads created by the module and have used module
code as a thread worker function are really exited when the module is
unloaded.

See http://marc.info/?l=linux-kernel&m=132811276131767&w=2 to check
why it might be useful.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 include/linux/kthread.h |    5 +++++
 init/Kconfig            |    9 +++++++++
 kernel/kthread.c        |   24 ++++++++++++++++++++++++
 kernel/module.c         |   45 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 0714b24..33897c3 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -13,6 +13,11 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 #define kthread_create(threadfn, data, namefmt, arg...) \
 	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
 
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+unsigned long get_kthread_func(struct task_struct *tsk);
+#else
+#define get_kthread_func(tsk, addr, mod) (0)
+#endif
 
 /**
  * kthread_run - create and wake a thread.
diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..fa7c6e0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1397,6 +1397,15 @@ config MODULE_FORCE_UNLOAD
 	  rmmod).  This is mainly for kernel developers and desperate users.
 	  If unsure, say N.
 
+config MODULE_KTHREAD_CHECK
+	bool "Check for runaway kernel threads at module unload"
+	depends on MODULE_UNLOAD && EXPERIMENTAL && DEBUG_KERNEL
+	help
+	  This option allows you to check whether all kernel threads created
+	  by the module and have used module code as a thread worker function
+	  are really exited when the module is unloaded. This is mainly for
+	  module developers. If insure, say N.
+
 config MODVERSIONS
 	bool "Module versioning support"
 	help
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3d3de63..5c53817 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -38,6 +38,9 @@ struct kthread_create_info
 
 struct kthread {
 	int should_stop;
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+	void *fn;
+#endif
 	void *data;
 	struct completion exited;
 };
@@ -45,6 +48,24 @@ struct kthread {
 #define to_kthread(tsk)	\
 	container_of((tsk)->vfork_done, struct kthread, exited)
 
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+
+unsigned long get_kthread_func(struct task_struct *tsk)
+{
+	struct kthread *kt;
+	unsigned long addr;
+
+	get_task_struct(tsk);
+	BUG_ON(!(tsk->flags & PF_KTHREAD));
+	kt = to_kthread(tsk);
+	barrier();
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
@@ -106,6 +127,9 @@ static int kthread(void *_create)
 	int ret;
 
 	self.should_stop = 0;
+#ifdef CONFIG_MODULE_KTHREAD_CHECK
+	self.fn = threadfn;
+#endif
 	self.data = data;
 	init_completion(&self.exited);
 	current->vfork_done = &self.exited;
diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..fe6637b 100644
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
@@ -764,6 +765,49 @@ static void wait_for_zero_refcount(struct module *mod)
 	mutex_lock(&module_mutex);
 }
 
+#ifdef CONFIG_KALLSYMS
+static const char *get_ksymbol(struct module *mod, unsigned long addr,
+			       unsigned long *size, unsigned long *offset);
+#else
+#define get_ksymbol(mod, addr, size, offset) NULL
+#endif
+
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
+		   have their 'struct kthread' on the stack until
+		   do_exit() calls schedule() for the last time. */
+		if (p->mm || p == kthreadd_task)
+			continue;
+
+		addr = get_kthread_func(p);
+		if (__module_text_address(addr) == mod) {
+			name = get_ksymbol(mod, addr, &size, &offset);
+			printk(KERN_WARNING "khread %p[%s:%d] running "
+			       "0x%lx(%s) is still alive, fix module %s, "
+			       "crash possible\n", p, p->comm, p->pid, addr,
+			       (name ? name : "<unknown>"), mod->name);
+		}
+	} while_each_thread(g, p);
+	read_unlock_irqrestore(&tasklist_lock, flags);
+}
+
+#else
+
+#define check_kthreads(mod) do { } while (0)
+
+#endif /* CONFIG_MODULE_KTHREAD_CHECK */
+
 SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		unsigned int, flags)
 {
@@ -831,6 +875,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
 	async_synchronize_full();
+	check_kthreads(mod);
 
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
-- 
1.7.7.6

