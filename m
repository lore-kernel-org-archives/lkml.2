Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2LEQKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:10:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2LEQJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:48 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 42/44] metag: Add JTAG Debug Adapter (DA) support
Date: Wed, 5 Dec 2012 16:09:00 +0000
Message-ID: <1354723742-6195-43-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic JTAG Debug Adapter (DA) support so that drivers which
communicate with the DA can detect whether one is actually present
(otherwise the target will halt indefinitely).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/Kconfig                     |    9 ++++++
 arch/metag/configs/meta1_defconfig     |    1 +
 arch/metag/configs/meta2_defconfig     |    1 +
 arch/metag/configs/meta2_smp_defconfig |    1 +
 arch/metag/include/asm/da.h            |   43 ++++++++++++++++++++++++++++++++
 arch/metag/kernel/Makefile             |    1 +
 arch/metag/kernel/da.c                 |   23 +++++++++++++++++
 arch/metag/kernel/setup.c              |    3 ++
 8 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/da.h
 create mode 100644 arch/metag/kernel/da.c

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index d198c9b..5807964 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -213,6 +213,15 @@ config METAG_PERFCOUNTER_IRQS
 	  When disabled, Performance Counters information will be collected
 	  based on Timer Interrupt.
 
+config METAG_DA
+	bool "DA support"
+	help
+	  Say Y if you plan to use a DA debug adapter with Linux. The presence
+	  of the DA will be detected automatically at boot, so it is safe to say
+	  Y to this option even when booting without a DA.
+
+	  This enables support for services provided by DA JTAG debug adapters.
+
 menu "Boot options"
 
 config METAG_BUILTIN_DTB
diff --git a/arch/metag/configs/meta1_defconfig b/arch/metag/configs/meta1_defconfig
index 74cc490..76a2d5f 100644
--- a/arch/metag/configs/meta1_defconfig
+++ b/arch/metag/configs/meta1_defconfig
@@ -14,6 +14,7 @@ CONFIG_PARTITION_ADVANCED=y
 # CONFIG_IOSCHED_CFQ is not set
 CONFIG_FLATMEM_MANUAL=y
 CONFIG_META12_FPGA=y
+CONFIG_METAG_DA=y
 CONFIG_HZ_100=y
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
diff --git a/arch/metag/configs/meta2_defconfig b/arch/metag/configs/meta2_defconfig
index ad4ee2b..0b46722 100644
--- a/arch/metag/configs/meta2_defconfig
+++ b/arch/metag/configs/meta2_defconfig
@@ -16,6 +16,7 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_METAG_L2C=y
 CONFIG_FLATMEM_MANUAL=y
 CONFIG_METAG_HALT_ON_PANIC=y
+CONFIG_METAG_DA=y
 CONFIG_HZ_100=y
 CONFIG_DEVTMPFS=y
 # CONFIG_STANDALONE is not set
diff --git a/arch/metag/configs/meta2_smp_defconfig b/arch/metag/configs/meta2_smp_defconfig
index d9349df..b254e6c 100644
--- a/arch/metag/configs/meta2_smp_defconfig
+++ b/arch/metag/configs/meta2_smp_defconfig
@@ -17,6 +17,7 @@ CONFIG_METAG_L2C=y
 CONFIG_FLATMEM_MANUAL=y
 CONFIG_METAG_HALT_ON_PANIC=y
 CONFIG_SMP=y
+CONFIG_METAG_DA=y
 CONFIG_HZ_100=y
 CONFIG_DEVTMPFS=y
 # CONFIG_STANDALONE is not set
diff --git a/arch/metag/include/asm/da.h b/arch/metag/include/asm/da.h
new file mode 100644
index 0000000..81bd521
--- /dev/null
+++ b/arch/metag/include/asm/da.h
@@ -0,0 +1,43 @@
+/*
+ * Meta DA JTAG debugger control.
+ *
+ * Copyright 2012 Imagination Technologies Ltd.
+ */
+
+#ifndef _METAG_DA_H_
+#define _METAG_DA_H_
+
+#ifdef CONFIG_METAG_DA
+
+#include <linux/init.h>
+#include <linux/types.h>
+
+extern bool _metag_da_present;
+
+/**
+ * metag_da_enabled() - Find whether a DA is currently enabled.
+ *
+ * Returns:	true if a DA was detected, false if not.
+ */
+static inline bool metag_da_enabled(void)
+{
+	return _metag_da_present;
+}
+
+/**
+ * metag_da_probe() - Try and detect a connected DA.
+ *
+ * This is used at start up to detect whether a DA is active.
+ *
+ * Returns:	0 on detection, -err otherwise.
+ */
+int __init metag_da_probe(void);
+
+#else /* !CONFIG_METAG_DA */
+
+#define metag_da_enabled() false
+#define metag_da_probe() do {} while (0)
+
+#endif
+
+#endif /* _METAG_DA_H_ */
diff --git a/arch/metag/kernel/Makefile b/arch/metag/kernel/Makefile
index 01536f9..228607e 100644
--- a/arch/metag/kernel/Makefile
+++ b/arch/metag/kernel/Makefile
@@ -29,6 +29,7 @@ obj-y	+= user_gateway.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf/
 
 obj-$(CONFIG_METAG_COREMEM)		+= coremem.o
+obj-$(CONFIG_METAG_DA)			+= da.o
 obj-$(CONFIG_DYNAMIC_FTRACE)		+= ftrace.o
 obj-$(CONFIG_FUNCTION_TRACER)		+= ftrace_stub.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq_internal.o
diff --git a/arch/metag/kernel/da.c b/arch/metag/kernel/da.c
new file mode 100644
index 0000000..52aabb6
--- /dev/null
+++ b/arch/metag/kernel/da.c
@@ -0,0 +1,23 @@
+/*
+ * Meta DA JTAG debugger control.
+ *
+ * Copyright 2012 Imagination Technologies Ltd.
+ */
+
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <asm/da.h>
+#include <asm/metag_mem.h>
+
+bool _metag_da_present;
+
+int __init metag_da_probe(void)
+{
+	_metag_da_present = (metag_in32(T0VECINT_BHALT) == 1);
+	if (_metag_da_present)
+		pr_info("DA present\n");
+	else
+		pr_info("DA not present\n");
+	return 0;
+}
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 5d7d8a1..65e8641 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -37,6 +37,7 @@
 #include <asm/hwthread.h>
 #include <asm/mmzone.h>
 #include <asm/l2cache.h>
+#include <asm/da.h>
 #include <asm/prom.h>
 #include <asm/mach/arch.h>
 #include <asm/core_reg.h>
@@ -182,6 +183,8 @@ void __init setup_arch(char **cmdline_p)
 	PTBISEG p_heap;
 	int heap_id, i;
 
+	metag_da_probe();
+
 	/* try interpreting the argument as a device tree */
 	machine_desc = setup_machine_fdt(original_cmd_line);
 	/* if it doesn't look like a device tree it must be a command line */
-- 
1.7.7.6


