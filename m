Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1HBWxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:53:46 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:41662 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1HBWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:51:55 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 16/19] ACPI, APEI, GHES: Add hardware memory error recovery
 support
Date: Tue, 02 Aug 2011 18:14:49 -0400
Message-id: <70738ef3836dfd4dbdaffef5522f4584b601770d.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

memory_failure_queue() is called when recoverable memory errors are
notified by firmware to do the recovery work.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/Kconfig |    7 +++++++
 drivers/acpi/apei/ghes.c  |   24 +++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 35596ea..c34aa51 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -32,6 +32,13 @@ config ACPI_APEI_PCIEAER
 	  PCIe AER errors may be reported via APEI firmware first mode.
 	  Turn on this option to enable the corresponding support.
 
+config ACPI_APEI_MEMORY_FAILURE
+	bool "APEI memory error recovering support"
+	depends on ACPI_APEI && MEMORY_FAILURE
+	help
+	  Memory errors may be reported via APEI firmware first mode.
+	  Turn on this option to enable the memory recovering support.
+
 config ACPI_APEI_EINJ
 	tristate "APEI Error INJection (EINJ)"
 	depends on ACPI_APEI && DEBUG_FS
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 931410d..e92c47c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -451,20 +451,30 @@ static void ghes_clear_estatus(struct ghes *ghes)
 
 static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
 {
-	int sev, processed = 0;
+	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
-#ifdef CONFIG_X86_MCE
+		sec_sev = ghes_severity(gdata->error_severity);
 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				 CPER_SEC_PLATFORM_MEM)) {
-			apei_mce_report_mem_error(
-				sev == GHES_SEV_CORRECTED,
-				(struct cper_sec_mem_err *)(gdata+1));
-			processed = 1;
-		}
+			struct cper_sec_mem_err *mem_err;
+			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+#ifdef CONFIG_X86_MCE
+			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
+						  mem_err);
 #endif
+#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
+			if (sev == GHES_SEV_RECOVERABLE &&
+			    sec_sev == GHES_SEV_RECOVERABLE &&
+			    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+				unsigned long pfn;
+				pfn = mem_err->physical_addr >> PAGE_SHIFT;
+				memory_failure_queue(pfn, 0, 0);
+			}
+#endif
+		}
 	}
 }
 
-- 
1.7.6.396.ge0613

