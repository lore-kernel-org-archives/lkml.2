Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1AXP1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:27:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44584 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1AXP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:21 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/7] x86, microcode, AMD: Release firmware on error
Date: Mon, 24 Jan 2011 16:28:59 +0100
Message-Id: <1295882943-11184-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295882943-11184-1-git-send-email-bp@amd64.org>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When the ucode magic is wrong, for whatever reason, we don't release the
loaded firmware binary and its related resources. Make sure we do. Also,
fix function naming to fit this driver's convention and shorten variable
names.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 0fe6d1a..ef91df0 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -278,27 +278,29 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	return state;
 }
 
-static enum ucode_state request_microcode_fw(int cpu, struct device *device)
+static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
-	const struct firmware *firmware;
-	enum ucode_state ret;
+	const struct firmware *fw;
+	enum ucode_state ret = UCODE_NFOUND;
 
-	if (request_firmware(&firmware, fw_name, device)) {
+	if (request_firmware(&fw, fw_name, device)) {
 		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
-		return UCODE_NFOUND;
+		goto out;
 	}
 
-	if (*(u32 *)firmware->data != UCODE_MAGIC) {
-		pr_err("invalid UCODE_MAGIC (0x%08x)\n",
-		       *(u32 *)firmware->data);
-		return UCODE_ERROR;
+	ret = UCODE_ERROR;
+	if (*(u32 *)fw->data != UCODE_MAGIC) {
+		pr_err("Invalid UCODE_MAGIC (0x%08x)\n", *(u32 *)fw->data);
+		goto fw_release;
 	}
 
-	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
+	ret = generic_load_microcode(cpu, fw->data, fw->size);
 
-	release_firmware(firmware);
+fw_release:
+	release_firmware(fw);
 
+out:
 	return ret;
 }
 
@@ -319,7 +321,7 @@ static void microcode_fini_cpu_amd(int cpu)
 
 static struct microcode_ops microcode_amd_ops = {
 	.request_microcode_user           = request_microcode_user,
-	.request_microcode_fw             = request_microcode_fw,
+	.request_microcode_fw             = request_microcode_amd,
 	.collect_cpu_info                 = collect_cpu_info_amd,
 	.apply_microcode                  = apply_microcode_amd,
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
-- 
1.7.4.rc2

