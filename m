Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1CJCdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:33:54 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:53682 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1CJCdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:33:53 -0500
X-IronPort-AV: E=Sophos;i="4.62,293,1297054800"; 
   d="scan'208";a="30375964"
From: Bob Liu <lliubbo@gmail.com>
To: linux-kernel@vger.kernel.org
CC: mchehab@redhat.com, hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
        jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
        agust@denx.de, gregkh@suse.de, vapier.adi@gmail.com,
        uclinux-dist-devel@blackfin.uclinux.org, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] media: uvc_driver: add NO-MMU arch support
Date: Thu, 10 Mar 2011 10:44:37 +0800
Message-ID: <1299725077-13839-1-git-send-email-lliubbo@gmail.com>
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
 drivers/media/video/uvc/uvc_v4l2.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-dev.c     |   18 ++++++++++++++++++
 drivers/usb/gadget/uvc_queue.c     |   15 +++++++++++++++
 include/media/v4l2-dev.h           |    2 ++
 4 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 9005a8d..2413ec9 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1081,6 +1081,39 @@ static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
 	return uvc_queue_poll(&stream->queue, file, wait);
 }
 
+#ifndef CONFIG_MMU
+static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_streaming *stream = handle->stream;
+	struct uvc_video_queue *queue = &stream->queue;
+	struct uvc_buffer *uninitialized_var(buffer);
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
+		PAGE_ALIGN(len) != queue->buf_size) {
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
+#endif
+
 const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
@@ -1089,5 +1122,8 @@ const struct v4l2_file_operations uvc_fops = {
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = uvc_v4l2_get_unmapped_area,
+#endif
 };
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 341764a..bdcf413 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -299,6 +299,21 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 	return ret;
 }
 
+#ifndef CONFIG_MMU
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
@@ -362,6 +377,9 @@ static const struct file_operations v4l2_fops = {
 	.write = v4l2_write,
 	.open = v4l2_open,
 	.mmap = v4l2_mmap,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = v4l2_get_unmapped_area,
+#endif
 	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index f7395ac..24378fb 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -431,6 +431,7 @@ uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 			break;
 	}
 
+#ifdef CONFIG_MMU
 	if (i == queue->count || size != queue->buf_size) {
 		ret = -EINVAL;
 		goto done;
@@ -452,6 +453,20 @@ uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 		addr += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
+#else
+	if (i == queue->count ||
+		PAGE_ALIGN(size) != queue->buf_size) {
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
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 15802a0..a0af49a 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -42,6 +42,8 @@ struct v4l2_file_operations {
 	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
+				unsigned long, unsigned long, unsigned long);
 	int (*open) (struct file *);
 	int (*release) (struct file *);
 };
-- 
1.6.3.3

