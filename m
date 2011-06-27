Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1F0I2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:28:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:49411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab1F0I0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:26:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,431,1304319600"; 
   d="scan'208";a="19009113"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [PATCH -v2 3/4] ACPI, APEI, Add APEI bit support in generic _OSC call
Date: Mon, 27 Jun 2011 16:25:59 +0800
Message-Id: <1309163160-3201-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
References: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
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

To gain full APEI power on these machines, APEI bit in generic _OSC
call can be specified to tell firmware that Linux has full APEI
support.  This patch adds the APEI bit support in generic _OSC call.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/bus.c   |   16 ++++++++++++++--
 include/linux/acpi.h |    2 ++
 2 files changed, 16 insertions(+), 2 deletions(-)

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
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -282,6 +282,8 @@ acpi_status acpi_run_osc(acpi_handle han
 
 extern bool osc_sb_apei_support_acked;
 
+extern bool osc_sb_apei_support_acked;
+
 /* PCI defined _OSC bits */
 /* _OSC DW1 Definition (OS Support Fields) */
 #define OSC_EXT_PCI_CONFIG_SUPPORT		1
