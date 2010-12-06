Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0LFXZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26827 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0LFXZK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/23] agp: Add dma_addr array in struct agp_memory.
Date: Mon,  6 Dec 2010 18:24:14 -0500
Message-Id: <1291677875-30493-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are expanding the 'struct agp_memory' with an extra array
of dma_addr_t values. They correspond 1-to-1 to the page* array.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/generic.c  |    9 +++++++--
 include/linux/agp_backend.h |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 09332ba..bcefc66 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -97,11 +97,14 @@ EXPORT_SYMBOL(agp_flush_chipset);
 void agp_alloc_page_array(size_t size, struct agp_memory *mem)
 {
 	mem->pages = NULL;
-
-	if (size <= 2*PAGE_SIZE)
+	mem->dma_addr = NULL;
+	if (size <= 2*PAGE_SIZE) {
 		mem->pages = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		mem->dma_addr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	}
 	if (mem->pages == NULL) {
 		mem->pages = vmalloc(size);
+		mem->dma_addr = vmalloc(size);
 	}
 }
 EXPORT_SYMBOL(agp_alloc_page_array);
@@ -110,8 +113,10 @@ void agp_free_page_array(struct agp_memory *mem)
 {
 	if (is_vmalloc_addr(mem->pages)) {
 		vfree(mem->pages);
+		vfree(mem->dma_addr);
 	} else {
 		kfree(mem->pages);
+		kfree(mem->dma_addr);
 	}
 }
 EXPORT_SYMBOL(agp_free_page_array);
diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 09ea4a1..1d0d73f 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -81,9 +81,11 @@ struct agp_memory {
 	bool is_flushed;
 	/* list of agp_memory mapped to the aperture */
 	struct list_head mapped_list;
-	/* DMA-mapped addresses */
+	/* DMA-mapped addresses (exclusivly used by intel-gtt) */
 	struct scatterlist *sg_list;
 	int num_sg;
+	/* DMA address for pages. */
+	dma_addr_t *dma_addr;
 };
 
 #define AGP_NORMAL_MEMORY 0
-- 
1.7.1

