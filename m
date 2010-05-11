Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0EKUu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:50:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0EKUu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:50:28 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, Peter Jones <pjones@redhat.com>
Subject: [PATCH 2/4] ibft: For UEFI machines actually do scan ACPI for iBFT.
Date: Tue, 11 May 2010 18:04:15 +0000
Message-Id: <1273601057-5907-3-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273601057-5907-1-git-send-email-konrad@kernel.org>
References: <1273601057-5907-1-git-send-email-konrad@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 20:49:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For machines with IBFT 1.03 do scan the ACPI table for 'iBFT'
or for 'IBFT'. If the machine is in UEFI mode, only do the ACPI
table scan. For all other machines (pre IBFT 1.03) do
a memory scan if not found in the ACPI tables.

Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Tested-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/firmware/iscsi_ibft_find.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index dd85555..82a7a15 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -57,23 +57,12 @@ static int __init acpi_find_ibft(struct acpi_table_header *header)
 }
 #endif /* CONFIG_ACPI */
 
-/*
- * Routine used to find the iSCSI Boot Format Table. The logical
- * kernel address is set in the ibft_addr global variable.
- */
-unsigned long __init find_ibft_region(unsigned long *sizep)
+static int __init find_ibft_in_mem(void)
 {
 	unsigned long pos;
 	unsigned int len = 0;
 	void *virt;
 
-	ibft_addr = NULL;
-
-	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
-	 * only use ACPI for this */
-	if (efi_enabled)
-		return 0;
-
 	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
 		/* The table can't be inside the VGA BIOS reserved space,
 		 * so skip that area */
@@ -92,6 +81,17 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 			}
 		}
 	}
+	return len;
+}
+/*
+ * Routine used to find the iSCSI Boot Format Table. The logical
+ * kernel address is set in the ibft_addr global variable.
+ */
+unsigned long __init find_ibft_region(unsigned long *sizep)
+{
+
+	ibft_addr = NULL;
+
 #ifdef CONFIG_ACPI
 	/*
 	 * One spec says "IBFT", the other says "iBFT". We have to check
@@ -102,6 +102,13 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 	if (!ibft_addr)
 		acpi_table_parse("iBFT", acpi_find_ibft);
 #endif /* CONFIG_ACPI */
+
+	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
+	 * only use ACPI for this */
+
+	if (!ibft_addr && !efi_enabled)
+		find_ibft_in_mem();
+
 	if (ibft_addr) {
 		*sizep = PAGE_ALIGN(ibft_addr->header.length);
 		return (u64)isa_virt_to_bus(ibft_addr);
-- 
1.7.1

