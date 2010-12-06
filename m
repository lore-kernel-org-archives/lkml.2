Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0LFWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:25 -0500
Received: from mail.perches.com ([173.55.12.10]:2326 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0LFWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:20 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/29] include/asm-generic/bug.h: Update WARN macros
Date: Mon,  6 Dec 2010 14:04:51 -0800
Message-Id: <e49fe9e9adf608f370ea036d6eb0d2f8bad3252a.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add KERN_EMERG to BUG printk
Add KERN_WARNING to WARN printk
Change macros to use (fmt, arg...) style
Whitespace/checkpatch neatening

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-generic/bug.h |  101 +++++++++++++++++++++++++++------------------
 1 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c2c9ba0..f006309 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -43,9 +43,11 @@ struct bug_entry {
  * users don't need to reboot ASAP and can mostly shut down cleanly.
  */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do { \
-	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
-	panic("BUG!"); \
+#define BUG()							\
+do {								\
+	printk(KERN_EMERG "BUG: failure at %s:%d/%s()!\n",	\
+	       __FILE__, __LINE__, __func__);			\
+	panic("BUG!");						\
 } while (0)
 #endif
 
@@ -69,40 +71,53 @@ extern void warn_slowpath_fmt_taint(const char *file, const int line,
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
-#define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
-#define __WARN_printf_taint(taint, arg...)				\
-	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
+#define __WARN()						\
+	warn_slowpath_null(__FILE__, __LINE__)
+#define __WARN_printf(fmt, args...)				\
+	warn_slowpath_fmt(__FILE__, __LINE__, fmt, ##args)
+#define __WARN_printf_taint(taint, fmt, args...)		\
+	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, fmt, ##args)
 #else
-#define __WARN()		__WARN_TAINT(TAINT_WARN)
-#define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
-#define __WARN_printf_taint(taint, arg...)				\
-	do { printk(arg); __WARN_TAINT(taint); } while (0)
+#define __WARN()						\
+	__WARN_TAINT(TAINT_WARN)
+#define __WARN_printf(fmt, args...)				\
+do {								\
+	printk(KERN_WARNING fmt, ##args);			\
+	__WARN();						\
+} while (0)
+#define __WARN_printf_taint(taint, fmt, args...)		\
+do {								\
+	printk(KERN_WARNING fmt, ##args);			\
+	__WARN_TAINT(taint);					\
+} while (0)
 #endif
 
 #ifndef WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
-		__WARN();						\
-	unlikely(__ret_warn_on);					\
+#define WARN_ON(condition)					\
+({								\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on))				\
+		__WARN();					\
+	unlikely(__ret_warn_on);				\
 })
 #endif
 
 #ifndef WARN
-#define WARN(condition, format...) ({						\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
-		__WARN_printf(format);					\
-	unlikely(__ret_warn_on);					\
+#define WARN(condition, fmt, args...)				\
+({								\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on))				\
+		__WARN_printf(fmt, ##args);			\
+	unlikely(__ret_warn_on);				\
 })
 #endif
 
-#define WARN_TAINT(condition, taint, format...) ({			\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
-		__WARN_printf_taint(taint, format);			\
-	unlikely(__ret_warn_on);					\
+#define WARN_TAINT(condition, taint, fmt, args...)		\
+({								\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on))				\
+		__WARN_printf_taint(taint, fmt, ##args);	\
+	unlikely(__ret_warn_on);				\
 })
 
 #else /* !CONFIG_BUG */
@@ -115,55 +130,61 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
+#define WARN_ON(condition)					\
+({								\
+	int __ret_warn_on = !!(condition);			\
+	unlikely(__ret_warn_on);				\
 })
 #endif
 
 #ifndef WARN
-#define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
+#define WARN(condition, fmt, args...)				\
+({								\
+	int __ret_warn_on = !!(condition);			\
+	unlikely(__ret_warn_on);				\
 })
 #endif
 
-#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
+#define WARN_TAINT(condition, taint, fmt, args...) 		\
+	WARN_ON(condition)
 
 #endif
 
-#define WARN_ON_ONCE(condition)	({				\
+#define WARN_ON_ONCE(condition)					\
+({								\
 	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN_ON(!__warned)) 			\
+		if (WARN_ON(!__warned))				\
 			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
-#define WARN_ONCE(condition, format...)	({			\
+#define WARN_ONCE(condition, fmt, args...)			\
+({								\
 	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN(!__warned, format)) 			\
+		if (WARN(!__warned, fmt, ##args))		\
 			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
-#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
+#define WARN_TAINT_ONCE(condition, taint, fmt, args...)		\
+({								\
 	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN_TAINT(!__warned, taint, format))	\
+		if (WARN_TAINT(!__warned, taint, fmt, ##args))	\
 			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_ON_RATELIMIT(condition, state)			\
-		WARN_ON((condition) && __ratelimit(state))
+	WARN_ON((condition) && __ratelimit(state))
 
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
-- 
1.7.3.2.245.g03276.dirty

