Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1I2HpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:45:14 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4980 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1I2HpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:45:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 5/6] videobuf2-core: also test for pending events.
Date: Thu, 29 Sep 2011 09:44:11 +0200
Message-Id: <9b0edab8ffab74f2ead0914c8aef09fd3079d54a.1317281827.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
References: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |   41 +++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index a921638..7674220 100644
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
@@ -1363,15 +1366,28 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
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
@@ -1379,19 +1395,17 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
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
 
@@ -1399,7 +1413,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * There is nothing to wait for if no buffers have already been queued.
 	 */
 	if (list_empty(&q->queued_list))
-		return POLLERR;
+		return res | POLLERR;
 
 	poll_wait(file, &q->done_wq, wait);
 
@@ -1414,10 +1428,11 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 
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
1.7.5.4

