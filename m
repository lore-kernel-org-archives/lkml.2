Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2ITNtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:49:02 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35528 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2ITNtA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 20 Sep 2012 09:49:00 -0400
Message-Id: <505B3AFF020000780009CB27@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 20 Sep 2012 14:49:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: don't track CPU model data that is used by
 32-bit code only
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cpu_dev's c_models is only ever set inside CONFIG_X86_32
conditionals (or code that's being built for 32-bit only), so there's
no use of reserving the (empty) space for the model names in a 64-bit
kernel.

Similarly, c_size_cache is only used in the #else of a CONFIG_X86_64
conditional, so reserving space for (and in one case even initializing)
that field is pointless for 64-bit kernels too.

While moving both fields to the end of the structure, I also noticed
that
- the c_models array size was one too small, potentially causing
  table_lookup_model() to return garbage on Intel CPUs (intel.c's
  instance was lacking the sentinel with family being zero), so the
  patch bumps that by one,
- c_models' vendor sub-field was unused (and anyway redundant with
  the base structure's c_x86_vendor field), so the patch deletes it.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/amd.c     |    2 +-
 arch/x86/kernel/cpu/centaur.c |    6 ++++--
 arch/x86/kernel/cpu/common.c  |    4 +++-
 arch/x86/kernel/cpu/cpu.h     |   16 +++++++---------
 arch/x86/kernel/cpu/intel.c   |    8 ++++----
 arch/x86/kernel/cpu/umc.c     |    2 +-
 6 files changed, 20 insertions(+), 18 deletions(-)

--- 3.6-rc6/arch/x86/kernel/cpu/amd.c
+++ 3.6-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/amd.c
@@ -742,7 +742,7 @@ static const struct cpu_dev __cpuinitcon
 	.c_ident	= { "AuthenticAMD" },
 #ifdef CONFIG_X86_32
 	.c_models = {
-		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
+		{ .family = 4, .model_names =
 		  {
 			  [3] = "486 DX/2",
 			  [7] = "486 DX/2-WB",
--- 3.6-rc6/arch/x86/kernel/cpu/centaur.c
+++ 3.6-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/centaur.c
@@ -468,10 +468,10 @@ static void __cpuinit init_centaur(struc
 #endif
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit
 centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
-#ifdef CONFIG_X86_32
 	/* VIA C3 CPUs (670-68F) need further shifting. */
 	if ((c->x86 == 6) && ((c->x86_model == 7) || (c->x86_model == 8)))
 		size >>= 8;
@@ -484,16 +484,18 @@ centaur_size_cache(struct cpuinfo_x86 *c
 	if ((c->x86 == 6) && (c->x86_model == 9) &&
 				(c->x86_mask == 1) && (size == 65))
 		size -= 1;
-#endif
 	return size;
 }
+#endif
 
 static const struct cpu_dev __cpuinitconst centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
+#ifdef CONFIG_X86_32
 	.c_size_cache	= centaur_size_cache,
+#endif
 	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
--- 3.6-rc6/arch/x86/kernel/cpu/common.c
+++ 3.6-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/common.c
@@ -336,6 +336,7 @@ static void __cpuinit filter_cpuid_featu
 /* Look up CPU names by table lookup. */
 static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 	const struct cpu_model_info *info;
 
 	if (c->x86_model >= 16)
@@ -346,11 +347,12 @@ static const char *__cpuinit table_looku
 
 	info = this_cpu->c_models;
 
-	while (info && info->family) {
+	while (info->family) {
 		if (info->family == c->x86)
 			return info->model_names[c->x86_model];
 		info++;
 	}
+#endif
 	return NULL;		/* Not found */
 }
 
--- 3.6-rc6/arch/x86/kernel/cpu/cpu.h
+++ 3.6-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/cpu.h
@@ -1,12 +1,6 @@
 #ifndef ARCH_X86_CPU_H
 #define ARCH_X86_CPU_H
 
-struct cpu_model_info {
-	int		vendor;
-	int		family;
-	const char	*model_names[16];
-};
-
 /* attempt to consolidate cpu attributes */
 struct cpu_dev {
 	const char	*c_vendor;
@@ -14,15 +8,19 @@ struct cpu_dev {
 	/* some have two possibilities for cpuid string */
 	const char	*c_ident[2];
 
-	struct		cpu_model_info c_models[4];
-
 	void            (*c_early_init)(struct cpuinfo_x86 *);
 	void		(*c_bsp_init)(struct cpuinfo_x86 *);
 	void		(*c_init)(struct cpuinfo_x86 *);
 	void		(*c_identify)(struct cpuinfo_x86 *);
 	void		(*c_detect_tlb)(struct cpuinfo_x86 *);
-	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
 	int		c_x86_vendor;
+#ifdef CONFIG_X86_32
+	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
+	struct cpu_model_info {
+		int		family;
+		const char	*model_names[16];
+	}		c_models[5];
+#endif
 };
 
 struct _tlb_table {
--- 3.6-rc6/arch/x86/kernel/cpu/intel.c
+++ 3.6-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/intel.c
@@ -671,7 +671,7 @@ static const struct cpu_dev __cpuinitcon
 	.c_ident	= { "GenuineIntel" },
 #ifdef CONFIG_X86_32
 	.c_models = {
-		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names =
+		{ .family = 4, .model_names =
 		  {
 			  [0] = "486 DX-25/33",
 			  [1] = "486 DX-50",
@@ -684,7 +684,7 @@ static const struct cpu_dev __cpuinitcon
 			  [9] = "486 DX/4-WB"
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 5, .model_names =
+		{ .family = 5, .model_names =
 		  {
 			  [0] = "Pentium 60/66 A-step",
 			  [1] = "Pentium 60/66",
@@ -695,7 +695,7 @@ static const struct cpu_dev __cpuinitcon
 			  [8] = "Mobile Pentium MMX"
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 6, .model_names =
+		{ .family = 6, .model_names =
 		  {
 			  [0] = "Pentium Pro A-step",
 			  [1] = "Pentium Pro",
@@ -709,7 +709,7 @@ static const struct cpu_dev __cpuinitcon
 			  [11] = "Pentium III (Tualatin)",
 		  }
 		},
-		{ .vendor = X86_VENDOR_INTEL, .family = 15, .model_names =
+		{ .family = 15, .model_names =
 		  {
 			  [0] = "Pentium 4 (Unknown)",
 			  [1] = "Pentium 4 (Willamette)",
--- 3.6-rc6/arch/x86/kernel/cpu/umc.c
+++ 3.6-rc6-x86-cpu-32bit-only-pieces/arch/x86/kernel/cpu/umc.c
@@ -12,7 +12,7 @@ static const struct cpu_dev __cpuinitcon
 	.c_vendor	= "UMC",
 	.c_ident	= { "UMC UMC UMC" },
 	.c_models = {
-		{ .vendor = X86_VENDOR_UMC, .family = 4, .model_names =
+		{ .family = 4, .model_names =
 		  {
 			  [1] = "U5D",
 			  [2] = "U5S",


