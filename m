Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0LFXZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26820 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0LFXZK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/23] agp: Make agp_generic_[alloc|destroy]_pages use the _agp_[alloc|free]_page macro.
Date: Mon,  6 Dec 2010 18:24:16 -0500
Message-Id: <1291677875-30493-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way when we want to opt in a platform to use the PCI DMA it
is just the matter of changing the implementation in
arch/<platform>/include/asm/agp.h

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/generic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index bcefc66..cf465b5 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1233,7 +1233,7 @@ int agp_generic_alloc_pages(struct agp_bridge_data *bridge, struct agp_memory *m
 	int i, ret = -ENOMEM;
 
 	for (i = 0; i < num_pages; i++) {
-		page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
+		page = _agp_alloc_page(agp_bridge, &mem->dma_addr[i]);
 		/* agp_free_memory() needs gart address */
 		if (page == NULL)
 			goto out;
@@ -1292,7 +1292,7 @@ void agp_generic_destroy_pages(struct agp_memory *mem)
 		unmap_page_from_agp(page);
 #endif
 		put_page(page);
-		__free_page(page);
+		_agp_free_page(agp_bridge, page, &mem->dma_addr[i]);
 		atomic_dec(&agp_bridge->current_memory_agp);
 		mem->pages[i] = NULL;
 	}
-- 
1.7.1

