Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0LFX0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:26:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0LFXZ1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 16/23] agp: save the size of GATT table.
Date: Mon,  6 Dec 2010 18:24:28 -0500
Message-Id: <1291677875-30493-17-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad@kernel.org>

We need this extra value when we use the PCI API for 
de-allocating the GART pages.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/agp.h     |    1 +
 drivers/char/agp/generic.c |   10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 6c60d68..6569d01 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -133,6 +133,7 @@ struct agp_bridge_data {
 	struct pci_dev *dev;
 	u32 __iomem *gatt_table;
 	u32 *gatt_table_real;
+	ssize_t gatt_table_size;
 	unsigned long scratch_page;
 	struct page *scratch_page_page;
 	dma_addr_t scratch_page_dma;
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 4cf3f94..b21eebb 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -974,14 +974,14 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 	if (table == NULL)
 		return -ENOMEM;
 
-	table_end = table + ((PAGE_SIZE * (1 << page_order)) - 1);
+	bridge->gatt_table_size = PAGE_SIZE * (1 << page_order);
+	table_end = table + bridge->gatt_table_size - 1;
 
 	for (page = virt_to_page(table); page <= virt_to_page(table_end); page++)
 		SetPageReserved(page);
 
 	bridge->gatt_table_real = (u32 *) table;
 	agp_gatt_table = (void *)table;
-
 	bridge->driver->cache_flush();
 #ifdef CONFIG_X86
 	if (set_memory_uc((unsigned long)table, 1 << page_order))
@@ -990,7 +990,7 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 	bridge->gatt_table = (void *)table;
 #else
 	bridge->gatt_table = ioremap_nocache(virt_to_phys(table),
-					(PAGE_SIZE * (1 << page_order)));
+					bridge->gatt_table_size);
 	bridge->driver->cache_flush();
 #endif
 
@@ -1055,7 +1055,7 @@ int agp_generic_free_gatt_table(struct agp_bridge_data *bridge)
 	iounmap(bridge->gatt_table);
 #endif
 	table = (char *) bridge->gatt_table_real;
-	table_end = table + ((PAGE_SIZE * (1 << page_order)) - 1);
+	table_end = table + bridge->gatt_table_size - 1;
 
 	for (page = virt_to_page(table); page <= virt_to_page(table_end); page++)
 		ClearPageReserved(page);
@@ -1066,7 +1066,7 @@ int agp_generic_free_gatt_table(struct agp_bridge_data *bridge)
 	bridge->gatt_table = NULL;
 	bridge->gatt_table_real = NULL;
 	bridge->gatt_bus_addr = 0;
-
+	bridge->gatt_table_size = 0;
 	return 0;
 }
 EXPORT_SYMBOL(agp_generic_free_gatt_table);
-- 
1.7.1

