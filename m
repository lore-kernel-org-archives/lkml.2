Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2C0RXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:23:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36127 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754192Ab2C0RXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:23:51 -0400
Message-ID: <1332869030.2213.46.camel@joe2Laptop>
Subject: [RFC] Remove most all #define pr_fmt(fmt) lines
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@redhat.com>,
        Jim Cromie <jim.cromie@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 10:23:50 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the next RC window I'd like to convert the
current pr_fmt #define in include/linux/printk.h
so that non-debug uses of pr_<level> always get a
standardized KBUILD_MODNAME prefix when pr_fmt is
otherwise undefined.

Basically, add #define pr_fmt_std and pr_fmt_dbg
and convert the existing pr_fmt uses in printk.h
to these new #defines.

This will allow deletion of all of the 600 or so
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
sprinkled around the kernel tree.

This will also allow separate and possibly clearer
uses of dynamic_debugging or adding __func__ only
to pr_debug uses.

Below this rfc patch is more commentary and another
suggested patch to a Makefile to improve prefixing.

 include/linux/printk.h |  114 ++++++++++++++++++++++++++++++------------------
 1 files changed, 72 insertions(+), 42 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 0525927..d9c05f4 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -158,48 +158,78 @@ static inline void setup_log_buf(int early)
 
 extern void dump_stack(void) __cold;
 
+/* Define separate possible prefixes for pr_debug and other pr_<level> uses
+ *
+ * pr_fmt_dbg for pr_debug and pr_devel (default: blank)
+ * pr_fmt_std for everything else (default: KBUILD_MODNAME ": ")
+ *
+ * if pr_fmt is defined before this inclusion, it is
+ * used for both pr_fmt_dbg and pr_fmt_std
+ *
+ * nb: Most debugging can now be done with dynamic debug.
+ *     dynamic debug can optionally prefix KBUILD_MODNAME and/or __func__
+ *     see Documentation/dynamic-debug-howto.txt
+ */
+
 #ifndef pr_fmt
+
+#ifndef pr_fmt_std
+#define pr_fmt_std(fmt) KBUILD_MODNAME ": " fmt
+#endif
+#ifndef pr_fmt_dbg
+#define pr_fmt_dbg(fmt) fmt
+#endif
 #define pr_fmt(fmt) fmt
+
+#else
+
+#ifndef pr_fmt_std
+#define pr_fmt_std(fmt...) pr_fmt(fmt)
+#endif
+#ifndef pr_fmt_dbg
+#define pr_fmt_dbg(fmt...) pr_fmt(fmt)
+#endif
+
 #endif
 
-#define pr_emerg(fmt, ...) \
-	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...) \
-	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...) \
-	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...) \
-	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_emerg(fmt, ...)					\
+	printk(KERN_EMERG pr_fmt_std(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...)					\
+	printk(KERN_ALERT pr_fmt_std(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...)					\
+	printk(KERN_CRIT pr_fmt_std(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...)					\
+	printk(KERN_ERR pr_fmt_std(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...)					\
+	printk(KERN_WARNING pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_warn pr_warning
-#define pr_notice(fmt, ...) \
-	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...) \
+#define pr_notice(fmt, ...)					\
+	printk(KERN_NOTICE pr_fmt_std(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...)					\
+	printk(KERN_INFO pr_fmt_std(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...)					\
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
-#define pr_devel(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_devel(fmt, ...)					\
+	printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #else
-#define pr_devel(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_devel(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
-#define pr_debug(fmt, ...) \
+#define pr_debug(fmt, ...)					\
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
 #elif defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug(fmt, ...)					\
+	printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #else
-#define pr_debug(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug(fmt, ...) 					\
+	no_printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #endif
 
 /*
@@ -222,28 +252,28 @@ extern void dump_stack(void) __cold;
 #endif
 
 #define pr_emerg_once(fmt, ...)					\
-	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_EMERG pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_alert_once(fmt, ...)					\
-	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_ALERT pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_crit_once(fmt, ...)					\
-	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_CRIT pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_err_once(fmt, ...)					\
-	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_ERR pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_warn_once(fmt, ...)					\
-	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_WARNING pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_notice_once(fmt, ...)				\
-	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_NOTICE pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_info_once(fmt, ...)					\
-	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_INFO pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_cont_once(fmt, ...)					\
 	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_once(fmt, ...)					\
-	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_once(fmt, ...)					\
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	no_printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #endif
 
 /*
@@ -266,27 +296,27 @@ extern void dump_stack(void) __cold;
 #endif
 
 #define pr_emerg_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_EMERG pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_alert_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_ALERT pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_crit_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_CRIT pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_err_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_ERR pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_warn_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_WARNING pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_notice_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_NOTICE pr_fmt_std(fmt), ##__VA_ARGS__)
 #define pr_info_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_INFO pr_fmt_std(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
-	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	printk_ratelimited(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_ratelimited(fmt, ...) \
-	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	no_printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__)
 #endif
 
 enum {

-------------------------

This does have some side-effects to current uses of
pr_<level> without a pre-existing pr_fmt.

All non-debug pr_<level> uses will have a prefix.

pr_debug can be prefixed by dynamic_debug or have
__func__ added independently of other pr_<level> uses.

For instance, drivers/regulator/ uses pr_err and pr_crit
for dmesg output, but the messages are not prefixed
by subsystem at all.

With this change, objects like drivers/regulator/core.o
are prefixed with "core: ".  This is somewhat senseless
and may prompt Makefile changes to make the prefixes for
some objects more sensible.

For example, modifying the Makefile to bundle objects
together with a specific name can change the prefixes.
Here the prefix becomes "regulator: "

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 94b5274..93fff05 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -2,8 +2,10 @@
 # Makefile for regulator drivers.
 #
 
+regulator-y := core.o dummy.o fixed-helper.o
+regulator-objs := $(regulator-y)
 
-obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
+obj-$(CONFIG_REGULATOR) += regulator.o
 obj-$(CONFIG_OF) += of_regulator.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o

------------------

Any objections or other suggestions/improvements?


