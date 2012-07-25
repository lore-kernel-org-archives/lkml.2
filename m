Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab2GYDmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:15 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33308 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab2GYDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:12 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 06/52] ACPICA: Disassembler: Add support for Operation Region externals
Date: Tue, 24 Jul 2012 23:41:02 -0400
Message-Id: <6ccd7b5acc418e02953a8dd8a3c17e04907aacff.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Adds missing support for operation regions defined in another
table, but referenced via a Field or BankField operator. Generate
the correct External statement.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/dsfield.c | 81 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index cd243cf..8098439 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -53,11 +53,79 @@
 ACPI_MODULE_NAME("dsfield")
 
 /* Local prototypes */
+#ifdef ACPI_ASL_COMPILER
+#include "acdisasm.h"
+static acpi_status
+acpi_ds_create_external_region(acpi_status lookup_status,
+			       union acpi_parse_object *op,
+			       char *path,
+			       struct acpi_walk_state *walk_state,
+			       struct acpi_namespace_node **node);
+#endif
+
 static acpi_status
 acpi_ds_get_field_names(struct acpi_create_field_info *info,
 			struct acpi_walk_state *walk_state,
 			union acpi_parse_object *arg);
 
+#ifdef ACPI_ASL_COMPILER
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ds_create_external_region (i_aSL Disassembler only)
+ *
+ * PARAMETERS:  lookup_status   - Status from ns_lookup operation
+ *              Op              - Op containing the Field definition and args
+ *              Path            - Pathname of the region
+ *  `           walk_state      - Current method state
+ *              Node            - Where the new region node is returned
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Add region to the external list if NOT_FOUND. Create a new
+ *              region node/object.
+ *
+ ******************************************************************************/
+
+static acpi_status
+acpi_ds_create_external_region(acpi_status lookup_status,
+			       union acpi_parse_object *op,
+			       char *path,
+			       struct acpi_walk_state *walk_state,
+			       struct acpi_namespace_node **node)
+{
+	acpi_status status;
+	union acpi_operand_object *obj_desc;
+
+	if (lookup_status != AE_NOT_FOUND) {
+		return (lookup_status);
+	}
+
+	/*
+	 * Table disassembly:
+	 * operation_region not found. Generate an External for it, and
+	 * insert the name into the namespace.
+	 */
+	acpi_dm_add_to_external_list(op, path, ACPI_TYPE_REGION, 0);
+	status = acpi_ns_lookup(walk_state->scope_info, path, ACPI_TYPE_REGION,
+				ACPI_IMODE_LOAD_PASS1, ACPI_NS_SEARCH_PARENT,
+				walk_state, node);
+	if (ACPI_FAILURE(status)) {
+		return (status);
+	}
+
+	/* Must create and install a region object for the new node */
+
+	obj_desc = acpi_ut_create_internal_object(ACPI_TYPE_REGION);
+	if (!obj_desc) {
+		return (AE_NO_MEMORY);
+	}
+
+	obj_desc->region.node = *node;
+	status = acpi_ns_attach_object(*node, obj_desc, ACPI_TYPE_REGION);
+	return (status);
+}
+#endif
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ds_create_buffer_field
@@ -413,12 +481,19 @@ acpi_ds_create_field(union acpi_parse_object *op,
 	/* First arg is the name of the parent op_region (must already exist) */
 
 	arg = op->common.value.arg;
+
 	if (!region_node) {
 		status =
 		    acpi_ns_lookup(walk_state->scope_info,
 				   arg->common.value.name, ACPI_TYPE_REGION,
 				   ACPI_IMODE_EXECUTE, ACPI_NS_SEARCH_PARENT,
 				   walk_state, &region_node);
+#ifdef ACPI_ASL_COMPILER
+		status = acpi_ds_create_external_region(status, arg,
+							arg->common.value.name,
+							walk_state,
+							&region_node);
+#endif
 		if (ACPI_FAILURE(status)) {
 			ACPI_ERROR_NAMESPACE(arg->common.value.name, status);
 			return_ACPI_STATUS(status);
@@ -591,6 +666,12 @@ acpi_ds_create_bank_field(union acpi_parse_object *op,
 				   arg->common.value.name, ACPI_TYPE_REGION,
 				   ACPI_IMODE_EXECUTE, ACPI_NS_SEARCH_PARENT,
 				   walk_state, &region_node);
+#ifdef ACPI_ASL_COMPILER
+		status = acpi_ds_create_external_region(status, arg,
+							arg->common.value.name,
+							walk_state,
+							&region_node);
+#endif
 		if (ACPI_FAILURE(status)) {
 			ACPI_ERROR_NAMESPACE(arg->common.value.name, status);
 			return_ACPI_STATUS(status);
-- 
1.7.12.rc0

