Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2KRRDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 12:03:08 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:34178 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752408Ab2KRRDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 12:03:07 -0500
From: Vladimir Kondratiev <vkondrat@qti.qualcomm.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Sun, 18 Nov 2012 19:01:18 +0200
Message-ID: <2748656.Zh8WY0OSmS@lx-vladimir>
Organization: Qualcomm
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1380367.3QOKJVXxFC@lx-vladimir>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1353249531.15959.10.camel@joe-AO722> <1380367.3QOKJVXxFC@lx-vladimir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 18, 2012 05:43:07 PM Vladimir Kondratiev wrote:
> On Sunday, November 18, 2012 06:38:51 AM Joe Perches wrote:
> > Another option could be testing __builtin_constant_p(prefix)
> 
> You mean something like below? Yes, it will work as well.
> 
> Pro: don't need to change existing code
> (drop [PATCH 2/2] dynamic_debug: use constant format in
> print_hex_dump_bytes())
> 
> Cons: format in dynamic metadata will be useless
> 
> What looks better?
> 
> ---
> #define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
> 			 groupsize, buf, len, ascii)		\
> do {								\
> 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, 		\
> 		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
> 	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
> 		print_hex_dump(KERN_DEBUG, prefix_str,		\
> 			       prefix_type, rowsize, groupsize,	\
> 			       buf, len, ascii);		\
> } while (0)

In case this option wins, patch follows. There is no need for
2-nd one to fix existing drivers.


>From 42bea6be2b3899eac1ed3f48eb955a4d83960cf5 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Sun, 18 Nov 2012 18:56:29 +0200
Subject: [PATCH] dynamic_debug: dynamic hex dump

Introduce print_hex_dump_debug() that can be dynamically controlled, similar to
pr_debug.

Also, make print_hex_dump_bytes() dynamically controlled

Implement only 'p' flag (_DPRINTK_FLAGS_PRINT) to keep it simple since hex dump prints
multiple lines and long prefix would impact readability.
To provide line/file etc. information, use pr_debug or similar
before/after print_hex_dump_debug()

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
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
1.7.10.4


