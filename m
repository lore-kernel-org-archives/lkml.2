Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2H1WZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:25:29 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:52062 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2H1WZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:25:28 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2012 18:25:03 EDT
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:25:07 +0300
Message-ID: <CANg8OWJGdq_TEHPvphhrATerxXjqKca4hRAQ70ipkP77Q0QYgQ@mail.gmail.com>
Subject: [PATCH 01/13] perf tools: include wrapper for magic.h
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

perf is currently including magic.h directly from the kernel.
If the glibc magic.h is also included, this leads to warnings
that the constants are redefined. This happens on some systems
(e.g. Android).

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
---
 tools/perf/Makefile                   |    1 +
 tools/perf/util/include/linux/magic.h |   12 ++++++++++++
 tools/perf/util/util.h                |    2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/include/linux/magic.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6bd888d..58304d9 100644
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
diff --git a/tools/perf/util/include/linux/magic.h
b/tools/perf/util/include/linux/magic.h
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
index 00a93a9..d306ec1f 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -75,7 +75,7 @@
 #include <arpa/inet.h>
 #include <netdb.h>
 #include <inttypes.h>
-#include "../../../include/linux/magic.h"
+#include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>

-- 
1.7.9.5
