Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0LFNbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:31:05 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:33624 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429Ab0LFNbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:31:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] V4L: videobuf, don't use dma addr as physical
Date: Mon,  6 Dec 2010 14:30:52 +0100
Message-Id: <1291642252-10264-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem->dma_handle is a dma address obtained by dma_alloc_coherent which
needn't be a physical address in presence of IOMMU. So ensure we are
remapping (remap_pfn_range) the right page in __videobuf_mmap_mapper
by using virt_to_phys(mem->vaddr) and not mem->dma_handle.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/videobuf-dma-contig.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index c969111..8d778aa 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	retval = remap_pfn_range(vma, vma->vm_start,
-				 mem->dma_handle >> PAGE_SHIFT,
+				 virt_to_phys(mem->vaddr) >> PAGE_SHIFT,
 				 size, vma->vm_page_prot);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
-- 
1.7.3.1


