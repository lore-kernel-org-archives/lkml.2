Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab2FYREI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:04:08 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:31318 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2FYRED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:04:03 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        andi@firstfloor.org, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 1/6] ACPI: Add an interface to evaluate _OST
Date: Mon, 25 Jun 2012 10:59:28 -0600
Message-Id: <1340643573-28299-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
References: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added acpi_evaluate_hotplug_opt(). All ACPI hotplug handlers must call
this function when evaluating _OST for hotplug operations. If the
platform does not support _OST, this function returns AE_NOT_FOUND and
has no effect on the platform.

ACPI_HOTPLUG_OST is defined when all relevant ACPI hotplug operations,
such as CPU, memory and container hotplug, are enabled. This assures
consistent behavior among the hotplug operations with regarding the
_OST support. When ACPI_HOTPLUG_OST is not defined, this function is
a no-op.

ACPI PCI hotplug is not enhanced to support _OST at this time since it
is a legacy method being replaced by PCIe native hotplug. _OST support
for ACPI PCI hotplug may be added in future if necessary.

Some platforms may require the OS to support _OST in order to support
ACPI hotplug operations. For example, if a platform has the management
console where user can request a hotplug operation from, this _OST
support would be required for the management console to show the result
of the hotplug request to user.

Added macro definitions of _OST source events and status codes.
Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
since this _OSC bit is not specific to CPU hotplug. This bit is
defined in Table 6-147 of ACPI 5.0 as follows.

  Bits:       3
  Field Name: Insertion / Ejection _OST Processing Support
  Definition: This bit is set if OSPM will evaluate the _OST
              object defined under a device when processing
              insertion and ejection source event codes.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/utils.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |    3 +++
 include/linux/acpi.h    |   40 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index adbbc1c..3e87c9c 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -412,3 +412,45 @@ out:
 	return status;
 }
 EXPORT_SYMBOL(acpi_get_physical_device_location);
+
+/**
+ * acpi_evaluate_hotplug_ost: Evaluate _OST for hotplug operations
+ * @handle: ACPI device handle
+ * @source_event: source event code
+ * @status_code: status code
+ * @status_buf: optional detailed information (NULL if none)
+ *
+ * Evaluate _OST for hotplug operations. All ACPI hotplug handlers
+ * must call this function when evaluating _OST for hotplug operations.
+ * When the platform does not support _OST, this function has no effect.
+ */
+acpi_status
+acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
+		u32 status_code, struct acpi_buffer *status_buf)
+{
+#ifdef ACPI_HOTPLUG_OST
+	union acpi_object params[3] = {
+		{.type = ACPI_TYPE_INTEGER,},
+		{.type = ACPI_TYPE_INTEGER,},
+		{.type = ACPI_TYPE_BUFFER,}
+	};
+	struct acpi_object_list arg_list = {3, params};
+	acpi_status status;
+
+	params[0].integer.value = source_event;
+	params[1].integer.value = status_code;
+	if (status_buf != NULL) {
+		params[2].buffer.pointer = status_buf->pointer;
+		params[2].buffer.length = status_buf->length;
+	} else {
+		params[2].buffer.pointer = NULL;
+		params[2].buffer.length = 0;
+	}
+
+	status = acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
+	return status;
+#else
+	return AE_OK;
+#endif
+}
+EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 9e6e1c6..1d9e432 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -50,6 +50,9 @@ acpi_evaluate_reference(acpi_handle handle,
 			acpi_string pathname,
 			struct acpi_object_list *arguments,
 			struct acpi_handle_list *list);
+acpi_status
+acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
+			u32 status_code, struct acpi_buffer *status_buf);
 
 struct acpi_pld {
 	unsigned int revision:7; /* 0 */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f421dd8..b2b4d2a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -277,7 +277,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_PAD_SUPPORT		1
 #define OSC_SB_PPC_OST_SUPPORT		2
 #define OSC_SB_PR3_SUPPORT		4
-#define OSC_SB_CPUHP_OST_SUPPORT	8
+#define OSC_SB_HOTPLUG_OST_SUPPORT	8
 #define OSC_SB_APEI_SUPPORT		16
 
 extern bool osc_sb_apei_support_acked;
@@ -309,6 +309,44 @@ extern bool osc_sb_apei_support_acked;
 
 extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
 					     u32 *mask, u32 req);
+
+/* Enable _OST when all relevant hotplug operations are enabled */
+#if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
+	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
+	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
+	(defined(CONFIG_ACPI_CONTAINER) ||		\
+	 defined(CONFIG_ACPI_CONTAINER_MODULE))
+#define ACPI_HOTPLUG_OST
+#endif
+
+/* _OST Source Event Code (OSPM Action) */
+#define ACPI_OST_EC_OSPM_SHUTDOWN		0x100
+#define ACPI_OST_EC_OSPM_EJECT			0x103
+#define ACPI_OST_EC_OSPM_INSERTION		0x200
+
+/* _OST General Processing Status Code */
+#define ACPI_OST_SC_SUCCESS			0x0
+#define ACPI_OST_SC_NON_SPECIFIC_FAILURE	0x1
+#define ACPI_OST_SC_UNRECOGNIZED_NOTIFY		0x2
+
+/* _OST OS Shutdown Processing (0x100) Status Code */
+#define ACPI_OST_SC_OS_SHUTDOWN_DENIED		0x80
+#define ACPI_OST_SC_OS_SHUTDOWN_IN_PROGRESS	0x81
+#define ACPI_OST_SC_OS_SHUTDOWN_COMPLETED	0x82
+#define ACPI_OST_SC_OS_SHUTDOWN_NOT_SUPPORTED	0x83
+
+/* _OST Ejection Request (0x3, 0x103) Status Code */
+#define ACPI_OST_SC_EJECT_NOT_SUPPORTED		0x80
+#define ACPI_OST_SC_DEVICE_IN_USE		0x81
+#define ACPI_OST_SC_DEVICE_BUSY			0x82
+#define ACPI_OST_SC_EJECT_DEPENDENCY_BUSY	0x83
+#define ACPI_OST_SC_EJECT_IN_PROGRESS		0x84
+
+/* _OST Insertion Request (0x200) Status Code */
+#define ACPI_OST_SC_INSERT_IN_PROGRESS		0x80
+#define ACPI_OST_SC_DRIVER_LOAD_FAILURE		0x81
+#define ACPI_OST_SC_INSERT_NOT_SUPPORTED	0x82
+
 extern void acpi_early_init(void);
 
 extern int acpi_nvs_register(__u64 start, __u64 size);
-- 
1.7.7.6

