Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2LLJNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:13:04 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55394 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2LLJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:13:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6923"; a="11592171"
X-IronPort-AV: E=McAfee;i="5400,1158,6923"; a="3776879"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-wireless@vger.kernel.org>, Jim Cromie <jim.cromie@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Wed, 12 Dec 2012 11:12:55 +0200
Message-ID: <10591713.1pVYGV5bcJ@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.9.3 (Linux/3.5.0-19-generic; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121211225555.GC15974@pogo>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1355257444.24219.7.camel@joe-AO722> <20121211225555.GC15974@pogo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 11, 2012 02:55:55 PM Luis R. Rodriguez wrote:
> Vladimir, to be clear, you can continue with waiting for the patches
> to get into 3.9 but that will take a while but given that you want
> your driver in 3.8 you can fold those routines into your driver as
> you had before but with a rename by adding a prefix and sumbit that
> driver and specify it is for 3.8.
> 

I have internally patch that will compensate not merged yet functionality,
without any rename, see below. I can massage commit message and include it
with my driver as separate patch to be easier to undo later.

Comments?

>From c4e7254d0cba51c8b43d36a317a1b847fffb18d8 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Wed, 21 Nov 2012 13:57:21 +0200
Subject: [PATCH] [DEBUG] Allow to compile with mainstream kernel

Unless patch for dynamic hexdump merged into mainstream kernel,
need to provide replacement for the dynamic hexdump functionality

Do not hurt compilation with kernel that have patch above merged.

REMOVE when dynamic hexdump merged into mainstream kernel!!

Change-Id: I6abb8f91ed529ffc84bd9cc21444a59ee15fe456
---
 dbg_hexdump.h |   32 ++++++++++++++++++++++++++++++++
 wil6210.h     |    2 ++
 2 files changed, 34 insertions(+)
 create mode 100644 dbg_hexdump.h

diff --git a/dbg_hexdump.h b/dbg_hexdump.h
new file mode 100644
index 0000000..7144eed
--- /dev/null
+++ b/dbg_hexdump.h
@@ -0,0 +1,32 @@
+#ifndef DBG_HEXDUMP_H_
+#define DBG_HEXDUMP_H_
+
+#if !defined(print_hex_dump_debug)
+#if defined(CONFIG_DYNAMIC_DEBUG)
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
+#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
+			     groupsize, buf, len, ascii)	\
+	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)
+
+#define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
+	dynamic_hex_dump(prefix_str, prefix_type, 16, 1, buf, len, true)
+#else /* defined(CONFIG_DYNAMIC_DEBUG) */
+#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,		\
+			     groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
+#endif /* !defined(print_hex_dump_debug) */
+
+#endif /* DBG_HEXDUMP_H_ */
diff --git a/wil6210.h b/wil6210.h
index b37c3d2..4797da0 100644
--- a/wil6210.h
+++ b/wil6210.h
@@ -21,6 +21,8 @@
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
 
+#include "dbg_hexdump.h"
+
 #define WIL_NAME "wil6210"
 
 /**
-- 
1.7.10.4


