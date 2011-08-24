Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1HXJsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:48:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab1HXJs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:48:26 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: eric.piel@tremplin-utc.net, jnelson-suse@jamponi.net, devel@acpica.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, hpa@zytor.com, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/2] ACPICA: Introduce acpi_os_phys_table_override function
Date: Wed, 24 Aug 2011 11:48:09 +0200
Message-Id: <1314179290-31526-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1314179290-31526-1-git-send-email-trenn@suse.de>
References: <1314179290-31526-1-git-send-email-trenn@suse.de>
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

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: devel@acpica.org
CC: linux-acpi@vger.kernel.org
CC: lenb@kernel.org
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
index 0f2d395..df85afe 100644
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
+			mapped_table = acpi_os_map_memory(address,
+					  sizeof(struct acpi_table_header));
+			address = tmp_addr;
+		}
 		flags = ACPI_TABLE_ORIGIN_MAPPED;
+		table_to_install = mapped_table;
 	}
 
 	/* Initialize the table entry */
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index fa32f58..49b5fa6 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -522,6 +522,17 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
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
index 4543b6f..0bef969 100644
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
1.7.3.4

