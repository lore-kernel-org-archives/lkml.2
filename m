Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2AQN0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:26:35 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:42929 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2AQNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:07 -0500
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:06 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 12/50] ACPI 5.0: Implement Connection() and AccessAs() changes
Date: Tue, 17 Jan 2012 07:21:04 -0500
Message-id: <9ce81784c9c0396a6a6be05248928a71134fe60b.1326802229.git.len.brown@intel.com>
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

Support within the interpreter and operation region dispatch.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acevents.h |    1 +
 drivers/acpi/acpica/aclocal.h  |    6 ++-
 drivers/acpi/acpica/acobject.h |    5 +-
 drivers/acpi/acpica/acopcode.h |    4 +
 drivers/acpi/acpica/amlcode.h  |   10 +++
 drivers/acpi/acpica/dsfield.c  |   81 +++++++++++++++++++----
 drivers/acpi/acpica/evregion.c |   29 +++++++-
 drivers/acpi/acpica/exconfig.c |    6 +-
 drivers/acpi/acpica/exdump.c   |    7 ++-
 drivers/acpi/acpica/exfldio.c  |   11 ++--
 drivers/acpi/acpica/exprep.c   |   25 +++++++
 drivers/acpi/acpica/psargs.c   |  141 ++++++++++++++++++++++++++++++++++++----
 drivers/acpi/acpica/psopcode.c |   13 +++-
 drivers/acpi/acpica/pstree.c   |    6 ++
 include/acpi/actypes.h         |    8 ++
 15 files changed, 308 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index bea3b48..f763b88 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -162,6 +162,7 @@ acpi_status acpi_ev_initialize_op_regions(void);
 
 acpi_status
 acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
+			       union acpi_operand_object *field_obj,
 			       u32 function,
 			       u32 region_offset, u32 bit_width, u64 *value);
 
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 5552125..52c4ebd 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -53,7 +53,7 @@ typedef u32 acpi_mutex_handle;
 
 /* Total number of aml opcodes defined */
 
-#define AML_NUM_OPCODES                 0x7F
+#define AML_NUM_OPCODES                 0x81
 
 /* Forward declarations */
 
@@ -249,12 +249,16 @@ struct acpi_create_field_info {
 	struct acpi_namespace_node *field_node;
 	struct acpi_namespace_node *register_node;
 	struct acpi_namespace_node *data_register_node;
+	struct acpi_namespace_node *connection_node;
+	u8 *resource_buffer;
 	u32 bank_value;
 	u32 field_bit_position;
 	u32 field_bit_length;
+	u16 resource_length;
 	u8 field_flags;
 	u8 attribute;
 	u8 field_type;
+	u8 access_length;
 };
 
 typedef
diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index 6d276c2..435dd2f 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -254,6 +254,7 @@ ACPI_OBJECT_COMMON_HEADER ACPI_COMMON_NOTIFY_INFO};
 	u32                             base_byte_offset;   /* Byte offset within containing object */\
 	u32                             value;              /* Value to store into the Bank or Index register */\
 	u8                              start_field_bit_offset;/* Bit offset within first field datum (0-63) */\
+	u8                              access_length;	/* For serial regions/fields */
 
 
 struct acpi_object_field_common {	/* COMMON FIELD (for BUFFER, REGION, BANK, and INDEX fields) */
@@ -261,7 +262,9 @@ struct acpi_object_field_common {	/* COMMON FIELD (for BUFFER, REGION, BANK, and
 };
 
 struct acpi_object_region_field {
-	ACPI_OBJECT_COMMON_HEADER ACPI_COMMON_FIELD_INFO union acpi_operand_object *region_obj;	/* Containing op_region object */
+	ACPI_OBJECT_COMMON_HEADER ACPI_COMMON_FIELD_INFO u16 resource_length;
+	union acpi_operand_object *region_obj;	/* Containing op_region object */
+	u8 *resource_buffer;	/* resource_template for serial regions/fields */
 };
 
 struct acpi_object_bank_field {
diff --git a/drivers/acpi/acpica/acopcode.h b/drivers/acpi/acpica/acopcode.h
index bb2ccfa..9896c77 100644
--- a/drivers/acpi/acpica/acopcode.h
+++ b/drivers/acpi/acpica/acopcode.h
@@ -93,6 +93,7 @@
 #define ARGP_CONCAT_OP                  ARGP_LIST3 (ARGP_TERMARG,    ARGP_TERMARG,       ARGP_TARGET)
 #define ARGP_CONCAT_RES_OP              ARGP_LIST3 (ARGP_TERMARG,    ARGP_TERMARG,       ARGP_TARGET)
 #define ARGP_COND_REF_OF_OP             ARGP_LIST2 (ARGP_SUPERNAME,  ARGP_SUPERNAME)
+#define ARGP_CONNECTFIELD_OP            ARGP_LIST1 (ARGP_NAMESTRING)
 #define ARGP_CONTINUE_OP                ARG_NONE
 #define ARGP_COPY_OP                    ARGP_LIST2 (ARGP_TERMARG,    ARGP_SIMPLENAME)
 #define ARGP_CREATE_BIT_FIELD_OP        ARGP_LIST3 (ARGP_TERMARG,    ARGP_TERMARG,       ARGP_NAME)
@@ -164,6 +165,7 @@
 #define ARGP_RETURN_OP                  ARGP_LIST1 (ARGP_TERMARG)
 #define ARGP_REVISION_OP                ARG_NONE
 #define ARGP_SCOPE_OP                   ARGP_LIST3 (ARGP_PKGLENGTH,  ARGP_NAME,          ARGP_TERMLIST)
+#define ARGP_SERIALFIELD_OP             ARGP_LIST1 (ARGP_NAMESTRING)
 #define ARGP_SHIFT_LEFT_OP              ARGP_LIST3 (ARGP_TERMARG,    ARGP_TERMARG,       ARGP_TARGET)
 #define ARGP_SHIFT_RIGHT_OP             ARGP_LIST3 (ARGP_TERMARG,    ARGP_TERMARG,       ARGP_TARGET)
 #define ARGP_SIGNAL_OP                  ARGP_LIST1 (ARGP_SUPERNAME)
@@ -223,6 +225,7 @@
 #define ARGI_CONCAT_OP                  ARGI_LIST3 (ARGI_COMPUTEDATA,ARGI_COMPUTEDATA,   ARGI_TARGETREF)
 #define ARGI_CONCAT_RES_OP              ARGI_LIST3 (ARGI_BUFFER,     ARGI_BUFFER,        ARGI_TARGETREF)
 #define ARGI_COND_REF_OF_OP             ARGI_LIST2 (ARGI_OBJECT_REF, ARGI_TARGETREF)
+#define ARGI_CONNECTFIELD_OP            ARGI_INVALID_OPCODE
 #define ARGI_CONTINUE_OP                ARGI_INVALID_OPCODE
 #define ARGI_COPY_OP                    ARGI_LIST2 (ARGI_ANYTYPE,    ARGI_SIMPLE_TARGET)
 #define ARGI_CREATE_BIT_FIELD_OP        ARGI_LIST3 (ARGI_BUFFER,     ARGI_INTEGER,       ARGI_REFERENCE)
@@ -294,6 +297,7 @@
 #define ARGI_RETURN_OP                  ARGI_INVALID_OPCODE
 #define ARGI_REVISION_OP                ARG_NONE
 #define ARGI_SCOPE_OP                   ARGI_INVALID_OPCODE
+#define ARGI_SERIALFIELD_OP             ARGI_INVALID_OPCODE
 #define ARGI_SHIFT_LEFT_OP              ARGI_LIST3 (ARGI_INTEGER,    ARGI_INTEGER,       ARGI_TARGETREF)
 #define ARGI_SHIFT_RIGHT_OP             ARGI_LIST3 (ARGI_INTEGER,    ARGI_INTEGER,       ARGI_TARGETREF)
 #define ARGI_SIGNAL_OP                  ARGI_LIST1 (ARGI_EVENT)
diff --git a/drivers/acpi/acpica/amlcode.h b/drivers/acpi/acpica/amlcode.h
index 1077f17..adf7a71 100644
--- a/drivers/acpi/acpica/amlcode.h
+++ b/drivers/acpi/acpica/amlcode.h
@@ -189,6 +189,14 @@
 #define AML_LNOTEQUAL_OP            (u16) 0x9293
 
 /*
+ * Opcodes for "Field" operators
+ */
+#define AML_FIELD_OFFSET_OP         (u8) 0x00
+#define AML_FIELD_ACCESS_OP         (u8) 0x01
+#define AML_FIELD_CONNECTION_OP     (u8) 0x02	/* ACPI 5.0 */
+#define AML_FIELD_EXT_ACCESS_OP     (u8) 0x03	/* ACPI 5.0 */
+
+/*
  * Internal opcodes
  * Use only "Unknown" AML opcodes, don't attempt to use
  * any valid ACPI ASCII values (A-Z, 0-9, '-')
@@ -202,6 +210,8 @@
 #define AML_INT_METHODCALL_OP       (u16) 0x0035
 #define AML_INT_RETURN_VALUE_OP     (u16) 0x0036
 #define AML_INT_EVAL_SUBTREE_OP     (u16) 0x0037
+#define AML_INT_CONNECTION_OP       (u16) 0x0038
+#define AML_INT_EXTACCESSFIELD_OP   (u16) 0x0039
 
 #define ARG_NONE                    0x0
 
diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index 34be60c..aa880d9 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -221,6 +221,7 @@ acpi_ds_get_field_names(struct acpi_create_field_info *info,
 {
 	acpi_status status;
 	u64 position;
+	union acpi_parse_object *child;
 
 	ACPI_FUNCTION_TRACE_PTR(ds_get_field_names, info);
 
@@ -232,10 +233,11 @@ acpi_ds_get_field_names(struct acpi_create_field_info *info,
 
 	while (arg) {
 		/*
-		 * Three types of field elements are handled:
-		 * 1) Offset - specifies a bit offset
-		 * 2) access_as - changes the access mode
-		 * 3) Name - Enters a new named field into the namespace
+		 * Four types of field elements are handled:
+		 * 1) Name - Enters a new named field into the namespace
+		 * 2) Offset - specifies a bit offset
+		 * 3) access_as - changes the access mode/attributes
+		 * 4) Connection - Associate a resource template with the field
 		 */
 		switch (arg->common.aml_opcode) {
 		case AML_INT_RESERVEDFIELD_OP:
@@ -253,21 +255,70 @@ acpi_ds_get_field_names(struct acpi_create_field_info *info,
 			break;
 
 		case AML_INT_ACCESSFIELD_OP:
-
+		case AML_INT_EXTACCESSFIELD_OP:
 			/*
-			 * Get a new access_type and access_attribute -- to be used for all
-			 * field units that follow, until field end or another access_as
-			 * keyword.
+			 * Get new access_type, access_attribute, and access_length fields
+			 * -- to be used for all field units that follow, until the
+			 * end-of-field or another access_as keyword is encountered.
+			 * NOTE. These three bytes are encoded in the integer value
+			 * of the parseop for convenience.
 			 *
 			 * In field_flags, preserve the flag bits other than the
-			 * ACCESS_TYPE bits
+			 * ACCESS_TYPE bits.
 			 */
+
+			/* access_type (byte_acc, word_acc, etc.) */
+
 			info->field_flags = (u8)
 			    ((info->
 			      field_flags & ~(AML_FIELD_ACCESS_TYPE_MASK)) |
-			     ((u8) ((u32) arg->common.value.integer >> 8)));
+			     ((u8)((u32)(arg->common.value.integer & 0x07))));
+
+			/* access_attribute (attrib_quick, attrib_byte, etc.) */
+
+			info->attribute =
+			    (u8)((arg->common.value.integer >> 8) & 0xFF);
+
+			/* access_length (for serial/buffer protocols) */
+
+			info->access_length =
+			    (u8)((arg->common.value.integer >> 16) & 0xFF);
+			break;
+
+		case AML_INT_CONNECTION_OP:
+			/*
+			 * Clear any previous connection. New connection is used for all
+			 * fields that follow, similar to access_as
+			 */
+			info->resource_buffer = NULL;
+			info->connection_node = NULL;
 
-			info->attribute = (u8) (arg->common.value.integer);
+			/*
+			 * A Connection() is either an actual resource descriptor (buffer)
+			 * or a named reference to a resource template
+			 */
+			child = arg->common.value.arg;
+			if (child->common.aml_opcode == AML_INT_BYTELIST_OP) {
+				info->resource_buffer = child->named.data;
+				info->resource_length =
+				    (u16)child->named.value.integer;
+			} else {
+				/* Lookup the Connection() namepath, it should already exist */
+
+				status = acpi_ns_lookup(walk_state->scope_info,
+							child->common.value.
+							name, ACPI_TYPE_ANY,
+							ACPI_IMODE_EXECUTE,
+							ACPI_NS_DONT_OPEN_SCOPE,
+							walk_state,
+							&info->connection_node);
+				if (ACPI_FAILURE(status)) {
+					ACPI_ERROR_NAMESPACE(child->common.
+							     value.name,
+							     status);
+					return_ACPI_STATUS(status);
+				}
+			}
 			break;
 
 		case AML_INT_NAMEDFIELD_OP:
@@ -374,6 +425,8 @@ acpi_ds_create_field(union acpi_parse_object *op,
 		}
 	}
 
+	ACPI_MEMSET(&info, 0, sizeof(struct acpi_create_field_info));
+
 	/* Second arg is the field flags */
 
 	arg = arg->common.next;
@@ -386,7 +439,6 @@ acpi_ds_create_field(union acpi_parse_object *op,
 	info.region_node = region_node;
 
 	status = acpi_ds_get_field_names(&info, walk_state, arg->common.next);
-
 	return_ACPI_STATUS(status);
 }
 
@@ -474,8 +526,8 @@ acpi_ds_init_field_objects(union acpi_parse_object *op,
 	 */
 	while (arg) {
 		/*
-		 * Ignore OFFSET and ACCESSAS terms here; we are only interested in the
-		 * field names in order to enter them into the namespace.
+		 * Ignore OFFSET/ACCESSAS/CONNECTION terms here; we are only interested
+		 * in the field names in order to enter them into the namespace.
 		 */
 		if (arg->common.aml_opcode == AML_INT_NAMEDFIELD_OP) {
 			status = acpi_ns_lookup(walk_state->scope_info,
@@ -651,6 +703,5 @@ acpi_ds_create_index_field(union acpi_parse_object *op,
 	info.region_node = region_node;
 
 	status = acpi_ds_get_field_names(&info, walk_state, arg->common.next);
-
 	return_ACPI_STATUS(status);
 }
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index f0edf5c..dcdc7e4 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -329,6 +329,7 @@ acpi_ev_execute_reg_method(union acpi_operand_object *region_obj, u32 function)
  * FUNCTION:    acpi_ev_address_space_dispatch
  *
  * PARAMETERS:  region_obj          - Internal region object
+ *              field_obj           - Corresponding field. Can be NULL.
  *              Function            - Read or Write operation
  *              region_offset       - Where in the region to read or write
  *              bit_width           - Field width in bits (8, 16, 32, or 64)
@@ -344,6 +345,7 @@ acpi_ev_execute_reg_method(union acpi_operand_object *region_obj, u32 function)
 
 acpi_status
 acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
+			       union acpi_operand_object *field_obj,
 			       u32 function,
 			       u32 region_offset, u32 bit_width, u64 *value)
 {
@@ -353,6 +355,7 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	union acpi_operand_object *handler_desc;
 	union acpi_operand_object *region_obj2;
 	void *region_context = NULL;
+	struct acpi_connection_info *context;
 
 	ACPI_FUNCTION_TRACE(ev_address_space_dispatch);
 
@@ -375,6 +378,8 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		return_ACPI_STATUS(AE_NOT_EXIST);
 	}
 
+	context = handler_desc->address_space.context;
+
 	/*
 	 * It may be the case that the region has never been initialized.
 	 * Some types of regions require special init code
@@ -404,8 +409,7 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		acpi_ex_exit_interpreter();
 
 		status = region_setup(region_obj, ACPI_REGION_ACTIVATE,
-				      handler_desc->address_space.context,
-				      &region_context);
+				      context, &region_context);
 
 		/* Re-enter the interpreter */
 
@@ -455,6 +459,25 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 			  acpi_ut_get_region_name(region_obj->region.
 						  space_id)));
 
+	/*
+	 * Special handling for generic_serial_bus and general_purpose_io:
+	 * There are three extra parameters that must be passed to the
+	 * handler via the context:
+	 *   1) Connection buffer, a resource template from Connection() op.
+	 *   2) Length of the above buffer.
+	 *   3) Actual access length from the access_as() op.
+	 */
+	if (((region_obj->region.space_id == ACPI_ADR_SPACE_GSBUS) ||
+	     (region_obj->region.space_id == ACPI_ADR_SPACE_GPIO)) &&
+	    context && field_obj) {
+
+		/* Get the Connection (resource_template) buffer */
+
+		context->connection = field_obj->field.resource_buffer;
+		context->length = field_obj->field.resource_length;
+		context->access_length = field_obj->field.access_length;
+	}
+
 	if (!(handler_desc->address_space.handler_flags &
 	      ACPI_ADDR_HANDLER_DEFAULT_INSTALLED)) {
 		/*
@@ -469,7 +492,7 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 
 	status = handler(function,
 			 (region_obj->region.address + region_offset),
-			 bit_width, value, handler_desc->address_space.context,
+			 bit_width, value, context,
 			 region_obj2->extra.region_context);
 
 	if (ACPI_FAILURE(status)) {
diff --git a/drivers/acpi/acpica/exconfig.c b/drivers/acpi/acpica/exconfig.c
index 745a42b..efe41f7 100644
--- a/drivers/acpi/acpica/exconfig.c
+++ b/drivers/acpi/acpica/exconfig.c
@@ -297,9 +297,9 @@ acpi_ex_region_read(union acpi_operand_object *obj_desc, u32 length, u8 *buffer)
 	/* Bytewise reads */
 
 	for (i = 0; i < length; i++) {
-		status = acpi_ev_address_space_dispatch(obj_desc, ACPI_READ,
-							region_offset, 8,
-							&value);
+		status =
+		    acpi_ev_address_space_dispatch(obj_desc, NULL, ACPI_READ,
+						   region_offset, 8, &value);
 		if (ACPI_FAILURE(status)) {
 			return status;
 		}
diff --git a/drivers/acpi/acpica/exdump.c b/drivers/acpi/acpica/exdump.c
index 61b8c0e..c7064f4 100644
--- a/drivers/acpi/acpica/exdump.c
+++ b/drivers/acpi/acpica/exdump.c
@@ -192,10 +192,13 @@ static struct acpi_exdump_info acpi_ex_dump_buffer_field[3] = {
 	 "Buffer Object"}
 };
 
-static struct acpi_exdump_info acpi_ex_dump_region_field[3] = {
+static struct acpi_exdump_info acpi_ex_dump_region_field[5] = {
 	{ACPI_EXD_INIT, ACPI_EXD_TABLE_SIZE(acpi_ex_dump_region_field), NULL},
 	{ACPI_EXD_FIELD, 0, NULL},
-	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(field.region_obj), "Region Object"}
+	{ACPI_EXD_UINT8, ACPI_EXD_OFFSET(field.access_length), "AccessLength"},
+	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(field.region_obj), "Region Object"},
+	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(field.resource_buffer),
+	 "ResourceBuffer"}
 };
 
 static struct acpi_exdump_info acpi_ex_dump_bank_field[5] = {
diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index 2a524fc..cc9c5df 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -283,11 +283,12 @@ acpi_ex_access_region(union acpi_operand_object *obj_desc,
 
 	/* Invoke the appropriate address_space/op_region handler */
 
-	status =
-	    acpi_ev_address_space_dispatch(rgn_desc, function, region_offset,
-					   ACPI_MUL_8(obj_desc->common_field.
-						      access_byte_width),
-					   value);
+	status = acpi_ev_address_space_dispatch(rgn_desc, obj_desc,
+						function, region_offset,
+						ACPI_MUL_8(obj_desc->
+							   common_field.
+							   access_byte_width),
+						value);
 
 	if (ACPI_FAILURE(status)) {
 		if (status == AE_NOT_IMPLEMENTED) {
diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index cc95e20..18b75fe 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -47,6 +47,7 @@
 #include "acinterp.h"
 #include "amlcode.h"
 #include "acnamesp.h"
+#include "acdispat.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exprep")
@@ -455,6 +456,30 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
 		obj_desc->field.region_obj =
 		    acpi_ns_get_attached_object(info->region_node);
 
+		/* Fields specific to generic_serial_bus fields */
+
+		obj_desc->field.access_length = info->access_length;
+
+		if (info->connection_node) {
+			second_desc = info->connection_node->object;
+			if (!(second_desc->common.flags & AOPOBJ_DATA_VALID)) {
+				status =
+				    acpi_ds_get_buffer_arguments(second_desc);
+				if (ACPI_FAILURE(status)) {
+					acpi_ut_delete_object_desc(obj_desc);
+					return_ACPI_STATUS(status);
+				}
+			}
+
+			obj_desc->field.resource_buffer =
+			    second_desc->buffer.pointer;
+			obj_desc->field.resource_length =
+			    (u16)second_desc->buffer.length;
+		} else if (info->resource_buffer) {
+			obj_desc->field.resource_buffer = info->resource_buffer;
+			obj_desc->field.resource_length = info->resource_length;
+		}
+
 		/* Allow full data read from EC address space */
 
 		if ((obj_desc->field.region_obj->region.space_id ==
diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index e1fad0e..4037f90 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -484,34 +484,54 @@ acpi_ps_get_next_simple_arg(struct acpi_parse_state *parser_state,
 static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 						       *parser_state)
 {
-	u32 aml_offset = (u32)
-	    ACPI_PTR_DIFF(parser_state->aml,
-			  parser_state->aml_start);
+	u32 aml_offset;
 	union acpi_parse_object *field;
+	union acpi_parse_object *arg = NULL;
 	u16 opcode;
 	u32 name;
+	u8 access_type;
+	u8 access_attribute;
+	u8 access_length;
+	u32 pkg_length;
+	u8 *pkg_end;
+	u32 buffer_length;
 
 	ACPI_FUNCTION_TRACE(ps_get_next_field);
 
+	aml_offset =
+	    (u32)ACPI_PTR_DIFF(parser_state->aml, parser_state->aml_start);
+
 	/* Determine field type */
 
 	switch (ACPI_GET8(parser_state->aml)) {
-	default:
+	case AML_FIELD_OFFSET_OP:
 
-		opcode = AML_INT_NAMEDFIELD_OP;
+		opcode = AML_INT_RESERVEDFIELD_OP;
+		parser_state->aml++;
 		break;
 
-	case 0x00:
+	case AML_FIELD_ACCESS_OP:
 
-		opcode = AML_INT_RESERVEDFIELD_OP;
+		opcode = AML_INT_ACCESSFIELD_OP;
 		parser_state->aml++;
 		break;
 
-	case 0x01:
+	case AML_FIELD_CONNECTION_OP:
 
-		opcode = AML_INT_ACCESSFIELD_OP;
+		opcode = AML_INT_CONNECTION_OP;
+		parser_state->aml++;
+		break;
+
+	case AML_FIELD_EXT_ACCESS_OP:
+
+		opcode = AML_INT_EXTACCESSFIELD_OP;
 		parser_state->aml++;
 		break;
+
+	default:
+
+		opcode = AML_INT_NAMEDFIELD_OP;
+		break;
 	}
 
 	/* Allocate a new field op */
@@ -549,16 +569,111 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 		break;
 
 	case AML_INT_ACCESSFIELD_OP:
+	case AML_INT_EXTACCESSFIELD_OP:
 
 		/*
 		 * Get access_type and access_attrib and merge into the field Op
-		 * access_type is first operand, access_attribute is second
+		 * access_type is first operand, access_attribute is second. stuff
+		 * these bytes into the node integer value for convenience.
 		 */
-		field->common.value.integer =
-		    (((u32) ACPI_GET8(parser_state->aml) << 8));
+
+		/* Get the two bytes (Type/Attribute) */
+
+		access_type = ACPI_GET8(parser_state->aml);
 		parser_state->aml++;
-		field->common.value.integer |= ACPI_GET8(parser_state->aml);
+		access_attribute = ACPI_GET8(parser_state->aml);
 		parser_state->aml++;
+
+		field->common.value.integer = (u8)access_type;
+		field->common.value.integer |= (u16)(access_attribute << 8);
+
+		/* This opcode has a third byte, access_length */
+
+		if (opcode == AML_INT_EXTACCESSFIELD_OP) {
+			access_length = ACPI_GET8(parser_state->aml);
+			parser_state->aml++;
+
+			field->common.value.integer |=
+			    (u32)(access_length << 16);
+		}
+		break;
+
+	case AML_INT_CONNECTION_OP:
+
+		/*
+		 * Argument for Connection operator can be either a Buffer
+		 * (resource descriptor), or a name_string.
+		 */
+		if (ACPI_GET8(parser_state->aml) == AML_BUFFER_OP) {
+			parser_state->aml++;
+
+			pkg_end = parser_state->aml;
+			pkg_length =
+			    acpi_ps_get_next_package_length(parser_state);
+			pkg_end += pkg_length;
+
+			if (parser_state->aml < pkg_end) {
+
+				/* Non-empty list */
+
+				arg = acpi_ps_alloc_op(AML_INT_BYTELIST_OP);
+				if (!arg) {
+					return_PTR(NULL);
+				}
+
+				/* Get the actual buffer length argument */
+
+				opcode = ACPI_GET8(parser_state->aml);
+				parser_state->aml++;
+
+				switch (opcode) {
+				case AML_BYTE_OP:	/* AML_BYTEDATA_ARG */
+					buffer_length =
+					    ACPI_GET8(parser_state->aml);
+					parser_state->aml += 1;
+					break;
+
+				case AML_WORD_OP:	/* AML_WORDDATA_ARG */
+					buffer_length =
+					    ACPI_GET16(parser_state->aml);
+					parser_state->aml += 2;
+					break;
+
+				case AML_DWORD_OP:	/* AML_DWORDATA_ARG */
+					buffer_length =
+					    ACPI_GET32(parser_state->aml);
+					parser_state->aml += 4;
+					break;
+
+				default:
+					buffer_length = 0;
+					break;
+				}
+
+				/* Fill in bytelist data */
+
+				arg->named.value.size = buffer_length;
+				arg->named.data = parser_state->aml;
+			}
+
+			/* Skip to End of byte data */
+
+			parser_state->aml = pkg_end;
+		} else {
+			arg = acpi_ps_alloc_op(AML_INT_NAMEPATH_OP);
+			if (!arg) {
+				return_PTR(NULL);
+			}
+
+			/* Get the Namestring argument */
+
+			arg->common.value.name =
+			    acpi_ps_get_next_namestring(parser_state);
+		}
+
+		/* Link the buffer/namestring to parent (CONNECTION_OP) */
+
+		acpi_ps_append_arg(field, arg);
 		break;
 
 	default:
diff --git a/drivers/acpi/acpica/psopcode.c b/drivers/acpi/acpica/psopcode.c
index bed08de..9b31910 100644
--- a/drivers/acpi/acpica/psopcode.c
+++ b/drivers/acpi/acpica/psopcode.c
@@ -638,7 +638,16 @@ const struct acpi_opcode_info acpi_gbl_aml_op_info[AML_NUM_OPCODES] = {
 
 /* 7E */ ACPI_OP("Timer", ARGP_TIMER_OP, ARGI_TIMER_OP, ACPI_TYPE_ANY,
 		 AML_CLASS_EXECUTE, AML_TYPE_EXEC_0A_0T_1R,
-		 AML_FLAGS_EXEC_0A_0T_1R)
+			 AML_FLAGS_EXEC_0A_0T_1R),
+
+/* ACPI 5.0 opcodes */
+
+/* 7F */ ACPI_OP("-ConnectField-", ARGP_CONNECTFIELD_OP,
+			 ARGI_CONNECTFIELD_OP, ACPI_TYPE_ANY,
+			 AML_CLASS_INTERNAL, AML_TYPE_BOGUS, AML_HAS_ARGS),
+/* 80 */ ACPI_OP("-ExtAccessField-", ARGP_CONNECTFIELD_OP,
+			 ARGI_CONNECTFIELD_OP, ACPI_TYPE_ANY,
+			 AML_CLASS_INTERNAL, AML_TYPE_BOGUS, 0)
 
 /*! [End] no source code translation !*/
 };
@@ -657,7 +666,7 @@ static const u8 acpi_gbl_short_op_index[256] = {
 /* 0x20 */ _UNK, _UNK, _UNK, _UNK, _UNK, _UNK, _UNK, _UNK,
 /* 0x28 */ _UNK, _UNK, _UNK, _UNK, _UNK, 0x63, _PFX, _PFX,
 /* 0x30 */ 0x67, 0x66, 0x68, 0x65, 0x69, 0x64, 0x6A, 0x7D,
-/* 0x38 */ _UNK, _UNK, _UNK, _UNK, _UNK, _UNK, _UNK, _UNK,
+/* 0x38 */ 0x7F, 0x80, _UNK, _UNK, _UNK, _UNK, _UNK, _UNK,
 /* 0x40 */ _UNK, _ASC, _ASC, _ASC, _ASC, _ASC, _ASC, _ASC,
 /* 0x48 */ _ASC, _ASC, _ASC, _ASC, _ASC, _ASC, _ASC, _ASC,
 /* 0x50 */ _ASC, _ASC, _ASC, _ASC, _ASC, _ASC, _ASC, _ASC,
diff --git a/drivers/acpi/acpica/pstree.c b/drivers/acpi/acpica/pstree.c
index f1464c0..04311bb 100644
--- a/drivers/acpi/acpica/pstree.c
+++ b/drivers/acpi/acpica/pstree.c
@@ -74,6 +74,12 @@ union acpi_parse_object *acpi_ps_get_arg(union acpi_parse_object *op, u32 argn)
 
 	ACPI_FUNCTION_ENTRY();
 
+/*
+	if (Op->Common.aml_opcode == AML_INT_CONNECTION_OP)
+	{
+		return (Op->Common.Value.Arg);
+	}
+*/
 	/* Get the info structure for this opcode */
 
 	op_info = acpi_ps_get_opcode_info(op->common.aml_opcode);
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index ed73f67..d088c90 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -957,6 +957,14 @@ acpi_status(*acpi_adr_space_handler) (u32 function,
 
 #define ACPI_DEFAULT_HANDLER            NULL
 
+/* Special Context data for generic_serial_bus/general_purpose_io (ACPI 5.0) */
+
+struct acpi_connection_info {
+	u8 *connection;
+	u16 length;
+	u8 access_length;
+};
+
 typedef
 acpi_status(*acpi_adr_space_setup) (acpi_handle region_handle,
 				    u32 function,
-- 
1.7.9.rc1

