Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0FFKzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:55:36 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:37564 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab0FFKze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:55:34 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [BUG][PATCH]dma-coherent.c: error path bug
Date: Sun, 6 Jun 2010 13:53:04 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.34-rc7; KDE/4.4.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006061353.05310.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The error path in dma_declare_coherent_memory() leaves 
the pointer dev->dma_mem non completely initialized.

If allocation of dev->dma_mem succeeds, 
but allocation of dev->dma_mem->bitmap fails
dev->dma_mem is freed, but left non NULL
and non completely initialized.

Either zero it after being freed (one liner patch), or assign to 
dev->dma_mem only completely initialized structure (patch included).

Comments welcome.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=======================================================================
--- a/drivers/base/dma-coherent.c	2010-06-06 12:47:17.000000000 +0300
+++ b/drivers/base/dma-coherent.c	2010-06-06 12:53:36.000000000 +0300
@@ -17,6 +17,7 @@ struct dma_coherent_mem {
 int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 				dma_addr_t device_addr, size_t size, int flags)
 {
+	struct dma_coherent_mem *mem;
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
 	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
@@ -34,17 +35,18 @@ int dma_declare_coherent_memory(struct d
 	if (!mem_base)
 		goto out;
 
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
 		goto out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
+	mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!mem->bitmap)
 		goto free1_out;
 
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
+	mem->virt_base = mem_base;
+	mem->device_base = device_addr;
+	mem->size = pages;
+	mem->flags = flags;
+	dev->dma_mem = mem;
 
 	if (flags & DMA_MEMORY_MAP)
 		return DMA_MEMORY_MAP;
@@ -52,7 +54,7 @@ int dma_declare_coherent_memory(struct d
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem);
+	kfree(mem);
  out:
 	if (mem_base)
 		iounmap(mem_base);
