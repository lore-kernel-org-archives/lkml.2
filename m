Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0LFX2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:28:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27001 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab0LFXZO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/23] agp/amd64: Use the dma_addr[] and gatt_bus_addr instead of [page|virt]_to_phys respectivly.
Date: Mon,  6 Dec 2010 18:24:20 -0500
Message-Id: <1291677875-30493-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_addr/gatt_bus_addr contains the same value as page_to_phys(page) and
virt_to_phys(agp_bridge->gatt_bus_addr) respectivly. That is
until the PCI API is enabled at which point the dma_addr will
contain the true DMA (bus) address - which on baremetal will in all
likehood be the same as page_to_phys(page)/virt_to_phys(..). However
under Xen it might be different.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/amd64-agp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 42396df..b28bd86 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -79,7 +79,7 @@ static int amd64_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		tmp = agp_bridge->driver->mask_memory(agp_bridge,
-						      page_to_phys(mem->pages[i]),
+						      mem->dma_addr[i],
 						      mask_type);
 
 		BUG_ON(tmp & 0xffffff0000000ffcULL);
@@ -178,7 +178,7 @@ static const struct aper_size_info_32 amd_8151_sizes[7] =
 
 static int amd_8151_configure(void)
 {
-	unsigned long gatt_bus = virt_to_phys(agp_bridge->gatt_table_real);
+	unsigned long gatt_bus = agp_bridge->gatt_bus_addr;
 	int i;
 
 	if (!k8_northbridges.gart_supported)
-- 
1.7.1

