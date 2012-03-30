Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888Ab2C3NSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:18:37 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:33467 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760867Ab2C3NS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:18:26 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Thomas Renninger <trenn@suse.de>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 29/76] ACPICA: Add acpi_os_physical_table_override interface
Date: Fri, 30 Mar 2012 06:13:32 -0400
Message-id: <f7b004a17c9183f023796dea0d70284684ec000d.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This interface allows the host to override a table via a
physical address, instead of the logical address required by
acpi_os_table_override. This simplifies the host implementation.
Initial implementation by Thomas Renninger. ACPICA implementation
creates a single function for table overrides that attempts both
a logical and a physical override.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/actables.h |    5 ++
 drivers/acpi/acpica/tbinstal.c |  117 +++++++++++++++++++++++++++++++++-------
 drivers/acpi/acpica/tbutils.c  |   93 +++++++++++++++++---------------
 drivers/acpi/osl.c             |    9 ++++
 include/acpi/acpiosxf.h        |    5 ++
 5 files changed, 166 insertions(+), 63 deletions(-)

diff --git a/drivers/acpi/acpica/actables.h b/drivers/acpi/acpica/actables.h
index d5bec30..6712965 100644
--- a/drivers/acpi/acpica/actables.h
+++ b/drivers/acpi/acpica/actables.h
@@ -67,6 +67,11 @@ acpi_status acpi_tb_resize_root_table_list(void);
 
 acpi_status acpi_tb_verify_table(struct acpi_table_desc *table_desc);
 
+struct acpi_table_header *acpi_tb_table_override(struct acpi_table_header
+						 *table_header,
+						 struct acpi_table_desc
+						 *table_desc);
+
 acpi_status
 acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index);
 
diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index 1aecf7b..c03500b 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -114,7 +114,6 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 {
 	u32 i;
 	acpi_status status = AE_OK;
-	struct acpi_table_header *override_table = NULL;
 
 	ACPI_FUNCTION_TRACE(tb_add_table);
 
@@ -224,25 +223,10 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 	/*
 	 * ACPI Table Override:
 	 * Allow the host to override dynamically loaded tables.
+	 * NOTE: the table is fully mapped at this point, and the mapping will
+	 * be deleted by tb_table_override if the table is actually overridden.
 	 */
-	status = acpi_os_table_override(table_desc->pointer, &override_table);
-	if (ACPI_SUCCESS(status) && override_table) {
-		ACPI_INFO((AE_INFO,
-			   "%4.4s @ 0x%p Table override, replaced with:",
-			   table_desc->pointer->signature,
-			   ACPI_CAST_PTR(void, table_desc->address)));
-
-		/* We can delete the table that was passed as a parameter */
-
-		acpi_tb_delete_table(table_desc);
-
-		/* Setup descriptor for the new table */
-
-		table_desc->address = ACPI_PTR_TO_PHYSADDR(override_table);
-		table_desc->pointer = override_table;
-		table_desc->length = override_table->length;
-		table_desc->flags = ACPI_TABLE_ORIGIN_OVERRIDE;
-	}
+	(void)acpi_tb_table_override(table_desc->pointer, table_desc);
 
 	/* Add the table to the global root table list */
 
@@ -263,6 +247,95 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_tb_table_override
+ *
+ * PARAMETERS:  table_header        - Header for the original table
+ *              table_desc          - Table descriptor initialized for the
+ *                                    original table. May or may not be mapped.
+ *
+ * RETURN:      Pointer to the entire new table. NULL if table not overridden.
+ *              If overridden, installs the new table within the input table
+ *              descriptor.
+ *
+ * DESCRIPTION: Attempt table override by calling the OSL override functions.
+ *              Note: If the table is overridden, then the entire new table
+ *              is mapped and returned by this function.
+ *
+ ******************************************************************************/
+
+struct acpi_table_header *acpi_tb_table_override(struct acpi_table_header
+						 *table_header,
+						 struct acpi_table_desc
+						 *table_desc)
+{
+	acpi_status status;
+	struct acpi_table_header *new_table = NULL;
+	acpi_physical_address new_address = 0;
+	u32 new_table_length = 0;
+	u8 new_flags;
+	char *override_type;
+
+	/* (1) Attempt logical override (returns a logical address) */
+
+	status = acpi_os_table_override(table_header, &new_table);
+	if (ACPI_SUCCESS(status) && new_table) {
+		new_address = ACPI_PTR_TO_PHYSADDR(new_table);
+		new_table_length = new_table->length;
+		new_flags = ACPI_TABLE_ORIGIN_OVERRIDE;
+		override_type = "Logical";
+		goto finish_override;
+	}
+
+	/* (2) Attempt physical override (returns a physical address) */
+
+	status = acpi_os_physical_table_override(table_header,
+						 &new_address,
+						 &new_table_length);
+	if (ACPI_SUCCESS(status) && new_address && new_table_length) {
+
+		/* Map the entire new table */
+
+		new_table = acpi_os_map_memory(new_address, new_table_length);
+		if (!new_table) {
+			ACPI_EXCEPTION((AE_INFO, AE_NO_MEMORY,
+					"%4.4s %p Attempted physical table override failed",
+					table_header->signature,
+					ACPI_CAST_PTR(void,
+						      table_desc->address)));
+			return (NULL);
+		}
+
+		override_type = "Physical";
+		new_flags = ACPI_TABLE_ORIGIN_MAPPED;
+		goto finish_override;
+	}
+
+	return (NULL);		/* There was no override */
+
+      finish_override:
+
+	ACPI_INFO((AE_INFO,
+		   "%4.4s %p %s table override, new table: %p",
+		   table_header->signature,
+		   ACPI_CAST_PTR(void, table_desc->address),
+		   override_type, new_table));
+
+	/* We can now unmap/delete the original table (if fully mapped) */
+
+	acpi_tb_delete_table(table_desc);
+
+	/* Setup descriptor for the new table */
+
+	table_desc->address = new_address;
+	table_desc->pointer = new_table;
+	table_desc->length = new_table_length;
+	table_desc->flags = new_flags;
+
+	return (new_table);
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_tb_resize_root_table_list
  *
  * PARAMETERS:  None
@@ -396,7 +469,11 @@ void acpi_tb_delete_table(struct acpi_table_desc *table_desc)
 	case ACPI_TABLE_ORIGIN_ALLOCATED:
 		ACPI_FREE(table_desc->pointer);
 		break;
-	default:;
+
+		/* Not mapped or allocated, there is nothing we can do */
+
+	default:
+		return;
 	}
 
 	table_desc->pointer = NULL;
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 1347c08..0a706ca 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -446,7 +446,7 @@ struct acpi_table_header *acpi_tb_copy_dsdt(u32 table_index)
  * RETURN:      None
  *
  * DESCRIPTION: Install an ACPI table into the global data structure. The
- *              table override mechanism is implemented here to allow the host
+ *              table override mechanism is called to allow the host
  *              OS to replace any table before it is installed in the root
  *              table array.
  *
@@ -456,11 +456,9 @@ void
 acpi_tb_install_table(acpi_physical_address address,
 		      char *signature, u32 table_index)
 {
-	u8 flags;
-	acpi_status status;
-	struct acpi_table_header *table_to_install;
-	struct acpi_table_header *mapped_table;
-	struct acpi_table_header *override_table = NULL;
+	struct acpi_table_header *table;
+	struct acpi_table_header *final_table;
+	struct acpi_table_desc *table_desc;
 
 	if (!address) {
 		ACPI_ERROR((AE_INFO,
@@ -471,69 +469,78 @@ acpi_tb_install_table(acpi_physical_address address,
 
 	/* Map just the table header */
 
-	mapped_table =
-	    acpi_os_map_memory(address, sizeof(struct acpi_table_header));
-	if (!mapped_table) {
+	table = acpi_os_map_memory(address, sizeof(struct acpi_table_header));
+	if (!table) {
+		ACPI_ERROR((AE_INFO,
+			    "Could not map memory for table [%s] at %p",
+			    signature, ACPI_CAST_PTR(void, address)));
 		return;
 	}
 
 	/* If a particular signature is expected (DSDT/FACS), it must match */
 
-	if (signature && !ACPI_COMPARE_NAME(mapped_table->signature, signature)) {
+	if (signature && !ACPI_COMPARE_NAME(table->signature, signature)) {
 		ACPI_ERROR((AE_INFO,
 			    "Invalid signature 0x%X for ACPI table, expected [%s]",
-			    *ACPI_CAST_PTR(u32, mapped_table->signature),
-			    signature));
+			    *ACPI_CAST_PTR(u32, table->signature), signature));
 		goto unmap_and_exit;
 	}
 
 	/*
+	 * Initialize the table entry. Set the pointer to NULL, since the
+	 * table is not fully mapped at this time.
+	 */
+	table_desc = &acpi_gbl_root_table_list.tables[table_index];
+
+	table_desc->address = address;
+	table_desc->pointer = NULL;
+	table_desc->length = table->length;
+	table_desc->flags = ACPI_TABLE_ORIGIN_MAPPED;
+	ACPI_MOVE_32_TO_32(table_desc->signature.ascii, table->signature);
+
+	/*
 	 * ACPI Table Override:
 	 *
 	 * Before we install the table, let the host OS override it with a new
 	 * one if desired. Any table within the RSDT/XSDT can be replaced,
 	 * including the DSDT which is pointed to by the FADT.
+	 *
+	 * NOTE: If the table is overridden, then final_table will contain a
+	 * mapped pointer to the full new table. If the table is not overridden,
+	 * or if there has been a physical override, then the table will be
+	 * fully mapped later (in verify table). In any case, we must
+	 * unmap the header that was mapped above.
 	 */
-	status = acpi_os_table_override(mapped_table, &override_table);
-	if (ACPI_SUCCESS(status) && override_table) {
-		ACPI_INFO((AE_INFO,
-			   "%4.4s @ 0x%p Table override, replaced with:",
-			   mapped_table->signature, ACPI_CAST_PTR(void,
-								  address)));
-
-		acpi_gbl_root_table_list.tables[table_index].pointer =
-		    override_table;
-		address = ACPI_PTR_TO_PHYSADDR(override_table);
-
-		table_to_install = override_table;
-		flags = ACPI_TABLE_ORIGIN_OVERRIDE;
-	} else {
-		table_to_install = mapped_table;
-		flags = ACPI_TABLE_ORIGIN_MAPPED;
+	final_table = acpi_tb_table_override(table, table_desc);
+	if (!final_table) {
+		final_table = table;	/* There was no override */
 	}
 
-	/* Initialize the table entry */
+	acpi_tb_print_table_header(table_desc->address, final_table);
 
-	acpi_gbl_root_table_list.tables[table_index].address = address;
-	acpi_gbl_root_table_list.tables[table_index].length =
-	    table_to_install->length;
-	acpi_gbl_root_table_list.tables[table_index].flags = flags;
-
-	ACPI_MOVE_32_TO_32(&
-			   (acpi_gbl_root_table_list.tables[table_index].
-			    signature), table_to_install->signature);
-
-	acpi_tb_print_table_header(address, table_to_install);
+	/* Set the global integer width (based upon revision of the DSDT) */
 
 	if (table_index == ACPI_TABLE_INDEX_DSDT) {
+		acpi_ut_set_integer_width(final_table->revision);
+	}
 
-		/* Global integer width is based upon revision of the DSDT */
-
-		acpi_ut_set_integer_width(table_to_install->revision);
+	/*
+	 * If we have a physical override during this early loading of the ACPI
+	 * tables, unmap the table for now. It will be mapped again later when
+	 * it is actually used. This supports very early loading of ACPI tables,
+	 * before virtual memory is fully initialized and running within the
+	 * host OS. Note: A logical override has the ACPI_TABLE_ORIGIN_OVERRIDE
+	 * flag set and will not be deleted below.
+	 */
+	if (final_table != table) {
+		acpi_tb_delete_table(table_desc);
 	}
 
       unmap_and_exit:
-	acpi_os_unmap_memory(mapped_table, sizeof(struct acpi_table_header));
+
+	/* Always unmap the table header that we mapped above */
+
+	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
 }
 
 /*******************************************************************************
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 1dea025..07d4264 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -554,6 +554,15 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 	return AE_OK;
 }
 
+acpi_status
+acpi_os_physical_table_override(struct acpi_table_header *existing_table,
+				acpi_physical_address * new_address,
+				u32 *new_table_length)
+{
+	return AE_SUPPORT;
+}
+
+
 static irqreturn_t acpi_irq(int irq, void *dev_id)
 {
 	u32 handled;
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 1cd2204..21a5548 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -95,6 +95,11 @@ acpi_status
 acpi_os_table_override(struct acpi_table_header *existing_table,
 		       struct acpi_table_header **new_table);
 
+acpi_status
+acpi_os_physical_table_override(struct acpi_table_header *existing_table,
+				acpi_physical_address * new_address,
+				u32 *new_table_length);
+
 /*
  * Spinlock primitives
  */
-- 
1.7.10.rc2.19.gfae9d

