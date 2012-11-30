Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2K3Ita (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:49:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:40531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab2K3It2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459071"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 03/10] x86/microcode_core_early.c: Define interfaces for early loading ucode
Date: Thu, 29 Nov 2012 17:47:41 -0800
Message-Id: <1354240068-9821-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Define interfaces load_ucode_bsp() and load_ucode_ap() to load ucode on BSP and
AP in early boot time. These are generic interfaces. Internally they call
vendor specific implementations.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/microcode.h       |   23 ++++++++++
 arch/x86/kernel/microcode_core_early.c |   70 ++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_core_early.c

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 43d921b..2e2ff3a 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -57,4 +57,27 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 static inline void __exit exit_amd_microcode(void) {}
 #endif
 
+struct mc_saved_data {
+	unsigned int mc_saved_count;
+	struct microcode_intel **mc_saved;
+	struct ucode_cpu_info *ucode_cpu_info;
+};
+#ifdef CONFIG_MICROCODE_EARLY
+#define MAX_UCODE_COUNT 128
+extern struct ucode_cpu_info ucode_cpu_info_early[NR_CPUS];
+extern struct microcode_intel __initdata *mc_saved_in_initrd[MAX_UCODE_COUNT];
+extern struct mc_saved_data mc_saved_data;
+extern void __init load_ucode_bsp(char *real_mode_data);
+extern __init void load_ucode_ap(void);
+extern void __init
+save_microcode_in_initrd(struct mc_saved_data *mc_saved_data,
+			 struct microcode_intel **mc_saved_in_initrd);
+#else
+static inline void __init load_ucode_bsp(char *real_mode_data) {}
+static inline __init void load_ucode_ap(void) {}
+static inline void __init
+save_microcode_in_initrd(struct mc_saved_data *mc_saved_data,
+			 struct microcode_intel **mc_saved_in_initrd) {}
+#endif
+
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
new file mode 100644
index 0000000..1c6cc8f
--- /dev/null
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -0,0 +1,70 @@
+/*
+ *	X86 CPU microcode early update for Linux
+ *
+ *	Copyright (C) 2012 Fenghua Yu <fenghua.yu@intel.com>
+ *			   H Peter Anvin" <hpa@zytor.com>
+ *
+ *	This driver allows to early upgrade microcode on Intel processors
+ *	belonging to IA-32 family - PentiumPro, Pentium II,
+ *	Pentium III, Xeon, Pentium 4, etc.
+ *
+ *	Reference: Section 9.11 of Volume 3, IA-32 Intel Architecture
+ *	Software Developer's Manual.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/microcode_intel.h>
+#include <asm/processor.h>
+
+struct ucode_cpu_info	ucode_cpu_info_early[NR_CPUS];
+EXPORT_SYMBOL_GPL(ucode_cpu_info_early);
+
+static inline int __init x86_vendor(void)
+{
+	unsigned int eax = 0x00000000;
+	char x86_vendor_id[16];
+	int i;
+	struct {
+		char x86_vendor_id[16];
+		__u8 x86_vendor;
+	} cpu_vendor_table[] = {
+		{ "GenuineIntel", X86_VENDOR_INTEL },
+		{ "AuthenticAMD", X86_VENDOR_AMD },
+	};
+
+	memset(x86_vendor_id, 0, ARRAY_SIZE(x86_vendor_id));
+	/* Get vendor name */
+	native_cpuid(&eax,
+		(unsigned int *)&x86_vendor_id[0],
+		(unsigned int *)&x86_vendor_id[8],
+		(unsigned int *)&x86_vendor_id[4]);
+
+	for (i = 0; i < ARRAY_SIZE(cpu_vendor_table); i++) {
+		if (!strcmp(x86_vendor_id, cpu_vendor_table[i].x86_vendor_id))
+			return cpu_vendor_table[i].x86_vendor;
+	}
+
+	return X86_VENDOR_UNKNOWN;
+}
+
+
+void __init load_ucode_bsp(char *real_mode_data)
+{
+	/*
+	 * boot_cpu_data is not setup yet in this early phase.
+	 * So we get vendor information directly through cpuid.
+	 */
+	if (x86_vendor() == X86_VENDOR_INTEL)
+		load_ucode_intel_bsp(real_mode_data);
+}
+
+void __cpuinit load_ucode_ap(void)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		load_ucode_intel_ap();
+}
-- 
1.7.2

