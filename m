Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161245Ab2KNQSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:18:21 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22086 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab2KNQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:18:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6895"; a="6778327"
X-IronPort-AV: E=McAfee;i="5400,1158,6895"; a="370406499"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-wireless@vger.kernel.org>,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Wed, 14 Nov 2012 18:18:16 +0200
Message-ID: <4818336.JicdpLVKSo@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1352900468.9388.20.camel@joe-AO722>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352895463-22851-2-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352900468.9388.20.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2012 05:41:08 AM Joe Perches wrote:
> On Wed, 2012-11-14 at 14:17 +0200, Vladimir Kondratiev wrote:
> > Introduce debug_hex_dump() that can be dynamically controlled, similar to
> > pr_debug.
> 
> (added Jason Baron, Jim Cromie, GregKH and lkml to cc's)
> 
> []
> 
> > diff --git a/include/linux/printk.h b/include/linux/printk.h
> 
> []
> 
> > @@ -220,6 +220,20 @@ extern void dump_stack(void) __cold;
> > 
> >  	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> >  
> >  #endifD
> > 
> > +#if defined(CONFIG_DYNAMIC_DEBUG)
> > +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> > +		       groupsize, buf, len, ascii)		\
> > +		       dynamic_hex_dump(prefix_str, prefix_type,\
> > +					rowsize, groupsize, buf,\
> > +					len, ascii)
> > +#else
> > +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> > +		       groupsize, buf, len, ascii)		\
> > +		       print_hex_dump(KERN_DEBUG, prefix_str,	\
> > +				      prefix_type, rowsize,	\
> > +				      groupsize, buf, len, ascii)
> > +#endif
> 
> These should be in a different location after print_hex_dump
> is declared. Also for #defines, the indentation doesn't
> need to be so deep.

Ups, correct.

> 
> #if defined(CONFIG_DYNAMIC_DEBUG)
> #define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> 		       groupsize, buf, len, ascii)		\
> 	dynamic_hex_dump(prefix_str, prefix_type,		\
> 			 rowsize, groupsize, buf, len, ascii)
> #else
> #define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> 		       groupsize, buf, len, ascii)		\
> 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
> 		       rowsize, groupsize, buf, len, ascii)
> #endif
> 
> A better option might be to convert print_hex_dump_bytes()
> to dynamic_debug as that's already KERN_DEBUG.  That
> could be simpler overall and it makes existing calls
> become dynamic as well.

And, here it goes (can I call it PATCH?):

>From 755b74861b66435bfe4875b64a53c45bbe172495 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Wed, 14 Nov 2012 18:14:15 +0200
Subject: [PATCH] dynamic_debug: dynamic hex dump

Introduce debug_hex_dump() that can be dynamically controlled, similar to
pr_debug.

Also, make print_hex_dump_bytes() dynamically controlled

Implement only 'p' flag (_DPRINTK_FLAGS_PRINT) to keep it simple since hex dump prints
multiple lines and long prefix would impact readability.
To provide line/file etc. information, use pr_debug or similar
before/after debug_hex_dump()

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 Documentation/dynamic-debug-howto.txt |   11 +++++++++--
 include/linux/dynamic_debug.h         |   10 ++++++++++
 include/linux/printk.h                |   17 +++++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 6e16849..cec98f8 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -6,8 +6,12 @@ This document describes how to use the dynamic debug (dyndbg) feature.
 
 Dynamic debug is designed to allow you to dynamically enable/disable
 kernel code to obtain additional kernel information.  Currently, if
-CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can
-be dynamically enabled per-callsite.
+CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() and
+debug_hex_dump()/print_hex_dump_bytes() calls can be dynamically
+enabled per-callsite.
+
+If CONFIG_DYNAMIC_DEBUG is not set, debug_hex_dump() is just shortcut
+for print_hex_dump(KERN_DEBUG).
 
 Dynamic debug has even more useful features:
 
@@ -202,6 +206,9 @@ The flags are:
   t    Include thread ID in messages not generated from interrupt context
   _    No flags are set. (Or'd with others on input)
 
+For debug_hex_dump() and print_hex_dump_bytes(), only 'p' flag have meaning,
+other flags ignored.
+
 For display, the flags are preceded by '='
 (mnemonic: what the flags are currently equal to).
 
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 6dd4787..17565ab 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -95,6 +95,16 @@ do {								\
 				     ##__VA_ARGS__);		\
 } while (0)
 
+#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)		\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, prefix_str);	\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+		print_hex_dump(KERN_DEBUG, prefix_str,		\
+			       prefix_type, rowsize, groupsize,	\
+			       buf, len, ascii);		\
+} while (0)
+
 #else
 
 #include <linux/string.h>
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..82dc610 100644
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
+#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)		\
+	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)
+#else
+#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
+
 #endif
-- 
1.7.10.4


