Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1ANIum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:50:42 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:61610 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1ANIug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:50:36 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 03:50:36 EST
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=CcL198nxbdZlCUwtUDyejctmSxaI9F9NIN1iG6Pc2IadVH75liBZs4NmIH/32FizJ3+2H0UK+WZmEICA9H7AtiO6TKEkoBCSFviESb47w3CwH9OoGWRu946E6kU6C3KzY5lCIXDCG3EVB7Xs5fFed2omvbbm2zvxhph3pa2fYck=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Proposal to add dynamic debug feature for print_hex_dump
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.6-default; KDE/4.5.5; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de> <201012061113.01576.roman.fietze@telemotive.de> <1291822758.1240.8.camel@Joe-Laptop>
In-Reply-To: <1291822758.1240.8.camel@Joe-Laptop>
MIME-Version: 1.0
X-TNEFEvaluated: 1
Message-ID: <201101140943.53142.roman.fietze@telemotive.de>
Date: Fri, 14 Jan 2011 09:43:52 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 14.01.2011 09:43:53,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 14.01.2011 09:43:54,
	Serialize complete at 14.01.2011 09:43:54
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On Wednesday, 08.December.2010 16:39:18 Joe Perches wrote:

> The patches I made to printk are now in Andrew Morton's
> tree and should be in 2.6.38

This morning I got them. Due to the changes and optimizations you
added, I decided to collapse the two patches into one. I also modified
my code to use the no_ mechanism as you did it with no_printk, and I
added the devel-version.

This patch goes on top of linux-next/master and your latest patches.

Comments are again welcome.


>From b0881e9520eb7b670581a2046be733db82a9bb12 Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Fri, 14 Jan 2011 09:30:12 +0100
Subject: [PATCH] printk.h dynamic_debug.h: add pr_<level>_hex_dump macros

Add macros e.g. named pr_<level>_hex_dump calling print_hex_dump with
the approriate level, with level beeing emerg, alert, ..., debug. This
is similiar to the functions starting with "pr_".

The parameters for those macros are the same as for print_hex_dump
excluding the level.

Use dynamic printk wrapper to support turning pr_debug_hex_dump on and
off similar to pr_debug using the dynamic debug sysfs control file.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 include/linux/dynamic_debug.h |   20 ++++++++
 include/linux/printk.h        |   97 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 109 insertions(+), 8 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 1c70028..7f3778f 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -64,6 +64,20 @@ extern int ddebug_remove_module(const char *mod_name);
 		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
+#define dynamic_pr_debug_hex_dump(prefix_str, prefix_type,		\
+				  rowsize, groupsize,			\
+				  buf, len, ascii)			\
+	do {								\
+		static struct _ddebug descriptor			\
+			__used						\
+			__attribute__((section("__verbose"), aligned(8))) = { \
+			KBUILD_MODNAME, __func__, __FILE__, prefix_str, __LINE__, \
+			_DPRINTK_FLAGS_DEFAULT };			\
+		if (unlikely(descriptor.enabled))			\
+			print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, \
+				       rowsize, groupsize, buf, len, ascii); \
+	} while (0)
+
 #else
 
 static inline int ddebug_remove_module(const char *mod)
@@ -75,6 +89,12 @@ static inline int ddebug_remove_module(const char *mod)
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dynamic_pr_debug_hex_dump(prefix_str, prefix_type,	\
+				  rowsize, groupsize,		\
+				  buf, len, ascii)		\
+	no_print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
+			  rowsize, groupsize,			\
+			  buf, len, ascii)
 #endif
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..a802f0f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -77,8 +77,8 @@ struct va_format {
 #define HW_ERR		"[Hardware Error]: "
 
 /*
- * Dummy printk for disabled debugging statements to use whilst maintaining
- * gcc's format and side-effect checking.
+ * Dummy printk and print_hex_dump for disabled debugging statements to use
+ * whilst maintaining gcc's format and side-effect checking.
  */
 static inline __attribute__ ((format (printf, 1, 2)))
 int no_printk(const char *fmt, ...)
@@ -86,6 +86,13 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
+static inline
+void no_print_hex_dump(const char *level, const char *prefix_str,
+		       int prefix_type, int rowsize, int groupsize,
+		       const void *buf, size_t len, bool ascii)
+{
+}
+
 extern asmlinkage __attribute__ ((format (printf, 1, 2)))
 void early_printk(const char *fmt, ...);
 
@@ -163,26 +170,104 @@ extern void dump_stack(void) __cold;
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
-/* pr_devel() should produce zero code unless DEBUG is defined */
+#define pr_emerg_hex_dump(prefix_str, prefix_type,		\
+			  rowsize,  groupsize,			\
+			  buf, len, ascii)			\
+	print_hex_dump(KERN_EMERG, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define pr_alert_hex_dump(prefix_str, prefix_type,		\
+			  rowsize,  groupsize,			\
+			  buf, len, ascii)			\
+	print_hex_dump(KERN_ALERT, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define pr_crit_hex_dump(prefix_str, prefix_type,		\
+			 rowsize,  groupsize,			\
+			 buf, len, ascii)			\
+	print_hex_dump(KERN_CRIT, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define pr_err_hex_dump(prefix_str, prefix_type,		\
+			rowsize,  groupsize,			\
+			buf, len, ascii)			\
+	print_hex_dump(KERN_ERR, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define pr_warn_hex_dump(prefix_str, prefix_type,		\
+			 rowsize,  groupsize,			\
+			 buf, len, ascii)			\
+	print_hex_dump(KERN_WARNING, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define pr_notice_hex_dump(prefix_str, prefix_type,		\
+			   rowsize,  groupsize,			\
+			   buf, len, ascii)			\
+	print_hex_dump(KERN_NOTICE, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define pr_info_hex_dump(prefix_str, prefix_type,		\
+			 rowsize,  groupsize,			\
+			 buf, len, ascii)			\
+	print_hex_dump(KERN_INFO, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+
+/* pr_devel() and pr_devel_hex_dump() should produce zero code unless DEBUG is
+ * defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_devel_hex_dump(prefix_str, prefix_type,	\
+			  rowsize,  groupsize,		\
+			  buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG,			\
+		       pr_fmt(prefix_str), prefix_type,	\
+		       rowsize, groupsize,		\
+		       buf, len, ascii)
 #else
 #define pr_devel(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_devel_hex_dump(prefix_str, prefix_type,		\
+			  rowsize,  groupsize,			\
+			  buf, len, ascii)			\
+	no_print_hex_dump(KERN_DEBUG,				\
+			  pr_fmt(prefix_str), prefix_type,	\
+			  rowsize, groupsize,			\
+			  buf, len, ascii)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug_hex_dump(prefix_str, prefix_type,	\
+			  rowsize,  groupsize,		\
+			  buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG,			\
+		       pr_fmt(prefix_str), prefix_type,	\
+		       rowsize, groupsize,		\
+		       buf, len, ascii)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#define pr_debug_hex_dump(prefix_str, prefix_type,			\
+			  rowsize, groupsize,				\
+			  buf, len, ascii)				\
+	dynamic_pr_debug_hex_dump(pr_fmt(prefix_str), prefix_type,	\
+				  rowsize, groupsize,			\
+				  buf, len, ascii)
 #else
 #define pr_debug(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug_hex_dump(prefix_str, prefix_type,		\
+			  rowsize, groupsize,			\
+			  buf, len, ascii)			\
+	no_print_hex_dump(KERN_DEBUG,				\
+			  pr_fmt(prefix_str), prefix_type,	\
+			  rowsize, groupsize,			\
+			  buf, len, ascii)
 #endif
 
 /*
@@ -287,11 +372,7 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 				 const void *buf, size_t len);
 #else
-static inline void print_hex_dump(const char *level, const char *prefix_str,
-				  int prefix_type, int rowsize, int groupsize,
-				  const void *buf, size_t len, bool ascii)
-{
-}
+#define print_hex_dump	no_print_hex_dump
 static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 					const void *buf, size_t len)
 {
-- 
1.7.3.4


Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
