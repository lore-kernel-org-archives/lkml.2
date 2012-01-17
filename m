Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2AQNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:25:58 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43625 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2AQNWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:13 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:13 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 07/50] ACPICA: Do not abort table load on invalid space ID
Date: Tue, 17 Jan 2012 07:20:59 -0500
Message-id: <ec4636669bf9c6ff157121ab42709650a9e0cc2a.1326802229.git.len.brown@intel.com>
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

From: Bob Moore <robert.moore@intel.com>

Ignore an invalid space ID during a table load. Instead, detect it
if a control method attempts access - then abort the method.

http://www.acpica.org/bugzilla/show_bug.cgi?id=925

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acinterp.h |    2 ++
 drivers/acpi/acpica/excreate.c |   23 +++++++++++++----------
 drivers/acpi/acpica/exfldio.c  |   16 ++++++++++++++--
 drivers/acpi/acpica/exutils.c  |   25 +++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpica/acinterp.h b/drivers/acpi/acpica/acinterp.h
index 3731e1c..4ee9058 100644
--- a/drivers/acpi/acpica/acinterp.h
+++ b/drivers/acpi/acpica/acinterp.h
@@ -468,6 +468,8 @@ void acpi_ex_eisa_id_to_string(char *dest, u64 compressed_id);
 
 void acpi_ex_integer_to_string(char *dest, u64 value);
 
+u8 acpi_is_valid_space_id(u8 space_id);
+
 /*
  * exregion - default op_region handlers
  */
diff --git a/drivers/acpi/acpica/excreate.c b/drivers/acpi/acpica/excreate.c
index 8a06dc5..c66562b 100644
--- a/drivers/acpi/acpica/excreate.c
+++ b/drivers/acpi/acpica/excreate.c
@@ -267,7 +267,7 @@ acpi_status acpi_ex_create_mutex(struct acpi_walk_state *walk_state)
  *
  * PARAMETERS:  aml_start           - Pointer to the region declaration AML
  *              aml_length          - Max length of the declaration AML
- *              region_space        - space_iD for the region
+ *              space_id            - Address space ID for the region
  *              walk_state          - Current state
  *
  * RETURN:      Status
@@ -279,7 +279,7 @@ acpi_status acpi_ex_create_mutex(struct acpi_walk_state *walk_state)
 acpi_status
 acpi_ex_create_region(u8 * aml_start,
 		      u32 aml_length,
-		      u8 region_space, struct acpi_walk_state *walk_state)
+		      u8 space_id, struct acpi_walk_state *walk_state)
 {
 	acpi_status status;
 	union acpi_operand_object *obj_desc;
@@ -304,16 +304,19 @@ acpi_ex_create_region(u8 * aml_start,
 	 * Space ID must be one of the predefined IDs, or in the user-defined
 	 * range
 	 */
-	if ((region_space >= ACPI_NUM_PREDEFINED_REGIONS) &&
-	    (region_space < ACPI_USER_REGION_BEGIN) &&
-	    (region_space != ACPI_ADR_SPACE_DATA_TABLE)) {
-		ACPI_ERROR((AE_INFO, "Invalid AddressSpace type 0x%X",
-			    region_space));
-		return_ACPI_STATUS(AE_AML_INVALID_SPACE_ID);
+	if (!acpi_is_valid_space_id(space_id)) {
+		/*
+		 * Print an error message, but continue. We don't want to abort
+		 * a table load for this exception. Instead, if the region is
+		 * actually used at runtime, abort the executing method.
+		 */
+		ACPI_ERROR((AE_INFO,
+			    "Invalid/unknown Address Space ID: 0x%2.2X",
+			    space_id));
 	}
 
 	ACPI_DEBUG_PRINT((ACPI_DB_LOAD, "Region Type - %s (0x%X)\n",
-			  acpi_ut_get_region_name(region_space), region_space));
+			  acpi_ut_get_region_name(space_id), space_id));
 
 	/* Create the region descriptor */
 
@@ -339,7 +342,7 @@ acpi_ex_create_region(u8 * aml_start,
 
 	/* Init the region from the operands */
 
-	obj_desc->region.space_id = region_space;
+	obj_desc->region.space_id = space_id;
 	obj_desc->region.address = 0;
 	obj_desc->region.length = 0;
 	obj_desc->region.node = node;
diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index 19df8ce..2a524fc 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -86,6 +86,7 @@ acpi_ex_setup_region(union acpi_operand_object *obj_desc,
 {
 	acpi_status status = AE_OK;
 	union acpi_operand_object *rgn_desc;
+	u8 space_id;
 
 	ACPI_FUNCTION_TRACE_U32(ex_setup_region, field_datum_byte_offset);
 
@@ -101,6 +102,17 @@ acpi_ex_setup_region(union acpi_operand_object *obj_desc,
 		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
 	}
 
+	space_id = rgn_desc->region.space_id;
+
+	/* Validate the Space ID */
+
+	if (!acpi_is_valid_space_id(space_id)) {
+		ACPI_ERROR((AE_INFO,
+			    "Invalid/unknown Address Space ID: 0x%2.2X",
+			    space_id));
+		return_ACPI_STATUS(AE_AML_INVALID_SPACE_ID);
+	}
+
 	/*
 	 * If the Region Address and Length have not been previously evaluated,
 	 * evaluate them now and save the results.
@@ -122,8 +134,8 @@ acpi_ex_setup_region(union acpi_operand_object *obj_desc,
 	 * Exit now for SMBus or IPMI address space, it has a non-linear
 	 * address space and the request cannot be directly validated
 	 */
-	if (rgn_desc->region.space_id == ACPI_ADR_SPACE_SMBUS ||
-	    rgn_desc->region.space_id == ACPI_ADR_SPACE_IPMI) {
+	if (space_id == ACPI_ADR_SPACE_SMBUS ||
+	    space_id == ACPI_ADR_SPACE_IPMI) {
 
 		/* SMBus or IPMI has a non-linear address space */
 
diff --git a/drivers/acpi/acpica/exutils.c b/drivers/acpi/acpica/exutils.c
index 8ad9314..3993aa5 100644
--- a/drivers/acpi/acpica/exutils.c
+++ b/drivers/acpi/acpica/exutils.c
@@ -435,4 +435,29 @@ void acpi_ex_integer_to_string(char *out_string, u64 value)
 	}
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_is_valid_space_id
+ *
+ * PARAMETERS:  space_id            - ID to be validated
+ *
+ * RETURN:      TRUE if valid/supported ID.
+ *
+ * DESCRIPTION: Validate an operation region space_iD.
+ *
+ ******************************************************************************/
+
+u8 acpi_is_valid_space_id(u8 space_id)
+{
+
+	if ((space_id >= ACPI_NUM_PREDEFINED_REGIONS) &&
+	    (space_id < ACPI_USER_REGION_BEGIN) &&
+	    (space_id != ACPI_ADR_SPACE_DATA_TABLE) &&
+	    (space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
+		return (FALSE);
+	}
+
+	return (TRUE);
+}
+
 #endif
-- 
1.7.9.rc1

