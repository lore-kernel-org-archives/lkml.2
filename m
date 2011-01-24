Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1AXP0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:26:25 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44589 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1AXP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:22 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/7] x86, microcode, AMD: Simplify get_next_ucode
Date: Mon, 24 Jan 2011 16:29:01 +0100
Message-Id: <1295882943-11184-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295882943-11184-1-git-send-email-bp@amd64.org>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Do not copy the section header but look at it directly through the
pointer. Also, make it return a ptr to a ucode header directly
thus dropping a bunch of unneeded casts. Finally, simplify
generic_load_microcode(), while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   68 ++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 9a451d7..8b58fc1 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -88,9 +88,9 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	return 0;
 }
 
-static int get_matching_microcode(int cpu, void *mc, int rev)
+static int get_matching_microcode(int cpu, struct microcode_header_amd *mc_hdr,
+				  int rev)
 {
-	struct microcode_header_amd *mc_header = mc;
 	unsigned int current_cpu_id;
 	u16 equiv_cpu_id = 0;
 	unsigned int i = 0;
@@ -109,17 +109,17 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	if (!equiv_cpu_id)
 		return 0;
 
-	if (mc_header->processor_rev_id != equiv_cpu_id)
+	if (mc_hdr->processor_rev_id != equiv_cpu_id)
 		return 0;
 
 	/* ucode might be chipset specific -- currently we don't support this */
-	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
+	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
 		pr_err("CPU%d: loading of chipset specific code not yet supported\n",
 		       cpu);
 		return 0;
 	}
 
-	if (mc_header->patch_id <= rev)
+	if (mc_hdr->patch_id <= rev)
 		return 0;
 
 	return 1;
@@ -155,21 +155,18 @@ static int apply_microcode_amd(int cpu)
 	return 0;
 }
 
-static void *
+static struct microcode_header_amd *
 get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 {
+	struct microcode_header_amd *mc;
 	unsigned int total_size;
-	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
-	void *mc;
 
-	get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR);
-
-	if (section_hdr[0] != UCODE_UCODE_TYPE) {
+	if (buf[0] != UCODE_UCODE_TYPE) {
 		pr_err("error: invalid type field in container file section header\n");
 		return NULL;
 	}
 
-	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
+	total_size = buf[4] + (buf[5] << 8);
 
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
 		pr_err("error: size mismatch\n");
@@ -218,12 +215,12 @@ static enum ucode_state
 generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct microcode_header_amd *mc_hdr = NULL;
+	unsigned int mc_size, leftover;
+	unsigned long offset;
 	const u8 *ucode_ptr = data;
 	void *new_mc = NULL;
-	void *mc;
 	int new_rev = uci->cpu_sig.rev;
-	unsigned int leftover;
-	unsigned long offset;
 	enum ucode_state state = UCODE_OK;
 
 	offset = install_equiv_cpu_table(ucode_ptr);
@@ -236,38 +233,37 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	leftover = size - offset;
 
 	while (leftover) {
-		unsigned int uninitialized_var(mc_size);
-		struct microcode_header_amd *mc_header;
-
-		mc = get_next_ucode(ucode_ptr, leftover, &mc_size);
-		if (!mc)
+		mc_hdr = get_next_ucode(ucode_ptr, leftover, &mc_size);
+		if (!mc_hdr)
 			break;
 
-		mc_header = (struct microcode_header_amd *)mc;
-		if (get_matching_microcode(cpu, mc, new_rev)) {
+		if (get_matching_microcode(cpu, mc_hdr, new_rev)) {
 			vfree(new_mc);
-			new_rev = mc_header->patch_id;
-			new_mc  = mc;
+			new_rev = mc_hdr->patch_id;
+			new_mc  = mc_hdr;
 		} else
-			vfree(mc);
+			vfree(mc_hdr);
 
 		ucode_ptr += mc_size;
 		leftover  -= mc_size;
 	}
 
-	if (new_mc) {
-		if (!leftover) {
-			vfree(uci->mc);
-			uci->mc = new_mc;
-			pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
-				 cpu, new_rev, uci->cpu_sig.rev);
-		} else {
-			vfree(new_mc);
-			state = UCODE_ERROR;
-		}
-	} else
+	if (!new_mc) {
 		state = UCODE_NFOUND;
+		goto free_table;
+	}
+
+	if (!leftover) {
+		vfree(uci->mc);
+		uci->mc = new_mc;
+		pr_debug("CPU%d update ucode to version 0x%x (from 0x%x)\n",
+			 cpu, new_rev, uci->cpu_sig.rev);
+	} else {
+		vfree(new_mc);
+		state = UCODE_ERROR;
+	}
 
+free_table:
 	free_equiv_cpu_table();
 
 	return state;
-- 
1.7.4.rc2

