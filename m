Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2GZLOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:14:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2GZLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:13:47 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v2 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent if available
Date: Thu, 26 Jul 2012 20:13:10 +0900
Message-Id: <1343301191-26001-4-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
References: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the vb2_dma_contig_mmap() function was using a dma_addr_t as a
physical address.  The two addressses are not necessarily the same.
For example, when using the IOMMU funtion on certain platforms, dma_addr_t
addresses are not directly mappable physical address.
dma_mmap_coherent() maps the address correctly.
It is available on ARM platforms.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 drivers/media/video/videobuf2-dma-contig.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 4b71326..4dc85ab 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -101,14 +101,32 @@ static unsigned int vb2_dma_contig_num_users(void *buf_priv)
 static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
 {
 	struct vb2_dc_buf *buf = buf_priv;
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+	int ret;
+#endif
 
 	if (!buf) {
 		printk(KERN_ERR "No buffer to map\n");
 		return -EINVAL;
 	}
 
+#ifdef ARCH_HAS_DMA_MMAP_COHERENT
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	ret = dma_mmap_coherent(buf->conf->dev, vma, buf->vaddr, buf->dma_addr,
+				buf->size);
+	if (ret) {
+		pr_err("Remapping memory failed, error: %d\n", ret);
+		return ret;
+	}
+	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_private_data = &buf->handler;
+	vma->vm_ops = &vb2_common_vm_ops;
+	vma->vm_ops->open(vma);
+	return 0;
+#else
 	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
 				  &vb2_common_vm_ops, &buf->handler);
+#endif
 }
 
 static void *vb2_dma_contig_get_userptr(void *alloc_ctx, unsigned long vaddr,
-- 
1.7.0.4

