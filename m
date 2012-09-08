Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab2IHAqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:46:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52817 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IHAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:46:16 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 01/12] perf tools: include wrapper for magic.h
Date: Sat,  8 Sep 2012 03:43:13 +0300
Message-Id: <1347065004-15306-2-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

perf is currently including magic.h directly from the kernel. If the glibc
magic.h is also included, this leads to warnings that the constants are
redefined. This happens on some systems (e.g. Android).

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
index afd5075..25d2bab 100644
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
1.7.9.5

