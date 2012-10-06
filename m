Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2JFUO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:14:58 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60718 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2JFUOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:14:53 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 16/49] ACPICA: Table Manager: Merge duplicate code (root table)
Date: Sat,  6 Oct 2012 16:09:37 -0400
Message-Id: <2bc198c1527be998850ade8f91ec7d340b67fdf3.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

Merge/remove duplicate code in the root table resize functions
One function is external, the other is internal.  Lv Zheng,

ACPICA BZ 846:
https://acpica.org/bugzilla/show_bug.cgi?id=846

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/tbinstal.c | 20 +++++++++++++-------
 drivers/acpi/acpica/tbxface.c  | 41 +++++------------------------------------
 2 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index 74f97d7..70f9d78 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -350,6 +350,7 @@ struct acpi_table_header *acpi_tb_table_override(struct acpi_table_header
 acpi_status acpi_tb_resize_root_table_list(void)
 {
 	struct acpi_table_desc *tables;
+	u32 table_count;
 
 	ACPI_FUNCTION_TRACE(tb_resize_root_table_list);
 
@@ -363,8 +364,13 @@ acpi_status acpi_tb_resize_root_table_list(void)
 
 	/* Increase the Table Array size */
 
-	tables = ACPI_ALLOCATE_ZEROED(((acpi_size) acpi_gbl_root_table_list.
-				       max_table_count +
+	if (acpi_gbl_root_table_list.flags & ACPI_ROOT_ORIGIN_ALLOCATED) {
+		table_count = acpi_gbl_root_table_list.max_table_count;
+	} else {
+		table_count = acpi_gbl_root_table_list.current_table_count;
+	}
+
+	tables = ACPI_ALLOCATE_ZEROED(((acpi_size) table_count +
 				       ACPI_ROOT_TABLE_SIZE_INCREMENT) *
 				      sizeof(struct acpi_table_desc));
 	if (!tables) {
@@ -377,8 +383,8 @@ acpi_status acpi_tb_resize_root_table_list(void)
 
 	if (acpi_gbl_root_table_list.tables) {
 		ACPI_MEMCPY(tables, acpi_gbl_root_table_list.tables,
-			    (acpi_size) acpi_gbl_root_table_list.
-			    max_table_count * sizeof(struct acpi_table_desc));
+			    (acpi_size) table_count *
+			    sizeof(struct acpi_table_desc));
 
 		if (acpi_gbl_root_table_list.flags & ACPI_ROOT_ORIGIN_ALLOCATED) {
 			ACPI_FREE(acpi_gbl_root_table_list.tables);
@@ -386,9 +392,9 @@ acpi_status acpi_tb_resize_root_table_list(void)
 	}
 
 	acpi_gbl_root_table_list.tables = tables;
-	acpi_gbl_root_table_list.max_table_count +=
-	    ACPI_ROOT_TABLE_SIZE_INCREMENT;
-	acpi_gbl_root_table_list.flags |= (u8)ACPI_ROOT_ORIGIN_ALLOCATED;
+	acpi_gbl_root_table_list.max_table_count =
+	    table_count + ACPI_ROOT_TABLE_SIZE_INCREMENT;
+	acpi_gbl_root_table_list.flags |= ACPI_ROOT_ORIGIN_ALLOCATED;
 
 	return_ACPI_STATUS(AE_OK);
 }
diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index 29e51bc..2110126 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -159,14 +159,12 @@ acpi_initialize_tables(struct acpi_table_desc * initial_table_array,
  * DESCRIPTION: Reallocate Root Table List into dynamic memory. Copies the
  *              root list from the previously provided scratch area. Should
  *              be called once dynamic memory allocation is available in the
- *              kernel
+ *              kernel.
  *
  ******************************************************************************/
 acpi_status acpi_reallocate_root_table(void)
 {
-	struct acpi_table_desc *tables;
-	acpi_size new_size;
-	acpi_size current_size;
+	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_reallocate_root_table);
 
@@ -178,39 +176,10 @@ acpi_status acpi_reallocate_root_table(void)
 		return_ACPI_STATUS(AE_SUPPORT);
 	}
 
-	/*
-	 * Get the current size of the root table and add the default
-	 * increment to create the new table size.
-	 */
-	current_size = (acpi_size)
-	    acpi_gbl_root_table_list.current_table_count *
-	    sizeof(struct acpi_table_desc);
-
-	new_size = current_size +
-	    (ACPI_ROOT_TABLE_SIZE_INCREMENT * sizeof(struct acpi_table_desc));
-
-	/* Create new array and copy the old array */
-
-	tables = ACPI_ALLOCATE_ZEROED(new_size);
-	if (!tables) {
-		return_ACPI_STATUS(AE_NO_MEMORY);
-	}
+	acpi_gbl_root_table_list.flags |= ACPI_ROOT_ALLOW_RESIZE;
 
-	ACPI_MEMCPY(tables, acpi_gbl_root_table_list.tables, current_size);
-
-	/*
-	 * Update the root table descriptor. The new size will be the current
-	 * number of tables plus the increment, independent of the reserved
-	 * size of the original table list.
-	 */
-	acpi_gbl_root_table_list.tables = tables;
-	acpi_gbl_root_table_list.max_table_count =
-	    acpi_gbl_root_table_list.current_table_count +
-	    ACPI_ROOT_TABLE_SIZE_INCREMENT;
-	acpi_gbl_root_table_list.flags =
-	    ACPI_ROOT_ORIGIN_ALLOCATED | ACPI_ROOT_ALLOW_RESIZE;
-
-	return_ACPI_STATUS(AE_OK);
+	status = acpi_tb_resize_root_table_list();
+	return_ACPI_STATUS(status);
 }
 
 /*******************************************************************************
-- 
1.8.0.rc0.18.gf84667d

