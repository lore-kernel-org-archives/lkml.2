Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2HGRoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:32 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35603 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab2HGRo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 09/12] x86, microcode: Add a refresh firmware flag to ->request_microcode_fw
Date: Tue,  7 Aug 2012 19:44:18 +0200
Message-Id: <1344361461-10076-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is done in preparation for teaching the ucode driver to either load
a new ucode patches container from userspace or use an already cached
version. No functionality change in this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/microcode.h  |  4 ++--
 arch/x86/kernel/microcode_amd.c   |  3 ++-
 arch/x86/kernel/microcode_core.c  | 11 ++++++-----
 arch/x86/kernel/microcode_intel.c |  3 ++-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 8813be600995..43d921b4752c 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -15,8 +15,8 @@ struct microcode_ops {
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
-	enum ucode_state (*request_microcode_fw) (int cpu,
-				struct device *device);
+	enum ucode_state (*request_microcode_fw) (int cpu, struct device *,
+						  bool refresh_fw);
 
 	void (*microcode_fini_cpu) (int cpu);
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 25d34b177482..94ecdaa24052 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -330,7 +330,8 @@ out:
  *
  * These might be larger than 2K.
  */
-static enum ucode_state request_microcode_amd(int cpu, struct device *device)
+static enum ucode_state request_microcode_amd(int cpu, struct device *device,
+					      bool refresh_fw)
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	const struct firmware *fw;
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index dcde544e012c..9420972e98fe 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -282,7 +282,7 @@ static int reload_for_cpu(int cpu)
 	if (!uci->valid)
 		return err;
 
-	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev, true);
 	if (ustate == UCODE_OK)
 		apply_microcode_on_target(cpu);
 	else
@@ -377,7 +377,7 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 	return UCODE_OK;
 }
 
-static enum ucode_state microcode_init_cpu(int cpu)
+static enum ucode_state microcode_init_cpu(int cpu, bool refresh_fw)
 {
 	enum ucode_state ustate;
 
@@ -388,7 +388,8 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	if (system_state != SYSTEM_RUNNING)
 		return UCODE_NFOUND;
 
-	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev,
+						     refresh_fw);
 
 	if (ustate == UCODE_OK) {
 		pr_debug("CPU%d updated upon init\n", cpu);
@@ -405,7 +406,7 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	if (uci->valid)
 		return microcode_resume_cpu(cpu);
 
-	return microcode_init_cpu(cpu);
+	return microcode_init_cpu(cpu, false);
 }
 
 static int mc_device_add(struct device *dev, struct subsys_interface *sif)
@@ -421,7 +422,7 @@ static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR)
+	if (microcode_init_cpu(cpu, true) == UCODE_ERROR)
 		return -EINVAL;
 
 	return err;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0327e2b3c408..3544aed39338 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -405,7 +405,8 @@ static int get_ucode_fw(void *to, const void *from, size_t n)
 	return 0;
 }
 
-static enum ucode_state request_microcode_fw(int cpu, struct device *device)
+static enum ucode_state request_microcode_fw(int cpu, struct device *device,
+					     bool refresh_fw)
 {
 	char name[30];
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-- 
1.7.11.rc1

