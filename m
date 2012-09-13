Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2IMSES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:04:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34750 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515Ab2IMSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:04:13 -0400
From: sjur.brandeland@stericsson.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_console: Add support for remoteproc serial
Date: Thu, 13 Sep 2012 20:04:00 +0200
Message-Id: <1347559440-6668-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add a virtio remoteproc serial driver: VIRTIO_ID_RPROC_SERIAL (0xB)
for communicating with a remote processor in an asymmetric
multi-processing configuration.

The virtio remoteproc serial driver reuses the existing virtio_console
implementation, and adds support for DMA allocation of data buffers
but disables support for tty console, mutiple ports, and the control queue.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: Amit Shah <amit.shah@redhat.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: virtualization@lists.linux-foundation.org
cc: linux-kernel@vger.kernel.org

>Just one thing, should it depend on CONFIG_REMOTEPROC?  And have
>OMAP_REMOTEPROC depend on CONFIG_HAS_DMA (if it doesn't already).

I have changed to use CONFIG_REMOTEPROC_MODULE now. I'll send a patch
to Ohad adding an explicit dependency to HAS_DMA for remoteproc.

>PS.  I've reserved 11 for you in the latest virtio spec draft.
Ok, I'll look into updating the spec.

Thanks,
Sjur


 drivers/char/virtio_console.c |  137 +++++++++++++++++++++++++++++++++--------
 include/linux/virtio_ids.h    |    1 +
 2 files changed, 112 insertions(+), 26 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..7c697ca 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -35,6 +35,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/kconfig.h>
 #include "../tty/hvc/hvc_console.h"
 
 /*
@@ -323,6 +325,52 @@ static bool is_console_port(struct port *port)
 	return false;
 }
 
+#ifdef CONFIG_REMOTEPROC_MODULE
+static inline bool is_rproc_serial(struct virtio_device *vdev)
+{
+	return vdev->id.device == VIRTIO_ID_RPROC_SERIAL;
+}
+#else
+static inline bool is_rproc_serial(struct virtio_device *vdev)
+{
+	return false;
+}
+#endif
+
+/* Allocate data buffer from DMA memory if requested */
+static inline void *
+alloc_databuf(struct virtio_device *vdev, size_t size, gfp_t flag)
+{
+	if (is_rproc_serial(vdev)) {
+		dma_addr_t dma;
+		struct device *dev = &vdev->dev;
+		/*
+		 * Allocate DMA memory from ancestors. Finding the ancestor
+		 * is a bit quirky when DMA_MEMORY_INCLUDES_CHILDREN is not
+		 * implemented.
+		 */
+		dev = dev->parent ? dev->parent : dev;
+		dev = dev->parent ? dev->parent : dev;
+		return dma_alloc_coherent(dev, size, &dma, flag);
+	}
+	return kmalloc(size, flag);
+}
+
+static inline void
+free_databuf(struct virtio_device *vdev, size_t size, void *cpu_addr)
+{
+
+	if (is_rproc_serial(vdev)) {
+		struct device *dev = &vdev->dev;
+		dma_addr_t dma_handle = virt_to_bus(cpu_addr);
+		dev = dev->parent ? dev->parent : dev;
+		dev = dev->parent ? dev->parent : dev;
+		dma_free_coherent(dev, size, cpu_addr, dma_handle);
+		return;
+	}
+	kfree(cpu_addr);
+}
+
 static inline bool use_multiport(struct ports_device *portdev)
 {
 	/*
@@ -334,20 +382,22 @@ static inline bool use_multiport(struct ports_device *portdev)
 	return portdev->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
-static void free_buf(struct port_buffer *buf)
+static void
+free_buf(struct virtqueue *vq, struct port_buffer *buf, size_t buf_size)
 {
-	kfree(buf->buf);
+	free_databuf(vq->vdev, buf_size, buf->buf);
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
+	memset(buf->buf, 0, buf_size);
 	if (!buf->buf)
 		goto free_buf;
 	buf->len = 0;
@@ -414,7 +464,7 @@ static void discard_port_data(struct port *port)
 		port->stats.bytes_discarded += buf->len - buf->offset;
 		if (add_inbuf(port->in_vq, buf) < 0) {
 			err++;
-			free_buf(buf);
+			free_buf(port->in_vq, buf, PAGE_SIZE);
 		}
 		port->inbuf = NULL;
 		buf = get_inbuf(port);
@@ -485,7 +535,7 @@ static void reclaim_consumed_buffers(struct port *port)
 		return;
 	}
 	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
-		kfree(buf);
+		free_databuf(port->portdev->vdev, len, buf);
 		port->outvq_full = false;
 	}
 }
@@ -672,6 +722,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 	char *buf;
 	ssize_t ret;
 	bool nonblock;
+	struct virtio_device *vdev;
 
 	/* Userspace could be out to fool us */
 	if (!count)
@@ -694,9 +745,10 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 	if (!port->guest_connected)
 		return -ENODEV;
 
+	vdev = port->portdev->vdev;
 	count = min((size_t)(32 * 1024), count);
 
-	buf = kmalloc(count, GFP_KERNEL);
+	buf = alloc_databuf(vdev, count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -720,7 +772,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 		goto out;
 
 free_buf:
-	kfree(buf);
+	free_databuf(vdev, count, buf);
 out:
 	return ret;
 }
@@ -918,7 +970,8 @@ static void resize_console(struct port *port)
 		return;
 
 	vdev = port->portdev->vdev;
-	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
+	if (!is_rproc_serial(vdev) &&
+	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
 		hvc_resize(port->cons.hvc, port->cons.ws);
 }
 
@@ -1102,7 +1155,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 
 	nr_added_bufs = 0;
 	do {
-		buf = alloc_buf(PAGE_SIZE);
+		buf = alloc_buf(vq, PAGE_SIZE);
 		if (!buf)
 			break;
 
@@ -1110,7 +1163,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 		ret = add_inbuf(vq, buf);
 		if (ret < 0) {
 			spin_unlock_irq(lock);
-			free_buf(buf);
+			free_buf(vq, buf, PAGE_SIZE);
 			break;
 		}
 		nr_added_bufs++;
@@ -1198,10 +1251,18 @@ static int add_port(struct ports_device *portdev, u32 id)
 		goto free_device;
 	}
 
-	/*
-	 * If we're not using multiport support, this has to be a console port
-	 */
-	if (!use_multiport(port->portdev)) {
+	if (is_rproc_serial(port->portdev->vdev))
+		/*
+		 * For rproc_serial assume remote processor is connected.
+		 * rproc_serial does not want the console port, but
+		 * the generic port implementation.
+		 */
+		port->host_connected = true;
+	else if (!use_multiport(port->portdev)) {
+		/*
+		 * If we're not using multiport support,
+		 * this has to be a console port.
+		 */
 		err = init_port_console(port);
 		if (err)
 			goto free_inbufs;
@@ -1234,7 +1295,7 @@ static int add_port(struct ports_device *portdev, u32 id)
 
 free_inbufs:
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+		free_buf(port->in_vq, buf, PAGE_SIZE);
 free_device:
 	device_destroy(pdrvdata.class, port->dev->devt);
 free_cdev:
@@ -1276,7 +1337,7 @@ static void remove_port_data(struct port *port)
 
 	/* Remove buffers we queued up for the Host to send us data in. */
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+		free_buf(port->in_vq, buf, PAGE_SIZE);
 }
 
 /*
@@ -1478,7 +1539,7 @@ static void control_work_handler(struct work_struct *work)
 		if (add_inbuf(portdev->c_ivq, buf) < 0) {
 			dev_warn(&portdev->vdev->dev,
 				 "Error adding buffer to queue\n");
-			free_buf(buf);
+			free_buf(portdev->c_ivq, buf, PAGE_SIZE);
 		}
 	}
 	spin_unlock(&portdev->cvq_lock);
@@ -1674,10 +1735,10 @@ static void remove_controlq_data(struct ports_device *portdev)
 		return;
 
 	while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
-		free_buf(buf);
+		free_buf(portdev->c_ivq, buf, PAGE_SIZE);
 
 	while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
-		free_buf(buf);
+		free_buf(portdev->c_ivq, buf, PAGE_SIZE);
 }
 
 /*
@@ -1688,7 +1749,7 @@ static void remove_controlq_data(struct ports_device *portdev)
  * config space to see how many ports the host has spawned.  We
  * initialize each port found.
  */
-static int __devinit virtcons_probe(struct virtio_device *vdev)
+static int virtcons_probe(struct virtio_device *vdev)
 {
 	struct ports_device *portdev;
 	int err;
@@ -1724,10 +1785,12 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 
 	multiport = false;
 	portdev->config.max_nr_ports = 1;
-	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
-			      offsetof(struct virtio_console_config,
-				       max_nr_ports),
-			      &portdev->config.max_nr_ports) == 0)
+	if (is_rproc_serial(vdev))
+		multiport = false;
+	else if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
+				  offsetof(struct virtio_console_config,
+					   max_nr_ports),
+				  &portdev->config.max_nr_ports) == 0)
 		multiport = true;
 
 	err = init_vqs(portdev);
@@ -1838,6 +1901,16 @@ static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_MULTIPORT,
 };
 
+static struct virtio_device_id rproc_serial_id_table[] = {
+#ifdef CONFIG_REMOTEPROC_MODULE
+	{ VIRTIO_ID_RPROC_SERIAL, VIRTIO_DEV_ANY_ID },
+#endif
+	{ 0 },
+};
+
+static unsigned int rproc_serial_features[] = {
+};
+
 #ifdef CONFIG_PM
 static int virtcons_freeze(struct virtio_device *vdev)
 {
@@ -1922,6 +1995,16 @@ static struct virtio_driver virtio_console = {
 #endif
 };
 
+static struct virtio_driver virtio_rproc_serial = {
+	.feature_table = rproc_serial_features,
+	.feature_table_size = ARRAY_SIZE(rproc_serial_features),
+	.driver.name =	"virtio_rproc_serial",
+	.driver.owner =	THIS_MODULE,
+	.id_table =	rproc_serial_id_table,
+	.probe =	virtcons_probe,
+	.remove =	virtcons_remove,
+};
+
 static int __init init(void)
 {
 	int err;
@@ -1941,12 +2024,14 @@ static int __init init(void)
 	INIT_LIST_HEAD(&pdrvdata.consoles);
 	INIT_LIST_HEAD(&pdrvdata.portdevs);
 
-	return register_virtio_driver(&virtio_console);
+	return register_virtio_driver(&virtio_console) &&
+		register_virtio_driver(&virtio_rproc_serial);
 }
 
 static void __exit fini(void)
 {
 	unregister_virtio_driver(&virtio_console);
+	unregister_virtio_driver(&virtio_rproc_serial);
 
 	class_destroy(pdrvdata.class);
 	if (pdrvdata.debugfs_dir)
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 270fb22..07cf6f7 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -37,5 +37,6 @@
 #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI		8 /* virtio scsi */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
+#define VIRTIO_ID_RPROC_SERIAL	0xB /* virtio remoteproc serial link */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
1.7.5.4

