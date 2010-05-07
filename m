Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0EGH6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:58:17 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:53497 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0EGH6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:58:15 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] staging: dt3155v4l syncronize with API changes
Date: Fri, 7 May 2010 11:00:35 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005071100.35616.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

dt3155v4l driver, as in -rc6-next-20100506 compiles, but will
not run properly due to recent changes in the videobuf APIs.

This patch synchronizes some functions that have been copied
from drivers/media/video/videobuf-dma-contig.c (and modified)
with the recent (-rc6 -> -rc6-next-) changes in videobuf layer
especially drivers/media/video/videobuf-dma-contig.c

Please, apply.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

===========================================================
--- a/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-07 07:43:44.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-07 09:41:00.000000000 +0300
@@ -1,3 +1,23 @@
+/***************************************************************************
+ *   Copyright (C) 2006-2010 by Marin Mitov                                *
+ *   mitov@issp.bas.bg                                                     *
+ *                                                                         *
+ *   This program is free software; you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation; either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
+ *   GNU General Public License for more details.                          *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this program; if not, write to the                         *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
 #include <media/v4l2-ioctl.h>
@@ -260,9 +280,11 @@ dt3155_dma_contig_user_get(struct videob
 	struct vm_area_struct *vma;
 	unsigned long prev_pfn, this_pfn;
 	unsigned long pages_done, user_address;
+	unsigned int offset;
 	int ret;
 
-	mem->size = PAGE_ALIGN(vb->size);
+	offset = vb->baddr & ~PAGE_MASK;
+	mem->size = PAGE_ALIGN(vb->size + offset);
 	mem->is_userptr = 0;
 	ret = -EINVAL;
 
@@ -285,7 +307,7 @@ dt3155_dma_contig_user_get(struct videob
 			break;
 
 		if (pages_done == 0)
-			mem->dma_handle = this_pfn << PAGE_SHIFT;
+			mem->dma_handle = (this_pfn << PAGE_SHIFT) + offset;
 		else if (this_pfn != (prev_pfn + 1))
 			ret = -EFAULT;
 
@@ -416,14 +438,14 @@ dt3155_vm_close(struct vm_area_struct *v
 	struct videobuf_queue *q = map->q;
 	int i;
 
-	dev_dbg(map->q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
+	dev_dbg(q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
 
 	map->count--;
 	if (0 == map->count) {
 		struct videobuf_dma_contig_memory *mem;
 
-		dev_dbg(map->q->dev, "munmap %p q=%p\n", map, q);
+		dev_dbg(q->dev, "munmap %p q=%p\n", map, q);
 		mutex_lock(&q->vb_lock);
 
 		/* We need first to cancel streams, before unmapping */
@@ -450,7 +472,7 @@ dt3155_vm_close(struct vm_area_struct *v
 				/* vfree is not atomic - can't be
 				   called with IRQ's disabled
 				 */
-				dev_dbg(map->q->dev, "buf[%d] freeing %p\n",
+				dev_dbg(q->dev, "buf[%d] freeing %p\n",
 					i, mem->vaddr);
 
 				dt3155_free_buffer(q->dev, mem->size,
@@ -475,51 +497,33 @@ static const struct vm_operations_struct
 
 /* same as videobuf_mmap_mapper(), but allocates from the pool */
 static int
-dt3155_mmap_mapper(struct videobuf_queue *q, struct vm_area_struct *vma)
+dt3155_mmap_mapper(struct videobuf_queue *q, struct videobuf_buffer *buf,
+						struct vm_area_struct *vma)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_mapping *map;
-	unsigned int first;
 	int retval;
-	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long size;
 
 	dev_dbg(q->dev, "%s\n", __func__);
-	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
-		return -EINVAL;
-
-	/* look for first buffer to map */
-	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
-		if (!q->bufs[first])
-			continue;
-
-		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
-			continue;
-		if (q->bufs[first]->boff == offset)
-			break;
-	}
-	if (VIDEO_MAX_FRAME == first) {
-		dev_dbg(q->dev, "invalid user space offset [offset=0x%lx]\n",
-			offset);
-		return -EINVAL;
-	}
 
 	/* create mapping + update buffer list */
 	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
 	if (!map)
 		return -ENOMEM;
 
-	q->bufs[first]->map = map;
+	buf->map = map;
 	map->start = vma->vm_start;
 	map->end = vma->vm_end;
 	map->q = q;
 
-	q->bufs[first]->baddr = vma->vm_start;
+	buf->baddr = vma->vm_start;
 
-	mem = q->bufs[first]->priv;
+	mem = buf->priv;
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
+	mem->size = PAGE_ALIGN(buf->bsize);
 	mem->vaddr = dt3155_alloc_buffer(q->dev, mem->size,
 					&mem->dma_handle, GFP_KERNEL);
 	if (!mem->vaddr) {
@@ -552,8 +556,8 @@ dt3155_mmap_mapper(struct videobuf_queue
 
 	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
 		map, q, vma->vm_start, vma->vm_end,
-		(long int) q->bufs[first]->bsize,
-		vma->vm_pgoff, first);
+		(long int)buf->bsize,
+		vma->vm_pgoff, buf->i);
 
 	dt3155_vm_open(vma);
 
