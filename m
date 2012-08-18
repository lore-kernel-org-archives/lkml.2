Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab2HRIb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:31:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:4511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab2HRI36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="182264751"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for early load ucode
Date: Sat, 18 Aug 2012 01:15:22 -0700
Message-Id: <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
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
 arch/x86/kernel/microcode_core_early.c |   74 ++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_core_early.c

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 4ebe157..080ea77 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -63,4 +63,27 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
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
index 0000000..5bcc6f8
--- /dev/null
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -0,0 +1,74 @@
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
+#include <asm/cpio.h>
+
+struct ucode_cpu_info	ucode_cpu_info_early[NR_CPUS];
+EXPORT_SYMBOL_GPL(ucode_cpu_info_early);
+
+static __init enum ucode_state
+find_ucode_intel(unsigned long start, unsigned long end)
+{
+	unsigned int size = end - start + 1;
+	struct cpio_data cd = { 0, 0 };
+	char ucode_name[] = "kernel/x86/microcode/GenuineIntel/microcode.hex";
+
+	cd = find_cpio_data(ucode_name, (void *)start, size);
+	if (cd.data)
+		return UCODE_OK;
+
+	return UCODE_ERROR;
+}
+
+void __init load_ucode_bsp(char *real_mode_data)
+{
+	u64 ramdisk_image, ramdisk_size, ramdisk_end;
+	unsigned long initrd_start, initrd_end;
+	struct boot_params *boot_params;
+
+	boot_params = (struct boot_params *)real_mode_data;
+	ramdisk_image = boot_params->hdr.ramdisk_image;
+	ramdisk_size  = boot_params->hdr.ramdisk_size;
+
+#ifdef CONFIG_X86_64
+	ramdisk_end  = PAGE_ALIGN(ramdisk_image + ramdisk_size);
+	initrd_start = ramdisk_image + PAGE_OFFSET;
+#else
+	ramdisk_end  = ramdisk_image + ramdisk_size;
+	initrd_start = ramdisk_image;
+#endif
+	initrd_end = initrd_start + ramdisk_size;
+
+	/*
+	 * It's early to get CPU vendor info at this point.
+	 * By searching initrd to find right name for vendor's microcode,
+	 * it's relative easier to get CPU vendor info.
+	 */
+	if (find_ucode_intel(initrd_start, initrd_end) == UCODE_OK)
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

