Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2H1V77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 17:59:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2H1V7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 17:59:53 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 00:59:33 +0300
Message-ID: <CANg8OWJTKWnk=qx+rud3ypdbNFr=-B2Tp_j5_Ud-Z6S4vd_rwg@mail.gmail.com>
Subject: [PATCH 03/13] perf tools: drop asm/byteorder.h wrapper
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

Wrapping asm/byteorder.h will also replace the glibc header,
not only the kernel one. asm/byteorder.h further includes
architecture dependent headers that define endianess.

Some systems (e.g. Android) need constant definitions that
depend on endianess (e.g. __constant_htonl).

In file included from bionic/libc/include/netinet/tcp.h:32:0,
                 from kernel/intel/tools/perf/util/util.h:74,
                 from kernel/intel/tools/perf/util/cache.h:5,
                 from kernel/intel/tools/perf/util/abspath.c:1:
bionic/libc/kernel/common/linux/tcp.h:61:2:
error: enumerator value for 'TCP_FLAG_CWR' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:62:2:
error: enumerator value for 'TCP_FLAG_ECE' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:63:2:
error: enumerator value for 'TCP_FLAG_URG' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:64:2:
error: enumerator value for 'TCP_FLAG_ACK' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:65:2:
error: enumerator value for 'TCP_FLAG_PSH' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:66:2:
error: enumerator value for 'TCP_FLAG_RST' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:67:2:
error: enumerator value for 'TCP_FLAG_SYN' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:68:2:
error: enumerator value for 'TCP_FLAG_FIN' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:69:2:
error: enumerator value for 'TCP_RESERVED_BITS' is not an integer constant
bionic/libc/kernel/common/linux/tcp.h:71:1:
error: enumerator value for 'TCP_DATA_OFFSET' is not an integer constant

Drop this wrapper and use swab.h. glibc byteorder.h header
already includes asm/types.h and swab.h. Using swab.h
wrapper to do the work from byteorder.h should be enough.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Makefile                     |    1 -
 tools/perf/util/include/asm/byteorder.h |    2 --
 tools/perf/util/include/asm/swab.h      |    2 +-
 tools/perf/util/parse-events.l          |    1 +
 tools/perf/util/util.h                  |    1 +
 5 files changed, 3 insertions(+), 4 deletions(-)
 delete mode 100644 tools/perf/util/include/asm/byteorder.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 58304d9..81ea120 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -273,7 +273,6 @@ LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bug.h
-LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
diff --git a/tools/perf/util/include/asm/byteorder.h
b/tools/perf/util/include/asm/byteorder.h
deleted file mode 100644
index b722abe..0000000
--- a/tools/perf/util/include/asm/byteorder.h
+++ /dev/null
@@ -1,2 +0,0 @@
-#include <asm/types.h>
-#include "../../../../include/linux/swab.h"
diff --git a/tools/perf/util/include/asm/swab.h
b/tools/perf/util/include/asm/swab.h
index ed53894..e1d3ae0 100644
--- a/tools/perf/util/include/asm/swab.h
+++ b/tools/perf/util/include/asm/swab.h
@@ -1 +1 @@
-/* stub */
+#include "../../../../include/linux/swab.h"
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 2c0d006..73d123b 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -7,6 +7,7 @@
 %{
 #include <errno.h>
 #include "../perf.h"
+#include <linux/compiler.h>
 #include "parse-events-bison.h"
 #include "parse-events.h"

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index d306ec1f..f6716be 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -78,6 +78,7 @@
 #include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
+#include <linux/compiler.h>

 extern const char *graph_line;
 extern const char *graph_dotted_line;
--
1.7.9.5
