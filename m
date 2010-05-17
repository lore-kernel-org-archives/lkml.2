Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0EQMFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:05:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2283 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab0EQMFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:05:04 -0400
Subject: Re: [PATCH] Staging: comedi: Fixed long line lengths in drivers.c
From: Joe Perches <joe@perches.com>
To: Mark <reodge@gmail.com>
Cc: gregkh@suse.de, Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274093311-6309-1-git-send-email-reodge@gmail.com>
References: <1274093311-6309-1-git-send-email-reodge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 05:05:01 -0700
Message-ID: <1274097901.1705.575.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 18:48 +0800, Mark wrote:
> This patch clears up some long line length warnings in drivers.c found by
> checkpatch
> 
> Signed-off-by: Mark Rankilor <reodge@gmail.com>

Hi Mark.

> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 4a29ed7..7da4625 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -442,7 +444,10 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
>  		unsigned i;
>  		for (i = 0; i < async->n_buf_pages; ++i) {
>  			if (async->buf_page_list[i].virt_addr) {
> -				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));

It's better to not just fix the checkpatch errors by simply
wrapping the code, but rather to factor the code for clarity.

Using a temporary would fix a lot of these long line problems.

Moving these into static alloc/free functions would help as well.

Perhaps something like:
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


