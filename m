Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2BCJb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:31:26 -0500
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3191 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2BCJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:29:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/6] videobuf2-core: also test for pending events.
Date: Fri,  3 Feb 2012 10:28:44 +0100
Message-Id: <1f5cb3c703963a39a9ac182af9a3fe50f87b0a72.1328260650.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
References: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
References: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |   41 +++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 0b1c771..3786d88 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -19,6 +19,9 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf2-core.h>
 
 static int debug;
@@ -1642,15 +1645,28 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
  * will be reported as available for writing.
  *
+ * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
+ * pending events.
+ *
  * The return values from this function are intended to be directly returned
  * from poll handler in driver.
  */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
+	struct video_device *vfd = video_devdata(file);
 	unsigned long req_events = poll_requested_events(wait);
-	unsigned long flags;
-	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
+	unsigned int res = 0;
+	unsigned long flags;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
+
+		if (v4l2_event_pending(fh))
+			res = POLLPRI;
+		else if (req_events & POLLPRI)
+			poll_wait(file, &fh->wait, wait);
+	}
 
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
@@ -1658,19 +1674,17 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if (q->num_buffers == 0 && q->fileio == NULL) {
 		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
 				(req_events & (POLLIN | POLLRDNORM))) {
-			ret = __vb2_init_fileio(q, 1);
-			if (ret)
-				return POLLERR;
+			if (__vb2_init_fileio(q, 1))
+				return res | POLLERR;
 		}
 		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
 				(req_events & (POLLOUT | POLLWRNORM))) {
-			ret = __vb2_init_fileio(q, 0);
-			if (ret)
-				return POLLERR;
+			if (__vb2_init_fileio(q, 0))
+				return res | POLLERR;
 			/*
 			 * Write to OUTPUT queue can be done immediately.
 			 */
-			return POLLOUT | POLLWRNORM;
+			return res | POLLOUT | POLLWRNORM;
 		}
 	}
 
@@ -1678,7 +1692,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * There is nothing to wait for if no buffers have already been queued.
 	 */
 	if (list_empty(&q->queued_list))
-		return POLLERR;
+		return res | POLLERR;
 
 	poll_wait(file, &q->done_wq, wait);
 
@@ -1693,10 +1707,11 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 
 	if (vb && (vb->state == VB2_BUF_STATE_DONE
 			|| vb->state == VB2_BUF_STATE_ERROR)) {
-		return (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
-			POLLIN | POLLRDNORM;
+		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
+				res | POLLOUT | POLLWRNORM :
+				res | POLLIN | POLLRDNORM;
 	}
-	return 0;
+	return res;
 }
 EXPORT_SYMBOL_GPL(vb2_poll);
 
-- 
1.7.8.3

