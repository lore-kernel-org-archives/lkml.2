Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2KZMKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:10:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:56462 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2KZMKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:10:33 -0500
Date: Mon, 26 Nov 2012 10:10:24 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20121126101024.1c5a7f13@infradead.org>
In-Reply-To: <20121126133153.50c5fa21cacd2858f30509e3@canb.auug.org.au>
References: <20121126133153.50c5fa21cacd2858f30509e3@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Em Mon, 26 Nov 2012 13:31:53 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "dma_common_get_sgtable" [drivers/media/v4l2-core/videobuf2-dma-contig.ko] undefined!
> 
> Caused by commit 9ef2cbeb8192 ("[media] v4l: vb2-dma-contig: add support
> for DMABUF exporting").  dma_common_get_sgtable() is called from the
> inline dma_get_sgtable_attrs() and dma_get_sgtable_attrs() is "called
> from" dma_get_sgtable().  dma_common_get_sgtable() is only defined if
> ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY is set which depends on
> CONFIG_HAVE_GENERIC_DMA_COHERENT being set which it isn't for this build.
> 
> I have used the v4l-dvb tree form next-20121026 for today.
> 
> Please try testing your tree with an x86_64 allmodconfig build.

My tree does compile here with allmodconfig on x86_64.

A quick fix is to just disable support for DMABUF if !HAVE_GENERIC_DMA_COHERENT.

Regards,
Mauro

-

videobuf2-dma-contig: Only support if  HAVE_GENERIC_DMA_COHERENT

As reported by Stephen:

> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "dma_common_get_sgtable" [drivers/media/v4l2-core/videobuf2-dma-contig.ko] undefined!
>
> Caused by commit 9ef2cbeb8192 ("[media] v4l: vb2-dma-contig: add support
> for DMABUF exporting").  dma_common_get_sgtable() is called from the
> inline dma_get_sgtable_attrs() and dma_get_sgtable_attrs() is "called
> from" dma_get_sgtable().  dma_common_get_sgtable() is only defined if
> ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY is set which depends on
> CONFIG_HAVE_GENERIC_DMA_COHERENT being set which it isn't for this build.

The simplest fix is to just not support DMABUF with vb2-contig, on archs
where this symbol doesn't exist. Some latter patch can rewrite it to
support this outside -arm.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 10beaee..5729450 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -226,6 +226,8 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 /*         DMABUF ops for exporters          */
 /*********************************************/
 
+#ifdef HAVE_GENERIC_DMA_COHERENT
+
 struct vb2_dc_attachment {
 	struct sg_table sgt;
 	enum dma_data_direction dir;
@@ -416,6 +418,8 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
 	return dbuf;
 }
 
+#endif
+
 /*********************************************/
 /*       callbacks for USERPTR buffers       */
 /*********************************************/
@@ -735,7 +739,9 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dc_alloc,
 	.put		= vb2_dc_put,
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
 	.get_dmabuf	= vb2_dc_get_dmabuf,
+#endif
 	.cookie		= vb2_dc_cookie,
 	.vaddr		= vb2_dc_vaddr,
 	.mmap		= vb2_dc_mmap,
