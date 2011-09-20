Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1ITBjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 21:39:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:52041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1ITBjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 21:39:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50392866"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 5/8] ACPI, APEI, EINJ, Fix resource conflict on some machine
Date: Tue, 20 Sep 2011 09:38:58 +0800
Message-Id: <1316482741-21799-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316482741-21799-1-git-send-email-ying.huang@intel.com>
References: <1316482741-21799-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/acpi/apei/apei-base.c     |   11 +++++++++++
 drivers/acpi/apei/apei-internal.h |    3 +++
 drivers/acpi/apei/einj.c          |   24 ++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -421,6 +421,17 @@ static int apei_resources_merge(struct a
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
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -95,6 +95,9 @@ static inline void apei_resources_init(s
 }
 
 void apei_resources_fini(struct apei_resources *resources);
+int apei_resources_add(struct apei_resources *resources,
+		       unsigned long start, unsigned long size,
+		       bool iomem);
 int apei_resources_sub(struct apei_resources *resources1,
 		       struct apei_resources *resources2);
 int apei_resources_request(struct apei_resources *resources,
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -195,7 +195,8 @@ static int einj_check_trigger_header(str
 }
 
 /* Execute instructions in trigger error action table */
-static int __einj_error_trigger(u64 trigger_paddr)
+static int __einj_error_trigger(u64 trigger_paddr, u32 type,
+				u64 param1, u64 param2)
 {
 	struct acpi_einj_trigger *trigger_tab = NULL;
 	struct apei_exec_context trigger_ctx;
@@ -256,6 +257,25 @@ static int __einj_error_trigger(u64 trig
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
@@ -325,7 +345,7 @@ static int __einj_error_inject(u32 type,
 	if (rc)
 		return rc;
 	trigger_paddr = apei_exec_ctx_get_output(&ctx);
-	rc = __einj_error_trigger(trigger_paddr);
+	rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
 	if (rc)
 		return rc;
 	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_END_OPERATION);
