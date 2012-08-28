Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2H1XI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 19:08:28 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:53421 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2H1XI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 19:08:27 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 00:59:21 +0300
Message-ID: <CANg8OW+fiW9gho475uW35TcWn9a3nJLrZp+LZv_kZFemeFBH7A@mail.gmail.com>
Subject: [PATCH 02/13] perf tools: update types definitions for Android
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems (e.g. Android) define in their libc types.h
__le16, __be16, etc. Since perf is wrapping
<linux/types.h> with a local version, we need to define this
constants in the local version too.

Errors in Android:
In file included from bionic/libc/include/netinet/in.h:34:0,
                 from util/util.h:73,
                 from util/cache.h:5,
                 from util/abspath.c:1:
bionic/libc/kernel/common/linux/in6.h:20:2: error: unknown type name '__be16'
bionic/libc/kernel/common/linux/in6.h:21:2: error: unknown type name '__be32'
bionic/libc/kernel/common/linux/in6.h:30:2: error: unknown type name '__be16'
bionic/libc/kernel/common/linux/in6.h:31:2: error: unknown type name '__be32'
bionic/libc/kernel/common/linux/in6.h:47:2: error: unknown type name '__be32'

roundup() definition is also missing:
util/symbol.c: In function 'symbols__fixup_end':
util/symbol.c:106: warning: implicit declaration of function 'roundup'
util/symbol.c:106: warning: nested extern declaration of 'roundup'

Some macro defined in perf are also defined in libc which
leads to redefinition errors. In order to avoid these, we
guard these definitions with #ifndef.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/include/linux/compiler.h |    4 ++++
 tools/perf/util/include/linux/kernel.h   |   11 +++++++++++
 tools/perf/util/include/linux/types.h    |   15 +++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/tools/perf/util/include/linux/compiler.h
b/tools/perf/util/include/linux/compiler.h
index 2dc8671..ce2367b 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -12,4 +12,8 @@
 #define __used        __attribute__((__unused__))
 #define __packed    __attribute__((__packed__))

+#ifndef __force
+#define __force
+#endif
+
 #endif
diff --git a/tools/perf/util/include/linux/kernel.h
b/tools/perf/util/include/linux/kernel.h
index b6842c1..391c425 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -46,6 +46,17 @@
     _min1 < _min2 ? _min1 : _min2; })
 #endif

+#ifndef roundup
+#define roundup(x, y) (                                \
+{                                                      \
+       const typeof(y) __y = y;                        \
+       (((x) + (__y - 1)) / __y) * __y;                \
+}                                                      \
+)
+#endif
+
+
+
 #ifndef BUG_ON
 #define BUG_ON(cond) assert(!(cond))
 #endif
diff --git a/tools/perf/util/include/linux/types.h
b/tools/perf/util/include/linux/types.h
index 12de3b8..60a97bb 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -3,6 +3,21 @@

 #include <asm/types.h>

+#ifndef __bitwise__
+#define __bitwise__
+#endif
+
+#ifndef __bitwise
+#define __bitwise
+#endif
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
 #define DECLARE_BITMAP(name,bits) \
     unsigned long name[BITS_TO_LONGS(bits)]

--
1.7.9.5
