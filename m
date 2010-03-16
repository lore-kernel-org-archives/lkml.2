Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017Ab0CPG0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:26:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:45638 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab0CPG03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,648,1262592000"; 
   d="scan'208";a="255088581"
From: Shane Wang <shane.wang@intel.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, joseph.cihula@intel.com
Subject: [RESEND][PATCH] intel_txt: fix section warning messages from tboot (v2)
Date: Tue, 16 Mar 2010 07:26:12 -0700
Message-Id: <1268749572-2454-1-git-send-email-shane.wang@intel.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix the warning messages related to tboot when "allyesconfig"
is set on i386.

Signed-off-by: Shane Wang <shane.wang@intel.com>
Acked-by: Joseph Cihula <joseph.cihula@intel.com>
---
 arch/x86/kernel/tboot.c |  108 +++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 59 deletions(-)

diff -r d5d64753146c arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Mon Mar 01 09:47:50 2010 -0500
+++ b/arch/x86/kernel/tboot.c	Thu Mar 04 09:36:37 2010 -0500
@@ -54,51 +54,6 @@ struct tboot *tboot __read_mostly;
 #define pr_fmt(fmt)	"tboot: " fmt
 
 static u8 tboot_uuid[16] __initdata = TBOOT_UUID;
-
-void __init tboot_probe(void)
-{
-	/* Look for valid page-aligned address for shared page. */
-	if (!boot_params.tboot_addr)
-		return;
-	/*
-	 * also verify that it is mapped as we expect it before calling
-	 * set_fixmap(), to reduce chance of garbage value causing crash
-	 */
-	if (!e820_any_mapped(boot_params.tboot_addr,
-			     boot_params.tboot_addr, E820_RESERVED)) {
-		pr_warning("non-0 tboot_addr but it is not of type E820_RESERVED\n");
-		return;
-	}
-
-	/* only a natively booted kernel should be using TXT */
-	if (paravirt_enabled()) {
-		pr_warning("non-0 tboot_addr but pv_ops is enabled\n");
-		return;
-	}
-
-	/* Map and check for tboot UUID. */
-	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
-	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
-	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
-		pr_warning("tboot at 0x%llx is invalid\n",
-			   boot_params.tboot_addr);
-		tboot = NULL;
-		return;
-	}
-	if (tboot->version < 5) {
-		pr_warning("tboot version is invalid: %u\n", tboot->version);
-		tboot = NULL;
-		return;
-	}
-
-	pr_info("found shared page at phys addr 0x%llx:\n",
-		boot_params.tboot_addr);
-	pr_debug("version: %d\n", tboot->version);
-	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
-	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
-	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
-	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
-}
 
 static pgd_t *tboot_pg_dir;
 static struct mm_struct tboot_mm = {
@@ -182,7 +137,7 @@ static void add_mac_region(phys_addr_t s
 	}
 }
 
-static int tboot_setup_sleep(void)
+static void __init tboot_setup_sleep(void)
 {
 	tboot->num_mac_regions = 0;
 
@@ -198,20 +153,60 @@ static int tboot_setup_sleep(void)
 	add_mac_region(virt_to_phys(_text), _end - _text);
 
 	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
-
-	return 0;
 }
 
 #else /* no CONFIG_ACPI_SLEEP */
 
-static int tboot_setup_sleep(void)
-{
-	/* S3 shutdown requested, but S3 not supported by the kernel... */
-	BUG();
-	return -1;
-}
+static void tboot_setup_sleep(void)     {}
 
 #endif
+
+void __init tboot_probe(void)
+{
+	/* Look for valid page-aligned address for shared page. */
+	if (!boot_params.tboot_addr)
+		return;
+	/*
+	 * also verify that it is mapped as we expect it before calling
+	 * set_fixmap(), to reduce chance of garbage value causing crash
+	 */
+	if (!e820_any_mapped(boot_params.tboot_addr,
+			boot_params.tboot_addr, E820_RESERVED)) {
+		pr_warning("non-0 tboot_addr but it is not of type E820_RESERVED\n");
+		return;
+	}
+
+	/* only a natively booted kernel should be using TXT */
+	if (paravirt_enabled()) {
+		pr_warning("non-0 tboot_addr but pv_ops is enabled\n");
+		return;
+	}
+
+	/* Map and check for tboot UUID. */
+	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
+	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
+	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
+		pr_warning("tboot at 0x%llx is invalid\n",
+			boot_params.tboot_addr);
+		tboot = NULL;
+		return;
+	}
+	if (tboot->version < 5) {
+		pr_warning("tboot version is invalid: %u\n", tboot->version);
+		tboot = NULL;
+		return;
+	}
+
+	pr_info("found shared page at phys addr 0x%llx:\n",
+		boot_params.tboot_addr);
+	pr_debug("version: %d\n", tboot->version);
+	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
+	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
+	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
+	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
+
+	tboot_setup_sleep();
+}
 
 void tboot_shutdown(u32 shutdown_type)
 {
@@ -227,11 +222,6 @@ void tboot_shutdown(u32 shutdown_type)
 	 */
 	if (!tboot_pg_dir)
 		return;
-
-	/* if this is S3 then set regions to MAC */
-	if (shutdown_type == TB_SHUTDOWN_S3)
-		if (tboot_setup_sleep())
-			return;
 
 	tboot->shutdown_type = shutdown_type;
 
