Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0HBHsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:48:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:53447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0HBHsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:48:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="591970023"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 2/4] ACPI, APEI, Rename CPER and GHES severity constants
Date: Mon,  2 Aug 2010 15:48:23 +0800
Message-Id: <1280735305-15379-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
References: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The abbreviation of severity should be SEV instead of SER, so the CPER
severity constants are renamed accordingly. GHES severity constants
are renamed in the same way too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-apei.c |    4 ++--
 drivers/acpi/apei/ghes.c              |   32 ++++++++++++++++----------------
 include/linux/cper.h                  |    8 ++++----
 3 files changed, 22 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -80,7 +80,7 @@ int apei_write_mce(struct mce *m)
 	rcd.hdr.revision = CPER_RECORD_REV;
 	rcd.hdr.signature_end = CPER_SIG_END;
 	rcd.hdr.section_count = 1;
-	rcd.hdr.error_severity = CPER_SER_FATAL;
+	rcd.hdr.error_severity = CPER_SEV_FATAL;
 	/* timestamp, platform_id, partition_id are all invalid */
 	rcd.hdr.validation_bits = 0;
 	rcd.hdr.record_length = sizeof(rcd);
@@ -96,7 +96,7 @@ int apei_write_mce(struct mce *m)
 	rcd.sec_hdr.validation_bits = 0;
 	rcd.sec_hdr.flags = CPER_SEC_PRIMARY;
 	rcd.sec_hdr.section_type = CPER_SECTION_TYPE_MCE;
-	rcd.sec_hdr.section_severity = CPER_SER_FATAL;
+	rcd.sec_hdr.section_severity = CPER_SEV_FATAL;
 
 	memcpy(&rcd.mce, m, sizeof(*m));
 
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -132,26 +132,26 @@ static void ghes_fini(struct ghes *ghes)
 }
 
 enum {
-	GHES_SER_NO = 0x0,
-	GHES_SER_CORRECTED = 0x1,
-	GHES_SER_RECOVERABLE = 0x2,
-	GHES_SER_PANIC = 0x3,
+	GHES_SEV_NO = 0x0,
+	GHES_SEV_CORRECTED = 0x1,
+	GHES_SEV_RECOVERABLE = 0x2,
+	GHES_SEV_PANIC = 0x3,
 };
 
 static inline int ghes_severity(int severity)
 {
 	switch (severity) {
-	case CPER_SER_INFORMATIONAL:
-		return GHES_SER_NO;
-	case CPER_SER_CORRECTED:
-		return GHES_SER_CORRECTED;
-	case CPER_SER_RECOVERABLE:
-		return GHES_SER_RECOVERABLE;
-	case CPER_SER_FATAL:
-		return GHES_SER_PANIC;
+	case CPER_SEV_INFORMATIONAL:
+		return GHES_SEV_NO;
+	case CPER_SEV_CORRECTED:
+		return GHES_SEV_CORRECTED;
+	case CPER_SEV_RECOVERABLE:
+		return GHES_SEV_RECOVERABLE;
+	case CPER_SEV_FATAL:
+		return GHES_SEV_PANIC;
 	default:
 		/* Unkown, go panic */
-		return GHES_SER_PANIC;
+		return GHES_SEV_PANIC;
 	}
 }
 
@@ -237,16 +237,16 @@ static void ghes_clear_estatus(struct gh
 
 static void ghes_do_proc(struct ghes *ghes)
 {
-	int ser, processed = 0;
+	int sev, processed = 0;
 	struct acpi_hest_generic_data *gdata;
 
-	ser = ghes_severity(ghes->estatus->error_severity);
+	sev = ghes_severity(ghes->estatus->error_severity);
 	apei_estatus_for_each_section(ghes->estatus, gdata) {
 #ifdef CONFIG_X86_MCE
 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			apei_mce_report_mem_error(
-				ser == GHES_SER_CORRECTED,
+				sev == GHES_SEV_CORRECTED,
 				(struct cper_sec_mem_err *)(gdata+1));
 			processed = 1;
 		}
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -39,10 +39,10 @@
  * Severity difinition for error_severity in struct cper_record_header
  * and section_severity in struct cper_section_descriptor
  */
-#define CPER_SER_RECOVERABLE			0x0
-#define CPER_SER_FATAL				0x1
-#define CPER_SER_CORRECTED			0x2
-#define CPER_SER_INFORMATIONAL			0x3
+#define CPER_SEV_RECOVERABLE			0x0
+#define CPER_SEV_FATAL				0x1
+#define CPER_SEV_CORRECTED			0x2
+#define CPER_SEV_INFORMATIONAL			0x3
 
 /*
  * Validation bits difinition for validation_bits in struct
