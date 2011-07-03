Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1GCOPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:15:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39777 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab1GCOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:14:59 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-pm@lists.linux-foundation.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/7] fault-injection: notifier error injection
Date: Sun,  3 Jul 2011 23:16:17 +0900
Message-Id: <1309702581-16863-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notifier error injection provides the ability to inject artifical
errors to specified notifier chain callbacks. It is useful to test
the error handling of notifier call chain failures.

This adds common basic functions to define which type of events can be
fail and to initialize the debugfs interface to control what error code
should be returned and which event should be failed.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-pm@lists.linux-foundation.org
Cc: linux-mm@kvack.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 include/linux/notifier.h |   25 ++++++++++++++++++++
 kernel/notifier.c        |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug        |   11 +++++++++
 3 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index c0688b0..51882d6 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -278,5 +278,30 @@ extern struct blocking_notifier_head reboot_notifier_list;
 #define VT_UPDATE		0x0004 /* A bigger update occurred */
 #define VT_PREWRITE		0x0005 /* A char is about to be written to the console */
 
+#ifdef CONFIG_NOTIFIER_ERROR_INJECTION
+
+struct err_inject_notifier_action {
+	unsigned long val;
+	int error;
+	const char *name;
+};
+
+#define ERR_INJECT_NOTIFIER_ACTION(action)	\
+	.name = #action, .val = (action),
+
+struct err_inject_notifier_block {
+	struct notifier_block nb;
+	struct dentry *dir;
+	struct err_inject_notifier_action actions[];
+	/* The last slot must be terminated with zero sentinel */
+};
+
+extern int err_inject_notifier_block_init(struct err_inject_notifier_block *enb,
+				const char *name, int priority);
+extern void err_inject_notifier_block_cleanup(
+				struct err_inject_notifier_block *enb);
+
+#endif /* CONFIG_NOTIFIER_ERROR_INJECTION */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2488ba7..8dcc485 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -5,6 +5,7 @@
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
+#include <linux/debugfs.h>
 
 /*
  *	Notifier list for kernel code which wants to be called
@@ -584,3 +585,59 @@ int unregister_die_notifier(struct notifier_block *nb)
 	return atomic_notifier_chain_unregister(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(unregister_die_notifier);
+
+#ifdef CONFIG_NOTIFIER_ERROR_INJECTION
+
+static int err_inject_notifier_callback(struct notifier_block *nb,
+				unsigned long val, void *p)
+{
+	int err = 0;
+	struct err_inject_notifier_block *enb =
+		container_of(nb, struct err_inject_notifier_block, nb);
+	struct err_inject_notifier_action *action;
+
+	for (action = enb->actions; action->name; action++) {
+		if (action->val == val) {
+			err = action->error;
+			break;
+		}
+	}
+	if (err) {
+		printk(KERN_INFO "Injecting error (%d) to %s\n",
+			err, action->name);
+	}
+
+	return notifier_from_errno(err);
+}
+
+int err_inject_notifier_block_init(struct err_inject_notifier_block *enb,
+				const char *name, int priority)
+{
+	struct err_inject_notifier_action *action;
+	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+
+	enb->nb.notifier_call = err_inject_notifier_callback;
+	enb->nb.priority = priority;
+
+	enb->dir = debugfs_create_dir(name, NULL);
+	if (!enb->dir)
+		return -ENOMEM;
+
+	for (action = enb->actions; action->name; action++) {
+		struct dentry *file = debugfs_create_int(action->name, mode,
+						enb->dir, &action->error);
+
+		if (!file) {
+			debugfs_remove_recursive(enb->dir);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+void err_inject_notifier_block_cleanup(struct err_inject_notifier_block *enb)
+{
+	debugfs_remove_recursive(enb->dir);
+}
+
+#endif /* CONFIG_NOTIFIER_ERROR_INJECTION */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd373c8..8c6ce7e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1018,6 +1018,17 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.txt
 
+config NOTIFIER_ERROR_INJECTION
+	bool "Notifier error injection"
+	depends on DEBUG_KERNEL
+	select DEBUG_FS
+	help
+	  This option provides the ability to inject artifical errors to
+	  specified notifier chain callbacks. It is useful to test the error
+	  handling of notifier call chain failures.
+
+	  Say N if unsure.
+
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
 	depends on HOTPLUG_CPU && DEBUG_KERNEL
-- 
1.7.4.4

