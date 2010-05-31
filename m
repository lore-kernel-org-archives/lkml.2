Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0EaJUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:20:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47252 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab0EaJUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rMaGcgsF+okbP/8taC2f0vqlnl7ngCNbuHOc170hRylObS/3LfdBQu8hgFW2CSxXyw
         mEIgQOdFGfluuX8Qtbopz/41EFRiX8RdzJFyy0y8psAJlvwwZY7Ar62ImjhH2cjMxmsy
         wLj08h29A0opUZiKVORJENYnrSvxp1W4tVwak=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Joe Perches <joe@perches.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Refactored code to fix long line lengths in drivers.c
Date: Mon, 31 May 2010 17:19:26 +0800
Message-Id: <1275297567-11584-2-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275297567-11584-1-git-send-email-reodge@gmail.com>
References: <1275297567-11584-1-git-send-email-reodge@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors some code to clean up some long line length checkpatch
warnings.

Signed-off-by: Mark Rankilor <reodge@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/comedi/drivers.c |  188 ++++++++++++++++++--------------------
 1 files changed, 87 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..bdbbe8e 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -420,6 +420,91 @@ static inline unsigned long kvirt_to_kva(unsigned long adr)
 	return kva;
 }
 
+static void free_buf_page_list(struct comedi_device *dev,
+			       struct comedi_subdevice *s)
+{
+	int i;
+	struct comedi_async *async = s->async;
+	struct comedi_buf_page *bp = async->buf_page_list;
+
+	if (!async->buf_page_list)
+		return;
+
+	for (i = 0; i < async->n_buf_pages; ++i) {
+		if (bp->virt_addr) {
+			clear_bit(PG_reserved,
+				  &virt_to_page(bp->virt_addr)->flags);
+			if (s->async_dma_dir != DMA_NONE) {
+				dma_free_coherent(dev->hw_dev, PAGE_SIZE,
+						  bp->virt_addr, bp->dma_addr);
+			} else {
+				free_page((unsigned long)bp->virt_addr);
+			}
+		}
+		bp++;
+	}
+	vfree(async->buf_page_list);
+	async->buf_page_list = NULL;
+	async->n_buf_pages = 0;
+}
+
+static int alloc_buf_page_list(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       unsigned long new_size)
+{
+	unsigned i = 0;
+	struct comedi_async *async = s->async;
+	unsigned n_pages = new_size >> PAGE_SHIFT;
+	unsigned bp_size = sizeof(struct comedi_buf_page) * n_pages;
+	struct page **pages = NULL;
+
+	/*  allocate new buffer */
+	if (!new_size)
+		return 0;
+
+	async->buf_page_list = vmalloc(bp_size);
+	if (!async->buf_page_list)
+		return -ENOMEM;
+	memset(async->buf_page_list, 0, bp_size);
+	pages = vmalloc(sizeof(struct page *) * n_pages);
+	if (pages) {
+		struct comedi_buf_page *bp = async->buf_page_list;
+		for (i = 0; i < n_pages; i++) {
+			if (s->async_dma_dir != DMA_NONE) {
+				bp->virt_addr =
+					dma_alloc_coherent(dev->hw_dev,
+							   PAGE_SIZE,
+							   &bp->dma_addr,
+							   GFP_KERNEL |
+							   __GFP_COMP);
+			} else {
+				bp->virt_addr = (void *)
+					get_zeroed_page(GFP_KERNEL);
+			}
+			if (bp->virt_addr == NULL) {
+				vfree(pages);
+				free_buf_page_list(dev, s);
+				return -ENOMEM;
+			}
+
+			set_bit(PG_reserved,
+				&virt_to_page(bp->virt_addr)->flags);
+			pages[i] = virt_to_page(bp->virt_addr);
+			bp++;
+		}
+	}
+
+	async->prealloc_buf = vmap(pages, n_pages, VM_MAP, PAGE_KERNEL_NOCACHE);
+	vfree(pages);
+	if (!async->prealloc_buf) {
+		free_buf_page_list(dev, s);
+		return -ENOMEM;
+	}
+	async->n_buf_pages = n_pages;
+	async->prealloc_bufsz = new_size;
+	return 0;
+}
+
 int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		     unsigned long new_size)
 {
@@ -438,108 +523,9 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		async->prealloc_buf = NULL;
 		async->prealloc_bufsz = 0;
 	}
-	if (async->buf_page_list) {
-		unsigned i;
-		for (i = 0; i < async->n_buf_pages; ++i) {
-			if (async->buf_page_list[i].virt_addr) {
-				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-				if (s->async_dma_dir != DMA_NONE) {
-					dma_free_coherent(dev->hw_dev,
-							  PAGE_SIZE,
-							  async->
-							  buf_page_list
-							  [i].virt_addr,
-							  async->
-							  buf_page_list
-							  [i].dma_addr);
-				} else {
-					free_page((unsigned long)
-						  async->buf_page_list[i].
-						  virt_addr);
-				}
-			}
-		}
-		vfree(async->buf_page_list);
-		async->buf_page_list = NULL;
-		async->n_buf_pages = 0;
-	}
-	/*  allocate new buffer */
-	if (new_size) {
-		unsigned i = 0;
-		unsigned n_pages = new_size >> PAGE_SHIFT;
-		struct page **pages = NULL;
-
-		async->buf_page_list =
-		    vmalloc(sizeof(struct comedi_buf_page) * n_pages);
-		if (async->buf_page_list) {
-			memset(async->buf_page_list, 0,
-			       sizeof(struct comedi_buf_page) * n_pages);
-			pages = vmalloc(sizeof(struct page *) * n_pages);
-		}
-		if (pages) {
-			for (i = 0; i < n_pages; i++) {
-				if (s->async_dma_dir != DMA_NONE) {
-					async->buf_page_list[i].virt_addr =
-					    dma_alloc_coherent(dev->hw_dev,
-							       PAGE_SIZE,
-							       &async->
-							       buf_page_list
-							       [i].dma_addr,
-							       GFP_KERNEL |
-							       __GFP_COMP);
-				} else {
-					async->buf_page_list[i].virt_addr =
-					    (void *)
-					    get_zeroed_page(GFP_KERNEL);
-				}
-				if (async->buf_page_list[i].virt_addr == NULL)
-					break;
-
-				set_bit(PG_reserved,
-					&(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-				pages[i] = virt_to_page(async->buf_page_list[i].virt_addr);
-			}
-		}
-		if (i == n_pages) {
-			async->prealloc_buf =
-			    vmap(pages, n_pages, VM_MAP, PAGE_KERNEL_NOCACHE);
-		}
-		vfree(pages);
-
-		if (async->prealloc_buf == NULL) {
-			/* Some allocation failed above. */
-			if (async->buf_page_list) {
-				for (i = 0; i < n_pages; i++) {
-					if (async->buf_page_list[i].virt_addr ==
-					    NULL) {
-						break;
-					}
-					clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-					if (s->async_dma_dir != DMA_NONE) {
-						dma_free_coherent(dev->hw_dev,
-								  PAGE_SIZE,
-								  async->
-								  buf_page_list
-								  [i].virt_addr,
-								  async->
-								  buf_page_list
-								  [i].dma_addr);
-					} else {
-						free_page((unsigned long)
-							  async->buf_page_list
-							  [i].virt_addr);
-					}
-				}
-				vfree(async->buf_page_list);
-				async->buf_page_list = NULL;
-			}
-			return -ENOMEM;
-		}
-		async->n_buf_pages = n_pages;
-	}
-	async->prealloc_bufsz = new_size;
 
-	return 0;
+	free_buf_page_list(dev, s);
+	return alloc_buf_page_list(dev, s, new_size);
 }
 
 /* munging is applied to data by core as it passes between user
-- 
1.7.1

