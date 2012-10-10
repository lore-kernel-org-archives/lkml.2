Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2JJOUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:20:30 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44190 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab2JJOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:20:17 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 3/3] Convert mce_disabled
Date: Wed, 10 Oct 2012 16:20:01 +0200
Message-Id: <1349878801-15956-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349878801-15956-1-git-send-email-bp@amd64.org>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Not-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |  9 +++++----
 arch/x86/kernel/cpu/mcheck/mce.c | 12 +++++-------
 arch/x86/lguest/boot.c           |  2 +-
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 18a66ac35fc5..e8ed5a3a0512 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -126,7 +126,6 @@ extern void mce_unregister_decode_chain(struct notifier_block *nb);
 #include <linux/init.h>
 #include <linux/atomic.h>
 
-extern int mce_disabled;
 extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_MCE
@@ -208,9 +207,11 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
 				    size_t usize, loff_t *off));
 
 struct mca_config {
-	u64 dont_log_ce	: 1,
-#define MCA_CFG_DONT_LOG_CE	0
-	    __resv1	: 63;
+	u64	dont_log_ce	: 1,
+#define MCA_CFG_DONT_LOG_CE	  0
+		mca_disabled	: 1,
+#define MCA_CFG_MCA_DISABLED	  1
+	    __resv1	: 62;
 };
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8925bcdc5816..6341c1a0afdd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -58,8 +58,6 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
-int mce_disabled __read_mostly;
-
 #define SPINUNIT 100	/* 100ns */
 
 atomic_t mce_entry;
@@ -514,7 +512,7 @@ static int mce_ring_add(unsigned long pfn)
 
 int mce_available(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled)
+	if (mca_cfg.mca_disabled)
 		return 0;
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
@@ -1669,7 +1667,7 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
  */
 void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled)
+	if (mca_cfg.mca_disabled)
 		return;
 
 	if (__mcheck_cpu_ancient_init(c))
@@ -1679,7 +1677,7 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 		return;
 
 	if (__mcheck_cpu_cap_init() < 0 || __mcheck_cpu_apply_quirks(c) < 0) {
-		mce_disabled = 1;
+		mca_cfg.mca_disabled = 1;
 		return;
 	}
 
@@ -1959,7 +1957,7 @@ static int __init mcheck_enable(char *str)
 	if (*str == '=')
 		str++;
 	if (!strcmp(str, "off"))
-		mce_disabled = 1;
+		mca_cfg.mca_disabled = 1;
 	else if (!strcmp(str, "no_cmci"))
 		mce_cmci_disabled = 1;
 	else if (!strcmp(str, "dont_log_ce"))
@@ -2433,7 +2431,7 @@ device_initcall_sync(mcheck_init_device);
  */
 static int __init mcheck_disable(char *str)
 {
-	mce_disabled = 1;
+	mca_cfg.mca_disabled = 1;
 	return 1;
 }
 __setup("nomce", mcheck_disable);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 642d8805bc1b..0929fbba1371 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1412,7 +1412,7 @@ __init void lguest_init(void)
 
 	/* We don't have features.  We have puppies!  Puppies! */
 #ifdef CONFIG_X86_MCE
-	mce_disabled = 1;
+	mca_cfg.mca_disabled = 1;
 #endif
 #ifdef CONFIG_ACPI
 	acpi_disabled = 1;
-- 
1.8.0.rc0.18.gf84667d

