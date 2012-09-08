Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2IHAqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:46:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63600 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IHAqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:46:37 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 02/12] perf tools: update types definitions for Android
Date: Sat,  8 Sep 2012 03:43:14 +0300
Message-Id: <1347065004-15306-3-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Some type definitions are missing from Android or are already defined in bionic
and lead to redefinition errors.

Android defines in types.h __le32. Since perf is wrapping <linux/types.h> with a
local version, we need to define this constant in the local version too.
Error in Android:
In file included from bionic/libc/include/unistd.h:36:0,
                 from external/perf/tools/perf/util/util.h:46,
                 from external/perf/tools/perf/util/cache.h:5,
                 from external/perf/tools/perf/util/abspath.c:1:
bionic/libc/kernel/common/linux/capability.h:60:2:
error: unknown type name '__le32'

roundup() definition is missing:
util/symbol.c: In function 'symbols__fixup_end':
util/symbol.c:106: warning: implicit declaration of function 'roundup'
util/symbol.c:106: warning: nested extern declaration of 'roundup'

__force macro defined in perf is also defined in libc which leads to
redefinition errors. In order to avoid these, we guard these definition with

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/include/linux/compiler.h |    4 ++++
 tools/perf/util/include/linux/kernel.h   |    9 +++++++++
 tools/perf/util/include/linux/types.h    |    8 ++++++++
 3 files changed, 21 insertions(+)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 2dc8671..ce2367b 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -12,4 +12,8 @@
 #define __used		__attribute__((__unused__))
 #define __packed	__attribute__((__packed__))
 
+#ifndef __force
+#define __force
+#endif
+
 #endif
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index b6842c1..466b51a 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -46,6 +46,15 @@
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
+#ifndef roundup
+#define roundup(x, y) (                                \
+{                                                      \
+	const typeof(y) __y = y;		       \
+	(((x) + (__y - 1)) / __y) * __y;	       \
+}                                                      \
+)
+#endif
+
 #ifndef BUG_ON
 #define BUG_ON(cond) assert(!(cond))
 #endif
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
index 12de3b8..eb46478 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -3,6 +3,14 @@
 
 #include <asm/types.h>
 
+#ifndef __bitwise
+#define __bitwise
+#endif
+
+#ifndef __le32
+typedef __u32 __bitwise __le32;
+#endif
+
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
-- 
1.7.9.5

