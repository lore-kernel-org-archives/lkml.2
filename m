Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2IGG6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:58:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49801 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2IGG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:58:01 -0400
From: sjur.brandeland@stericsson.com
To: "Michael S . Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFCv2 1/2] virtio_console: Add support for DMA memory allocation
Date: Fri,  7 Sep 2012 08:57:44 +0200
Message-Id: <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add feature VIRTIO_CONSOLE_F_DMA_MEM. If the architecture has
DMA support and this feature bit is set, the virtio data buffers
will be allocated from DMA memory. If the device requests
the feature VIRTIO_CONSOLE_F_DMA_MEM, but the architecture
don't support DMA the driver's probe function will fail.

This is needed for using virtio_console from the remoteproc
framework.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: Amit Shah <amit.shah@redhat.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: virtualization@lists.linux-foundation.org
cc: linux-kernel@vger.kernel.org
---
 drivers/char/virtio_console.c  |   91 +++++++++++++++++++++++++++++++++-------
 include/linux/virtio_console.h |    1 +
 2 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..469c05f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -35,8 +35,15 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
 #include "../tty/hvc/hvc_console.h"
 
+#ifdef CONFIG_HAS_DMA
+#define VIRTIO_CONSOLE_HAS_DMA (1)
+#else
+#define VIRTIO_CONSOLE_HAS_DMA (0)
+#endif
+
 /*
  * This is a global struct for storing common data for all the devices
  * this driver handles.
@@ -334,20 +341,56 @@ static inline bool use_multiport(struct ports_device *portdev)
 	return portdev->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
-static void free_buf(struct port_buffer *buf)
+/* Allocate data buffer from DMA memory if requested */
+static inline void *
+alloc_databuf(struct virtio_device *vdev, size_t size, gfp_t flag)
+{
+	if (VIRTIO_CONSOLE_HAS_DMA &&
+	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_DMA_MEM)) {
+		struct device *dev = &vdev->dev;
+		dma_addr_t dma;
+		/*
+		 * Allocate DMA memory from ancestors. Finding the ancestor
+		 * is a bit quirky when DMA_MEMORY_INCLUDES_CHILDREN is not
+		 * implemented.
+		 */
+		dev = dev->parent ? dev->parent : dev;
+		dev = dev->parent ? dev->parent : dev;
+		return dma_alloc_coherent(dev, size, &dma, flag);
+	}
+	return kzalloc(size, flag);
+}
+
+static inline void
+free_databuf(struct virtio_device *vdev, size_t size, void *cpu_addr)
+{
+	if (VIRTIO_CONSOLE_HAS_DMA &&
+	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_DMA_MEM)) {
+		struct device *dev = &vdev->dev;
+		dma_addr_t dma = virt_to_bus(cpu_addr);
+		dev = dev->parent ? dev->parent : dev;
+		dev = dev->parent ? dev->parent : dev;
+		dma_free_coherent(dev, size, cpu_addr, dma);
+		return;
+	}
+	kfree(cpu_addr);
+}
+
+static void
+free_buf(struct virtqueue *vq, struct port_buffer *buf, size_t buf_size)
 {
-	kfree(buf->buf);
+	free_databuf(vq->vdev, buf_size, buf);
 	kfree(buf);
 }
 
-static struct port_buffer *alloc_buf(size_t buf_size)
+static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size)
 {
 	struct port_buffer *buf;
 
 	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		goto fail;
-	buf->buf = kzalloc(buf_size, GFP_KERNEL);
+	buf->buf = alloc_databuf(vq->vdev, buf_size, GFP_KERNEL);
 	if (!buf->buf)
 		goto free_buf;
 	buf->len = 0;
@@ -414,7 +457,7 @@ static void discard_port_data(struct port *port)
 		port->stats.bytes_discarded += buf->len - buf->offset;
 		if (add_inbuf(port->in_vq, buf) < 0) {
 			err++;
-			free_buf(buf);
+			free_buf(port->in_vq, buf, PAGE_SIZE);
 		}
 		port->inbuf = NULL;
 		buf = get_inbuf(port);
@@ -485,7 +528,7 @@ static void reclaim_consumed_buffers(struct port *port)
 		return;
 	}
 	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
-		kfree(buf);
+		free_databuf(port->portdev->vdev, len, buf);
 		port->outvq_full = false;
 	}
 }
@@ -672,6 +715,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 	char *buf;
 	ssize_t ret;
 	bool nonblock;
+	struct virtio_device *vdev;
 
 	/* Userspace could be out to fool us */
 	if (!count)
@@ -694,9 +738,10 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 	if (!port->guest_connected)
 		return -ENODEV;
 
+	vdev = port->portdev->vdev;
 	count = min((size_t)(32 * 1024), count);
 
-	buf = kmalloc(count, GFP_KERNEL);
+	buf = alloc_databuf(vdev, count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -720,7 +765,8 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 		goto out;
 
 free_buf:
-	kfree(buf);
+	free_databuf(vdev, count, buf);
+
 out:
 	return ret;
 }
@@ -1102,7 +1148,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 
 	nr_added_bufs = 0;
 	do {
-		buf = alloc_buf(PAGE_SIZE);
+		buf = alloc_buf(vq, PAGE_SIZE);
 		if (!buf)
 			break;
 
@@ -1110,7 +1156,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 		ret = add_inbuf(vq, buf);
 		if (ret < 0) {
 			spin_unlock_irq(lock);
-			free_buf(buf);
+			free_buf(vq, buf, PAGE_SIZE);
 			break;
 		}
 		nr_added_bufs++;
@@ -1234,7 +1280,7 @@ static int add_port(struct ports_device *portdev, u32 id)
 
 free_inbufs:
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+		free_buf(port->in_vq, buf, PAGE_SIZE);
 free_device:
 	device_destroy(pdrvdata.class, port->dev->devt);
 free_cdev:
@@ -1276,7 +1322,7 @@ static void remove_port_data(struct port *port)
 
 	/* Remove buffers we queued up for the Host to send us data in. */
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+		free_buf(port->in_vq, buf, PAGE_SIZE);
 }
 
 /*
@@ -1478,7 +1524,7 @@ static void control_work_handler(struct work_struct *work)
 		if (add_inbuf(portdev->c_ivq, buf) < 0) {
 			dev_warn(&portdev->vdev->dev,
 				 "Error adding buffer to queue\n");
-			free_buf(buf);
+			free_buf(portdev->c_ivq, buf, PAGE_SIZE);
 		}
 	}
 	spin_unlock(&portdev->cvq_lock);
@@ -1674,10 +1720,10 @@ static void remove_controlq_data(struct ports_device *portdev)
 		return;
 
 	while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
-		free_buf(buf);
+		free_buf(portdev->c_ivq, buf, PAGE_SIZE);
 
 	while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
-		free_buf(buf);
+		free_buf(portdev->c_ivq, buf, PAGE_SIZE);
 }
 
 /*
@@ -1698,6 +1744,17 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 	/* Ensure to read early_put_chars now */
 	barrier();
 
+	/* Refuse to bind if F_DMA_MEM request cannot be met */
+	if (!VIRTIO_CONSOLE_HAS_DMA &&
+	    (vdev->config->get_features(vdev) &
+		(1 << VIRTIO_CONSOLE_F_DMA_MEM))) {
+
+		dev_err(&vdev->dev,
+			"DMA_MEM requested but arch does not support DMA\n");
+		err = -ENODEV;
+		goto fail;
+	}
+
 	portdev = kmalloc(sizeof(*portdev), GFP_KERNEL);
 	if (!portdev) {
 		err = -ENOMEM;
@@ -1836,6 +1893,10 @@ static struct virtio_device_id id_table[] = {
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
 	VIRTIO_CONSOLE_F_MULTIPORT,
+#if VIRTIO_CONSOLE_HAS_DMA
+	VIRTIO_CONSOLE_F_DMA_MEM,
+#endif
+
 };
 
 #ifdef CONFIG_PM
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index bdf4b00..b27f7fa 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -38,6 +38,7 @@
 /* Feature bits */
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+#define VIRTIO_CONSOLE_F_DMA_MEM 2	/* Use DMA memory in vrings */
 
 #define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
 
-- 
1.7.9.5

