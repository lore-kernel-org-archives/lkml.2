Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2AQM00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:26:26 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56487 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2AQMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:20 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 35/50] ACPI, APEI, Resolve false conflict between ACPI NVS and
 APEI
Date: Tue, 17 Jan 2012 07:21:27 -0500
Message-id: <4134b8c8811f23aa8a281db50dcee64dda414736.1326802230.git.len.brown@intel.com>
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
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/apei-base.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index f2c5062..4abb6c7 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -449,8 +449,19 @@ int apei_resources_sub(struct apei_resources *resources1,
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
@@ -459,12 +470,26 @@ int apei_resources_request(struct apei_resources *resources,
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
@@ -511,6 +536,8 @@ err_unmap_iomem:
 			break;
 		release_mem_region(res->start, res->end - res->start);
 	}
+res_fini:
+	apei_resources_fini(&nvs_resources);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(apei_resources_request);
-- 
1.7.9.rc1

