Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1AXP03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:26:29 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44601 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1AXP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:27 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 7/7] x86, microcode, AMD: Cleanup dmesg output
Date: Mon, 24 Jan 2011 16:29:03 +0100
Message-Id: <1295882943-11184-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295882943-11184-1-git-send-email-bp@amd64.org>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Unify pr_* to use pr_fmt, shorten messages, correct type formatting.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 274fa40..adbcef4 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -78,12 +78,13 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	u32 dummy;
 
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
-			   "supported\n", cpu, c->x86);
+		pr_warning("CPU%d: family %d not supported\n", cpu, c->x86);
 		return -1;
 	}
+
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
-	pr_info("CPU%d: patch_level=0x%x\n", cpu, csig->rev);
+	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
+
 	return 0;
 }
 
@@ -113,7 +114,7 @@ static int get_matching_microcode(int cpu, struct microcode_header_amd *mc_hdr,
 
 	/* ucode might be chipset specific -- currently we don't support this */
 	if (mc_hdr->nb_dev_id || mc_hdr->sb_dev_id) {
-		pr_err("CPU%d: loading of chipset specific code not yet supported\n",
+		pr_err("CPU%d: chipset specific code not yet supported\n",
 		       cpu);
 		return 0;
 	}
@@ -143,12 +144,12 @@ static int apply_microcode_amd(int cpu)
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
-		pr_err("CPU%d: update failed (for patch_level=0x%x)\n",
+		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 		       cpu, mc_amd->hdr.patch_id);
 		return -1;
 	}
 
-	pr_info("CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
+	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 
 	return 0;
@@ -161,14 +162,14 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 	unsigned int total_size;
 
 	if (buf[0] != UCODE_UCODE_TYPE) {
-		pr_err("error: invalid type field in container file section header\n");
+		pr_err("invalid type field in container file section header\n");
 		return NULL;
 	}
 
 	total_size = buf[4] + (buf[5] << 8);
 
 	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		pr_err("error: size mismatch\n");
+		pr_err("section size mismatch\n");
 		return NULL;
 	}
 
@@ -189,7 +190,8 @@ static int install_equiv_cpu_table(const u8 *buf)
 	unsigned int size = ibuf[2];
 
 	if (type != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
-		pr_err("error: invalid type field in container file section header\n");
+		pr_err("empty section/"
+		       "invalid type field in container file section header\n");
 		return -EINVAL;
 	}
 
@@ -219,7 +221,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	unsigned long offset;
 	const u8 *ucode_ptr = data;
 	void *new_mc = NULL;
-	int new_rev = uci->cpu_sig.rev;
+	unsigned int new_rev = uci->cpu_sig.rev;
 	enum ucode_state state = UCODE_OK;
 
 	offset = install_equiv_cpu_table(ucode_ptr);
@@ -255,8 +257,8 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	if (!leftover) {
 		vfree(uci->mc);
 		uci->mc = new_mc;
-		pr_debug("CPU%d update ucode to version 0x%x (from 0x%x)\n",
-			 cpu, new_rev, uci->cpu_sig.rev);
+		pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
+			 cpu, uci->cpu_sig.rev, new_rev);
 	} else {
 		vfree(new_mc);
 		state = UCODE_ERROR;
@@ -275,13 +277,13 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 	enum ucode_state ret = UCODE_NFOUND;
 
 	if (request_firmware(&fw, fw_name, device)) {
-		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
+		pr_err("failed to load file %s\n", fw_name);
 		goto out;
 	}
 
 	ret = UCODE_ERROR;
 	if (*(u32 *)fw->data != UCODE_MAGIC) {
-		pr_err("Invalid UCODE_MAGIC (0x%08x)\n", *(u32 *)fw->data);
+		pr_err("invalid magic value (0x%08x)\n", *(u32 *)fw->data);
 		goto fw_release;
 	}
 
-- 
1.7.4.rc2

