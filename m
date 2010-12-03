Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0LCO20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:28:26 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:59573 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab0LCO2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:28:25 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=TkNkSe5fpkOhGoNXdP7jhqQFgR5C2awCqLJ0A6Mwu/OhdbAIKgNnNCzbwKopWnN5RDCz8yfp7OojV23xDPZa9rv2MDB5Frr7hfQBRdewvTXogDviZ9VPo7fdW/6BF1QTbvTsb6tb7TqFKBg1WhtMT10AQseRrP23PmnAvVxj87w=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] Proposal to add dynamic debug feature for print_hex_dump [2/2]
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.4-default; KDE/4.5.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de>
In-Reply-To: <201012031517.35062.roman.fietze@telemotive.de>
MIME-Version: 1.0
Message-ID: <201012031521.41332.roman.fietze@telemotive.de>
Date: Fri, 3 Dec 2010 15:21:40 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 03.12.2010 15:21:41,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 03.12.2010 15:21:42,
	Serialize complete at 03.12.2010 15:21:42
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the first, wrong subject line. The index field shoudl have
been reading [0/2].


>From 068faf208310a0a72194667143a5a9ca9beabdde Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Fri, 3 Dec 2010 15:00:43 +0100
Subject: [PATCH 2/2] dynamic printk: add support for pr_debug_hex_dump

Use dynamic printk wrapper to support turning pr_debug_hex_dump on and
off similar to pr_debug using the dynamic debug sysfs control file.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 include/linux/dynamic_debug.h |   22 ++++++++++++++++++++++
 include/linux/printk.h        |   16 ++++++++++++----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a90b389..0610e74 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -74,6 +74,24 @@ do_printk:								\
 out:	;								\
 	} while (0)
 
+#define dynamic_pr_hex_dump(prfx_str, prfx_type, rowsz, grpsz,		\
+			    buf, len, ascii)				\
+	do {								\
+		__label__ do_hex_dump;					\
+		__label__ out;						\
+		static struct _ddebug descriptor			\
+			__used						\
+			__attribute__((section("__verbose"), aligned(8))) = { \
+			KBUILD_MODNAME, __func__, __FILE__, prfx_str, __LINE__, \
+			_DPRINTK_FLAGS_DEFAULT };			\
+		JUMP_LABEL(&descriptor.enabled, do_hex_dump);		\
+		goto out;						\
+	do_hex_dump:							\
+		print_hex_dump(KERN_DEBUG, prfx_str, prfx_type,		\
+			       rowsz, grpsz, buf, len, ascii);		\
+	out:	;							\
+	} while (0)
+
 #else
 
 static inline int ddebug_remove_module(const char *mod)
@@ -85,6 +103,10 @@ static inline int ddebug_remove_module(const char *mod)
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dynamic_pr_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			    buf, len, ascii)				\
+	do { if (0) print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz, \
+				   buf, len, ascii); } while (0)
 #endif
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 77903f1..5bf4483 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -212,10 +212,6 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			 buf, len, ascii)				\
 	print_hex_dump(KERN_CONT, prfx_str, prfx_type, rowsz, grpsz,	\
 		       buf, len, ascii)
-#define pr_debug_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
-			  buf, len, ascii)				\
-	print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz,	\
-		       buf, len, ascii)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
@@ -230,13 +226,25 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #if defined(DEBUG)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			  buf, len, ascii)				\
+	print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#define pr_debug_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			  buf, len, ascii)				\
+	dynamic_pr_hex_dump(prfx_str, prfx_type, rowsz, grpsz,	\
+		       buf, len, ascii)
 #else
 #define pr_debug(fmt, ...) \
 	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#define pr_debug_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
+			  buf, len, ascii)				\
+	do { if (0) print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz, \
+				   buf, len, ascii); } while (0)
 #endif
 
 /*
-- 
1.7.3.2




-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
