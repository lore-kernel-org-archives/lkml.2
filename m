Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1LISK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:10:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36276 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1LISJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:10 -0500
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/5] x86, microcode, AMD: Simplify ucode verification
Date: Fri,  9 Dec 2011 19:08:53 +0100
Message-Id: <1323454135-16777-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323454135-16777-1-git-send-email-bp@amd64.org>
References: <1323454135-16777-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Basically, what we did until now is take out a chunk of the firmware
image, vmalloc space for it and inspect it before application. And
repeat.

This patch changes all that so that we look at each ucode patch from
the firmware image, check it for sanity and copy it to local buffer for
application only once and if it passes all checks. Thus, vmalloc-ing for
each piece is gone, we can do proper size checking only of the patch
which is destined for the CPU of the current machine instead of each
single patch, which is clearly wrong.

Oh yeah, simplify and cleanup the code while at it, along with adding
comments as to what actually happens.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |  179 ++++++++++++++++++++-------------------
 1 files changed, 93 insertions(+), 86 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 9129c69..384990d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -89,27 +89,76 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
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
 
@@ -123,7 +172,20 @@ static int get_matching_microcode(int cpu, struct microcode_header_amd *mc_hdr,
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
@@ -158,63 +220,6 @@ static int apply_microcode_amd(int cpu)
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
@@ -250,36 +255,38 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
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
-
-		ucode_ptr += mc_size;
-		leftover  -= mc_size;
+			leftover -= mc_size;
+		} else {
+			ucode_ptr += current_size;
+			leftover  -= current_size;
+		}
 	}
 
 	if (!new_mc) {
@@ -288,18 +295,19 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	}
 
 	if (!leftover) {
-		vfree(uci->mc);
 		uci->mc = new_mc;
+		state = UCODE_OK;
 		pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
 			 cpu, uci->cpu_sig.rev, new_rev);
 	} else {
-		vfree(new_mc);
+		new_mc = NULL;
 		state = UCODE_ERROR;
 	}
 
 free_table:
 	free_equiv_cpu_table();
 
+out:
 	return state;
 }
 
@@ -340,7 +348,6 @@ static void microcode_fini_cpu_amd(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	vfree(uci->mc);
 	uci->mc = NULL;
 }
 
-- 
1.7.8.rc0

