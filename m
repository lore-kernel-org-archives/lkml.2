Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0LFXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27190 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0LFXZX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 15/23] agp: Make agp_generic_insert_memory use the mem->dma_addr[i].
Date: Mon,  6 Dec 2010 18:24:27 -0500
Message-Id: <1291677875-30493-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms that are not using the PCI API the value
of dma_addr[i] is page_to_phys(mem->page[i]), which was
obtained by using the _agp_alloc_page macro.

This does mean that drivers that have their own .agp_create_page
functions and don't populate dma_addr[i] and use this
agp_generic_insert_memory need to have this right. Fortunatly,
all of the previous patches have done so. Just in case we have
a warning and end use the old mechanism to get the DMA address.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/generic.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 65fd7c7..4cf3f94 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1142,8 +1142,13 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
+		dma_addr_t dma_addr = mem->dma_addr[i];
+		if (dma_addr == DMA_ERROR_CODE) {
+			WARN_ONCE(1, "Caller hasn't converted to DMA API!\n");
+			dma_addr = page_to_phys(mem->pages[i]);
+		}
 		writel(bridge->driver->mask_memory(bridge,
-						   page_to_phys(mem->pages[i]),
+						   dma_addr,
 						   mask_type),
 		       bridge->gatt_table+j);
 	}
-- 
1.7.1

