Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1EYGFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:05:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:59091 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1EYGFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,265,1304319600"; 
   d="scan'208";a="1142755"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI, APEI, Add APEI _OSC support
Date: Wed, 25 May 2011 14:05:38 +0800
Message-Id: <1306303538-30524-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In APEI firmware first mode, hardware error is reported by hardware to
firmware firstly, then firmware reports the error to Linux in a GHES
error record via POLL/SCI/IRQ/NMI etc.

This may result in some issues if OS has no full APEI support.  So
some firmware implementation will work in a back-compatible mode by
default.  Where firmware will only notify OS in old-fashion, without
GHES record.  For example, for a fatal hardware error, only NMI is
signaled, no GHES record.

To gain full APEI power on these machines, a special APEI _OSC needs
to be evaluated to tell firmware that Linux has full APEI support.
This patch add the APEI _OSC support.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c     |   42 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/apei/apei-internal.h |    2 +
 drivers/acpi/apei/ghes.c          |    8 +++++++
 3 files changed, 52 insertions(+)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -603,3 +603,45 @@ struct dentry *apei_get_debugfs_dir(void
 	return dapei;
 }
 EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
+
+enum {
+	APEI_OSC_SETUP_UNKNOWN,
+	APEI_OSC_SETUP_FAILED,
+	APEI_OSC_SETUP_SUCCEEDED,
+};
+
+int apei_osc_setup(void)
+{
+	/* Prevent _OSC to be evaluated simultaneously */
+	static DEFINE_MUTEX(mutex);
+	static int status = APEI_OSC_SETUP_UNKNOWN;
+	static u8 apei_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
+	acpi_handle handle;
+	u32 capbuf[3];
+	struct acpi_osc_context context = {
+		.uuid_str	= apei_uuid_str,
+		.rev		= 1,
+		.cap.length	= sizeof(capbuf),
+		.cap.pointer	= capbuf,
+	};
+
+	mutex_lock(&mutex);
+	if (status == APEI_OSC_SETUP_UNKNOWN) {
+		capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
+		capbuf[OSC_SUPPORT_TYPE] = 0;
+		capbuf[OSC_CONTROL_TYPE] = 0;
+
+		if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle))
+		    || ACPI_FAILURE(acpi_run_osc(handle, &context))) {
+			pr_err(APEI_PFX "APEI _OSC failed!\n");
+			status = APEI_OSC_SETUP_FAILED;
+		} else {
+			kfree(context.ret.pointer);
+			status = APEI_OSC_SETUP_SUCCEEDED;
+		}
+	}
+	mutex_unlock(&mutex);
+
+	return status == APEI_OSC_SETUP_SUCCEEDED ? 0 : -EIO;
+}
+EXPORT_SYMBOL_GPL(apei_osc_setup);
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -113,4 +113,6 @@ void apei_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
+
+int apei_osc_setup(void);
 #endif
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -687,6 +687,8 @@ static unsigned long ghes_esource_preall
 	return prealloc_size;
 }
 
+static int ghes_remove(struct platform_device *ghes_dev);
+
 static int __devinit ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -770,6 +772,12 @@ static int __devinit ghes_probe(struct p
 	}
 	platform_set_drvdata(ghes_dev, ghes);
 
+	rc = apei_osc_setup();
+	if (rc) {
+		ghes_remove(ghes_dev);
+		return rc;
+	}
+
 	return 0;
 err:
 	if (ghes) {
