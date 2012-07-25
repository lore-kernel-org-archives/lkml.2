Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab2GYDqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:46:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab2GYDnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 42/52] ACPICA: Split file: tbxface.c -> tbxfload.c
Date: Tue, 24 Jul 2012 23:41:38 -0400
Message-Id: <d59b8ecd94ee6ab8c663fc187ed6acf8ffdd3b5d.1343187617.git.len.brown@intel.com>
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

Split out the table load functions in preparation for addition
of new interfaces.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/Makefile   |   1 +
 drivers/acpi/acpica/tbxface.c  | 165 +-------------------------------
 drivers/acpi/acpica/tbxfload.c | 211 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+), 164 deletions(-)
 create mode 100644 drivers/acpi/acpica/tbxfload.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index fa9a7d5..0a1b343 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -134,6 +134,7 @@ acpi-y +=		\
 	tbinstal.o	\
 	tbutils.o	\
 	tbxface.o	\
+	tbxfload.o	\
 	tbxfroot.o
 
 acpi-y +=		\
diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index abcc641..472a91c 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -1,7 +1,6 @@
 /******************************************************************************
  *
- * Module Name: tbxface - Public interfaces to the ACPI subsystem
- *                         ACPI table oriented interfaces
+ * Module Name: tbxface - ACPI table oriented external interfaces
  *
  *****************************************************************************/
 
@@ -51,11 +50,6 @@
 #define _COMPONENT          ACPI_TABLES
 ACPI_MODULE_NAME("tbxface")
 
-/* Local prototypes */
-static acpi_status acpi_tb_load_namespace(void);
-
-static int no_auto_ssdt;
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_allocate_root_table
@@ -69,7 +63,6 @@ static int no_auto_ssdt;
  *              acpi_initialize_tables.
  *
  ******************************************************************************/
-
 acpi_status acpi_allocate_root_table(u32 initial_table_count)
 {
 
@@ -502,150 +495,6 @@ acpi_get_table_by_index(u32 table_index, struct acpi_table_header **table)
 
 ACPI_EXPORT_SYMBOL(acpi_get_table_by_index)
 
-/*******************************************************************************
- *
- * FUNCTION:    acpi_tb_load_namespace
- *
- * PARAMETERS:  None
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Load the namespace from the DSDT and all SSDTs/PSDTs found in
- *              the RSDT/XSDT.
- *
- ******************************************************************************/
-static acpi_status acpi_tb_load_namespace(void)
-{
-	acpi_status status;
-	u32 i;
-	struct acpi_table_header *new_dsdt;
-
-	ACPI_FUNCTION_TRACE(tb_load_namespace);
-
-	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
-
-	/*
-	 * Load the namespace. The DSDT is required, but any SSDT and
-	 * PSDT tables are optional. Verify the DSDT.
-	 */
-	if (!acpi_gbl_root_table_list.current_table_count ||
-	    !ACPI_COMPARE_NAME(&
-			       (acpi_gbl_root_table_list.
-				tables[ACPI_TABLE_INDEX_DSDT].signature),
-			       ACPI_SIG_DSDT)
-	    ||
-	    ACPI_FAILURE(acpi_tb_verify_table
-			 (&acpi_gbl_root_table_list.
-			  tables[ACPI_TABLE_INDEX_DSDT]))) {
-		status = AE_NO_ACPI_TABLES;
-		goto unlock_and_exit;
-	}
-
-	/*
-	 * Save the DSDT pointer for simple access. This is the mapped memory
-	 * address. We must take care here because the address of the .Tables
-	 * array can change dynamically as tables are loaded at run-time. Note:
-	 * .Pointer field is not validated until after call to acpi_tb_verify_table.
-	 */
-	acpi_gbl_DSDT =
-	    acpi_gbl_root_table_list.tables[ACPI_TABLE_INDEX_DSDT].pointer;
-
-	/*
-	 * Optionally copy the entire DSDT to local memory (instead of simply
-	 * mapping it.) There are some BIOSs that corrupt or replace the original
-	 * DSDT, creating the need for this option. Default is FALSE, do not copy
-	 * the DSDT.
-	 */
-	if (acpi_gbl_copy_dsdt_locally) {
-		new_dsdt = acpi_tb_copy_dsdt(ACPI_TABLE_INDEX_DSDT);
-		if (new_dsdt) {
-			acpi_gbl_DSDT = new_dsdt;
-		}
-	}
-
-	/*
-	 * Save the original DSDT header for detection of table corruption
-	 * and/or replacement of the DSDT from outside the OS.
-	 */
-	ACPI_MEMCPY(&acpi_gbl_original_dsdt_header, acpi_gbl_DSDT,
-		    sizeof(struct acpi_table_header));
-
-	(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
-
-	/* Load and parse tables */
-
-	status = acpi_ns_load_table(ACPI_TABLE_INDEX_DSDT, acpi_gbl_root_node);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
-	/* Load any SSDT or PSDT tables. Note: Loop leaves tables locked */
-
-	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
-	for (i = 0; i < acpi_gbl_root_table_list.current_table_count; ++i) {
-		if ((!ACPI_COMPARE_NAME
-		     (&(acpi_gbl_root_table_list.tables[i].signature),
-		      ACPI_SIG_SSDT)
-		     &&
-		     !ACPI_COMPARE_NAME(&
-					(acpi_gbl_root_table_list.tables[i].
-					 signature), ACPI_SIG_PSDT))
-		    ||
-		    ACPI_FAILURE(acpi_tb_verify_table
-				 (&acpi_gbl_root_table_list.tables[i]))) {
-			continue;
-		}
-
-		if (no_auto_ssdt) {
-			printk(KERN_WARNING "ACPI: SSDT ignored due to \"acpi_no_auto_ssdt\"\n");
-			continue;
-		}
-
-		/* Ignore errors while loading tables, get as many as possible */
-
-		(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
-		(void)acpi_ns_load_table(i, acpi_gbl_root_node);
-		(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
-	}
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INIT, "ACPI Tables successfully acquired\n"));
-
-      unlock_and_exit:
-	(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
-	return_ACPI_STATUS(status);
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_load_tables
- *
- * PARAMETERS:  None
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Load the ACPI tables from the RSDT/XSDT
- *
- ******************************************************************************/
-
-acpi_status acpi_load_tables(void)
-{
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_load_tables);
-
-	/* Load the namespace from the tables */
-
-	status = acpi_tb_load_namespace();
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"While loading namespace from ACPI tables"));
-	}
-
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_load_tables)
-
 
 /*******************************************************************************
  *
@@ -734,15 +583,3 @@ acpi_status acpi_remove_table_handler(acpi_tbl_handler handler)
 }
 
 ACPI_EXPORT_SYMBOL(acpi_remove_table_handler)
-
-
-static int __init acpi_no_auto_ssdt_setup(char *s) {
-
-        printk(KERN_NOTICE "ACPI: SSDT auto-load disabled\n");
-
-        no_auto_ssdt = 1;
-
-        return 1;
-}
-
-__setup("acpi_no_auto_ssdt", acpi_no_auto_ssdt_setup);
diff --git a/drivers/acpi/acpica/tbxfload.c b/drivers/acpi/acpica/tbxfload.c
new file mode 100644
index 0000000..54a01ae
--- /dev/null
+++ b/drivers/acpi/acpica/tbxfload.c
@@ -0,0 +1,211 @@
+/******************************************************************************
+ *
+ * Module Name: tbxfload - Table load/unload external interfaces
+ *
+ *****************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2012, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <linux/export.h>
+#include <acpi/acpi.h>
+#include "accommon.h"
+#include "acnamesp.h"
+#include "actables.h"
+
+#define _COMPONENT          ACPI_TABLES
+ACPI_MODULE_NAME("tbxfload")
+
+/* Local prototypes */
+static acpi_status acpi_tb_load_namespace(void);
+
+static int no_auto_ssdt;
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_load_tables
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Load the ACPI tables from the RSDT/XSDT
+ *
+ ******************************************************************************/
+
+acpi_status acpi_load_tables(void)
+{
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_load_tables);
+
+	/* Load the namespace from the tables */
+
+	status = acpi_tb_load_namespace();
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status,
+				"While loading namespace from ACPI tables"));
+	}
+
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_load_tables)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_tb_load_namespace
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Load the namespace from the DSDT and all SSDTs/PSDTs found in
+ *              the RSDT/XSDT.
+ *
+ ******************************************************************************/
+static acpi_status acpi_tb_load_namespace(void)
+{
+	acpi_status status;
+	u32 i;
+	struct acpi_table_header *new_dsdt;
+
+	ACPI_FUNCTION_TRACE(tb_load_namespace);
+
+	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
+
+	/*
+	 * Load the namespace. The DSDT is required, but any SSDT and
+	 * PSDT tables are optional. Verify the DSDT.
+	 */
+	if (!acpi_gbl_root_table_list.current_table_count ||
+	    !ACPI_COMPARE_NAME(&
+			       (acpi_gbl_root_table_list.
+				tables[ACPI_TABLE_INDEX_DSDT].signature),
+			       ACPI_SIG_DSDT)
+	    ||
+	    ACPI_FAILURE(acpi_tb_verify_table
+			 (&acpi_gbl_root_table_list.
+			  tables[ACPI_TABLE_INDEX_DSDT]))) {
+		status = AE_NO_ACPI_TABLES;
+		goto unlock_and_exit;
+	}
+
+	/*
+	 * Save the DSDT pointer for simple access. This is the mapped memory
+	 * address. We must take care here because the address of the .Tables
+	 * array can change dynamically as tables are loaded at run-time. Note:
+	 * .Pointer field is not validated until after call to acpi_tb_verify_table.
+	 */
+	acpi_gbl_DSDT =
+	    acpi_gbl_root_table_list.tables[ACPI_TABLE_INDEX_DSDT].pointer;
+
+	/*
+	 * Optionally copy the entire DSDT to local memory (instead of simply
+	 * mapping it.) There are some BIOSs that corrupt or replace the original
+	 * DSDT, creating the need for this option. Default is FALSE, do not copy
+	 * the DSDT.
+	 */
+	if (acpi_gbl_copy_dsdt_locally) {
+		new_dsdt = acpi_tb_copy_dsdt(ACPI_TABLE_INDEX_DSDT);
+		if (new_dsdt) {
+			acpi_gbl_DSDT = new_dsdt;
+		}
+	}
+
+	/*
+	 * Save the original DSDT header for detection of table corruption
+	 * and/or replacement of the DSDT from outside the OS.
+	 */
+	ACPI_MEMCPY(&acpi_gbl_original_dsdt_header, acpi_gbl_DSDT,
+		    sizeof(struct acpi_table_header));
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
+
+	/* Load and parse tables */
+
+	status = acpi_ns_load_table(ACPI_TABLE_INDEX_DSDT, acpi_gbl_root_node);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Load any SSDT or PSDT tables. Note: Loop leaves tables locked */
+
+	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
+	for (i = 0; i < acpi_gbl_root_table_list.current_table_count; ++i) {
+		if ((!ACPI_COMPARE_NAME
+		     (&(acpi_gbl_root_table_list.tables[i].signature),
+		      ACPI_SIG_SSDT)
+		     &&
+		     !ACPI_COMPARE_NAME(&
+					(acpi_gbl_root_table_list.tables[i].
+					 signature), ACPI_SIG_PSDT))
+		    ||
+		    ACPI_FAILURE(acpi_tb_verify_table
+				 (&acpi_gbl_root_table_list.tables[i]))) {
+			continue;
+		}
+
+		if (no_auto_ssdt) {
+			printk(KERN_WARNING "ACPI: SSDT ignored due to \"acpi_no_auto_ssdt\"\n");
+			continue;
+		}
+
+		/* Ignore errors while loading tables, get as many as possible */
+
+		(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
+		(void)acpi_ns_load_table(i, acpi_gbl_root_node);
+		(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
+	}
+
+	ACPI_DEBUG_PRINT((ACPI_DB_INIT, "ACPI Tables successfully acquired\n"));
+
+      unlock_and_exit:
+	(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
+	return_ACPI_STATUS(status);
+}
+
+static int __init acpi_no_auto_ssdt_setup(char *s) {
+
+        printk(KERN_NOTICE "ACPI: SSDT auto-load disabled\n");
+
+        no_auto_ssdt = 1;
+
+        return 1;
+}
+
+__setup("acpi_no_auto_ssdt", acpi_no_auto_ssdt_setup);
-- 
1.7.12.rc0

