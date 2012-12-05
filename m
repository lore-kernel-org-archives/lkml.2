Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2LEVsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:48:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2LEVsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:48:32 -0500
Date: Wed, 5 Dec 2012 16:48:27 -0500
From: Jason Baron <jbaron@redhat.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, jim.cromie@gmail.com, qca_vkondrat@qca.qualcomm.com,
        linux-kernel@vger.kernel.org
Message-Id: <ba84c7a3075f3550434f33197f79013a2f47461b.1354741891.git.jbaron@redhat.com>
In-Reply-To: <cover.1354741891.git.jbaron@redhat.com>
References: <cover.1354741891.git.jbaron@redhat.com>
Subject: [PATCH 2/3] dynamic_debug: dynamic hex dump
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Introduce print_hex_dump_debug() that can be dynamically controlled, similar to
pr_debug.

Also, make print_hex_dump_bytes() dynamically controlled

Implement only 'p' flag (_DPRINTK_FLAGS_PRINT) to keep it simple since hex dump prints
multiple lines and long prefix would impact readability.
To provide line/file etc. information, use pr_debug or similar
before/after print_hex_dump_debug()

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 Documentation/dynamic-debug-howto.txt |   15 +++++++++++++--
 include/linux/dynamic_debug.h         |   11 +++++++++++
 include/linux/printk.h                |   17 +++++++++++++++++
 lib/hexdump.c                         |    4 +++-
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 6e16849..72322c6 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -6,8 +6,16 @@ This document describes how to use the dynamic debug (dyndbg) feature.
 
 Dynamic debug is designed to allow you to dynamically enable/disable
 kernel code to obtain additional kernel information.  Currently, if
-CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can
-be dynamically enabled per-callsite.
+CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() and
+print_hex_dump_debug()/print_hex_dump_bytes() calls can be dynamically
+enabled per-callsite.
+
+If CONFIG_DYNAMIC_DEBUG is not set, print_hex_dump_debug() is just
+shortcut for print_hex_dump(KERN_DEBUG).
+
+For print_hex_dump_debug()/print_hex_dump_bytes(), format string is
+its 'prefix_str' argument, if it is constant string; or "hexdump"
+in case 'prefix_str' is build dynamically.
 
 Dynamic debug has even more useful features:
 
@@ -202,6 +210,9 @@ The flags are:
   t    Include thread ID in messages not generated from interrupt context
   _    No flags are set. (Or'd with others on input)
 
+For print_hex_dump_debug() and print_hex_dump_bytes(), only 'p' flag
+have meaning, other flags ignored.
+
 For display, the flags are preceded by '='
 (mnemonic: what the flags are currently equal to).
 
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 6dd4787..2fe93b2 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -95,6 +95,17 @@ do {								\
 				     ##__VA_ARGS__);		\
 } while (0)
 
+#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)		\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,		\
+		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+		print_hex_dump(KERN_DEBUG, prefix_str,		\
+			       prefix_type, rowsize, groupsize,	\
+			       buf, len, ascii);		\
+} while (0)
+
 #else
 
 #include <linux/string.h>
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..02c95cf 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -321,8 +321,13 @@ extern void hex_dump_to_buffer(const void *buf, size_t len,
 extern void print_hex_dump(const char *level, const char *prefix_str,
 			   int prefix_type, int rowsize, int groupsize,
 			   const void *buf, size_t len, bool ascii);
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
+	dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
+#else
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 				 const void *buf, size_t len);
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
 #else
 static inline void print_hex_dump(const char *level, const char *prefix_str,
 				  int prefix_type, int rowsize, int groupsize,
@@ -336,4 +341,16 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
+			     groupsize, buf, len, ascii)	\
+	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)
+#else
+#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,		\
+			     groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
+
 #endif
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 6540d65..3f0494c 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -227,6 +227,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 }
 EXPORT_SYMBOL(print_hex_dump);
 
+#if !defined(CONFIG_DYNAMIC_DEBUG)
 /**
  * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
  * @prefix_str: string to prefix each line with;
@@ -246,4 +247,5 @@ void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 		       buf, len, true);
 }
 EXPORT_SYMBOL(print_hex_dump_bytes);
-#endif
+#endif /* !defined(CONFIG_DYNAMIC_DEBUG) */
+#endif /* defined(CONFIG_PRINTK) */
-- 
1.7.1

