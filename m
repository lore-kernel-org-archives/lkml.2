Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2AEPHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:07:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2AEPHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:07:31 -0500
Date: Thu, 5 Jan 2012 16:05:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v3.3
Message-ID: <20120105150523.GA8054@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (5):
      x86, microcode, AMD: Add a vendor-specific exit function
      x86, microcode, AMD: Add a reusable buffer
      x86, microcode, AMD: Simplify ucode verification
      x86, microcode, AMD: Exit early on success
      x86, microcode, AMD: Update copyrights


 arch/x86/include/asm/microcode.h |    2 +
 arch/x86/kernel/microcode_amd.c  |  209 +++++++++++++++++++++-----------------
 arch/x86/kernel/microcode_core.c |    5 +
 3 files changed, 121 insertions(+), 95 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 2421507..4ebe157 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -48,6 +48,7 @@ static inline struct microcode_ops * __init init_intel_microcode(void)
 
 #ifdef CONFIG_MICROCODE_AMD
 extern struct microcode_ops * __init init_amd_microcode(void);
+extern void __exit exit_amd_microcode(void);
 
 static inline void get_ucode_data(void *to, const u8 *from, size_t n)
 {
@@ -59,6 +60,7 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 {
 	return NULL;
 }
+static inline void __exit exit_amd_microcode(void) {}
 #endif
 
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index d494799..fe86493 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -1,14 +1,18 @@
 /*
  *  AMD CPU Microcode Update Driver for Linux
- *  Copyright (C) 2008 Advanced Micro Devices Inc.
+ *  Copyright (C) 2008-2011 Advanced Micro Devices Inc.
  *
  *  Author: Peter Oruba <peter.oruba@amd.com>
  *
  *  Based on work by:
  *  Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
  *
- *  This driver allows to upgrade microcode on AMD
- *  family 0x10 and 0x11 processors.
+ *  Maintainers:
+ *  Andreas Herrmann <andreas.herrmann3@amd.com>
+ *  Borislav Petkov <borislav.petkov@amd.com>
+ *
+ *  This driver allows to upgrade microcode on F10h AMD
+ *  CPUs and later.
  *
  *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
@@ -71,6 +75,9 @@ struct microcode_amd {
 
 static struct equiv_cpu_entry *equiv_cpu_table;
 
+/* page-sized ucode patch buffer */
+void *patch;
+
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -86,27 +93,76 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	return 0;
 }
 
-static int get_matching_microcode(int cpu, struct microcode_header_amd *mc_hdr,
-				  int rev)
+static unsigned int verify_ucode_size(int cpu, u32 patch_size,
+				      unsigned int size)
 {
-	unsigned int current_cpu_id;
-	u16 equiv_cpu_id = 0;
-	unsigned int i = 0;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	u32 max_size;
+
+#define F1XH_MPB_MAX_SIZE 2048
+#define F14H_MPB_MAX_SIZE 1824
+#define F15H_MPB_MAX_SIZE 4096
+
+	switch (c->x86) {
+	case 0x14:
+		max_size = F14H_MPB_MAX_SIZE;
+		break;
+	case 0x15:
+		max_size = F15H_MPB_MAX_SIZE;
+		break;
+	default:
+		max_size = F1XH_MPB_MAX_SIZE;
+		break;
+	}
+
+	if (patch_size > min_t(u32, size, max_size)) {
+		pr_err("patch size mismatch\n");
+		return 0;
+	}
+
+	return patch_size;
+}
+
+static u16 find_equiv_id(void)
+{
+	unsigned int current_cpu_id, i = 0;
 
 	BUG_ON(equiv_cpu_table == NULL);
+
 	current_cpu_id = cpuid_eax(0x00000001);
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
-		if (current_cpu_id == equiv_cpu_table[i].installed_cpu) {
-			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu;
-			break;
-		}
+		if (current_cpu_id == equiv_cpu_table[i].installed_cpu)
+			return equiv_cpu_table[i].equiv_cpu;
+
 		i++;
 	}
+	return 0;
+}
 
+/*
+ * we signal a good patch is found by returning its size > 0
+ */
+static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
+				  unsigned int leftover_size, int rev,
+				  unsigned int *current_size)
+{
+	struct microcode_header_amd *mc_hdr;
+	unsigned int actual_size;
+	u16 equiv_cpu_id;
+
+	/* size of the current patch we're staring at */
+	*current_size = *(u32 *)(ucode_ptr + 4) + SECTION_HDR_SIZE;
+
+	equiv_cpu_id = find_equiv_id();
 	if (!equiv_cpu_id)
 		return 0;
 
+	/*
+	 * let's look at the patch header itself now
+	 */
+	mc_hdr = (struct microcode_header_amd *)(ucode_ptr + SECTION_HDR_SIZE);
+
 	if (mc_hdr->processor_rev_id != equiv_cpu_id)
 		return 0;
 
@@ -120,7 +176,20 @@ static int get_matching_microcode(int cpu, struct microcode_header_amd *mc_hdr,
 	if (mc_hdr->patch_id <= rev)
 		return 0;
 
-	return 1;
+	/*
+	 * now that the header looks sane, verify its size
+	 */
+	actual_size = verify_ucode_size(cpu, *current_size, leftover_size);
+	if (!actual_size)
+		return 0;
+
+	/* clear the patch buffer */
+	memset(patch, 0, PAGE_SIZE);
+
+	/* all looks ok, get the binary patch */
+	get_ucode_data(patch, ucode_ptr + SECTION_HDR_SIZE, actual_size);
+
+	return actual_size;
 }
 
 static int apply_microcode_amd(int cpu)
@@ -155,63 +224,6 @@ static int apply_microcode_amd(int cpu)
 	return 0;
 }
 
-static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
-{
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	u32 max_size, actual_size;
-
-#define F1XH_MPB_MAX_SIZE 2048
-#define F14H_MPB_MAX_SIZE 1824
-#define F15H_MPB_MAX_SIZE 4096
-
-	switch (c->x86) {
-	case 0x14:
-		max_size = F14H_MPB_MAX_SIZE;
-		break;
-	case 0x15:
-		max_size = F15H_MPB_MAX_SIZE;
-		break;
-	default:
-		max_size = F1XH_MPB_MAX_SIZE;
-		break;
-	}
-
-	actual_size = *(u32 *)(buf + 4);
-
-	if (actual_size + SECTION_HDR_SIZE > size || actual_size > max_size) {
-		pr_err("section size mismatch\n");
-		return 0;
-	}
-
-	return actual_size;
-}
-
-static struct microcode_header_amd *
-get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
-{
-	struct microcode_header_amd *mc = NULL;
-	unsigned int actual_size = 0;
-
-	if (*(u32 *)buf != UCODE_UCODE_TYPE) {
-		pr_err("invalid type field in container file section header\n");
-		goto out;
-	}
-
-	actual_size = verify_ucode_size(cpu, buf, size);
-	if (!actual_size)
-		goto out;
-
-	mc = vzalloc(actual_size);
-	if (!mc)
-		goto out;
-
-	get_ucode_data(mc, buf + SECTION_HDR_SIZE, actual_size);
-	*mc_size = actual_size + SECTION_HDR_SIZE;
-
-out:
-	return mc;
-}
-
 static int install_equiv_cpu_table(const u8 *buf)
 {
 	unsigned int *ibuf = (unsigned int *)buf;
@@ -247,36 +259,38 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_header_amd *mc_hdr = NULL;
-	unsigned int mc_size, leftover;
+	unsigned int mc_size, leftover, current_size = 0;
 	int offset;
 	const u8 *ucode_ptr = data;
 	void *new_mc = NULL;
 	unsigned int new_rev = uci->cpu_sig.rev;
-	enum ucode_state state = UCODE_OK;
+	enum ucode_state state = UCODE_ERROR;
 
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (offset < 0) {
 		pr_err("failed to create equivalent cpu table\n");
-		return UCODE_ERROR;
+		goto out;
 	}
-
 	ucode_ptr += offset;
 	leftover = size - offset;
 
-	while (leftover) {
-		mc_hdr = get_next_ucode(cpu, ucode_ptr, leftover, &mc_size);
-		if (!mc_hdr)
-			break;
+	if (*(u32 *)ucode_ptr != UCODE_UCODE_TYPE) {
+		pr_err("invalid type field in container file section header\n");
+		goto free_table;
+	}
 
-		if (get_matching_microcode(cpu, mc_hdr, new_rev)) {
-			vfree(new_mc);
+	while (leftover) {
+		mc_size = get_matching_microcode(cpu, ucode_ptr, leftover,
+						 new_rev, &current_size);
+		if (mc_size) {
+			mc_hdr  = patch;
+			new_mc  = patch;
 			new_rev = mc_hdr->patch_id;
-			new_mc  = mc_hdr;
-		} else
-			vfree(mc_hdr);
+			goto out_ok;
+		}
 
-		ucode_ptr += mc_size;
-		leftover  -= mc_size;
+		ucode_ptr += current_size;
+		leftover  -= current_size;
 	}
 
 	if (!new_mc) {
@@ -284,19 +298,16 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 		goto free_table;
 	}
 
-	if (!leftover) {
-		vfree(uci->mc);
-		uci->mc = new_mc;
-		pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
-			 cpu, uci->cpu_sig.rev, new_rev);
-	} else {
-		vfree(new_mc);
-		state = UCODE_ERROR;
-	}
+out_ok:
+	uci->mc = new_mc;
+	state = UCODE_OK;
+	pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
+		 cpu, uci->cpu_sig.rev, new_rev);
 
 free_table:
 	free_equiv_cpu_table();
 
+out:
 	return state;
 }
 
@@ -337,7 +348,6 @@ static void microcode_fini_cpu_amd(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	vfree(uci->mc);
 	uci->mc = NULL;
 }
 
@@ -351,5 +361,14 @@ static struct microcode_ops microcode_amd_ops = {
 
 struct microcode_ops * __init init_amd_microcode(void)
 {
+	patch = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!patch)
+		return NULL;
+
 	return &microcode_amd_ops;
 }
+
+void __exit exit_amd_microcode(void)
+{
+	free_page((unsigned long)patch);
+}
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9d46f5e..9302e2d 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -563,6 +563,8 @@ module_init(microcode_init);
 
 static void __exit microcode_exit(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
 	microcode_dev_exit();
 
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
@@ -580,6 +582,9 @@ static void __exit microcode_exit(void)
 
 	microcode_ops = NULL;
 
+	if (c->x86_vendor == X86_VENDOR_AMD)
+		exit_amd_microcode();
+
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
 }
 module_exit(microcode_exit);
