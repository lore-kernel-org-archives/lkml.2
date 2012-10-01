Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2JADjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 23:39:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab2JADjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 23:39:14 -0400
Date: Sun, 30 Sep 2012 20:38:59 -0700
From: tip-bot for Thomas Renninger <trenn@suse.de>
Message-ID: <tip-b2a35003dfbcc7b7a5e5c6e524e7d49ba66e0bb5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
In-Reply-To: <1349043837-22659-5-git-send-email-trenn@suse.de>
References: <1349043837-22659-5-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] ACPI: Implement physical address table override
Git-Commit-ID: b2a35003dfbcc7b7a5e5c6e524e7d49ba66e0bb5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 30 Sep 2012 20:39:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2a35003dfbcc7b7a5e5c6e524e7d49ba66e0bb5
Gitweb:     http://git.kernel.org/tip/b2a35003dfbcc7b7a5e5c6e524e7d49ba66e0bb5
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Mon, 1 Oct 2012 00:23:55 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 30 Sep 2012 18:03:29 -0700

ACPI: Implement physical address table override

Previous patches stored ACPI tables provided via initrd in a memblock reserved
area.
If a table is loaded and the table type of an initrd provided one matches,
the one from initrd is prefered.
In case of a SSDT table, the OEM table id also has to match.

ACPI tables can be loaded at boot time (static table pointers in XSDT),
but also dynamically any time later via ASL commands load() or loadTable().
The override mechanism always works.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1349043837-22659-5-git-send-email-trenn@suse.de
Cc: Len Brown <lenb@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
