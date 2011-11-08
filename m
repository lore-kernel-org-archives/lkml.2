Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1KHCju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:39:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:17611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1KHCjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288609"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 4/9] ACPI, APEI, Resolve false conflict between ACPI NVS and APEI
Date: Tue,  8 Nov 2011 10:39:29 +0800
Message-Id: <1320719974-3598-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmware will access memory in ACPI NVS region via APEI.  That
is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
region.  The original resource conflict checking in APEI code will
check memory/ioport accessed by APEI via general resource management
mech.  But ACPI NVS region is marked as busy already, so that the
false resource conflict will prevent APEI ERST/EINJ to work.

To fix this, this patch excludes ACPI NVS regions when APEI components
request resources.  So that they will not conflict with ACPI NVS
regions.

Reported-and-tested-by: Pavel Ivanov <paivanof@gmail.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -438,8 +438,19 @@ int apei_resources_sub(struct apei_resou
 }
 EXPORT_SYMBOL_GPL(apei_resources_sub);
 
+static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
+{
+	struct apei_resources *resources = data;
+	return apei_res_add(&resources->iomem, start, size);
+}
+
+static int apei_get_nvs_resources(struct apei_resources *resources)
+{
+	return acpi_nvs_for_each_region(apei_get_nvs_callback, resources);
+}
+
 /*
- * IO memory/port rersource management mechanism is used to check
+ * IO memory/port resource management mechanism is used to check
  * whether memory/port area used by GARs conflicts with normal memory
  * or IO memory/port of devices.
  */
@@ -448,12 +459,26 @@ int apei_resources_request(struct apei_r
 {
 	struct apei_res *res, *res_bak = NULL;
 	struct resource *r;
+	struct apei_resources nvs_resources;
 	int rc;
 
 	rc = apei_resources_sub(resources, &apei_resources_all);
 	if (rc)
 		return rc;
 
+	/*
+	 * Some firmware uses ACPI NVS region, that has been marked as
+	 * busy, so exclude it from APEI resources to avoid false
+	 * conflict.
+	 */
+	apei_resources_init(&nvs_resources);
+	rc = apei_get_nvs_resources(&nvs_resources);
+	if (rc)
+		goto res_fini;
+	rc = apei_resources_sub(resources, &nvs_resources);
+	if (rc)
+		goto res_fini;
+
 	rc = -EINVAL;
 	list_for_each_entry(res, &resources->iomem, list) {
 		r = request_mem_region(res->start, res->end - res->start,
@@ -500,6 +525,8 @@ err_unmap_iomem:
 			break;
 		release_mem_region(res->start, res->end - res->start);
 	}
+res_fini:
+	apei_resources_fini(&nvs_resources);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(apei_resources_request);
