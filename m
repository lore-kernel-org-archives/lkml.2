Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0JTBhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:37:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:62723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0JTBhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620664"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 8/9] ACPI, APEI, Report GHES error record with hardware error device core
Date: Wed, 20 Oct 2010 09:36:59 +0800
Message-Id: <1287538620-7442-9-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One hardware error device (struct herr_dev) is created for each GHES
in GHES platform device "probe" function.  Then when GHES hardware
error handler is notified by firmware, the hardware error records will
be reported on the struct herr_dev.

In the previous GHES support, only corrected memory error can be
reported to user space via /dev/mcelog, now all kinds of hardware
errors notified with SCI can be reported.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/cper.c |   18 +++++++
 drivers/acpi/apei/ghes.c |  119 +++++++++++++++++++++++++++++++----------------
 include/linux/cper.h     |    2 
 3 files changed, 99 insertions(+), 40 deletions(-)

--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -49,6 +49,24 @@ int herr_severity_to_cper(int herr_sever
 }
 EXPORT_SYMBOL_GPL(herr_severity_to_cper);
 
+int cper_severity_to_herr(int cper_severity)
+{
+	switch (cper_severity) {
+	case CPER_SEV_INFORMATIONAL:
+		return HERR_SEV_NONE;
+	case CPER_SEV_CORRECTED:
+		return HERR_SEV_CORRECTED;
+	case CPER_SEV_RECOVERABLE:
+		return HERR_SEV_RECOVERABLE;
+	case CPER_SEV_FATAL:
+		return HERR_SEV_FATAL;
+	default:
+		/* Unknown, default to fatal */
+		return HERR_SEV_FATAL;
+	}
+}
+EXPORT_SYMBOL_GPL(cper_severity_to_herr);
+
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -43,6 +43,7 @@
 #include <linux/kdebug.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/herror.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
 #include <acpi/hed.h>
@@ -74,6 +75,7 @@ struct ghes {
 	struct list_head list;
 	u64 buffer_paddr;
 	unsigned long flags;
+	struct herr_dev *herr_dev;
 };
 
 /*
@@ -238,9 +240,38 @@ static void ghes_clear_estatus(struct gh
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
+static void ghes_report(struct ghes *ghes)
+{
+	struct herr_record *ercd;
+	struct herr_section *esec;
+	struct acpi_hest_generic_status *estatus;
+	unsigned int estatus_len, ercd_alloc_flags = 0;
+	int ghes_sev;
+
+	ghes_sev = ghes_severity(ghes->estatus->error_severity);
+	if (ghes_sev >= GHES_SEV_PANIC)
+		ercd_alloc_flags |= HERR_ALLOC_NO_BURST_CONTROL;
+	estatus_len = apei_estatus_len(ghes->estatus);
+	ercd = herr_record_alloc(HERR_RECORD_LEN_ROUND1(estatus_len),
+				 ghes->herr_dev, ercd_alloc_flags);
+	if (!ercd)
+		return;
+
+	ercd->severity = cper_severity_to_herr(ghes->estatus->error_severity);
+
+	esec = herr_first_sec(ercd);
+	esec->length = HERR_SEC_LEN_ROUND(estatus_len);
+	esec->flags = 0;
+	esec->type = HERR_TYPE_GESR;
+
+	estatus = herr_sec_data(esec);
+	memcpy(estatus, ghes->estatus, estatus_len);
+	herr_record_report(ercd, ghes->herr_dev);
+}
+
 static void ghes_do_proc(struct ghes *ghes)
 {
-	int sev, processed = 0;
+	int sev;
 	struct acpi_hest_generic_data *gdata;
 
 	sev = ghes_severity(ghes->estatus->error_severity);
@@ -251,15 +282,9 @@ static void ghes_do_proc(struct ghes *gh
 			apei_mce_report_mem_error(
 				sev == GHES_SEV_CORRECTED,
 				(struct cper_sec_mem_err *)(gdata+1));
-			processed = 1;
 		}
 #endif
 	}
-
-	if (!processed && printk_ratelimit())
-		pr_warning(GHES_PFX
-		"Unknown error record from generic hardware error source: %d\n",
-			   ghes->generic->header.source_id);
 }
 
 static int ghes_proc(struct ghes *ghes)
@@ -269,7 +294,9 @@ static int ghes_proc(struct ghes *ghes)
 	rc = ghes_read_estatus(ghes, 0);
 	if (rc)
 		goto out;
+	ghes_report(ghes);
 	ghes_do_proc(ghes);
+	herr_notify();
 
 out:
 	ghes_clear_estatus(ghes);
@@ -300,41 +327,15 @@ static int __devinit ghes_probe(struct p
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
-	int rc = -EINVAL;
+	int rc;
 
+	rc = -ENODEV;
 	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
 	if (!generic->enabled)
-		return -ENODEV;
-
-	if (generic->error_block_length <
-	    sizeof(struct acpi_hest_generic_status)) {
-		pr_warning(FW_BUG GHES_PFX
-"Invalid error block length: %u for generic hardware error source: %d\n",
-			   generic->error_block_length,
-			   generic->header.source_id);
 		goto err;
-	}
-	if (generic->records_to_preallocate == 0) {
-		pr_warning(FW_BUG GHES_PFX
-"Invalid records to preallocate: %u for generic hardware error source: %d\n",
-			   generic->records_to_preallocate,
-			   generic->header.source_id);
-		goto err;
-	}
-	ghes = ghes_new(generic);
-	if (IS_ERR(ghes)) {
-		rc = PTR_ERR(ghes);
-		ghes = NULL;
-		goto err;
-	}
-	if (generic->notify.type == ACPI_HEST_NOTIFY_SCI) {
-		mutex_lock(&ghes_list_mutex);
-		if (list_empty(&ghes_sci))
-			register_acpi_hed_notifier(&ghes_notifier_sci);
-		list_add_rcu(&ghes->list, &ghes_sci);
-		mutex_unlock(&ghes_list_mutex);
-	} else {
-		unsigned char *notify = NULL;
+
+	if (generic->notify.type != ACPI_HEST_NOTIFY_SCI) {
+		char *notify = NULL;
 
 		switch (generic->notify.type) {
 		case ACPI_HEST_NOTIFY_POLLED:
@@ -357,9 +358,46 @@ static int __devinit ghes_probe(struct p
 "Unknown notification type: %u for generic hardware error source: %d\n",
 			generic->notify.type, generic->header.source_id);
 		}
-		rc = -ENODEV;
 		goto err;
 	}
+
+	rc = -EIO;
+	if (generic->error_block_length <
+	    sizeof(struct acpi_hest_generic_status)) {
+		pr_warning(FW_BUG GHES_PFX
+"Invalid error block length: %u for generic hardware error source: %d\n",
+			   generic->error_block_length,
+			   generic->header.source_id);
+		goto err;
+	}
+	ghes = ghes_new(generic);
+	if (IS_ERR(ghes)) {
+		rc = PTR_ERR(ghes);
+		ghes = NULL;
+		goto err;
+	}
+	rc = -ENOMEM;
+	ghes->herr_dev = herr_dev_alloc();
+	if (!ghes->herr_dev)
+		goto err;
+	ghes->herr_dev->name = dev_name(&ghes_dev->dev);
+	ghes->herr_dev->dev.parent = &ghes_dev->dev;
+	rc = herr_dev_register(ghes->herr_dev);
+	if (rc) {
+		herr_dev_free(ghes->herr_dev);
+		goto err;
+	}
+	switch (generic->notify.type) {
+	case ACPI_HEST_NOTIFY_SCI:
+		mutex_lock(&ghes_list_mutex);
+		if (list_empty(&ghes_sci))
+			register_acpi_hed_notifier(&ghes_notifier_sci);
+		list_add_rcu(&ghes->list, &ghes_sci);
+		mutex_unlock(&ghes_list_mutex);
+		break;
+	default:
+		BUG();
+	}
 	platform_set_drvdata(ghes_dev, ghes);
 
 	return 0;
@@ -386,13 +424,14 @@ static int __devexit ghes_remove(struct
 		if (list_empty(&ghes_sci))
 			unregister_acpi_hed_notifier(&ghes_notifier_sci);
 		mutex_unlock(&ghes_list_mutex);
+		synchronize_rcu();
 		break;
 	default:
 		BUG();
 		break;
 	}
 
-	synchronize_rcu();
+	herr_dev_unregister(ghes->herr_dev);
 	ghes_fini(ghes);
 	kfree(ghes);
 
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -22,6 +22,7 @@
 #define LINUX_CPER_H
 
 #include <linux/uuid.h>
+#include <linux/herror_record.h>
 
 /* CPER record signature and the size */
 #define CPER_SIG_RECORD				"CPER"
@@ -310,6 +311,7 @@ struct cper_sec_mem_err {
 #pragma pack()
 
 int herr_severity_to_cper(int herr_severity);
+int cper_severity_to_herr(int cper_severity);
 u64 cper_next_record_id(void);
 
 #endif
