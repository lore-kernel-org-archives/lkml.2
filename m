Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1BAMq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:46:59 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:56120 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab1BAMq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:46:58 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=sJPpBF5EvmgX1L8GKEpjaHZq7ePpYaTfZbbq5FvAryGmb+/13SDlb2y9dqt7gPnP0DjbAGO75QoE0I8glsm5FvwILQYxc3l0Kz9S3ToMmQwTAo+HkBYcW6GP2Zd2G7b0k105VXLPqDv6UlvvnhJkHQbA7Ddq6LfzNFJoc02+kK4=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Joe Perches <realty@perches.com>
Subject: Re: [PATCH 1/2] printk.h dynamic_debug.h: add hex_dump_<level> macros
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-default; KDE/4.5.5; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de> <1295029146.4099.71.camel@Joe-Laptop> <201102011345.30618.roman.fietze@telemotive.de>
In-Reply-To: <201102011345.30618.roman.fietze@telemotive.de>
MIME-Version: 1.0
X-TNEFEvaluated: 1
Message-ID: <201102011346.53756.roman.fietze@telemotive.de>
Date: Tue, 1 Feb 2011 13:46:53 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 01.02.2011 13:46:53,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 01.02.2011 13:46:54,
	Serialize complete at 01.02.2011 13:46:54
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From d2a76e8b586bdfb5c77151f4a0b35d0fb25144af Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Tue, 1 Feb 2011 10:41:17 +0100
Subject: [PATCH 1/2] printk.h dynamic_debug.h: add hex_dump_<level> macros

Add macros e.g. named hex_dump_<level> calling print_hex_dump with the
approriate level, with level beeing emerg, alert, ..., dbg. This is
similiar to the functions starting with "pr_" or "dev_".

The parameters for those macros are the same as for print_hex_dump
excluding the level.

Use dynamic printk wrapper to support turning hex_dump_debug on and
off similar to pr_debug using the dynamic debug sysfs control file.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 include/linux/dynamic_debug.h |   20 ++++++++
 include/linux/printk.h        |   97 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 109 insertions(+), 8 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 1c70028..be185ca 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -64,6 +64,20 @@ extern int ddebug_remove_module(const char *mod_name);
 		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
+#define dynamic_hex_dump_dbg(prefix_str, prefix_type,			\
+			     rowsize, groupsize,			\
+			     buf, len, ascii)				\
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
+#define dynamic_hex_dump_dbg(prefix_str, prefix_type,		\
+			     rowsize, groupsize,		\
+			     buf, len, ascii)			\
+	no_print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
+			  rowsize, groupsize,			\
+			  buf, len, ascii)
 #endif
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..35ef67a 100644
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
+#define hex_dump_emerg(prefix_str, prefix_type,			\
+		       rowsize,  groupsize,			\
+		       buf, len, ascii)				\
+	print_hex_dump(KERN_EMERG, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define hex_dump_alert(prefix_str, prefix_type,			\
+		       rowsize,  groupsize,			\
+		       buf, len, ascii)				\
+	print_hex_dump(KERN_ALERT, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define hex_dump_crit(prefix_str, prefix_type,			\
+		      rowsize,  groupsize,			\
+		      buf, len, ascii)				\
+	print_hex_dump(KERN_CRIT, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define hex_dump_err(prefix_str, prefix_type,			\
+		     rowsize,  groupsize,			\
+		     buf, len, ascii)				\
+	print_hex_dump(KERN_ERR, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define hex_dump_warn(prefix_str, prefix_type,			\
+		      rowsize,  groupsize,			\
+		      buf, len, ascii)				\
+	print_hex_dump(KERN_WARNING, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define hex_dump_notice(prefix_str, prefix_type,		\
+			rowsize,  groupsize,			\
+			buf, len, ascii)			\
+	print_hex_dump(KERN_NOTICE, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+#define hex_dump_info(prefix_str, prefix_type,			\
+		      rowsize,  groupsize,			\
+		      buf, len, ascii)				\
+	print_hex_dump(KERN_INFO, prefix_str, prefix_type,	\
+		       rowsize, groupsize,			\
+		       buf, len, ascii)
+
+/* pr_devel() and pr_devel_hex_dump() should produce zero code unless DEBUG is
+ * defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define hex_dump_devel(prefix_str, prefix_type,		\
+		       rowsize,  groupsize,		\
+		       buf, len, ascii)			\
+	print_hex_dump(KERN_DEBUG,			\
+		       pr_fmt(prefix_str), prefix_type,	\
+		       rowsize, groupsize,		\
+		       buf, len, ascii)
 #else
 #define pr_devel(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define hex_dump_devel(prefix_str, prefix_type,			\
+		       rowsize,  groupsize,			\
+		       buf, len, ascii)				\
+	no_print_hex_dump(KERN_DEBUG,				\
+			  pr_fmt(prefix_str), prefix_type,	\
+			  rowsize, groupsize,			\
+			  buf, len, ascii)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define hex_dump_dbg(prefix_str, prefix_type,		\
+		     rowsize,  groupsize,		\
+		     buf, len, ascii)			\
+	print_hex_dump(KERN_DEBUG,			\
+		       pr_fmt(prefix_str), prefix_type,	\
+		       rowsize, groupsize,		\
+		       buf, len, ascii)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#define hex_dump_dbg(prefix_str, prefix_type,			\
+		     rowsize, groupsize,			\
+		     buf, len, ascii)				\
+	dynamic_hex_dump_dbg(pr_fmt(prefix_str), prefix_type,	\
+			     rowsize, groupsize,		\
+			     buf, len, ascii)
 #else
 #define pr_debug(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define hex_dump_dbg(prefix_str, prefix_type,			\
+		     rowsize, groupsize,			\
+		     buf, len, ascii)				\
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



-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
