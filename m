Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1KDCzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:55:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab1KDCzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:55:08 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        devel@acpica.org, VoJcEK <vojcek@tlen.pl>, Markus <dsdt@gaugusch.at>,
        eric@gaugusch.at, Michael Chang <mchang@suse.com>,
        ming.m.lin@intel.com
Subject: [PATCH 1/2] ACPICA: Introduce acpi_os_phys_table_override function V2
Date: Fri,  4 Nov 2011 03:54:50 +0100
Message-Id: <1320375291-5622-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1320375291-5622-1-git-send-email-trenn@suse.de>
References: <1320375291-5622-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it's only possible to feed acpica with virtual
address for table overriding.
This patch introduces a function which allows the OS to
pass physical addresses for table overriding.

This is necessary to allow early table overridings of
arbitrary ACPI tables.

An extra flag like ACPI_TABLE_ORIGIN_OVERRIDE is not used,
because physical address overriding is rather transparent
(the same way acpica expects to get tables from reserved
memory BIOS regions which is the normal way).

V2: Includes a fix from Michael Chang:
Fix wrongly mapped acpi table header when overriding via initrd

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: devel@acpica.org
CC: lenb@kernel.org
CC: VoJcEK <vojcek@tlen.pl>
CC: Markus <dsdt@gaugusch.at>
CC: eric@gaugusch.at
CC: Michael Chang <mchang@suse.com>
CC: ming.m.lin@intel.com
---
 drivers/acpi/acpica/tbinstal.c |   15 +++++++++++++++
 drivers/acpi/acpica/tbutils.c  |   18 +++++++++++++++++-
 drivers/acpi/osl.c             |   11 +++++++++++
 include/acpi/acpiosxf.h        |    4 ++++
 4 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index 62365f6..b9b9d2a 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -242,6 +242,21 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 		table_desc->pointer = override_table;
 		table_desc->length = override_table->length;
 		table_desc->flags = ACPI_TABLE_ORIGIN_OVERRIDE;
+	} else {
+		acpi_physical_address address = 0;
+		u32 table_len = 0;
+		status = acpi_os_phys_table_override(table_desc->pointer,
+						     &address, &table_len);
+		if (ACPI_SUCCESS(status) && table_len && address) {
+			ACPI_INFO((AE_INFO, "%4.4s @ 0x%p "
+				   "Phys table override, replaced with:",
+				   table_desc->pointer->signature,
+				   ACPI_CAST_PTR(void, table_desc->address)));
+			table_desc->address = address;
+			table_desc->pointer = acpi_os_map_memory(address,
+								 table_len);
+			table_desc->length = table_len;
+		}
 	}
 
 	/* Add the table to the global root table list */
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 0f2d395..2e797d9 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -499,8 +499,24 @@ acpi_tb_install_table(acpi_physical_address address,
 		table_to_install = override_table;
 		flags = ACPI_TABLE_ORIGIN_OVERRIDE;
 	} else {
-		table_to_install = mapped_table;
+		u32 table_len = 0;
+		acpi_physical_address tmp_addr = 0;
+
+		status = acpi_os_phys_table_override(mapped_table,
+						     &tmp_addr, &table_len);
+		if (ACPI_SUCCESS(status) && table_len && tmp_addr) {
+			ACPI_INFO((AE_INFO, "%4.4s @ 0x%p "
+				   "Phys table override, replaced with:",
+				   mapped_table->signature,
+				   ACPI_CAST_PTR(void, address)));
+			acpi_os_unmap_memory(mapped_table,
+					     sizeof(struct acpi_table_header));
+			address = tmp_addr;
+			mapped_table = acpi_os_map_memory(address,
+					  sizeof(struct acpi_table_header));
+		}
 		flags = ACPI_TABLE_ORIGIN_MAPPED;
+		table_to_install = mapped_table;
 	}
 
 	/* Initialize the table entry */
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f31c5c5..099a3a6 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -523,6 +523,17 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 	return AE_OK;
 }
 
+acpi_status
+acpi_os_phys_table_override(struct acpi_table_header *existing_table,
+			    acpi_physical_address *address, u32 *table_length)
+{
+	if (!existing_table)
+		return AE_BAD_PARAMETER;
+
+	table_length = 0;
+	return AE_OK;
+}
+
 static irqreturn_t acpi_irq(int irq, void *dev_id)
 {
 	u32 handled;
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 83062ed..a56a811 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -95,6 +95,10 @@ acpi_status
 acpi_os_table_override(struct acpi_table_header *existing_table,
 		       struct acpi_table_header **new_table);
 
+acpi_status
+acpi_os_phys_table_override(struct acpi_table_header *existing_table,
+			    acpi_physical_address *address, u32 *table_length);
+
 /*
  * Spinlock primitives
  */
-- 
1.7.6.1

