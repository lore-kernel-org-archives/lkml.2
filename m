Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1HBWQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:16:08 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:57182 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1HBWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:40 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 08/19] ACPI, APEI, Add APEI bit support in generic _OSC call
Date: Tue, 02 Aug 2011 18:14:41 -0400
Message-id: <eccddd32ced0df8f9130024157bf8d37df860d76.1312323131.git.len.brown@intel.com>
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

In APEI firmware first mode, hardware error is reported by hardware to
firmware firstly, then firmware reports the error to Linux in a GHES
error record via POLL/SCI/IRQ/NMI etc.

This may result in some issues if OS has no full APEI support.  So
some firmware implementation will work in a back-compatible mode by
default.  Where firmware will only notify OS in old-fashion, without
GHES record.  For example, for a fatal hardware error, only NMI is
signaled, no GHES record.

To gain full APEI power on these machines, APEI bit in generic _OSC
call can be specified to tell firmware that Linux has full APEI
support.  This patch adds the APEI bit support in generic _OSC call.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/bus.c   |   16 ++++++++++++++--
 include/linux/acpi.h |    2 ++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index d1e06c1..43ce3b0 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -39,6 +39,7 @@
 #include <linux/pci.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <acpi/apei.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
 
@@ -519,6 +520,7 @@ out_kfree:
 }
 EXPORT_SYMBOL(acpi_run_osc);
 
+bool osc_sb_apei_support_acked;
 static u8 sb_uuid_str[] = "0811B06E-4A27-44F9-8D60-3CBBC22E7B48";
 static void acpi_bus_osc_support(void)
 {
@@ -541,11 +543,21 @@ static void acpi_bus_osc_support(void)
 #if defined(CONFIG_ACPI_PROCESSOR) || defined(CONFIG_ACPI_PROCESSOR_MODULE)
 	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
 #endif
+
+#ifdef CONFIG_ACPI_APEI_GHES
+	if (!ghes_disable)
+		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
+#endif
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
 		return;
-	if (ACPI_SUCCESS(acpi_run_osc(handle, &context)))
+	if (ACPI_SUCCESS(acpi_run_osc(handle, &context))) {
+		u32 *capbuf_ret = context.ret.pointer;
+		if (context.ret.length > OSC_SUPPORT_TYPE)
+			osc_sb_apei_support_acked =
+				capbuf_ret[OSC_SUPPORT_TYPE] & OSC_SB_APEI_SUPPORT;
 		kfree(context.ret.pointer);
-	/* do we need to check the returned cap? Sounds no */
+	}
+	/* do we need to check other returned cap? Sounds no */
 }
 
 /* --------------------------------------------------------------------------
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1deb2a7..e19527d 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -280,6 +280,8 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_CPUHP_OST_SUPPORT	8
 #define OSC_SB_APEI_SUPPORT		16
 
+extern bool osc_sb_apei_support_acked;
+
 /* PCI defined _OSC bits */
 /* _OSC DW1 Definition (OS Support Fields) */
 #define OSC_EXT_PCI_CONFIG_SUPPORT		1
-- 
1.7.6.396.ge0613

