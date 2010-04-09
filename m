Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0DIOWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:22:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:33498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab0DIOWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:22:22 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH 2/2] ibft: For UEFI machines actually do scan ACPI for iBFT.
Date: Fri,  9 Apr 2010 14:21:28 +0000
Message-Id: <1270822888-13192-3-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270822888-13192-1-git-send-email-konrad@kernel.org>
References: <1270822888-13192-1-git-send-email-konrad@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Apr 2010 14:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For machines with IBFT 1.03 do scan the ACPI table for 'iBFT'
or for 'IBFT'. If the machine is in UEFI mode, only do the ACPI
table scan. For all other machines (pre IBFT 1.03) do
a memory scan if not found in the ACPI tables.

Author: Konrad Rzeszutek Wilk <konrad@kernel.org>
Acked-by: Peter Jones <pjones@redhat.com>
Tested-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 drivers/firmware/iscsi_ibft_find.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index 8f4d157..0bc3fae 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -56,23 +56,12 @@ static int __init acpi_find_ibft(struct acpi_table_header *header)
 }
 #endif /* CONFIG_ACPI */
 
-/*
- * Routine used to find the iSCSI Boot Format Table. The logical
- * kernel address is set in the ibft_addr global variable.
- */
-unsigned long __init find_ibft_region(unsigned long *sizep)
+static int __init find_ibft_mem_scan(void)
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
@@ -91,6 +80,17 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
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
@@ -101,6 +101,13 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 	if (!ibft_addr)
 		acpi_table_parse("iBFT", acpi_find_ibft);
 #endif /* CONFIG_ACPI */
+
+	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
+	 * only use ACPI for this */
+
+	if (!ibft_addr && !efi_enabled)
+		find_ibft_mem_scan();
+
 	if (ibft_addr) {
 		*sizep = PAGE_ALIGN(ibft_addr->header.length);
 		return (u64)isa_virt_to_bus(ibft_addr);
-- 
1.7.0.4

