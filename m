Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1DSBny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:43:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:27981 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab1DSBnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="421595178"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [RFC 2/4] ACPI, APEI, GHES: Add hardware memory error recovery support
Date: Tue, 19 Apr 2011 09:43:37 +0800
Message-Id: <1303177419-22466-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
References: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
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
@@ -430,20 +430,30 @@ static void ghes_clear_estatus(struct gh
 
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
 
