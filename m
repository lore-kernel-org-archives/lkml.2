Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2IYO5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:57:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab2IYO42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:56:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: lenb@kernel.org, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 4/6] ACPI: Implement physical address table override
Date: Tue, 25 Sep 2012 16:55:59 +0200
Message-Id: <1348584961-1476-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1348584961-1476-1-git-send-email-trenn@suse.de>
References: <1348584961-1476-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patches stored ACPI tables provided via initrd in a memblock reserved
area.
If a table is loaded and the table type of an initrd provided one matches,
the one from initrd is prefered.
In case of a SSDT table, the OEM table id also has to match.

ACPI tables can be loaded at boot time (static table pointers in XSDT),
but also dynamically any time later via ASL commands load() or loadTable().
The override mechanism always works.


Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 drivers/acpi/osl.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index b20b079..007224b 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -681,12 +681,64 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 
 acpi_status
 acpi_os_physical_table_override(struct acpi_table_header *existing_table,
-				acpi_physical_address * new_address,
-				u32 *new_table_length)
+				acpi_physical_address *address,
+				u32 *table_length)
 {
-	return AE_SUPPORT;
-}
+#ifndef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+	*table_length = 0;
+	*address = 0;
+	return AE_OK;
+#else
+	int table_offset = 0;
+	struct acpi_table_header *table;
+
+	*table_length = 0;
+	*address = 0;
+
+	if (!acpi_tables_addr)
+		return AE_OK;
+
+	do {
+		if (table_offset + ACPI_HEADER_SIZE > all_tables_size) {
+			WARN_ON(1);
+			return AE_OK;
+		}
+
+		table = acpi_os_map_memory(acpi_tables_addr + table_offset,
+					   ACPI_HEADER_SIZE);
+
+		if (table_offset + table->length > all_tables_size) {
+			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+			WARN_ON(1);
+			return AE_OK;
+		}
 
+		table_offset += table->length;
+
+		if (memcmp(existing_table->signature, table->signature, 4)) {
+			acpi_os_unmap_memory(table,
+				     ACPI_HEADER_SIZE);
+			continue;
+		}
+
+		/* Only override tables with matching oem id */
+		if (memcmp(table->oem_table_id, existing_table->oem_table_id,
+			   ACPI_OEM_TABLE_ID_SIZE)) {
+			acpi_os_unmap_memory(table,
+				     ACPI_HEADER_SIZE);
+			continue;
+		}
+
+		table_offset -= table->length;
+		*table_length = table->length;
+		acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
+		*address = acpi_tables_addr + table_offset;
+		break;
+	} while (table_offset + ACPI_HEADER_SIZE < all_tables_size);
+
+	return AE_OK;
+#endif
+}
 
 static irqreturn_t acpi_irq(int irq, void *dev_id)
 {
-- 
1.7.6.1

