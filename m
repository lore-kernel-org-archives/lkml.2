Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1KHClF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:41:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:25706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1KHCjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288626"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        "Xiao, Hui" <hui.xiao@linux.intel.com>
Subject: [PATCH 7/9] ACPI, APEI, EINJ, Refine the fix of resource conflict
Date: Tue,  8 Nov 2011 10:39:32 +0800
Message-Id: <1320719974-3598-8-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Xiao, Hui" <hui.xiao@linux.intel.com>

Current fix for resource conflict is to remove the address region <param1 &
param2, ~param2+1> from trigger resource, which is highly relies on valid user
input. This patch is trying to avoid such potential issues by fetching the
exact address region from trigger action table entry.

Signed-off-by: Xiao, Hui <hui.xiao@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/einj.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -194,6 +194,26 @@ static int einj_check_trigger_header(str
 	return 0;
 }
 
+static struct acpi_generic_address *einj_get_trigger_parameter_region(
+	struct acpi_einj_trigger *trigger_tab, u64 param1, u64 param2)
+{
+	int i;
+	struct acpi_whea_header *entry;
+
+	entry = (struct acpi_whea_header *)
+		((char *)trigger_tab + sizeof(struct acpi_einj_trigger));
+	for (i = 0; i < trigger_tab->entry_count; i++) {
+		if (entry->action == ACPI_EINJ_TRIGGER_ERROR &&
+		entry->instruction == ACPI_EINJ_WRITE_REGISTER_VALUE &&
+		entry->register_region.space_id ==
+			ACPI_ADR_SPACE_SYSTEM_MEMORY &&
+		(entry->register_region.address & param2) == (param1 & param2))
+			return &entry->register_region;
+		entry++;
+	}
+
+	return NULL;
+}
 /* Execute instructions in trigger error action table */
 static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 				u64 param1, u64 param2)
@@ -205,6 +225,7 @@ static int __einj_error_trigger(u64 trig
 	struct resource *r;
 	u32 table_size;
 	int rc = -EIO;
+	struct acpi_generic_address *trigger_param_region = NULL;
 
 	r = request_mem_region(trigger_paddr, sizeof(*trigger_tab),
 			       "APEI EINJ Trigger Table");
@@ -266,12 +287,17 @@ static int __einj_error_trigger(u64 trig
 	if (param_extension && (type & 0x0038) && param2) {
 		struct apei_resources addr_resources;
 		apei_resources_init(&addr_resources);
-		rc = apei_resources_add(&addr_resources,
-					param1 & param2,
-					~param2 + 1, true);
-		if (rc)
-			goto out_fini;
-		rc = apei_resources_sub(&trigger_resources, &addr_resources);
+		trigger_param_region = einj_get_trigger_parameter_region(
+			trigger_tab, param1, param2);
+		if (trigger_param_region) {
+			rc = apei_resources_add(&addr_resources,
+				trigger_param_region->address,
+				trigger_param_region->bit_width/8, true);
+			if (rc)
+				goto out_fini;
+			rc = apei_resources_sub(&trigger_resources,
+					&addr_resources);
+		}
 		apei_resources_fini(&addr_resources);
 		if (rc)
 			goto out_fini;
