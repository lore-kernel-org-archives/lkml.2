Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1I0Vl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:41:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48437 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1I0VlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:41:20 -0400
From: jim.cromie@gmail.com
To: joe@perches.com
Cc: jbaron@redhat.com, greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 25/26] dynamic_debug: add pr_fmt_debug() for dynamic_pr_debug
Date: Tue, 27 Sep 2011 15:40:59 -0600
Message-Id: <1317159660-2506-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317159660-2506-1-git-send-email-jim.cromie@gmail.com>
References: <1316725066.29447.16.camel@Joe-Laptop>
 <1317159660-2506-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

dynamic_pr_debug can add module, function, file, and line selectively,
so theres no need to also add them via pr_fmt.  Moreover, using pr_fmt
to add KBUILD_MODNAME ": ", as is typical for pr_info etc, causes
pr_debug() to double-print those fields added by the flag-settings.

So define pr_fmt_debug(fmt), and use it in dynamic_pr_debug().  This
lets users use pr_fmt() for pr_info and friends, without affecting
pr_debug().  Also add pr_fmt_*(fmt) defns for info etc, which default
to pr_fmt().  This lets user set a default for all pr_$level()s, and
then customize one of them.

Unlike the previous revision of this patch, pr_fmt_debug() is the same
for DEBUG and !DEBUG.  User may want different formats, but doesnt get
them magically.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    8 ++++--
 include/linux/printk.h        |   51 ++++++++++++++++++++++++++++++++---------
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 5622e04..4382b0a 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -73,7 +73,7 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 do {								\
 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
 	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
+		__dynamic_pr_debug(&descriptor, pr_fmt_debug(fmt),\
 				   ##__VA_ARGS__);		\
 } while (0)
 
@@ -101,9 +101,11 @@ static inline int ddebug_remove_module(const char *mod)
 }
 
 #define dynamic_pr_debug(fmt, ...)					\
-	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+	do { if (0) printk(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__);\
+	} while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
-	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
+	} while (0)
 #endif
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1224b1d..5ff654d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -152,31 +152,60 @@ extern void dump_stack(void) __cold;
 #define pr_fmt(fmt) fmt
 #endif
 
+#ifndef pr_fmt_emerg
+#define pr_fmt_emerg(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_crit
+#define pr_fmt_crit(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_alert
+#define pr_fmt_alert(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_err
+#define pr_fmt_err(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_notice
+#define pr_fmt_notice(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_warning
+#define pr_fmt_warning(fmt) pr_fmt(fmt)
+#endif
+#define pr_fmt_warn pr_fmt_warning
+#ifndef pr_fmt_info
+#define pr_fmt_info(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_debug
+#define pr_fmt_debug(fmt) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_devel
+#define pr_fmt_devel(fmt) pr_fmt(fmt)
+#endif
+
 #define pr_emerg(fmt, ...) \
-	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_EMERG pr_fmt_emerg(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
-	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ALERT pr_fmt_alert(fmt), ##__VA_ARGS__)
 #define pr_crit(fmt, ...) \
-	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_CRIT pr_fmt_crit(fmt), ##__VA_ARGS__)
 #define pr_err(fmt, ...) \
-	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ERR pr_fmt_err(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_WARNING pr_fmt_warn(fmt), ##__VA_ARGS__)
 #define pr_warn pr_warning
 #define pr_notice(fmt, ...) \
-	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_NOTICE pr_fmt_notice(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_INFO pr_fmt_info(fmt), ##__VA_ARGS__)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_DEBUG pr_fmt_devel(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	no_printk(KERN_DEBUG pr_fmt_devel(fmt), ##__VA_ARGS__)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
@@ -186,10 +215,10 @@ extern void dump_stack(void) __cold;
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
 #elif defined(DEBUG)
 #define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	no_printk(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__)
 #endif
 
 /*
-- 
1.7.4.4

