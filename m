Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2HVXoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:44:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2HVXoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:44:20 -0400
Date: Wed, 22 Aug 2012 16:44:07 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-48e30685caa8bdc4b8d4417d8ac31db59689742c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-10-git-send-email-bp@amd64.org>
References: <1344361461-10076-10-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode:
  Add a refresh firmware flag to ->request_microcode_fw
Git-Commit-ID: 48e30685caa8bdc4b8d4417d8ac31db59689742c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:44:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48e30685caa8bdc4b8d4417d8ac31db59689742c
Gitweb:     http://git.kernel.org/tip/48e30685caa8bdc4b8d4417d8ac31db59689742c
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 26 Jul 2012 15:51:00 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:15:58 -0700

x86, microcode: Add a refresh firmware flag to ->request_microcode_fw

This is done in preparation for teaching the ucode driver to either load
a new ucode patches container from userspace or use an already cached
version. No functionality change in this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-10-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/microcode.h  |    4 ++--
 arch/x86/kernel/microcode_amd.c   |    3 ++-
 arch/x86/kernel/microcode_core.c  |   11 ++++++-----
 arch/x86/kernel/microcode_intel.c |    3 ++-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 8813be6..43d921b 100644
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
index 25d34b1..94ecdaa 100644
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
index dcde544..9420972 100644
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
index 0327e2b..3544aed 100644
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
