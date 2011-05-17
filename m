Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab1EQIKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:10:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:18452 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1EQII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2661671"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 6/9] ACPI, APEI, GHES: Add hardware memory error recovery support
Date: Tue, 17 May 2011 16:08:36 +0800
Message-Id: <1305619719-7480-7-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_failure_queue() is called when recoverable memory errors are
notified by firmware to do the recovery work.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/Kconfig |    7 +++++++
 drivers/acpi/apei/ghes.c  |   24 +++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -31,6 +31,13 @@ config ACPI_APEI_PCIEAER
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
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -422,20 +422,30 @@ static void ghes_clear_estatus(struct gh
 
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
 
