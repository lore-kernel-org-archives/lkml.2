Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0LFXZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26821 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0LFXZK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/23] agp/nvidia: Use the dma_addr[] instead of page_to_phys when inserting.
Date: Mon,  6 Dec 2010 18:24:19 -0500
Message-Id: <1291677875-30493-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_addr contains the same value as page_to_phys(page). That is
until the PCI API is enabled at which point the dma_addr will
contain the true DMA (bus) address - which on baremetal will in all
likehood be the same as page_to_phys(page). But under Xen it might
be different.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/nvidia-agp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index b9734a9..4b4993f 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -224,7 +224,7 @@ static int nvidia_insert_memory(struct agp_memory *mem, off_t pg_start, int type
 	}
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			       page_to_phys(mem->pages[i]), mask_type),
+			       mem->dma_addr[i], mask_type),
 			agp_bridge->gatt_table+nvidia_private.pg_offset+j);
 	}
 
-- 
1.7.1

