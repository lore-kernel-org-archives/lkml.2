Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1HBWQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:16:15 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:64035 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab1HBWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:52 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 09/19] ACPI, APEI, Add WHEA _OSC support
Date: Tue, 02 Aug 2011 18:14:42 -0400
Message-id: <9fb0bfe1408d5506b7b83d13d1eed573fd71d67d.1312323131.git.len.brown@intel.com>
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

APEI firmware first mode must be turned on explicitly on some
machines, otherwise there may be no GHES hardware error record for
hardware error notification.  APEI bit in generic _OSC call can be
used to do that, but on some machine, a special WHEA _OSC call must be
used.  This patch adds the support to that WHEA _OSC call.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/apei-base.c     |   26 ++++++++++++++++++++++++++
 drivers/acpi/apei/apei-internal.h |    2 ++
 drivers/acpi/apei/ghes.c          |   10 ++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 0714194..8041248 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -604,3 +604,29 @@ struct dentry *apei_get_debugfs_dir(void)
 	return dapei;
 }
 EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
+
+int apei_osc_setup(void)
+{
+	static u8 whea_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
+	acpi_handle handle;
+	u32 capbuf[3];
+	struct acpi_osc_context context = {
+		.uuid_str	= whea_uuid_str,
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
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index f286cf7..f57050e 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -124,4 +124,6 @@ void apei_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
+
+int apei_osc_setup(void);
 #endif
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b142b94..b1390a6 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -681,6 +681,16 @@ static int __init ghes_init(void)
 	if (rc)
 		goto err_ioremap_exit;
 
+	rc = apei_osc_setup();
+	if (rc == 0 && osc_sb_apei_support_acked)
+		pr_info(GHES_PFX "APEI firmware first mode is enabled by APEI bit and WHEA _OSC.\n");
+	else if (rc == 0 && !osc_sb_apei_support_acked)
+		pr_info(GHES_PFX "APEI firmware first mode is enabled by WHEA _OSC.\n");
+	else if (rc && osc_sb_apei_support_acked)
+		pr_info(GHES_PFX "APEI firmware first mode is enabled by APEI bit.\n");
+	else
+		pr_info(GHES_PFX "Failed to enable APEI firmware first mode.\n");
+
 	return 0;
 err_ioremap_exit:
 	ghes_ioremap_exit();
-- 
1.7.6.396.ge0613

