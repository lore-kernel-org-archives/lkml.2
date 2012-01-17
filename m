Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2AQMZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:25:41 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:51589 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2AQMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:23 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 15/50] ACPI 5.0: New interface, acpi_get_event_resources
Date: Tue, 17 Jan 2012 07:21:07 -0500
Message-id: <a91cdde20a870bd773d605c764ed211539bf3020.1326802229.git.len.brown@intel.com>
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

Executes _AEI and formats the result, similar to acpi_get_current_resources, etc.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acresrc.h |    4 +++
 drivers/acpi/acpica/rsutils.c |   50 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/rsxface.c |   40 ++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h         |    4 +++
 4 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/acresrc.h b/drivers/acpi/acpica/acresrc.h
index 05721b0..61b2e04 100644
--- a/drivers/acpi/acpica/acresrc.h
+++ b/drivers/acpi/acpica/acresrc.h
@@ -215,6 +215,10 @@ acpi_status
 acpi_rs_set_srs_method_data(struct acpi_namespace_node *node,
 			    struct acpi_buffer *ret_buffer);
 
+acpi_status
+acpi_rs_get_aei_method_data(struct acpi_namespace_node *node,
+			    struct acpi_buffer *ret_buffer);
+
 /*
  * rscalc
  */
diff --git a/drivers/acpi/acpica/rsutils.c b/drivers/acpi/acpica/rsutils.c
index 4409db8..54a9a97 100644
--- a/drivers/acpi/acpica/rsutils.c
+++ b/drivers/acpi/acpica/rsutils.c
@@ -594,6 +594,56 @@ acpi_rs_get_prs_method_data(struct acpi_namespace_node *node,
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_rs_get_aei_method_data
+ *
+ * PARAMETERS:  Node            - Device node
+ *              ret_buffer      - Pointer to a buffer structure for the
+ *                                results
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: This function is called to get the _AEI value of an object
+ *              contained in an object specified by the handle passed in
+ *
+ *              If the function fails an appropriate status will be returned
+ *              and the contents of the callers buffer is undefined.
+ *
+ ******************************************************************************/
+
+acpi_status
+acpi_rs_get_aei_method_data(struct acpi_namespace_node *node,
+			    struct acpi_buffer *ret_buffer)
+{
+	union acpi_operand_object *obj_desc;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(rs_get_aei_method_data);
+
+	/* Parameters guaranteed valid by caller */
+
+	/* Execute the method, no parameters */
+
+	status = acpi_ut_evaluate_object(node, METHOD_NAME__AEI,
+					 ACPI_BTYPE_BUFFER, &obj_desc);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/*
+	 * Make the call to create a resource linked list from the
+	 * byte stream buffer that comes back from the _CRS method
+	 * execution.
+	 */
+	status = acpi_rs_create_resource_list(obj_desc, ret_buffer);
+
+	/* On exit, we must delete the object returned by evaluate_object */
+
+	acpi_ut_remove_reference(obj_desc);
+	return_ACPI_STATUS(status);
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_rs_get_method_data
  *
  * PARAMETERS:  Handle          - Handle to the containing object
diff --git a/drivers/acpi/acpica/rsxface.c b/drivers/acpi/acpica/rsxface.c
index fe86b37..45a9e5e 100644
--- a/drivers/acpi/acpica/rsxface.c
+++ b/drivers/acpi/acpica/rsxface.c
@@ -307,6 +307,46 @@ acpi_set_current_resources(acpi_handle device_handle,
 
 ACPI_EXPORT_SYMBOL(acpi_set_current_resources)
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_get_event_resources
+ *
+ * PARAMETERS:  device_handle   - Handle to the device object for the
+ *                                device we are getting resources
+ *              in_buffer       - Pointer to a buffer containing the
+ *                                resources to be set for the device
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: This function is called to get the event resources for a
+ *              specific device. The caller must first acquire a handle for
+ *              the desired device. The resource data is passed to the routine
+ *              the buffer pointed to by the in_buffer variable. Uses the
+ *              _AEI method.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_get_event_resources(acpi_handle device_handle,
+			 struct acpi_buffer *ret_buffer)
+{
+	acpi_status status;
+	struct acpi_namespace_node *node;
+
+	ACPI_FUNCTION_TRACE(acpi_get_event_resources);
+
+	/* Validate parameters then dispatch to internal routine */
+
+	status = acpi_rs_validate_parameters(device_handle, ret_buffer, &node);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	status = acpi_rs_get_aei_method_data(node, ret_buffer);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_get_event_resources)
+
 /******************************************************************************
  *
  * FUNCTION:    acpi_resource_to_address64
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index dd86610..726d937 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -358,6 +358,10 @@ acpi_get_possible_resources(acpi_handle device, struct acpi_buffer *ret_buffer);
 #endif
 
 acpi_status
+acpi_get_event_resources(acpi_handle device_handle,
+			 struct acpi_buffer *ret_buffer);
+
+acpi_status
 acpi_walk_resources(acpi_handle device,
 		    char *name,
 		    acpi_walk_resource_callback user_function, void *context);
-- 
1.7.9.rc1

