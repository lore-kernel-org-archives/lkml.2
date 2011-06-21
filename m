Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1FUHQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:16:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:15682 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab1FUHQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:16:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,399,1304319600"; 
   d="scan'208";a="16258870"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [PATCH 4/4] ACPI, APEI, Add APEI _OSC support
Date: Tue, 21 Jun 2011 15:16:27 +0800
Message-Id: <1308640587-24502-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APEI firmware first mode must be turned on explicitly on some
machines, otherwise they may be no GHES hardware error record for
hardware error notification.  APEI bit in generic _OSC call can be
used to do that, but on some machine, a special APEI _OSC call must
be used.  This patch adds the support to that APEI _OSC call.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c     |   26 ++++++++++++++++++++++++++
 drivers/acpi/apei/apei-internal.h |    2 ++
 drivers/acpi/apei/ghes.c          |    4 ++++
 3 files changed, 32 insertions(+)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -604,3 +604,29 @@ struct dentry *apei_get_debugfs_dir(void
 	return dapei;
 }
 EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
+
+int apei_osc_setup(void)
+{
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
+	capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
+	capbuf[OSC_SUPPORT_TYPE] = 0;
+	capbuf[OSC_CONTROL_TYPE] = 0;
+
+	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle))
+	    || ACPI_FAILURE(acpi_run_osc(handle, &context)))
+		return -EIO;
+	else {
+		kfree(context.ret.pointer);
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(apei_osc_setup);
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -124,4 +124,6 @@ void apei_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
+
+int apei_osc_setup(void);
 #endif
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -678,6 +678,10 @@ static int __init ghes_init(void)
 	if (rc)
 		goto err_ioremap_exit;
 
+	rc = apei_osc_setup();
+	if (rc)
+		pr_info(GHES_PFX "Evaluate APEI _OSC failed!\n");
+
 	return 0;
 err_ioremap_exit:
 	ghes_ioremap_exit();
