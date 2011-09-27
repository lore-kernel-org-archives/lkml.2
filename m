Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1I0TJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1I0TJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:09:36 -0400
Date: Tue, 27 Sep 2011 15:09:15 -0400
From: Jason Baron <jbaron@redhat.com>
Message-Id: <201109271909.p8RJ9Fxk010028@int-mx02.intmail.prod.int.phx2.redhat.com>
To: arjan@linux.intel.com, mingo@elte.hu
Cc: peterz@infradead.org, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH] introduce CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, CONFIG_DEBUG_NOTIFIERS, is only a build-time option, since
it can be costly to have to check all modules and kernel text for valid
notifiers on each notifier callback. We can turn it into a run-time check
that has no over-head in the disabled case by using jump labels (leaving
a single no-op in the disabled code path). In this way, we can enable
it at run-time, via 0/1 in: <debugfs>/notifiers/debug_enable  or on the kernel
command line via: "debug_notifiers".

In general, I'd like to turn a number of the build-time debug options into
run-time options, where possible. For Red Hat, which ships a separate -debug
kernel, having debug options in our production kernel is desireable. Both from
a customer perspective (having less kernels to deal with), and from a testing
point of view.

I've also tested this change using a module load/unload loop, which hits
the notifier chain. Below is the combinations for
CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC enabled/disabled and jump label
enabled/disabled, when notifier debug is off.


CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC enabled/jump label enabled:

# taskset -c 0   perf stat --repeat 100 -e instructions,cycles,branches /tmp/load-unload

 Performance counter stats for '/tmp/load-unload' (100 runs):

     2,420,961,130 instructions             #      0.587 IPC     ( +-   0.018% )
     4,122,380,182 cycles                     ( +-   0.094% )
       463,442,670 branches                   ( +-   0.020% )

        1.622449703  seconds time elapsed   ( +-   0.099% )

CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC/jump label disabled:

 taskset -c 0   perf stat --repeat 100 -e instructions,cycles,branches /tmp/load-unload

 Performance counter stats for '/tmp/load-unload' (100 runs):

     2,425,139,714 instructions             #      0.580 IPC     ( +-   0.018% )
     4,178,078,387 cycles                     ( +-   0.114% )
       465,802,135 branches                   ( +-   0.020% )

        1.642928148  seconds time elapsed   ( +-   0.105% )


CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC disabled/jump label enabled:

#  taskset -c 0   perf stat --repeat 100 -e instructions,cycles,branches /tmp/load-unload

 Performance counter stats for '/tmp/load-unload' (100 runs):

     2,421,957,621 instructions             #      0.585 IPC     ( +-   0.019% )
     4,142,800,048 cycles                     ( +-   0.137% )
       463,568,665 branches                   ( +-   0.021% )

        1.628438721  seconds time elapsed   ( +-   0.130% )

CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC disabled/jump label disabled:

# taskset -c 0   perf stat --repeat 100 -e instructions,cycles,branches /tmp/load-unload

 Performance counter stats for '/tmp/load-unload' (100 runs):

     2,429,450,979 instructions             #      0.578 IPC     ( +-   0.022% )
     4,202,429,137 cycles                     ( +-   0.126% )
       466,506,471 branches                   ( +-   0.022% )

        1.651379469  seconds time elapsed   ( +-   0.119% )

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/notifier.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug |   13 ++++++++
 2 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 8d7b435..44ec29d 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -5,6 +5,9 @@
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
+#include <linux/jump_label.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
 
 /*
  *	Notifier list for kernel code which wants to be called
@@ -59,6 +62,79 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 	return -ENOENT;
 }
 
+#ifdef CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC
+static struct jump_label_key debug_notifiers_key;
+static int early_debug_enable;
+
+static ssize_t read_notifier_debug(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (jump_label_enabled(&debug_notifiers_key))
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_notifier_debug(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if ((buf[0] == '1') && !jump_label_enabled(&debug_notifiers_key))
+		jump_label_inc(&debug_notifiers_key);
+	else if ((buf[0] == '0') && jump_label_enabled(&debug_notifiers_key))
+		jump_label_dec(&debug_notifiers_key);
+
+	return count;
+}
+
+static const struct file_operations fops_debug_notifiers = {
+	.read =	read_notifier_debug,
+	.write = write_notifier_debug,
+	.llseek = default_llseek,
+};
+
+static int __init debug_notifiers_setup(char *str)
+{
+	early_debug_enable = 1;
+	return 0;
+}
+early_param("debug_notifiers", debug_notifiers_setup);
+
+static int __init debug_notifiers_setup_debugfs(void)
+{
+	struct dentry *dir, *file;
+
+	/* we can't enable jump labels until after early_initcall() */
+	if (early_debug_enable)
+		jump_label_inc(&debug_notifiers_key);
+
+	dir = debugfs_create_dir("notifiers", NULL);
+	if (!dir)
+		return -ENOMEM;
+	file = debugfs_create_file("debug_enable", 0644, dir, NULL,
+					&fops_debug_notifiers);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+	return 0;
+}
+/* must be after debugfs is setup */
+postcore_initcall(debug_notifiers_setup_debugfs);
+
+#endif
+
 /**
  * notifier_call_chain - Informs the registered notifiers about an event.
  *	@nl:		Pointer to head of the blocking notifier chain
@@ -82,8 +158,10 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference_raw(nb->next);
-
 #ifdef CONFIG_DEBUG_NOTIFIERS
+#ifdef CONFIG_DEBUG_NOTIFIERS_MAKE_DYNAMIC
+		if (static_branch(&debug_notifiers_key))
+#endif
 		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
 			WARN(1, "Invalid notifier called!");
 			nb = next_nb;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..4d57783 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -818,6 +818,19 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
+config DEBUG_NOTIFIERS_MAKE_DYNAMIC
+	bool "Debug notifier call chains"
+	depends on DEBUG_KERNEL
+	depends on DEBUG_NOTIFIERS
+	depends on DEBUG_FS
+	help
+	  Enable this to turn on sanity checking for notifier call chains.
+	  This is most useful for kernel developers to make sure that
+	  modules properly unregister themselves from notifier chains.
+	  This is a relatively cheap check but if you care about maximum
+	  performance, say N.
+
+
 config DEBUG_CREDENTIALS
 	bool "Debug credential management"
 	depends on DEBUG_KERNEL
-- 
1.7.5.4

