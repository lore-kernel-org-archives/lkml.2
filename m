Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab2GYDng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:43:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2GYDnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:22 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 43/52] ACPICA: Add new ACPI table load/unload external interfaces
Date: Tue, 24 Jul 2012 23:41:39 -0400
Message-Id: <f60d81813d0e01463e76155c393b75a09dd3bbb4.1343187617.git.len.brown@intel.com>
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

Add acpi_load_table and acpi_unload_parent_table to support
host-directed dynamic table load/unload. Intended to support
hotplug addition and removal of SSDTs.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/tbxface.c  |  42 ----------
 drivers/acpi/acpica/tbxfload.c | 178 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h          |  13 ++-
 3 files changed, 187 insertions(+), 46 deletions(-)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index 472a91c..9bf34f7 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -215,48 +215,6 @@ acpi_status acpi_reallocate_root_table(void)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_load_table
- *
- * PARAMETERS:  table_ptr       - pointer to a buffer containing the entire
- *                                table to be loaded
- *
- * RETURN:      Status
- *
- * DESCRIPTION: This function is called to load a table from the caller's
- *              buffer. The buffer must contain an entire ACPI Table including
- *              a valid header. The header fields will be verified, and if it
- *              is determined that the table is invalid, the call will fail.
- *
- ******************************************************************************/
-acpi_status acpi_load_table(struct acpi_table_header *table_ptr)
-{
-	acpi_status status;
-	u32 table_index;
-	struct acpi_table_desc table_desc;
-
-	if (!table_ptr)
-		return AE_BAD_PARAMETER;
-
-	ACPI_MEMSET(&table_desc, 0, sizeof(struct acpi_table_desc));
-	table_desc.pointer = table_ptr;
-	table_desc.length = table_ptr->length;
-	table_desc.flags = ACPI_TABLE_ORIGIN_UNKNOWN;
-
-	/*
-	 * Install the new table into the local data structures
-	 */
-	status = acpi_tb_add_table(&table_desc, &table_index);
-	if (ACPI_FAILURE(status)) {
-		return status;
-	}
-	status = acpi_ns_load_table(table_index, acpi_gbl_root_node);
-	return status;
-}
-
-ACPI_EXPORT_SYMBOL(acpi_load_table)
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_get_table_header
  *
  * PARAMETERS:  Signature           - ACPI signature of needed table
diff --git a/drivers/acpi/acpica/tbxfload.c b/drivers/acpi/acpica/tbxfload.c
index 54a01ae..f87cc63 100644
--- a/drivers/acpi/acpica/tbxfload.c
+++ b/drivers/acpi/acpica/tbxfload.c
@@ -199,6 +199,184 @@ static acpi_status acpi_tb_load_namespace(void)
 	return_ACPI_STATUS(status);
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_load_table
+ *
+ * PARAMETERS:  table               - Pointer to a buffer containing the ACPI
+ *                                    table to be loaded.
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Dynamically load an ACPI table from the caller's buffer. Must
+ *              be a valid ACPI table with a valid ACPI table header.
+ *              Note1: Mainly intended to support hotplug addition of SSDTs.
+ *              Note2: Does not copy the incoming table. User is reponsible
+ *              to ensure that the table is not deleted or unmapped.
+ *
+ ******************************************************************************/
+
+acpi_status acpi_load_table(struct acpi_table_header *table)
+{
+	acpi_status status;
+	struct acpi_table_desc table_desc;
+	u32 table_index;
+
+	ACPI_FUNCTION_TRACE(acpi_load_table);
+
+	/* Parameter validation */
+
+	if (!table) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	/* Init local table descriptor */
+
+	ACPI_MEMSET(&table_desc, 0, sizeof(struct acpi_table_desc));
+	table_desc.address = ACPI_PTR_TO_PHYSADDR(table);
+	table_desc.pointer = table;
+	table_desc.length = table->length;
+	table_desc.flags = ACPI_TABLE_ORIGIN_UNKNOWN;
+
+	/* Must acquire the interpreter lock during this operation */
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Install the table and load it into the namespace */
+
+	ACPI_INFO((AE_INFO, "Host-directed Dynamic ACPI Table Load:"));
+	status = acpi_tb_add_table(&table_desc, &table_index);
+	if (ACPI_FAILURE(status)) {
+		goto unlock_and_exit;
+	}
+
+	status = acpi_ns_load_table(table_index, acpi_gbl_root_node);
+
+	/* Invoke table handler if present */
+
+	if (acpi_gbl_table_handler) {
+		(void)acpi_gbl_table_handler(ACPI_TABLE_EVENT_LOAD, table,
+					     acpi_gbl_table_handler_context);
+	}
+
+      unlock_and_exit:
+	(void)acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_load_table)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_unload_parent_table
+ *
+ * PARAMETERS:  object              - Handle to any namespace object owned by
+ *                                    the table to be unloaded
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Via any namespace object within an SSDT or OEMx table, unloads
+ *              the table and deletes all namespace objects associated with
+ *              that table. Unloading of the DSDT is not allowed.
+ *              Note: Mainly intended to support hotplug removal of SSDTs.
+ *
+ ******************************************************************************/
+acpi_status acpi_unload_parent_table(acpi_handle object)
+{
+	struct acpi_namespace_node *node =
+	    ACPI_CAST_PTR(struct acpi_namespace_node, object);
+	acpi_status status = AE_NOT_EXIST;
+	acpi_owner_id owner_id;
+	u32 i;
+
+	ACPI_FUNCTION_TRACE(acpi_unload_parent_table);
+
+	/* Parameter validation */
+
+	if (!object) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	/*
+	 * The node owner_id is currently the same as the parent table ID.
+	 * However, this could change in the future.
+	 */
+	owner_id = node->owner_id;
+	if (!owner_id) {
+
+		/* owner_id==0 means DSDT is the owner. DSDT cannot be unloaded */
+
+		return_ACPI_STATUS(AE_TYPE);
+	}
+
+	/* Must acquire the interpreter lock during this operation */
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Find the table in the global table list */
+
+	for (i = 0; i < acpi_gbl_root_table_list.current_table_count; i++) {
+		if (owner_id != acpi_gbl_root_table_list.tables[i].owner_id) {
+			continue;
+		}
+
+		/*
+		 * Allow unload of SSDT and OEMx tables only. Do not allow unload
+		 * of the DSDT. No other types of tables should get here, since
+		 * only these types can contain AML and thus are the only types
+		 * that can create namespace objects.
+		 */
+		if (ACPI_COMPARE_NAME
+		    (acpi_gbl_root_table_list.tables[i].signature.ascii,
+		     ACPI_SIG_DSDT)) {
+			status = AE_TYPE;
+			break;
+		}
+
+		/* Ensure the table is actually loaded */
+
+		if (!acpi_tb_is_table_loaded(i)) {
+			status = AE_NOT_EXIST;
+			break;
+		}
+
+		/* Invoke table handler if present */
+
+		if (acpi_gbl_table_handler) {
+			(void)acpi_gbl_table_handler(ACPI_TABLE_EVENT_UNLOAD,
+						     acpi_gbl_root_table_list.
+						     tables[i].pointer,
+						     acpi_gbl_table_handler_context);
+		}
+
+		/*
+		 * Delete all namespace objects owned by this table. Note that
+		 * these objects can appear anywhere in the namespace by virtue
+		 * of the AML "Scope" operator. Thus, we need to track ownership
+		 * by an ID, not simply a position within the hierarchy.
+		 */
+		status = acpi_tb_delete_namespace_by_owner(i);
+		if (ACPI_FAILURE(status)) {
+			break;
+		}
+
+		status = acpi_tb_release_owner_id(i);
+		acpi_tb_set_table_loaded_flag(i, FALSE);
+		break;
+	}
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_unload_parent_table)
+
 static int __init acpi_no_auto_ssdt_setup(char *s) {
 
         printk(KERN_NOTICE "ACPI: SSDT auto-load disabled\n");
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 8f83f95..079bb90 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -154,15 +154,20 @@ void *acpi_callocate(u32 size);
 void acpi_free(void *address);
 
 /*
- * ACPI table manipulation interfaces
+ * ACPI table load/unload interfaces
  */
-acpi_status acpi_reallocate_root_table(void);
+acpi_status acpi_load_table(struct acpi_table_header *table);
 
-acpi_status acpi_find_root_pointer(acpi_size *rsdp_address);
+acpi_status acpi_unload_parent_table(acpi_handle object);
 
 acpi_status acpi_load_tables(void);
 
-acpi_status acpi_load_table(struct acpi_table_header *table_ptr);
+/*
+ * ACPI table manipulation interfaces
+ */
+acpi_status acpi_reallocate_root_table(void);
+
+acpi_status acpi_find_root_pointer(acpi_size *rsdp_address);
 
 acpi_status acpi_unload_table_id(acpi_owner_id id);
 
-- 
1.7.12.rc0

