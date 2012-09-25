Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2IYPBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:01:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37376 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2IYPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:01:00 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v3 1/4] v4l: vb2: add prepare/finish callbacks to allocators
Date: Tue, 25 Sep 2012 17:04:00 +0200
Message-Id: <1348585440-5385-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds support for prepare/finish callbacks in VB2 allocators.
These callback are used for buffer flushing.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 +++++++++++
 include/media/videobuf2-core.h           |  7 +++++++
 2 file modificati, 18 inserzioni(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4da3df6..079fa79 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -790,6 +790,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned long flags;
+	unsigned int plane;
 
 	if (vb->state != VB2_BUF_STATE_ACTIVE)
 		return;
@@ -800,6 +801,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	dprintk(4, "Done processing on buffer %d, state: %d\n",
 			vb->v4l2_buf.index, vb->state);
 
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(q, finish, vb->planes[plane].mem_priv);
+
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
 	vb->state = state;
@@ -975,9 +980,15 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 static void __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
 
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->queued_count);
+
+	/* sync buffers */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		call_memop(q, prepare, vb->planes[plane].mem_priv);
+
 	q->ops->buf_queue(vb);
 }
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8dd9b6c..2508609 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -41,6 +41,10 @@ struct vb2_fileio_data;
  *		 argument to other ops in this structure
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
  *		 be used
+ * @prepare:	called every time the buffer is passed from userspace to the
+ *		driver, usefull for cache synchronisation, optional
+ * @finish:	called every time the buffer is passed back from the driver
+ *		to the userspace, also optional
  * @vaddr:	return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
  *		such mapping exists
@@ -65,6 +69,9 @@ struct vb2_mem_ops {
 					unsigned long size, int write);
 	void		(*put_userptr)(void *buf_priv);
 
+	void		(*prepare)(void *buf_priv);
+	void		(*finish)(void *buf_priv);
+
 	void		*(*vaddr)(void *buf_priv);
 	void		*(*cookie)(void *buf_priv);
 
-- 
1.7.11.4

