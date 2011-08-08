Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab1HHS6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:58:04 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43001 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1HHS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:58:00 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC][PATCH 2/2] x86, cpu, amd: Add a per-vendor BSP function
Date: Mon,  8 Aug 2011 20:57:52 +0200
Message-Id: <1312829872-20260-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1312829872-20260-1-git-send-email-bp@amd64.org>
References: <1312829872-20260-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a per-vendor function which runs everything that needs to run once
on the BSP during boot. Concentrate AMD-specific functionality there.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c    |    5 +++--
 arch/x86/kernel/cpu/common.c |   21 ++++++++++++++++-----
 arch/x86/kernel/cpu/cpu.h    |    2 +-
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b6e3e87..45db331 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -410,7 +410,7 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
+void __init amd_run_on_bsp(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 
@@ -436,6 +436,8 @@ static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
 		va_align.mask	  = (upperbit - 1) & PAGE_MASK;
 		va_align.flags    = ALIGN_VA_32 | ALIGN_VA_64;
 	}
+
+	init_amd_e400_c1e_mask();
 }
 
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
@@ -690,7 +692,6 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_size_cache	= amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
-	.c_bsp_init	= bsp_init_amd,
 	.c_init		= init_amd,
 	.c_x86_vendor	= X86_VENDOR_AMD,
 };
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8ed394a..67f1d48 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -681,9 +681,6 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
-
-	if (this_cpu->c_bsp_init)
-		this_cpu->c_bsp_init(c);
 }
 
 void __init early_cpu_init(void)
@@ -902,16 +899,30 @@ static void vgetcpu_set_mode(void)
 }
 #endif
 
+static void __init vendor_run_on_bsp(struct cpuinfo_x86 *c)
+{
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		amd_run_on_bsp(c);
+		break;
+
+	default:
+		break;
+	}
+}
+
 void __init identify_boot_cpu(void)
 {
-	identify_cpu(&boot_cpu_data);
-	init_amd_e400_c1e_mask();
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	identify_cpu(c);
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
 #else
 	vgetcpu_set_mode();
 #endif
+	vendor_run_on_bsp(c);
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 9d388bf..a41d94e 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -18,7 +18,6 @@ struct cpu_dev {
 	struct		cpu_model_info c_models[4];
 
 	void            (*c_early_init)(struct cpuinfo_x86 *);
-	void		(*c_bsp_init)(struct cpuinfo_x86 *);
 	void		(*c_init)(struct cpuinfo_x86 *);
 	void		(*c_identify)(struct cpuinfo_x86 *);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
@@ -35,5 +34,6 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void amd_run_on_bsp(struct cpuinfo_x86 *c);
 
 #endif
-- 
1.7.4.rc2

