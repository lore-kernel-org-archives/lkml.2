Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2AQMWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:18 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:39447 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2AQMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:05 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 13/50] ACPI 5.0: Support for GeneralPurposeIo and
 GenericSerialBus operation region
Date: Tue, 17 Jan 2012 07:21:05 -0500
Message-id: <2da120b6847f85c406f9afa13853e2755684389e.1326802229.git.len.brown@intel.com>
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

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acconfig.h |    3 ++-
 drivers/acpi/acpica/amlcode.h  |   17 ++++++++++-------
 drivers/acpi/acpica/exfield.c  |   28 +++++++++++++++++++++-------
 drivers/acpi/acpica/exfldio.c  |    3 ++-
 drivers/acpi/acpica/utdecode.c |    4 +++-
 include/acpi/actypes.h         |    4 +++-
 6 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/acpica/acconfig.h b/drivers/acpi/acpica/acconfig.h
index f895a24..f467d49 100644
--- a/drivers/acpi/acpica/acconfig.h
+++ b/drivers/acpi/acpica/acconfig.h
@@ -202,9 +202,10 @@
 #define ACPI_RSDP_CHECKSUM_LENGTH       20
 #define ACPI_RSDP_XCHECKSUM_LENGTH      36
 
-/* SMBus and IPMI bidirectional buffer size */
+/* SMBus, GSBus and IPMI bidirectional buffer size */
 
 #define ACPI_SMBUS_BUFFER_SIZE          34
+#define ACPI_GSBUS_BUFFER_SIZE          34
 #define ACPI_IPMI_BUFFER_SIZE           66
 
 /* _sx_d and _sx_w control methods */
diff --git a/drivers/acpi/acpica/amlcode.h b/drivers/acpi/acpica/amlcode.h
index adf7a71..c7db80e 100644
--- a/drivers/acpi/acpica/amlcode.h
+++ b/drivers/acpi/acpica/amlcode.h
@@ -466,13 +466,16 @@ typedef enum {
  * access_as keyword
  */
 typedef enum {
-	AML_FIELD_ATTRIB_SMB_QUICK = 0x02,
-	AML_FIELD_ATTRIB_SMB_SEND_RCV = 0x04,
-	AML_FIELD_ATTRIB_SMB_BYTE = 0x06,
-	AML_FIELD_ATTRIB_SMB_WORD = 0x08,
-	AML_FIELD_ATTRIB_SMB_BLOCK = 0x0A,
-	AML_FIELD_ATTRIB_SMB_WORD_CALL = 0x0C,
-	AML_FIELD_ATTRIB_SMB_BLOCK_CALL = 0x0D
+	AML_FIELD_ATTRIB_QUICK = 0x02,
+	AML_FIELD_ATTRIB_SEND_RCV = 0x04,
+	AML_FIELD_ATTRIB_BYTE = 0x06,
+	AML_FIELD_ATTRIB_WORD = 0x08,
+	AML_FIELD_ATTRIB_BLOCK = 0x0A,
+	AML_FIELD_ATTRIB_MULTIBYTE = 0x0B,
+	AML_FIELD_ATTRIB_WORD_CALL = 0x0C,
+	AML_FIELD_ATTRIB_BLOCK_CALL = 0x0D,
+	AML_FIELD_ATTRIB_RAW_BYTES = 0x0E,
+	AML_FIELD_ATTRIB_RAW_PROCESS = 0x0F
 } AML_ACCESS_ATTRIBUTE;
 
 /* Bit fields in the AML method_flags byte */
diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index 0bde223..3aeec02 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -100,18 +100,25 @@ acpi_ex_read_data_from_field(struct acpi_walk_state *walk_state,
 		   (obj_desc->field.region_obj->region.space_id ==
 		    ACPI_ADR_SPACE_SMBUS
 		    || obj_desc->field.region_obj->region.space_id ==
+		    ACPI_ADR_SPACE_GSBUS
+		    || obj_desc->field.region_obj->region.space_id ==
 		    ACPI_ADR_SPACE_IPMI)) {
 		/*
-		 * This is an SMBus or IPMI read. We must create a buffer to hold
+		 * This is an SMBus, GSBus or IPMI read. We must create a buffer to hold
 		 * the data and then directly access the region handler.
 		 *
-		 * Note: Smbus protocol value is passed in upper 16-bits of Function
+		 * Note: SMBus and GSBus protocol value is passed in upper 16-bits of Function
 		 */
 		if (obj_desc->field.region_obj->region.space_id ==
 		    ACPI_ADR_SPACE_SMBUS) {
 			length = ACPI_SMBUS_BUFFER_SIZE;
 			function =
 			    ACPI_READ | (obj_desc->field.attribute << 16);
+		} else if (obj_desc->field.region_obj->region.space_id ==
+			   ACPI_ADR_SPACE_GSBUS) {
+			length = ACPI_GSBUS_BUFFER_SIZE;
+			function =
+			    ACPI_READ | (obj_desc->field.attribute << 16);
 		} else {	/* IPMI */
 
 			length = ACPI_IPMI_BUFFER_SIZE;
@@ -248,21 +255,23 @@ acpi_ex_write_data_to_field(union acpi_operand_object *source_desc,
 		   (obj_desc->field.region_obj->region.space_id ==
 		    ACPI_ADR_SPACE_SMBUS
 		    || obj_desc->field.region_obj->region.space_id ==
+		    ACPI_ADR_SPACE_GSBUS
+		    || obj_desc->field.region_obj->region.space_id ==
 		    ACPI_ADR_SPACE_IPMI)) {
 		/*
-		 * This is an SMBus or IPMI write. We will bypass the entire field
+		 * This is an SMBus, GSBus or IPMI write. We will bypass the entire field
 		 * mechanism and handoff the buffer directly to the handler. For
 		 * these address spaces, the buffer is bi-directional; on a write,
 		 * return data is returned in the same buffer.
 		 *
 		 * Source must be a buffer of sufficient size:
-		 * ACPI_SMBUS_BUFFER_SIZE or ACPI_IPMI_BUFFER_SIZE.
+		 * ACPI_SMBUS_BUFFER_SIZE, ACPI_GSBUS_BUFFER_SIZE, or ACPI_IPMI_BUFFER_SIZE.
 		 *
-		 * Note: SMBus protocol type is passed in upper 16-bits of Function
+		 * Note: SMBus and GSBus protocol type is passed in upper 16-bits of Function
 		 */
 		if (source_desc->common.type != ACPI_TYPE_BUFFER) {
 			ACPI_ERROR((AE_INFO,
-				    "SMBus or IPMI write requires Buffer, found type %s",
+				    "SMBus/IPMI/GenericSerialBus write requires Buffer, found type %s",
 				    acpi_ut_get_object_type_name(source_desc)));
 
 			return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
@@ -273,6 +282,11 @@ acpi_ex_write_data_to_field(union acpi_operand_object *source_desc,
 			length = ACPI_SMBUS_BUFFER_SIZE;
 			function =
 			    ACPI_WRITE | (obj_desc->field.attribute << 16);
+		} else if (obj_desc->field.region_obj->region.space_id ==
+			   ACPI_ADR_SPACE_GSBUS) {
+			length = ACPI_GSBUS_BUFFER_SIZE;
+			function =
+			    ACPI_WRITE | (obj_desc->field.attribute << 16);
 		} else {	/* IPMI */
 
 			length = ACPI_IPMI_BUFFER_SIZE;
@@ -281,7 +295,7 @@ acpi_ex_write_data_to_field(union acpi_operand_object *source_desc,
 
 		if (source_desc->buffer.length < length) {
 			ACPI_ERROR((AE_INFO,
-				    "SMBus or IPMI write requires Buffer of length %u, found length %u",
+				    "SMBus/IPMI/GenericSerialBus write requires Buffer of length %u, found length %u",
 				    length, source_desc->buffer.length));
 
 			return_ACPI_STATUS(AE_AML_BUFFER_LIMIT);
diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index cc9c5df..5b76c11 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -131,10 +131,11 @@ acpi_ex_setup_region(union acpi_operand_object *obj_desc,
 	}
 
 	/*
-	 * Exit now for SMBus or IPMI address space, it has a non-linear
+	 * Exit now for SMBus, GSBus or IPMI address space, it has a non-linear
 	 * address space and the request cannot be directly validated
 	 */
 	if (space_id == ACPI_ADR_SPACE_SMBUS ||
+	    space_id == ACPI_ADR_SPACE_GSBUS ||
 	    space_id == ACPI_ADR_SPACE_IPMI) {
 
 		/* SMBus or IPMI has a non-linear address space */
diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
index 8b087e2..6fd56d5 100644
--- a/drivers/acpi/acpica/utdecode.c
+++ b/drivers/acpi/acpica/utdecode.c
@@ -171,7 +171,9 @@ const char *acpi_gbl_region_types[ACPI_NUM_PREDEFINED_REGIONS] = {
 	"SMBus",
 	"SystemCMOS",
 	"PCIBARTarget",
-	"IPMI"
+	"IPMI",
+	"GeneralPurposeIo",
+	"GenericSerialBus"
 };
 
 char *acpi_ut_get_region_name(u8 space_id)
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index d088c90..d5dee7c 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -712,8 +712,10 @@ typedef u8 acpi_adr_space_type;
 #define ACPI_ADR_SPACE_CMOS             (acpi_adr_space_type) 5
 #define ACPI_ADR_SPACE_PCI_BAR_TARGET   (acpi_adr_space_type) 6
 #define ACPI_ADR_SPACE_IPMI             (acpi_adr_space_type) 7
+#define ACPI_ADR_SPACE_GPIO             (acpi_adr_space_type) 8
+#define ACPI_ADR_SPACE_GSBUS            (acpi_adr_space_type) 9
 
-#define ACPI_NUM_PREDEFINED_REGIONS     8
+#define ACPI_NUM_PREDEFINED_REGIONS     10
 
 /*
  * Special Address Spaces
-- 
1.7.9.rc1

