Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab2IKXzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:55:01 -0400
Received: from [205.233.59.134] ([205.233.59.134]:37421 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2IKXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:54:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/18] perf tools: include wrapper for magic.h
Date: Tue, 11 Sep 2012 20:52:56 -0300
Message-Id: <1347407590-30960-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@gmail.com>

perf is currently including magic.h directly from the kernel. If the
glibc magic.h is also included, this leads to warnings that the
constants are redefined. This happens on some systems (e.g. Android).

Redefinition errors on Android:
In file included from util/util.h:79:0,
                 from util/cache.h:5,
                 from util/abspath.c:1:
util/../../../include/linux/magic.h:5:0:
error: "AFFS_SUPER_MAGIC" redefined [-Werror]
bionic/libc/include/sys/vfs.h:53:0:
note: this is the location of the previous definition
util/../../../include/linux/magic.h:19:0:
error: "EFS_SUPER_MAGIC" redefined [-Werror]
bionic/libc/include/sys/vfs.h:61:0:
note: this is the location of the previous definition
util/../../../include/linux/magic.h:26:0:
error: "HPFS_SUPER_MAGIC" redefined [-Werror]
bionic/libc/include/sys/vfs.h:67:0:
note: this is the location of the previous definition

Only two constants from magic.h are used by perf (DEBUGFS_MAGIC and
SYSFS_MAGIC). This fix provides a wrapper for magic.h that includes only
these constants instead of including the kernel header file directly.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347315303-29906-2-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                   |    1 +
 tools/perf/util/include/linux/magic.h |   12 ++++++++++++
 tools/perf/util/util.h                |    2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/include/linux/magic.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e4b2e8f..1d2723c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -264,6 +264,7 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
+LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
diff --git a/tools/perf/util/include/linux/magic.h b/tools/perf/util/include/linux/magic.h
new file mode 100644
index 0000000..58b64ed
--- /dev/null
+++ b/tools/perf/util/include/linux/magic.h
@@ -0,0 +1,12 @@
+#ifndef _PERF_LINUX_MAGIC_H_
+#define _PERF_LINUX_MAGIC_H_
+
+#ifndef DEBUGFS_MAGIC
+#define DEBUGFS_MAGIC          0x64626720
+#endif
+
+#ifndef SYSFS_MAGIC
+#define SYSFS_MAGIC            0x62656572
+#endif
+
+#endif
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 67a3713..70fa70b 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -70,7 +70,7 @@
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
-#include "../../../include/linux/magic.h"
+#include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
 
-- 
1.7.9.2.358.g22243

