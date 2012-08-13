Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2HMUVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2HMUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        "Hadli, Manjunath" <manjunath.hadli@ti.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 14/82] media: videobuf-dma-contig: restore buffer mapping for uncached bufers
Date: Mon, 13 Aug 2012 13:18:50 -0700
Message-Id: <20120813201747.678069874@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lad, Prabhakar" <prabhakar.lad@ti.com>

commit 4099040eaaa4fe543c4e915b8cab51b1d843edee upstream.

from commit a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4
restore the mapping scheme for uncached buffers,
which was changed in a common scheme for cached and uncached.
This apparently was wrong, and was probably intended only for cached buffers.
the fix fixes the crash observed while mapping uncached buffers.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Hadli, Manjunath <manjunath.hadli@ti.com>
Acked-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/videobuf-dma-contig.c |   53 ++++++++++++++++++------------
 1 file changed, 32 insertions(+), 21 deletions(-)

--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -359,32 +359,43 @@ static int __videobuf_mmap_mapper(struct
 	size = vma->vm_end - vma->vm_start;
 	size = (size < mem->size) ? size : mem->size;
 
-	if (!mem->cached)
+	if (!mem->cached) {
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	pos = (unsigned long)mem->vaddr;
-
-	while (size > 0) {
-		page = virt_to_page((void *)pos);
-		if (NULL == page) {
-			dev_err(q->dev, "mmap: virt_to_page failed\n");
-			__videobuf_dc_free(q->dev, mem);
-			goto error;
-		}
-		retval = vm_insert_page(vma, start, page);
+		retval = remap_pfn_range(vma, vma->vm_start,
+			 mem->dma_handle >> PAGE_SHIFT,
+				 size, vma->vm_page_prot);
 		if (retval) {
-			dev_err(q->dev, "mmap: insert failed with error %d\n",
-				retval);
-			__videobuf_dc_free(q->dev, mem);
+			dev_err(q->dev, "mmap: remap failed with error %d. ",
+								retval);
+			dma_free_coherent(q->dev, mem->size,
+					mem->vaddr, mem->dma_handle);
 			goto error;
 		}
-		start += PAGE_SIZE;
-		pos += PAGE_SIZE;
+	} else {
+		pos = (unsigned long)mem->vaddr;
+
+		while (size > 0) {
+			page = virt_to_page((void *)pos);
+			if (NULL == page) {
+				dev_err(q->dev, "mmap: virt_to_page failed\n");
+				__videobuf_dc_free(q->dev, mem);
+				goto error;
+			}
+			retval = vm_insert_page(vma, start, page);
+			if (retval) {
+				dev_err(q->dev, "mmap: insert failed with error %d\n",
+					retval);
+				__videobuf_dc_free(q->dev, mem);
+				goto error;
+			}
+			start += PAGE_SIZE;
+			pos += PAGE_SIZE;
 
-		if (size > PAGE_SIZE)
-			size -= PAGE_SIZE;
-		else
-			size = 0;
+			if (size > PAGE_SIZE)
+				size -= PAGE_SIZE;
+			else
+				size = 0;
+		}
 	}
 
 	vma->vm_ops = &videobuf_vm_ops;


