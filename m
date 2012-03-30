Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab2C3MUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:20:38 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760712Ab2C3MSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:48 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 44/76] ACPICA: Object repair code: Support to add Package
 wrappers
Date: Fri, 30 Mar 2012 06:13:47 -0400
Message-id: <6a99b1c94d053b3420eaa4a4bc8b2883dd90a2f9.1333101989.git.len.brown@intel.com>
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

Repair a common problem with objects that are defined to return
a variable-length Package of sub-objects. If there is only one
sub-object, some BIOS code mistakenly simply declares the single
object instead of a Package with one sub-object.  This function
attempts to repair this error by wrapping a Package object around
the original object, creating the correct and expected Package
with one sub-object.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/aclocal.h  |    1 +
 drivers/acpi/acpica/acnamesp.h |    5 +-
 drivers/acpi/acpica/nspredef.c |    4 +-
 drivers/acpi/acpica/nsrepair.c |  159 +++++++++++++++-------------------------
 4 files changed, 64 insertions(+), 105 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 3f24068..e3922ca 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -370,6 +370,7 @@ struct acpi_predefined_data {
 /* Defines for Flags field above */
 
 #define ACPI_OBJECT_REPAIRED    1
+#define ACPI_OBJECT_WRAPPED     2
 
 /*
  * Bitmapped return value types
diff --git a/drivers/acpi/acpica/acnamesp.h b/drivers/acpi/acpica/acnamesp.h
index 2c9e0f0..9b19d4b 100644
--- a/drivers/acpi/acpica/acnamesp.h
+++ b/drivers/acpi/acpica/acnamesp.h
@@ -283,8 +283,9 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 		      union acpi_operand_object **return_object_ptr);
 
 acpi_status
-acpi_ns_repair_package_list(struct acpi_predefined_data *data,
-			    union acpi_operand_object **obj_desc_ptr);
+acpi_ns_wrap_with_package(struct acpi_predefined_data *data,
+			  union acpi_operand_object *original_object,
+			  union acpi_operand_object **obj_desc_ptr);
 
 acpi_status
 acpi_ns_repair_null_element(struct acpi_predefined_data *data,
diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index bbe46a4..23ce096 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -638,8 +638,8 @@ acpi_ns_check_package(struct acpi_predefined_data *data,
 			/* Create the new outer package and populate it */
 
 			status =
-			    acpi_ns_repair_package_list(data,
-							return_object_ptr);
+			    acpi_ns_wrap_with_package(data, *elements,
+						      return_object_ptr);
 			if (ACPI_FAILURE(status)) {
 				return (status);
 			}
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index 9c35d20..5519a64 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -71,11 +71,10 @@ ACPI_MODULE_NAME("nsrepair")
  * Buffer  -> String
  * Buffer  -> Package of Integers
  * Package -> Package of one Package
+ * An incorrect standalone object is wrapped with required outer package
  *
  * Additional possible repairs:
- *
  * Required package elements that are NULL replaced by Integer/String/Buffer
- * Incorrect standalone package wrapped with required outer package
  *
  ******************************************************************************/
 /* Local prototypes */
@@ -91,10 +90,6 @@ static acpi_status
 acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
 			  union acpi_operand_object **return_object);
 
-static acpi_status
-acpi_ns_convert_to_package(union acpi_operand_object *original_object,
-			   union acpi_operand_object **return_object);
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ns_repair_object
@@ -151,9 +146,24 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 		}
 	}
 	if (expected_btypes & ACPI_RTYPE_PACKAGE) {
-		status = acpi_ns_convert_to_package(return_object, &new_object);
+		/*
+		 * A package is expected. We will wrap the existing object with a
+		 * new package object. It is often the case that if a variable-length
+		 * package is required, but there is only a single object needed, the
+		 * BIOS will return that object instead of wrapping it with a Package
+		 * object. Note: after the wrapping, the package will be validated
+		 * for correct contents (expected object type or types).
+		 */
+		status =
+		    acpi_ns_wrap_with_package(data, return_object, &new_object);
 		if (ACPI_SUCCESS(status)) {
-			goto object_repaired;
+			/*
+			 * The original object just had its reference count
+			 * incremented for being inserted into the new package.
+			 */
+			*return_object_ptr = new_object;	/* New Package object */
+			data->flags |= ACPI_OBJECT_REPAIRED;
+			return (AE_OK);
 		}
 	}
 
@@ -165,22 +175,27 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 
 	/* Object was successfully repaired */
 
-	/*
-	 * If the original object is a package element, we need to:
-	 * 1. Set the reference count of the new object to match the
-	 *    reference count of the old object.
-	 * 2. Decrement the reference count of the original object.
-	 */
 	if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
-		new_object->common.reference_count =
-		    return_object->common.reference_count;
+		/*
+		 * The original object is a package element. We need to
+		 * decrement the reference count of the original object,
+		 * for removing it from the package.
+		 *
+		 * However, if the original object was just wrapped with a
+		 * package object as part of the repair, we don't need to
+		 * change the reference count.
+		 */
+		if (!(data->flags & ACPI_OBJECT_WRAPPED)) {
+			new_object->common.reference_count =
+			    return_object->common.reference_count;
 
-		if (return_object->common.reference_count > 1) {
-			return_object->common.reference_count--;
+			if (return_object->common.reference_count > 1) {
+				return_object->common.reference_count--;
+			}
 		}
 
 		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
-				  "%s: Converted %s to expected %s at index %u\n",
+				  "%s: Converted %s to expected %s at Package index %u\n",
 				  data->pathname,
 				  acpi_ut_get_object_type_name(return_object),
 				  acpi_ut_get_object_type_name(new_object),
@@ -453,65 +468,6 @@ acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ns_convert_to_package
- *
- * PARAMETERS:  original_object     - Object to be converted
- *              return_object       - Where the new converted object is returned
- *
- * RETURN:      Status. AE_OK if conversion was successful.
- *
- * DESCRIPTION: Attempt to convert a Buffer object to a Package. Each byte of
- *              the buffer is converted to a single integer package element.
- *
- ******************************************************************************/
-
-static acpi_status
-acpi_ns_convert_to_package(union acpi_operand_object *original_object,
-			   union acpi_operand_object **return_object)
-{
-	union acpi_operand_object *new_object;
-	union acpi_operand_object **elements;
-	u32 length;
-	u8 *buffer;
-
-	switch (original_object->common.type) {
-	case ACPI_TYPE_BUFFER:
-
-		/* Buffer-to-Package conversion */
-
-		length = original_object->buffer.length;
-		new_object = acpi_ut_create_package_object(length);
-		if (!new_object) {
-			return (AE_NO_MEMORY);
-		}
-
-		/* Convert each buffer byte to an integer package element */
-
-		elements = new_object->package.elements;
-		buffer = original_object->buffer.pointer;
-
-		while (length--) {
-			*elements =
-			    acpi_ut_create_integer_object((u64) *buffer);
-			if (!*elements) {
-				acpi_ut_remove_reference(new_object);
-				return (AE_NO_MEMORY);
-			}
-			elements++;
-			buffer++;
-		}
-		break;
-
-	default:
-		return (AE_AML_OPERAND_TYPE);
-	}
-
-	*return_object = new_object;
-	return (AE_OK);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ns_repair_null_element
  *
  * PARAMETERS:  Data                - Pointer to validation data structure
@@ -677,55 +633,56 @@ acpi_ns_remove_null_elements(struct acpi_predefined_data *data,
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ns_repair_package_list
+ * FUNCTION:    acpi_ns_wrap_with_package
  *
  * PARAMETERS:  Data                - Pointer to validation data structure
- *              obj_desc_ptr        - Pointer to the object to repair. The new
- *                                    package object is returned here,
- *                                    overwriting the old object.
+ *              original_object     - Pointer to the object to repair.
+ *              obj_desc_ptr        - The new package object is returned here
  *
  * RETURN:      Status, new object in *obj_desc_ptr
  *
- * DESCRIPTION: Repair a common problem with objects that are defined to return
- *              a variable-length Package of Packages. If the variable-length
- *              is one, some BIOS code mistakenly simply declares a single
- *              Package instead of a Package with one sub-Package. This
- *              function attempts to repair this error by wrapping a Package
- *              object around the original Package, creating the correct
- *              Package with one sub-Package.
+ * DESCRIPTION: Repair a common problem with objects that are defined to
+ *              return a variable-length Package of sub-objects. If there is
+ *              only one sub-object, some BIOS code mistakenly simply declares
+ *              the single object instead of a Package with one sub-object.
+ *              This function attempts to repair this error by wrapping a
+ *              Package object around the original object, creating the
+ *              correct and expected Package with one sub-object.
  *
  *              Names that can be repaired in this manner include:
- *              _ALR, _CSD, _HPX, _MLS, _PRT, _PSS, _TRT, TSS
+ *              _ALR, _CSD, _HPX, _MLS, _PLD, _PRT, _PSS, _TRT, _TSS,
+ *              _BCL, _DOD, _FIX, _Sx
  *
  ******************************************************************************/
 
 acpi_status
-acpi_ns_repair_package_list(struct acpi_predefined_data *data,
-			    union acpi_operand_object **obj_desc_ptr)
+acpi_ns_wrap_with_package(struct acpi_predefined_data *data,
+			  union acpi_operand_object *original_object,
+			  union acpi_operand_object **obj_desc_ptr)
 {
 	union acpi_operand_object *pkg_obj_desc;
 
-	ACPI_FUNCTION_NAME(ns_repair_package_list);
+	ACPI_FUNCTION_NAME(ns_wrap_with_package);
 
 	/*
 	 * Create the new outer package and populate it. The new package will
-	 * have a single element, the lone subpackage.
+	 * have a single element, the lone sub-object.
 	 */
 	pkg_obj_desc = acpi_ut_create_package_object(1);
 	if (!pkg_obj_desc) {
 		return (AE_NO_MEMORY);
 	}
 
-	pkg_obj_desc->package.elements[0] = *obj_desc_ptr;
+	pkg_obj_desc->package.elements[0] = original_object;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+			  "%s: Wrapped %s with expected Package object\n",
+			  data->pathname,
+			  acpi_ut_get_object_type_name(original_object)));
 
 	/* Return the new object in the object pointer */
 
 	*obj_desc_ptr = pkg_obj_desc;
-	data->flags |= ACPI_OBJECT_REPAIRED;
-
-	ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
-			  "%s: Repaired incorrectly formed Package\n",
-			  data->pathname));
-
+	data->flags |= ACPI_OBJECT_REPAIRED | ACPI_OBJECT_WRAPPED;
 	return (AE_OK);
 }
-- 
1.7.10.rc2.19.gfae9d

