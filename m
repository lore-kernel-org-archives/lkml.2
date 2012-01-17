Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2AQM1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:27:18 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:39595 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2AQMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:18 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 32/50] ACPI, APEI, EINJ, Fix resource conflict on some machine
Date: Tue, 17 Jan 2012 07:21:24 -0500
Message-id: <fdea163d8c17ba08814142259a467ba3e899010d.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Some APEI firmware implementation will access injected address
specified in param1 to trigger the error when injecting memory error.
This will cause resource conflict with RAM.

On one of our testing machine, if injecting at memory address
0x10000000, the following error will be reported in dmesg:

  APEI: Can not request iomem region <0000000010000000-0000000010000008> for GARs.

This patch removes the injecting memory address range from trigger
table resources to avoid conflict.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/apei-base.c     |   11 +++++++++++
 drivers/acpi/apei/apei-internal.h |    3 +++
 drivers/acpi/apei/einj.c          |   24 ++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 3492896..f2c5062 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -421,6 +421,17 @@ static int apei_resources_merge(struct apei_resources *resources1,
 	return 0;
 }
 
+int apei_resources_add(struct apei_resources *resources,
+		       unsigned long start, unsigned long size,
+		       bool iomem)
+{
+	if (iomem)
+		return apei_res_add(&resources->iomem, start, size);
+	else
+		return apei_res_add(&resources->ioport, start, size);
+}
+EXPORT_SYMBOL_GPL(apei_resources_add);
+
 /*
  * EINJ has two groups of GARs (EINJ table entry and trigger table
  * entry), so common resources are subtracted from the trigger table
diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
index f57050e..d778edd 100644
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -95,6 +95,9 @@ static inline void apei_resources_init(struct apei_resources *resources)
 }
 
 void apei_resources_fini(struct apei_resources *resources);
+int apei_resources_add(struct apei_resources *resources,
+		       unsigned long start, unsigned long size,
+		       bool iomem);
 int apei_resources_sub(struct apei_resources *resources1,
 		       struct apei_resources *resources2);
 int apei_resources_request(struct apei_resources *resources,
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 43eeb2e..4fdc8a3 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -195,7 +195,8 @@ static int einj_check_trigger_header(struct acpi_einj_trigger *trigger_tab)
 }
 
 /* Execute instructions in trigger error action table */
-static int __einj_error_trigger(u64 trigger_paddr)
+static int __einj_error_trigger(u64 trigger_paddr, u32 type,
+				u64 param1, u64 param2)
 {
 	struct acpi_einj_trigger *trigger_tab = NULL;
 	struct apei_exec_context trigger_ctx;
@@ -256,6 +257,25 @@ static int __einj_error_trigger(u64 trigger_paddr)
 	rc = apei_resources_sub(&trigger_resources, &einj_resources);
 	if (rc)
 		goto out_fini;
+	/*
+	 * Some firmware will access target address specified in
+	 * param1 to trigger the error when injecting memory error.
+	 * This will cause resource conflict with regular memory.  So
+	 * remove it from trigger table resources.
+	 */
+	if (param_extension && (type & 0x0038) && param2) {
+		struct apei_resources addr_resources;
+		apei_resources_init(&addr_resources);
+		rc = apei_resources_add(&addr_resources,
+					param1 & param2,
+					~param2 + 1, true);
+		if (rc)
+			goto out_fini;
+		rc = apei_resources_sub(&trigger_resources, &addr_resources);
+		apei_resources_fini(&addr_resources);
+		if (rc)
+			goto out_fini;
+	}
 	rc = apei_resources_request(&trigger_resources, "APEI EINJ Trigger");
 	if (rc)
 		goto out_fini;
@@ -325,7 +345,7 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 	if (rc)
 		return rc;
 	trigger_paddr = apei_exec_ctx_get_output(&ctx);
-	rc = __einj_error_trigger(trigger_paddr);
+	rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
 	if (rc)
 		return rc;
 	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_END_OPERATION);
-- 
1.7.9.rc1

