Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2AQNW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:29 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43763 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2AQNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:25 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "Xiao, Hui" <hui.xiao@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 33/50] ACPI, APEI, EINJ, Refine the fix of resource conflict
Date: Tue, 17 Jan 2012 07:21:25 -0500
Message-id: <b4e008dc53a31cb4bf6a12d9dbaf1d5c6070a838.1326802230.git.len.brown@intel.com>
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

From: "Xiao, Hui" <hui.xiao@linux.intel.com>

Current fix for resource conflict is to remove the address region <param1 &
param2, ~param2+1> from trigger resource, which is highly relies on valid user
input. This patch is trying to avoid such potential issues by fetching the
exact address region from trigger action table entry.

Signed-off-by: Xiao, Hui <hui.xiao@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/einj.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 4fdc8a3..6e6512e 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -194,6 +194,26 @@ static int einj_check_trigger_header(struct acpi_einj_trigger *trigger_tab)
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
@@ -205,6 +225,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	struct resource *r;
 	u32 table_size;
 	int rc = -EIO;
+	struct acpi_generic_address *trigger_param_region = NULL;
 
 	r = request_mem_region(trigger_paddr, sizeof(*trigger_tab),
 			       "APEI EINJ Trigger Table");
@@ -266,12 +287,17 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
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
-- 
1.7.9.rc1

