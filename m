Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2JFUM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:12:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35281 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2JFUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:12:51 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 09/49] ACPICA: Headers: Add support for CSRT and DBG2 ACPI tables.
Date: Sat,  6 Oct 2012 16:09:30 -0400
Message-Id: <4e2f9c278ad84196991fcf6f6646a3e15967fe90.1349554105.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

These tables are defined outside of the ACPI specification.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/actbl2.h | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/actbl3.h |   1 -
 2 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index d9ceb3d..b74476c 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -63,6 +63,8 @@
  */
 #define ACPI_SIG_ASF            "ASF!"	/* Alert Standard Format table */
 #define ACPI_SIG_BOOT           "BOOT"	/* Simple Boot Flag Table */
+#define ACPI_SIG_CSRT           "CSRT"	/* Core System Resource Table */
+#define ACPI_SIG_DBG2           "DBG2"	/* Debug Port table type 2 */
 #define ACPI_SIG_DBGP           "DBGP"	/* Debug Port table */
 #define ACPI_SIG_DMAR           "DMAR"	/* DMA Remapping table */
 #define ACPI_SIG_HPET           "HPET"	/* High Precision Event Timer table */
@@ -232,6 +234,115 @@ struct acpi_table_boot {
 
 /*******************************************************************************
  *
+ * CSRT - Core System Resource Table
+ *        Version 0
+ *
+ * Conforms to the "Core System Resource Table (CSRT)", November 14, 2011
+ *
+ ******************************************************************************/
+
+struct acpi_table_csrt {
+	struct acpi_table_header header;	/* Common ACPI table header */
+};
+
+/* Resource Group subtable */
+
+struct acpi_csrt_group {
+	u32 length;
+	u32 vendor_id;
+	u32 subvendor_id;
+	u16 device_id;
+	u16 subdevice_id;
+	u16 revision;
+	u16 reserved;
+	u32 info_length;
+
+	/* Shared data (length = info_length) immediately follows */
+};
+
+/* Resource Descriptor subtable */
+
+struct acpi_csrt_descriptor {
+	u32 length;
+	u16 type;
+	u16 subtype;
+	u32 uid;
+
+	/* Resource-specific information immediately follows */
+};
+
+/* Resource Types */
+
+#define ACPI_CSRT_TYPE_INTERRUPT    0x0001
+#define ACPI_CSRT_TYPE_TIMER        0x0002
+#define ACPI_CSRT_TYPE_DMA          0x0003
+
+/* Resource Subtypes */
+
+#define ACPI_CSRT_XRUPT_LINE        0x0000
+#define ACPI_CSRT_XRUPT_CONTROLLER  0x0001
+#define ACPI_CSRT_TIMER             0x0000
+#define ACPI_CSRT_DMA_CHANNEL       0x0000
+#define ACPI_CSRT_DMA_CONTROLLER    0x0001
+
+/*******************************************************************************
+ *
+ * DBG2 - Debug Port Table 2
+ *        Version 0 (Both main table and subtables)
+ *
+ * Conforms to "Microsoft Debug Port Table 2 (DBG2)", May 22 2012.
+ *
+ ******************************************************************************/
+
+struct acpi_table_dbg2 {
+	struct acpi_table_header header;	/* Common ACPI table header */
+	u32 info_offset;
+	u32 info_count;
+};
+
+/* Debug Device Information Subtable */
+
+struct acpi_dbg2_device {
+	u8 revision;
+	u16 length;
+	u8 register_count;	/* Number of base_address registers */
+	u16 namepath_length;
+	u16 namepath_offset;
+	u16 oem_data_length;
+	u16 oem_data_offset;
+	u16 port_type;
+	u16 port_subtype;
+	u16 reserved;
+	u16 base_address_offset;
+	u16 address_size_offset;
+	/*
+	 * Data that follows:
+	 *    base_address (required) - Each in 12-byte Generic Address Structure format.
+	 *    address_size (required) - Array of u32 sizes corresponding to each base_address register.
+	 *    Namepath    (required) - Null terminated string. Single dot if not supported.
+	 *    oem_data    (optional) - Length is oem_data_length.
+	 */
+};
+
+/* Types for port_type field above */
+
+#define ACPI_DBG2_SERIAL_PORT       0x8000
+#define ACPI_DBG2_1394_PORT         0x8001
+#define ACPI_DBG2_USB_PORT          0x8002
+#define ACPI_DBG2_NET_PORT          0x8003
+
+/* Subtypes for port_subtype field above */
+
+#define ACPI_DBG2_16550_COMPATIBLE  0x0000
+#define ACPI_DBG2_16550_SUBSET      0x0001
+
+#define ACPI_DBG2_1394_STANDARD     0x0000
+
+#define ACPI_DBG2_USB_XHCI          0x0000
+#define ACPI_DBG2_USB_EHCI          0x0001
+
+/*******************************************************************************
+ *
  * DBGP - Debug Port table
  *        Version 1
  *
diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index f65a0ed..37781ab 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -75,7 +75,6 @@
 /* Reserved table signatures */
 
 #define ACPI_SIG_CSRT           "CSRT"	/* Core System Resources Table */
-#define ACPI_SIG_DBG2           "DBG2"	/* Debug Port table 2 */
 #define ACPI_SIG_MATR           "MATR"	/* Memory Address Translation Table */
 #define ACPI_SIG_MSDM           "MSDM"	/* Microsoft Data Management Table */
 #define ACPI_SIG_WPBT           "WPBT"	/* Windows Platform Binary Table */
-- 
1.8.0.rc0.18.gf84667d

