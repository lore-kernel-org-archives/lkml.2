Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2GYDrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:47:48 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43079 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab2GYDnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:14 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 39/52] ACPICA: Table manager: deploy new firmware error/warning interfaces
Date: Tue, 24 Jul 2012 23:41:35 -0400
Message-Id: <3b3ea7759ce484fffce387cf20a2dd39d1be3858.1343187617.git.len.brown@intel.com>
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

Emit firmware error/warning messages where appropriate for table
and FADT errors.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/tbfadt.c   | 102 +++++++++++++++++++++--------------------
 drivers/acpi/acpica/tbinstal.c |  15 +++---
 drivers/acpi/acpica/tbutils.c  |  34 ++++++++------
 drivers/acpi/acpica/tbxfroot.c |   2 +-
 4 files changed, 80 insertions(+), 73 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index d919f40..b3e3fd03 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -303,11 +303,11 @@ void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 	 * a warning.
 	 */
 	if (length > sizeof(struct acpi_table_fadt)) {
-		ACPI_WARNING((AE_INFO,
-			      "FADT (revision %u) is longer than ACPI 5.0 version, "
-			      "truncating length %u to %u",
-			      table->revision, length,
-			      (u32)sizeof(struct acpi_table_fadt)));
+		ACPI_BIOS_WARNING((AE_INFO,
+				   "FADT (revision %u) is longer than ACPI 5.0 version, "
+				   "truncating length %u to %u",
+				   table->revision, length,
+				   (u32)sizeof(struct acpi_table_fadt)));
 	}
 
 	/* Clear the entire local FADT */
@@ -452,11 +452,13 @@ static void acpi_tb_convert_fadt(void)
 		 * they must match.
 		 */
 		if (address64->address && address32 &&
-		    (address64->address != (u64) address32)) {
-			ACPI_ERROR((AE_INFO,
-				    "32/64X address mismatch in %s: 0x%8.8X/0x%8.8X%8.8X, using 32",
-				    fadt_info_table[i].name, address32,
-				    ACPI_FORMAT_UINT64(address64->address)));
+		    (address64->address != (u64)address32)) {
+			ACPI_BIOS_ERROR((AE_INFO,
+					 "32/64X address mismatch in FADT/%s: "
+					 "0x%8.8X/0x%8.8X%8.8X, using 32",
+					 fadt_info_table[i].name, address32,
+					 ACPI_FORMAT_UINT64(address64->
+							    address)));
 		}
 
 		/* Always use 32-bit address if it is valid (non-null) */
@@ -511,25 +513,25 @@ static void acpi_tb_validate_fadt(void)
 	 * DSDT/X_DSDT) would indicate the presence of two FACS or two DSDT tables.
 	 */
 	if (acpi_gbl_FADT.facs &&
-	    (acpi_gbl_FADT.Xfacs != (u64) acpi_gbl_FADT.facs)) {
-		ACPI_WARNING((AE_INFO,
-			      "32/64X FACS address mismatch in FADT - "
-			      "0x%8.8X/0x%8.8X%8.8X, using 32",
-			      acpi_gbl_FADT.facs,
-			      ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xfacs)));
-
-		acpi_gbl_FADT.Xfacs = (u64) acpi_gbl_FADT.facs;
+	    (acpi_gbl_FADT.Xfacs != (u64)acpi_gbl_FADT.facs)) {
+		ACPI_BIOS_WARNING((AE_INFO,
+				   "32/64X FACS address mismatch in FADT - "
+				   "0x%8.8X/0x%8.8X%8.8X, using 32",
+				   acpi_gbl_FADT.facs,
+				   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xfacs)));
+
+		acpi_gbl_FADT.Xfacs = (u64)acpi_gbl_FADT.facs;
 	}
 
 	if (acpi_gbl_FADT.dsdt &&
-	    (acpi_gbl_FADT.Xdsdt != (u64) acpi_gbl_FADT.dsdt)) {
-		ACPI_WARNING((AE_INFO,
-			      "32/64X DSDT address mismatch in FADT - "
-			      "0x%8.8X/0x%8.8X%8.8X, using 32",
-			      acpi_gbl_FADT.dsdt,
-			      ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xdsdt)));
-
-		acpi_gbl_FADT.Xdsdt = (u64) acpi_gbl_FADT.dsdt;
+	    (acpi_gbl_FADT.Xdsdt != (u64)acpi_gbl_FADT.dsdt)) {
+		ACPI_BIOS_WARNING((AE_INFO,
+				   "32/64X DSDT address mismatch in FADT - "
+				   "0x%8.8X/0x%8.8X%8.8X, using 32",
+				   acpi_gbl_FADT.dsdt,
+				   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xdsdt)));
+
+		acpi_gbl_FADT.Xdsdt = (u64)acpi_gbl_FADT.dsdt;
 	}
 
 	/* If Hardware Reduced flag is set, we are all done */
@@ -559,10 +561,10 @@ static void acpi_tb_validate_fadt(void)
 		 */
 		if (address64->address &&
 		    (address64->bit_width != ACPI_MUL_8(length))) {
-			ACPI_WARNING((AE_INFO,
-				      "32/64X length mismatch in %s: %u/%u",
-				      name, ACPI_MUL_8(length),
-				      address64->bit_width));
+			ACPI_BIOS_WARNING((AE_INFO,
+					   "32/64X length mismatch in FADT/%s: %u/%u",
+					   name, ACPI_MUL_8(length),
+					   address64->bit_width));
 		}
 
 		if (fadt_info_table[i].type & ACPI_FADT_REQUIRED) {
@@ -571,13 +573,13 @@ static void acpi_tb_validate_fadt(void)
 			 * Both the address and length must be non-zero.
 			 */
 			if (!address64->address || !length) {
-				ACPI_ERROR((AE_INFO,
-					    "Required field %s has zero address and/or length:"
-					    " 0x%8.8X%8.8X/0x%X",
-					    name,
-					    ACPI_FORMAT_UINT64(address64->
-							       address),
-					    length));
+				ACPI_BIOS_ERROR((AE_INFO,
+						 "Required FADT field %s has zero address and/or length: "
+						 "0x%8.8X%8.8X/0x%X",
+						 name,
+						 ACPI_FORMAT_UINT64(address64->
+								    address),
+						 length));
 			}
 		} else if (fadt_info_table[i].type & ACPI_FADT_SEPARATE_LENGTH) {
 			/*
@@ -587,13 +589,13 @@ static void acpi_tb_validate_fadt(void)
 			 */
 			if ((address64->address && !length) ||
 			    (!address64->address && length)) {
-				ACPI_WARNING((AE_INFO,
-					      "Optional field %s has zero address or length: "
-					      "0x%8.8X%8.8X/0x%X",
-					      name,
-					      ACPI_FORMAT_UINT64(address64->
-								 address),
-					      length));
+				ACPI_BIOS_WARNING((AE_INFO,
+						   "Optional FADT field %s has zero address or length: "
+						   "0x%8.8X%8.8X/0x%X",
+						   name,
+						   ACPI_FORMAT_UINT64
+						   (address64->address),
+						   length));
 			}
 		}
 	}
@@ -638,12 +640,12 @@ static void acpi_tb_setup_fadt_registers(void)
 			    (fadt_info_table[i].default_length > 0) &&
 			    (fadt_info_table[i].default_length !=
 			     target64->bit_width)) {
-				ACPI_WARNING((AE_INFO,
-					      "Invalid length for %s: %u, using default %u",
-					      fadt_info_table[i].name,
-					      target64->bit_width,
-					      fadt_info_table[i].
-					      default_length));
+				ACPI_BIOS_WARNING((AE_INFO,
+						   "Invalid length for FADT/%s: %u, using default %u",
+						   fadt_info_table[i].name,
+						   target64->bit_width,
+						   fadt_info_table[i].
+						   default_length));
 
 				/* Incorrect size, set width to the default */
 
diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index c03500b..a265d4a 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -138,13 +138,14 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 	if ((table_desc->pointer->signature[0] != 0x00) &&
 	    (!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_SSDT))
 	    && (ACPI_STRNCMP(table_desc->pointer->signature, "OEM", 3))) {
-		ACPI_ERROR((AE_INFO,
-			    "Table has invalid signature [%4.4s] (0x%8.8X), must be SSDT or OEMx",
-			    acpi_ut_valid_acpi_name(*(u32 *)table_desc->
-						    pointer->
-						    signature) ? table_desc->
-			    pointer->signature : "????",
-			    *(u32 *)table_desc->pointer->signature));
+		ACPI_BIOS_ERROR((AE_INFO,
+				 "Table has invalid signature [%4.4s] (0x%8.8X), "
+				 "must be SSDT or OEMx",
+				 acpi_ut_valid_acpi_name(*(u32 *)table_desc->
+							 pointer->
+							 signature) ?
+				 table_desc->pointer->signature : "????",
+				 *(u32 *)table_desc->pointer->signature));
 
 		return_ACPI_STATUS(AE_BAD_SIGNATURE);
 	}
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 0a706ca..6818b31 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -317,10 +317,11 @@ acpi_status acpi_tb_verify_checksum(struct acpi_table_header *table, u32 length)
 	/* Checksum ok? (should be zero) */
 
 	if (checksum) {
-		ACPI_WARNING((AE_INFO,
-			      "Incorrect checksum in table [%4.4s] - 0x%2.2X, should be 0x%2.2X",
-			      table->signature, table->checksum,
-			      (u8) (table->checksum - checksum)));
+		ACPI_BIOS_WARNING((AE_INFO,
+				   "Incorrect checksum in table [%4.4s] - 0x%2.2X, "
+				   "should be 0x%2.2X",
+				   table->signature, table->checksum,
+				   (u8)(table->checksum - checksum)));
 
 #if (ACPI_CHECKSUM_ABORT)
 
@@ -377,8 +378,9 @@ void acpi_tb_check_dsdt_header(void)
 
 	if (acpi_gbl_original_dsdt_header.length != acpi_gbl_DSDT->length ||
 	    acpi_gbl_original_dsdt_header.checksum != acpi_gbl_DSDT->checksum) {
-		ACPI_ERROR((AE_INFO,
-			    "The DSDT has been corrupted or replaced - old, new headers below"));
+		ACPI_BIOS_ERROR((AE_INFO,
+				 "The DSDT has been corrupted or replaced - "
+				 "old, new headers below"));
 		acpi_tb_print_table_header(0, &acpi_gbl_original_dsdt_header);
 		acpi_tb_print_table_header(0, acpi_gbl_DSDT);
 
@@ -480,9 +482,10 @@ acpi_tb_install_table(acpi_physical_address address,
 	/* If a particular signature is expected (DSDT/FACS), it must match */
 
 	if (signature && !ACPI_COMPARE_NAME(table->signature, signature)) {
-		ACPI_ERROR((AE_INFO,
-			    "Invalid signature 0x%X for ACPI table, expected [%s]",
-			    *ACPI_CAST_PTR(u32, table->signature), signature));
+		ACPI_BIOS_ERROR((AE_INFO,
+				 "Invalid signature 0x%X for ACPI table, expected [%s]",
+				 *ACPI_CAST_PTR(u32, table->signature),
+				 signature));
 		goto unmap_and_exit;
 	}
 
@@ -589,10 +592,10 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size)
 
 			/* Will truncate 64-bit address to 32 bits, issue warning */
 
-			ACPI_WARNING((AE_INFO,
-				      "64-bit Physical Address in XSDT is too large (0x%8.8X%8.8X),"
-				      " truncating",
-				      ACPI_FORMAT_UINT64(address64)));
+			ACPI_BIOS_WARNING((AE_INFO,
+					   "64-bit Physical Address in XSDT is too large (0x%8.8X%8.8X),"
+					   " truncating",
+					   ACPI_FORMAT_UINT64(address64)));
 		}
 #endif
 		return ((acpi_physical_address) (address64));
@@ -694,8 +697,9 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
 
 	if (length < sizeof(struct acpi_table_header)) {
-		ACPI_ERROR((AE_INFO, "Invalid length 0x%X in RSDT/XSDT",
-			    length));
+		ACPI_BIOS_ERROR((AE_INFO,
+				 "Invalid table length 0x%X in RSDT/XSDT",
+				 length));
 		return_ACPI_STATUS(AE_INVALID_TABLE_LENGTH);
 	}
 
diff --git a/drivers/acpi/acpica/tbxfroot.c b/drivers/acpi/acpica/tbxfroot.c
index 4258f64..5f6f744 100644
--- a/drivers/acpi/acpica/tbxfroot.c
+++ b/drivers/acpi/acpica/tbxfroot.c
@@ -216,7 +216,7 @@ acpi_status acpi_find_root_pointer(acpi_size *table_address)
 
 	/* A valid RSDP was not found */
 
-	ACPI_ERROR((AE_INFO, "A valid RSDP was not found"));
+	ACPI_BIOS_ERROR((AE_INFO, "A valid RSDP was not found"));
 	return_ACPI_STATUS(AE_NOT_FOUND);
 }
 
-- 
1.7.12.rc0

