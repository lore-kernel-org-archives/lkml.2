Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0LFX0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:26:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27230 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0LFXZ1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 17/23] agp: Make agp_generic_[create|free]_gatt_table be aware of PCI API.
Date: Mon,  6 Dec 2010 18:24:29 -0500
Message-Id: <1291677875-30493-18-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the platform does not use the PCI API, we want to
still use the old mechanism of saving the gatt_bus_addr.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/generic.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index b21eebb..534dccb 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -911,6 +911,7 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 	temp = bridge->current_size;
 	size = page_order = num_entries = 0;
 
+	bridge->gatt_bus_addr = DMA_ERROR_CODE;
 	if (bridge->driver->size_type != FIXED_APER_SIZE) {
 		do {
 			switch (bridge->driver->size_type) {
@@ -999,10 +1000,12 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 			ClearPageReserved(page);
 
 		free_gatt_pages(bridge, page_order);
-
+		bridge->gatt_bus_addr = DMA_ERROR_CODE;
 		return -ENOMEM;
 	}
-	bridge->gatt_bus_addr = virt_to_phys(bridge->gatt_table_real);
+	/* If using PCI API, alloc_gatt_pages would fill in gatt_bus_addr. */
+	if (bridge->gatt_bus_addr == DMA_ERROR_CODE)
+		bridge->gatt_bus_addr = virt_to_phys(bridge->gatt_table_real);
 
 	/* AK: bogus, should encode addresses > 4GB */
 	for (i = 0; i < num_entries; i++) {
-- 
1.7.1

