Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2DJWYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:24:16 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:44961 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550Ab2DJWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:23:42 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/4] ACPI: Set hotplug _OST support bit to _OSC
Date: Tue, 10 Apr 2012 16:21:47 -0600
Message-Id: <1334096510-17319-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added macro definitions of _OST source event and status codes.
Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
since this _OSC bit is not specific to CPU hotplug.  This bit is
defined in table 6-147 of ACPI 5.0 as follows.

  Bits:       3
  Field Name: Insertion / Ejection _OST Processing Support
  Definition: This bit is set if OSPM will evaluate the _OST
              object defined under a device when processing
              insertion and ejection source event codes.

This patch sets OSC_SB_HOTPLUG_OST_SUPPORT to the platform-wide
OSPM capabilities when CONFIG option of ACPI CPU hotplug or memory
hotplug is enabled.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/bus.c   |    5 +++++
 include/linux/acpi.h |   26 +++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 3263b68..a492d64 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -544,6 +544,11 @@ static void acpi_bus_osc_support(void)
 	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
 #endif
 
+#if defined(CONFIG_ACPI_HOTPLUG_CPU) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||\
+		 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
+	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_HOTPLUG_OST_SUPPORT;
+#endif
+
 	if (!ghes_disable)
 		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f421dd8..4127df8 100644
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
@@ -309,6 +309,30 @@ extern bool osc_sb_apei_support_acked;
 
 extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
 					     u32 *mask, u32 req);
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

