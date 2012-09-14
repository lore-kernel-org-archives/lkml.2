Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2INFzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:55:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2INFzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:55:54 -0400
Date: Thu, 13 Sep 2012 22:55:31 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@gmail.com>
Message-ID: <tip-86d5a70c1eeb3d35bcadc94753fd9651df8835a8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, irina.tirdea@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1347315303-29906-3-git-send-email-irina.tirdea@intel.com>
References: <1347315303-29906-3-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Update types definitions for Android
Git-Commit-ID: 86d5a70c1eeb3d35bcadc94753fd9651df8835a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:55:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86d5a70c1eeb3d35bcadc94753fd9651df8835a8
Gitweb:     http://git.kernel.org/tip/86d5a70c1eeb3d35bcadc94753fd9651df8835a8
Author:     Irina Tirdea <irina.tirdea@gmail.com>
AuthorDate: Tue, 11 Sep 2012 01:14:59 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 11:46:09 -0300

perf tools: Update types definitions for Android

Some type definitions are missing from Android or are already defined in
bionic and lead to redefinition errors.

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
redefinition errors. In order to avoid these, we guard these definition
with

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347315303-29906-3-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/compiler.h |    4 ++++
 tools/perf/util/include/linux/kernel.h   |    9 +++++++++
 tools/perf/util/include/linux/types.h    |    8 ++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

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
index 4af9a10..a978f26 100644
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
 #ifdef NDEBUG
 #define BUG_ON(cond) do { if (cond) {} } while (0)
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
 
