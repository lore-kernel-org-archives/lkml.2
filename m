Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0EILrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 07:47:53 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:42785 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0EILrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 07:47:49 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Greg KH <greg@kroah.com>
Subject: [PATCH][BUG] staging/dt3155v4l correcting a bug
Date: Sun, 9 May 2010 14:50:40 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005091450.40482.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

dt3155v4l driver, as in -rc6-next-20100506 has a BUG.
When it modifies q->int_ops structure in videobuf-dma-contig
module the change is visible for all other modules using it.

Make a local copy of this structure and use its modification
to solve the bug.

This patch has to be applied after the synchronization patch.

Please, apply.

Thanks.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>


==========================================================
diff -up b/drivers/staging/dt3155v4l/dt3155v4l.c a/drivers/staging/dt3155v4l/dt3155v4l.c
--- a/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-07 10:02:26.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-09 14:04:05.000000000 +0300
@@ -612,9 +612,14 @@ dt3155_queue_dma_contig_init(struct vide
 					unsigned int msize,
 					void *priv)
 {
+	struct dt3155_priv *pd = q->priv_data;
+
 	videobuf_queue_dma_contig_init(q, ops, dev, irqlock,
 				       type, field, msize, priv);
-	/* overwrite with our methods */
+	/* replace with local copy */
+	pd->qt_ops = *q->int_ops;
+	q->int_ops = &pd->qt_ops;
+	/* and overwrite with our methods */
 	q->int_ops->iolock = dt3155_iolock;
 	q->int_ops->mmap_mapper = dt3155_mmap_mapper;
 	q->int_ops->sync = dt3155_sync_for_cpu;
diff -up b/drivers/staging/dt3155v4l/dt3155v4l.h a/drivers/staging/dt3155v4l/dt3155v4l.h
--- a/drivers/staging/dt3155v4l/dt3155v4l.h	2010-04-30 17:59:03.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.h	2010-05-09 13:59:37.000000000 +0300
@@ -185,6 +185,7 @@ struct dt3155_stats {
  * @curr_buf:		pointer to curren buffer
  * @thread		pointer to worker thraed
  * @irq_handler:	irq handler for the driver
+ * @qt_ops		local copy of dma-contig qtype_ops
  * @dmaq		queue for dma buffers
  * @do_dma		wait queue of the kernel thread
  * @mux:		mutex to protect the instance
@@ -204,6 +205,7 @@ struct dt3155_priv {
 	struct videobuf_buffer *curr_buf;
 	struct task_struct *thread;
 	irq_handler_t irq_handler;
+	struct videobuf_qtype_ops qt_ops;
 	struct list_head dmaq;
 	wait_queue_head_t do_dma;
 	struct mutex mux;
