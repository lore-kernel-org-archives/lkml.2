Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab1FFTUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:20:03 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11420 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1FFTUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:20:01 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v5 1/6] of/lib: Allow scripts/dtc/libfdt to be used from kernel code
Date: Mon,  6 Jun 2011 12:19:41 -0700
Message-Id: <1307387986-27069-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1307387986-27069-1-git-send-email-ddaney@caviumnetworks.com>
References: <1307387986-27069-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 06 Jun 2011 19:20:00.0517 (UTC) FILETIME=[BAC9D350:01CC247E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libfdt is part of the device tree support in scripts/dtc/libfdt.  For
some platforms that use the Device Tree, we want to be able to edit
the flattened device tree form.

We don't want to burden kernel builds that do not require it, so we
gate compilation of libfdt files with CONFIG_LIBFDT.  So if it is
needed, you need to do this in your Kconfig:

	select LIBFDT

And in the Makefile of the code using libfdt something like:

ccflags-y := -I$(src)/../../../scripts/dtc/libfdt

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 include/linux/libfdt.h     |    8 ++++++++
 include/linux/libfdt_env.h |   13 +++++++++++++
 lib/Kconfig                |    6 ++++++
 lib/Makefile               |    5 +++++
 lib/fdt.c                  |    2 ++
 lib/fdt_ro.c               |    2 ++
 lib/fdt_rw.c               |    2 ++
 lib/fdt_strerror.c         |    2 ++
 lib/fdt_sw.c               |    2 ++
 lib/fdt_wip.c              |    2 ++
 10 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/libfdt.h
 create mode 100644 include/linux/libfdt_env.h
 create mode 100644 lib/fdt.c
 create mode 100644 lib/fdt_ro.c
 create mode 100644 lib/fdt_rw.c
 create mode 100644 lib/fdt_strerror.c
 create mode 100644 lib/fdt_sw.c
 create mode 100644 lib/fdt_wip.c

diff --git a/include/linux/libfdt.h b/include/linux/libfdt.h
new file mode 100644
index 0000000..4c0306c
--- /dev/null
+++ b/include/linux/libfdt.h
@@ -0,0 +1,8 @@
+#ifndef _INCLUDE_LIBFDT_H_
+#define _INCLUDE_LIBFDT_H_
+
+#include <linux/libfdt_env.h>
+#include "../../scripts/dtc/libfdt/fdt.h"
+#include "../../scripts/dtc/libfdt/libfdt.h"
+
+#endif /* _INCLUDE_LIBFDT_H_ */
diff --git a/include/linux/libfdt_env.h b/include/linux/libfdt_env.h
new file mode 100644
index 0000000..01508c7
--- /dev/null
+++ b/include/linux/libfdt_env.h
@@ -0,0 +1,13 @@
+#ifndef _LIBFDT_ENV_H
+#define _LIBFDT_ENV_H
+
+#include <linux/string.h>
+
+#include <asm/byteorder.h>
+
+#define fdt32_to_cpu(x) be32_to_cpu(x)
+#define cpu_to_fdt32(x) cpu_to_be32(x)
+#define fdt64_to_cpu(x) be64_to_cpu(x)
+#define cpu_to_fdt64(x) cpu_to_be64(x)
+
+#endif /* _LIBFDT_ENV_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 830181c..893a7db 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -262,4 +262,10 @@ config AVERAGE
 
 	  If unsure, say N.
 
+#
+# libfdt files, only selected if needed.
+#
+config LIBFDT
+	bool
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 6b597fd..06c2336 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -112,6 +112,11 @@ obj-$(CONFIG_AVERAGE) += average.o
 
 obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
+libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o
+$(foreach file, $(libfdt_files), \
+	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
+lib-$(CONFIG_LIBFDT) += $(libfdt_files)
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/fdt.c b/lib/fdt.c
new file mode 100644
index 0000000..97f2006
--- /dev/null
+++ b/lib/fdt.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt.c"
diff --git a/lib/fdt_ro.c b/lib/fdt_ro.c
new file mode 100644
index 0000000..f73c04e
--- /dev/null
+++ b/lib/fdt_ro.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_ro.c"
diff --git a/lib/fdt_rw.c b/lib/fdt_rw.c
new file mode 100644
index 0000000..0c1f0f4
--- /dev/null
+++ b/lib/fdt_rw.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_rw.c"
diff --git a/lib/fdt_strerror.c b/lib/fdt_strerror.c
new file mode 100644
index 0000000..8713e3f
--- /dev/null
+++ b/lib/fdt_strerror.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_strerror.c"
diff --git a/lib/fdt_sw.c b/lib/fdt_sw.c
new file mode 100644
index 0000000..9ac7e50
--- /dev/null
+++ b/lib/fdt_sw.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_sw.c"
diff --git a/lib/fdt_wip.c b/lib/fdt_wip.c
new file mode 100644
index 0000000..45b3fc3
--- /dev/null
+++ b/lib/fdt_wip.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_wip.c"
-- 
1.7.2.3

