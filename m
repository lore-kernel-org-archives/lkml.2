Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2AQMbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:31:07 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:39447 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2AQMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:06 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 16/50] ACPI 5.0: New interface, acpi_buffer_to_resource
Date: Tue, 17 Jan 2012 07:21:08 -0500
Message-id: <0e243178047c0219b3367dd44f81040826b7ea83.1326802229.git.len.brown@intel.com>
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

This interface converts an AML buffer to an internal ACPI_RESOURCE.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/rscreate.c |   64 ++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h          |    5 +++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
index f61285d..06264e8 100644
--- a/drivers/acpi/acpica/rscreate.c
+++ b/drivers/acpi/acpica/rscreate.c
@@ -51,6 +51,70 @@ ACPI_MODULE_NAME("rscreate")
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_buffer_to_resource
+ *
+ * PARAMETERS:  aml_buffer          - Pointer to the resource byte stream
+ *              aml_buffer_length   - Length of the aml_buffer
+ *              resource_ptr        - Where the converted resource is returned
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Convert a raw AML buffer to a resource list
+ *
+ ******************************************************************************/
+acpi_status
+acpi_buffer_to_resource(u8 *aml_buffer,
+			u16 aml_buffer_length,
+			struct acpi_resource **resource_ptr)
+{
+	acpi_status status;
+	acpi_size list_size_needed;
+	void *resource;
+	void *current_resource_ptr;
+
+	/*
+	 * Note: we allow AE_AML_NO_RESOURCE_END_TAG, since an end tag
+	 * is not required here.
+	 */
+
+	/* Get the required length for the converted resource */
+
+	status = acpi_rs_get_list_length(aml_buffer, aml_buffer_length,
+					 &list_size_needed);
+	if (status == AE_AML_NO_RESOURCE_END_TAG) {
+		status = AE_OK;
+	}
+	if (ACPI_FAILURE(status)) {
+		return (status);
+	}
+
+	/* Allocate a buffer for the converted resource */
+
+	resource = ACPI_ALLOCATE_ZEROED(list_size_needed);
+	current_resource_ptr = resource;
+	if (!resource) {
+		return (AE_NO_MEMORY);
+	}
+
+	/* Perform the AML-to-Resource conversion */
+
+	status = acpi_ut_walk_aml_resources(aml_buffer, aml_buffer_length,
+					    acpi_rs_convert_aml_to_resources,
+					    &current_resource_ptr);
+	if (status == AE_AML_NO_RESOURCE_END_TAG) {
+		status = AE_OK;
+	}
+	if (ACPI_FAILURE(status)) {
+		ACPI_FREE(resource);
+	} else {
+		*resource_ptr = resource;
+	}
+
+	return (status);
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_rs_create_resource_list
  *
  * PARAMETERS:  aml_buffer          - Pointer to the resource byte stream
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 726d937..5d8df1d 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -376,6 +376,11 @@ acpi_status
 acpi_resource_to_address64(struct acpi_resource *resource,
 			   struct acpi_resource_address64 *out);
 
+acpi_status
+acpi_buffer_to_resource(u8 *aml_buffer,
+			u16 aml_buffer_length,
+			struct acpi_resource **resource_ptr);
+
 /*
  * Hardware (ACPI device) interfaces
  */
-- 
1.7.9.rc1

