Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0KITzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:55:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38880 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0KITyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dYZEg1f3SktY2MjEIXhtNCCVnC8w5EjXph8XVvCdIqXvPRm4WYTqlUJxatKHxxiQRW
         /l8pFUv1McIvr/bG2AdIzMvYbOTVKlwTjsf2kMqOxZte+JQR3cn72STmUqOKYB3LobL/
         7xiy76sfLIfnMGghSivc5RAf7h57A+Fk9IJnM=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 1/6] x86: Add CE4100 platform support
Date: Tue,  9 Nov 2010 12:08:04 -0800
Message-Id: <94720fd7f5564a12ebf202cf2c4f4c0d619aab35.1289331834.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289331834.git.dirk.brandewie@gmail.com>
References: <cover.1289331834.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Add CE4100 platform support. CE4100 needs early setup like
moorestown.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 Documentation/x86/boot.txt       |    1 +
 arch/x86/Kconfig                 |   11 +++++++++
 arch/x86/include/asm/bootparam.h |    1 +
 arch/x86/include/asm/setup.h     |    6 +++++
 arch/x86/kernel/Makefile         |    2 +
 arch/x86/kernel/ce4100.c         |   46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/head32.c         |    3 ++
 7 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/ce4100.c

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 30b43e1..bdeb81c 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -600,6 +600,7 @@ Protocol:	2.07+
   0x00000001	lguest
   0x00000002	Xen
   0x00000003	Moorestown MID
+  0x00000004	CE4100 TV Platform
 
 Field name:	hardware_subarch_data
 Type:		write (subarch-dependent)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..84236c9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -377,6 +377,17 @@ config X86_ELAN
 
 	  If unsure, choose "PC-compatible" instead.
 
+config X86_INTEL_CE
+	bool "CE4100 TV platform"
+	depends on PCI
+	depends on PCI_GODIRECT
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  Select for the Intel CE media processor (CE4100) SOC.
+	  This option compiles in support for the CE4100 SOC for settop
+	  boxes and media devices.
+
 config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 8e62185..c8bfe63 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -124,6 +124,7 @@ enum {
 	X86_SUBARCH_LGUEST,
 	X86_SUBARCH_XEN,
 	X86_SUBARCH_MRST,
+	X86_SUBARCH_CE4100,
 	X86_NR_SUBARCHS,
 };
 
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index d6763b1..db8aa19 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -53,6 +53,12 @@ extern void x86_mrst_early_setup(void);
 static inline void x86_mrst_early_setup(void) { }
 #endif
 
+#ifdef CONFIG_X86_INTEL_CE
+extern void x86_ce4100_early_setup(void);
+#else
+static inline void x86_ce4100_early_setup(void) { }
+#endif
+
 #ifndef _SETUP
 
 /*
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9e13763..3cb25ab 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -101,6 +101,8 @@ obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
+obj-$(CONFIG_X86_INTEL_CE)	+= ce4100.o
+
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
diff --git a/arch/x86/kernel/ce4100.c b/arch/x86/kernel/ce4100.c
new file mode 100644
index 0000000..b8f1c48
--- /dev/null
+++ b/arch/x86/kernel/ce4100.c
@@ -0,0 +1,46 @@
+/*
+ * Intel CE4100  platform specific setup code
+ *
+ * (C) Copyright 2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+
+#include <asm/setup.h>
+
+
+static int ce4100_i8042_detect(void)
+{
+	return 0;
+}
+
+static void __init sdv_arch_setup(void)
+{
+
+}
+
+
+static void __init sdv_find_smp_config(void)
+{
+}
+
+
+/*
+ * CE4100 specific x86_init function overrides and early setup
+ * calls.
+ */
+void __init x86_ce4100_early_setup(void)
+{
+	x86_init.oem.arch_setup = sdv_arch_setup;
+	x86_platform.i8042_detect = ce4100_i8042_detect;
+	x86_init.resources.probe_roms = x86_init_noop;
+	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
+	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
+}
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 7633101..7f138b3 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -61,6 +61,9 @@ void __init i386_start_kernel(void)
 	case X86_SUBARCH_MRST:
 		x86_mrst_early_setup();
 		break;
+	case X86_SUBARCH_CE4100:
+		x86_ce4100_early_setup();
+		break;
 	default:
 		i386_default_early_setup();
 		break;
-- 
1.7.2.3

