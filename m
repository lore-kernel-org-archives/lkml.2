Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1BFKv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:51:29 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:48122 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1BFKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:51:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        cz-bobek-lists-aranym@lists.bobek.cz
Cc: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Petr Stehlik <pstehlik@sophics.cz>
Subject: [PATCH 1/4] m68k/atari: Initial ARAnyM support
Date: Sun,  6 Feb 2011 11:51:06 +0100
Message-Id: <1296989469-7844-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
References: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>

Should be signed off by Petr, really.

[geert] Cleanups and updates
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Petr Stehlik <pstehlik@sophics.cz>

---
Changelog:
  - Export native feature API,
  - Remove bogus line from Kconfig help.
---
 arch/m68k/Kconfig               |    7 +++
 arch/m68k/Makefile              |    1 +
 arch/m68k/emu/Makefile          |    5 ++
 arch/m68k/emu/natfeat.c         |   78 +++++++++++++++++++++++++++++++++++++++
 arch/m68k/include/asm/natfeat.h |   22 +++++++++++
 arch/m68k/kernel/setup.c        |    5 ++
 6 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100644 arch/m68k/emu/Makefile
 create mode 100644 arch/m68k/emu/natfeat.c
 create mode 100644 arch/m68k/include/asm/natfeat.h

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index cbe8b18..f668a58 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -240,6 +240,13 @@ config SUN3
 
 	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
 
+config NATFEAT
+	bool "ARAnyM emulator support"
+	depends on ATARI
+	help
+	  This option enables support for ARAnyM native features, such as
+	  access to a disk image as /dev/hda.
+
 comment "Processor type"
 
 config M68020
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index b06a7e3..b793163 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -76,6 +76,7 @@ core-$(CONFIG_MVME16x)		+= arch/m68k/mvme16x/
 core-$(CONFIG_BVME6000)		+= arch/m68k/bvme6000/
 core-$(CONFIG_SUN3X)		+= arch/m68k/sun3x/	arch/m68k/sun3/
 core-$(CONFIG_SUN3)		+= arch/m68k/sun3/	arch/m68k/sun3/prom/
+core-$(CONFIG_NATFEAT)		+= arch/m68k/emu/
 core-$(CONFIG_M68040)		+= arch/m68k/fpsp040/
 core-$(CONFIG_M68060)		+= arch/m68k/ifpsp060/
 core-$(CONFIG_M68KFPU_EMU)	+= arch/m68k/math-emu/
diff --git a/arch/m68k/emu/Makefile b/arch/m68k/emu/Makefile
new file mode 100644
index 0000000..34cfa34
--- /dev/null
+++ b/arch/m68k/emu/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for Linux arch/m68k/emu source directory
+#
+
+obj-y			+= natfeat.o
diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
new file mode 100644
index 0000000..2291a7d
--- /dev/null
+++ b/arch/m68k/emu/natfeat.c
@@ -0,0 +1,78 @@
+/*
+ * natfeat.c - ARAnyM hardware support via Native Features (natfeats)
+ *
+ * Copyright (c) 2005 Petr Stehlik of ARAnyM dev team
+ *
+ * Reworked for Linux by Roman Zippel <zippel@linux-m68k.org>
+ *
+ * This software may be used and distributed according to the terms of
+ * the GNU General Public License (GPL), incorporated herein by reference.
+ */
+
+#include <linux/types.h>
+#include <linux/console.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <asm/machdep.h>
+#include <asm/natfeat.h>
+
+asm("\n"
+"	.global nf_get_id,nf_call\n"
+"nf_get_id:\n"
+"	.short	0x7300\n"
+"	rts\n"
+"nf_call:\n"
+"	.short	0x7301\n"
+"	rts\n"
+"1:	moveq.l	#0,%d0\n"
+"	rts\n"
+"	.section __ex_table,\"a\"\n"
+"	.long	nf_get_id,1b\n"
+"	.long	nf_call,1b\n"
+"	.previous");
+EXPORT_SYMBOL_GPL(nf_get_id);
+EXPORT_SYMBOL_GPL(nf_call);
+
+void nfprint(const char *fmt, ...)
+{
+	static char buf[256];
+	va_list ap;
+	int n;
+
+	va_start(ap, fmt);
+	n = vsnprintf(buf, 256, fmt, ap);
+	nf_call(nf_get_id("NF_STDERR"), buf);
+	va_end(ap);
+}
+
+static void nf_poweroff(void)
+{
+	long id = nf_get_id("NF_SHUTDOWN");
+
+	if (id)
+		nf_call(id);
+}
+
+void nf_init(void)
+{
+	unsigned long id, version;
+	char buf[256];
+
+	id = nf_get_id("NF_VERSION");
+	if (!id)
+		return;
+	version = nf_call(id);
+
+	id = nf_get_id("NF_NAME");
+	if (!id)
+		return;
+	nf_call(id, buf, 256);
+	buf[255] = 0;
+
+	pr_info("NatFeats found (%s, %lu.%lu)\n", buf, version >> 16,
+		version & 0xffff);
+
+	mach_power_off = nf_poweroff;
+}
diff --git a/arch/m68k/include/asm/natfeat.h b/arch/m68k/include/asm/natfeat.h
new file mode 100644
index 0000000..a3521b8
--- /dev/null
+++ b/arch/m68k/include/asm/natfeat.h
@@ -0,0 +1,22 @@
+/*
+ * ARAnyM hardware support via Native Features (natfeats)
+ *
+ * Copyright (c) 2005 Petr Stehlik of ARAnyM dev team
+ *
+ * This software may be used and distributed according to the terms of
+ * the GNU General Public License (GPL), incorporated herein by reference.
+ */
+
+#ifndef _NATFEAT_H
+#define _NATFEAT_H
+
+long nf_get_id(const char *feature_name);
+long nf_call(long id, ...);
+
+void nf_init(void);
+void nf_shutdown(void);
+
+void nfprint(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+
+# endif /* _NATFEAT_H */
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index b3963ab..334d836 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -42,6 +42,7 @@
 #ifdef CONFIG_SUN3X
 #include <asm/dvma.h>
 #endif
+#include <asm/natfeat.h>
 
 #if !FPSTATESIZE || !NR_IRQS
 #warning No CPU/platform type selected, your kernel will not work!
@@ -324,6 +325,10 @@ void __init setup_arch(char **cmdline_p)
 		panic("No configuration setup");
 	}
 
+#ifdef CONFIG_NATFEAT
+	nf_init();
+#endif
+
 	paging_init();
 
 #ifndef CONFIG_SUN3
-- 
1.7.0.4

