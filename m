Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1DHLB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 07:01:56 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49310 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1DHLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 07:01:55 -0400
X-IronPort-AV: E=Sophos;i="4.63,322,1299474000"; 
   d="scan'208";a="31453999"
From: Bob Liu <lliubbo@gmail.com>
To: linux-kernel@vger.kernel.org
CC: mchehab@redhat.com, hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
        jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
        agust@denx.de, gregkh@suse.de, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH v2] media: uvc_driver: add NO-MMU arch support
Date: Fri, 8 Apr 2011 19:16:34 +0800
Message-ID: <1302261394-25695-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UVC driver used to have partial no-mmu arch support, but it's removed by
commit c29fcff3daafbf46d64a543c1950bbd206ad8c1c.

This patch added them back and expanded to fully support no-mmu arch, so that
uvc cameras can be used on no-mmu platforms like Blackfin.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/media/video/uvc/uvc_queue.c |   47 +++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_v4l2.c  |   13 +++++++++
 drivers/media/video/uvc/uvcvideo.h  |    6 ++++
 drivers/media/video/v4l2-dev.c      |   18 +++++++++++++
 include/media/v4l2-dev.h            |    2 +
 5 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index f14581b..e505afe 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -424,6 +424,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 			break;
 	}
 
+#ifdef CONFIG_MMU
 	if (i == queue->count || size != queue->buf_size) {
 		ret = -EINVAL;
 		goto done;
@@ -445,6 +446,20 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 		addr += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
+#else
+	if (i == queue->count ||
+			PAGE_ALIGN(size) != queue->buf_size) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/* documentation/nommu-mmap.txt */
+	vma->vm_flags |= VM_IO | VM_MAYSHARE;
+
+	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
+	vma->vm_start = addr;
+	vma->vm_end = addr +  queue->buf_size;
+#endif
 
 	vma->vm_ops = &uvc_vm_ops;
 	vma->vm_private_data = buffer;
@@ -489,6 +504,38 @@ done:
 }
 
 /*
+ * Get unmapped area.
+ *
+ * NO-MMU arch need this function to make mmap() work correctly.
+ */
+unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
+		unsigned long addr, unsigned long len, unsigned long pgoff)
+{
+	struct uvc_buffer *buffer;
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&queue->mutex);
+	for (i = 0; i < queue->count; ++i) {
+		buffer = &queue->buffer[i];
+		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
+			break;
+	}
+
+	if (i == queue->count ||
+			PAGE_ALIGN(len) != queue->buf_size) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
+	ret = addr;
+done:
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+
+/*
  * Enable or disable the video buffers queue.
  *
  * The queue must be enabled before starting video acquisition and must be
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 9005a8d..9efab61 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1081,6 +1081,18 @@ static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
 	return uvc_queue_poll(&stream->queue, file, wait);
 }
 
+static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct uvc_fh *handle = file->private_data;
+	struct uvc_streaming *stream = handle->stream;
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
+
+	return uvc_queue_get_unmapped_area(&stream->queue, addr, len, pgoff);
+}
+
 const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
@@ -1089,5 +1101,6 @@ const struct v4l2_file_operations uvc_fops = {
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
+	.get_unmapped_area = uvc_v4l2_get_unmapped_area,
 };
 
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 45f01e7..48a2378 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -580,6 +580,12 @@ extern int uvc_queue_mmap(struct uvc_video_queue *queue,
 		struct vm_area_struct *vma);
 extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
 		struct file *file, poll_table *wait);
+#ifdef CONFIG_MMU
+#define uvc_queue_get_unmapped_area NULL
+#else
+extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
+		unsigned long addr, unsigned long len, unsigned long pgoff);
+#endif
 extern int uvc_queue_allocated(struct uvc_video_queue *queue);
 static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 {
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 498e674..221e73f 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -368,6 +368,23 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 	return ret;
 }
 
+#ifdef CONFIG_MMU
+#define v4l2_get_unmapped_area NULL
+#else
+static unsigned long v4l2_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct video_device *vdev = video_devdata(filp);
+
+	if (!vdev->fops->get_unmapped_area)
+		return -ENOSYS;
+	if (!video_is_registered(vdev))
+		return -ENODEV;
+	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+#endif
+
 /* Override for the open function */
 static int v4l2_open(struct inode *inode, struct file *filp)
 {
@@ -452,6 +469,7 @@ static const struct file_operations v4l2_fops = {
 	.write = v4l2_write,
 	.open = v4l2_open,
 	.mmap = v4l2_mmap,
+	.get_unmapped_area = v4l2_get_unmapped_area,
 	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 8266d5a..0616a43 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -63,6 +63,8 @@ struct v4l2_file_operations {
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
+			unsigned long, unsigned long, unsigned long);
 	int (*open) (struct file *);
 	int (*release) (struct file *);
 };
-- 
1.6.3.3

