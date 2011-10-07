Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab1JGUff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:35:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60374 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935541Ab1JGUfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:35:10 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 25/26] dynamic_debug: add pr_fmt_*() for each severity
Date: Fri,  7 Oct 2011 14:33:31 -0600
Message-Id: <1318019612-20068-26-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Define separate pr_fmt_*()s for each severity, defaulting to pr_fmt(),
and use them in all pr_$severity(), pr_$severity_once(), and
pr_$severity_ratelimited() macros.  This lets modules change the
printed prefix for the whole set and/or any subset.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    8 ++-
 include/linux/printk.h        |   87 +++++++++++++++++++++++++++--------------
 2 files changed, 63 insertions(+), 32 deletions(-)

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
index 1224b1d..e21de7e 100644
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
@@ -212,28 +241,28 @@ extern void dump_stack(void) __cold;
 #endif
 
 #define pr_emerg_once(fmt, ...)					\
-	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_EMERG pr_fmt_emerg(fmt), ##__VA_ARGS__)
 #define pr_alert_once(fmt, ...)					\
-	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_ALERT pr_fmt_alert(fmt), ##__VA_ARGS__)
 #define pr_crit_once(fmt, ...)					\
-	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_CRIT pr_fmt_crit(fmt), ##__VA_ARGS__)
 #define pr_err_once(fmt, ...)					\
-	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_ERR pr_fmt_err(fmt), ##__VA_ARGS__)
 #define pr_warn_once(fmt, ...)					\
-	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_WARNING pr_fmt_warn(fmt), ##__VA_ARGS__)
 #define pr_notice_once(fmt, ...)				\
-	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_NOTICE pr_fmt_notice(fmt), ##__VA_ARGS__)
 #define pr_info_once(fmt, ...)					\
-	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_INFO pr_fmt_info(fmt), ##__VA_ARGS__)
 #define pr_cont_once(fmt, ...)					\
 	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_once(fmt, ...)					\
-	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_once(fmt, ...)					\
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	no_printk(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__)
 #endif
 
 /*
@@ -256,27 +285,27 @@ extern void dump_stack(void) __cold;
 #endif
 
 #define pr_emerg_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_EMERG pr_fmt_emerg(fmt), ##__VA_ARGS__)
 #define pr_alert_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_ALERT pr_fmt_alert(fmt), ##__VA_ARGS__)
 #define pr_crit_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_CRIT pr_fmt_crit(fmt), ##__VA_ARGS__)
 #define pr_err_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_ERR pr_fmt_err(fmt), ##__VA_ARGS__)
 #define pr_warn_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_WARNING pr_fmt_warn(fmt), ##__VA_ARGS__)
 #define pr_notice_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_NOTICE pr_fmt_notice(fmt), ##__VA_ARGS__)
 #define pr_info_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_INFO pr_fmt_info(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_ratelimited(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	no_printk(KERN_DEBUG pr_fmt_debug(fmt), ##__VA_ARGS__)
 #endif
 
 enum {
-- 
1.7.4.4

