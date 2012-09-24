Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2IXMdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:33:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60818 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2IXMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:33:24 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv4] virtio_console: Add support for remoteproc serial
Date: Mon, 24 Sep 2012 14:33:07 +0200
Message-Id: <1348489987-6768-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add a simple serial connection driver called
VIRTIO_ID_RPROC_SERIAL (11) for communicating with a
remote processor in an asymmetric multi-processing
configuration.

This implementation reuses the existing virtio_console
implementation, and adds support for DMA allocation
of data buffers and disables use of tty console and
the virtio control queue.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: Amit Shah <amit.shah@redhat.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: Arnd Bergmann <arnd@arndb.de>
---

Changes since v3 are mostly related to freeing of dma-buffers:
- Change port_fops_write() to use struct port_buffer when allocating
  memory. This is done in order to store the dma-address of the
  allocated buffers, so the correct dma-address can be passed to
  dma_free_coherent().
- Added pending_free_list for port_buf. dma_free_coherent() requires
  the irqs to be enabled, so if irqs are disabled we queue the buffer
  on the pending_free_list and free it later when irqs are enabled.
- Remove #if around is_rproc_serial

Thanks,
Sjur

 drivers/char/virtio_console.c |  222 ++++++++++++++++++++++++++++++++++++-----
 include/linux/virtio_ids.h    |    1 +
 2 files changed, 199 insertions(+), 24 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..3af9a5d 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -35,8 +35,12 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/kconfig.h>
 #include "../tty/hvc/hvc_console.h"
 
+#define rproc_enabled IS_ENABLED(CONFIG_REMOTEPROC)
+
 /*
  * This is a global struct for storing common data for all the devices
  * this driver handles.
@@ -109,6 +113,15 @@ struct port_buffer {
 	size_t len;
 	/* offset in the buf from which to consume data */
 	size_t offset;
+
+	/* DMA address of buffer */
+	dma_addr_t dma;
+
+	/* Device we got DMA memory from */
+	struct device *dev;
+
+	/* List of pending dma buffers to free */
+	struct list_head list;
 };
 
 /*
@@ -323,6 +336,11 @@ static bool is_console_port(struct port *port)
 	return false;
 }
 
+static bool is_rproc_serial(const struct virtio_device *vdev)
+{
+	return rproc_enabled && vdev->id.device == VIRTIO_ID_RPROC_SERIAL;
+}
+
 static inline bool use_multiport(struct ports_device *portdev)
 {
 	/*
@@ -334,20 +352,99 @@ static inline bool use_multiport(struct ports_device *portdev)
 	return portdev->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
+static DEFINE_SPINLOCK(list_lock);
+static LIST_HEAD(pending_free_list);
+
 static void free_buf(struct port_buffer *buf)
 {
-	kfree(buf->buf);
+	unsigned long flags;
+
+	if (!buf->dev) {
+		kfree(buf->buf);
+		goto freebuf;
+	}
+
+	BUG_ON(!rproc_enabled);
+
+	/* dma_free_coherent requires interrupts to be enabled */
+	if (rproc_enabled && !irqs_disabled()) {
+		dma_free_coherent(buf->dev, buf->size, buf->buf, buf->dma);
+
+		/* Release device refcnt and allow it to be freed */
+		might_sleep();
+		put_device(buf->dev);
+		goto freebuf;
+	}
+
+	/* queue up dma-buffers to be freed later */
+	spin_lock_irqsave(&list_lock, flags);
+	list_add_tail(&buf->list, &pending_free_list);
+	spin_unlock_irqrestore(&list_lock, flags);
+	return;
+
+freebuf:
 	kfree(buf);
 }
 
-static struct port_buffer *alloc_buf(size_t buf_size)
+static void reclaim_dma_bufs(void)
+{
+	unsigned long flags;
+	struct port_buffer *buf, *tmp;
+	LIST_HEAD(tmp_list);
+
+	WARN_ON(irqs_disabled());
+	if (list_empty(&pending_free_list))
+		return;
+
+	BUG_ON(!rproc_enabled);
+
+	/* Create a copy of the pending_free_list while holding the lock*/
+	spin_lock_irqsave(&list_lock, flags);
+	list_cut_position(&tmp_list, &pending_free_list,
+			  pending_free_list.prev);
+	spin_unlock_irqrestore(&list_lock, flags);
+
+	/* Release the dma buffers, without irqs enabled */
+	list_for_each_entry_safe(buf, tmp, &tmp_list, list) {
+		list_del(&buf->list);
+		free_buf(buf);
+	}
+}
+
+static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size)
 {
 	struct port_buffer *buf;
 
+	if (is_rproc_serial(vq->vdev) && !irqs_disabled())
+		reclaim_dma_bufs();
+
 	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		goto fail;
-	buf->buf = kzalloc(buf_size, GFP_KERNEL);
+
+	if (is_rproc_serial(vq->vdev)) {
+		/*
+		 * Allocate DMA memory from ancestor. When a virtio
+		 * device is created by remoteproc, the DMA memory is
+		 * associated with the grandparent device:
+		 * vdev => rproc => platform-dev.
+		 * The code here would have been less quirky if
+		 * DMA_MEMORY_INCLUDES_CHILDREN had been supported
+		 * in dma-coherent.c
+		 */
+		if (!vq->vdev->dev.parent || !vq->vdev->dev.parent->parent)
+			goto free_buf;
+		buf->dev = vq->vdev->dev.parent->parent;
+
+		/* Increase device refcnt to avoid freeing it*/
+		get_device(buf->dev);
+		buf->buf = dma_alloc_coherent(buf->dev, buf_size, &buf->dma,
+						GFP_KERNEL);
+	} else {
+		buf->buf = kmalloc(buf_size, GFP_KERNEL);
+		buf->dev = NULL;
+	}
+
 	if (!buf->buf)
 		goto free_buf;
 	buf->len = 0;
@@ -485,7 +582,10 @@ static void reclaim_consumed_buffers(struct port *port)
 		return;
 	}
 	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
-		kfree(buf);
+		if (is_console_port(port))
+			kfree(buf);
+		else
+			free_buf(buf);
 		port->outvq_full = false;
 	}
 }
@@ -498,6 +598,7 @@ static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
 	ssize_t ret;
 	unsigned long flags;
 	unsigned int len;
+	struct port_buffer *buf = in_buf;
 
 	out_vq = port->out_vq;
 
@@ -505,8 +606,11 @@ static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
 
 	reclaim_consumed_buffers(port);
 
-	sg_init_one(sg, in_buf, in_count);
-	ret = virtqueue_add_buf(out_vq, sg, 1, 0, in_buf, GFP_ATOMIC);
+	if (is_console_port(port))
+		sg_init_one(sg, in_buf, in_count);
+	else
+		sg_init_one(sg, buf->buf, in_count);
+	ret = virtqueue_add_buf(out_vq, sg, 1, 0, buf, GFP_ATOMIC);
 
 	/* Tell Host to go! */
 	virtqueue_kick(out_vq);
@@ -669,7 +773,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 			       size_t count, loff_t *offp)
 {
 	struct port *port;
-	char *buf;
+	struct port_buffer *buf;
 	ssize_t ret;
 	bool nonblock;
 
@@ -696,11 +800,11 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 
 	count = min((size_t)(32 * 1024), count);
 
-	buf = kmalloc(count, GFP_KERNEL);
+	buf = alloc_buf(port->out_vq, count);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = copy_from_user(buf, ubuf, count);
+	ret = copy_from_user(buf->buf, ubuf, count);
 	if (ret) {
 		ret = -EFAULT;
 		goto free_buf;
@@ -720,7 +824,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 		goto out;
 
 free_buf:
-	kfree(buf);
+	free_buf(buf);
 out:
 	return ret;
 }
@@ -770,6 +874,8 @@ static int port_fops_release(struct inode *inode, struct file *filp)
 	reclaim_consumed_buffers(port);
 	spin_unlock_irq(&port->outvq_lock);
 
+	if (is_rproc_serial(port->portdev->vdev) && !irqs_disabled())
+		reclaim_dma_bufs();
 	/*
 	 * Locks aren't necessary here as a port can't be opened after
 	 * unplug, and if a port isn't unplugged, a kref would already
@@ -918,7 +1024,8 @@ static void resize_console(struct port *port)
 		return;
 
 	vdev = port->portdev->vdev;
-	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
+	if (!is_rproc_serial(vdev) &&
+	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
 		hvc_resize(port->cons.hvc, port->cons.ws);
 }
 
@@ -1102,10 +1209,10 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 
 	nr_added_bufs = 0;
 	do {
-		buf = alloc_buf(PAGE_SIZE);
+		buf = alloc_buf(vq, PAGE_SIZE);
 		if (!buf)
 			break;
-
+		memset(buf->buf, 0, PAGE_SIZE);
 		spin_lock_irq(lock);
 		ret = add_inbuf(vq, buf);
 		if (ret < 0) {
@@ -1198,10 +1305,18 @@ static int add_port(struct ports_device *portdev, u32 id)
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
@@ -1277,6 +1392,16 @@ static void remove_port_data(struct port *port)
 	/* Remove buffers we queued up for the Host to send us data in. */
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
 		free_buf(buf);
+
+	/*
+	 * Remove buffers from out queue for rproc-serial. We cannot afford
+	 * to leak any DMA mem, so reclaim this memory even if this might be
+	 * racy for the remote processor.
+	 */
+	if (is_rproc_serial(port->portdev->vdev)) {
+		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
+			free_buf(buf);
+	}
 }
 
 /*
@@ -1722,13 +1847,17 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 		goto free;
 	}
 
-	multiport = false;
-	portdev->config.max_nr_ports = 1;
-	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
-			      offsetof(struct virtio_console_config,
-				       max_nr_ports),
-			      &portdev->config.max_nr_ports) == 0)
+	/* Don't test MULTIPORT at all if we're rproc: not a valid feature! */
+	if (!is_rproc_serial(vdev) &&
+	    virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
+				  offsetof(struct virtio_console_config,
+					   max_nr_ports),
+				  &portdev->config.max_nr_ports) == 0) {
 		multiport = true;
+	} else {
+		multiport = false;
+		portdev->config.max_nr_ports = 1;
+	}
 
 	err = init_vqs(portdev);
 	if (err < 0) {
@@ -1838,6 +1967,16 @@ static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_MULTIPORT,
 };
 
+static struct virtio_device_id rproc_serial_id_table[] = {
+#if IS_ENABLED(CONFIG_REMOTEPROC)
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
@@ -1922,6 +2061,20 @@ static struct virtio_driver virtio_console = {
 #endif
 };
 
+/*
+ * virtio_rproc_serial refers to __devinit function which causes
+ * section mismatch warnings. So use __refdata to silence warnings.
+ */
+static struct virtio_driver __refdata virtio_rproc_serial = {
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
@@ -1941,12 +2094,33 @@ static int __init init(void)
 	INIT_LIST_HEAD(&pdrvdata.consoles);
 	INIT_LIST_HEAD(&pdrvdata.portdevs);
 
-	return register_virtio_driver(&virtio_console);
+	err = register_virtio_driver(&virtio_console);
+	if (err < 0) {
+		pr_err("Error %d registering virtio driver\n", err);
+		goto free;
+	}
+	err = register_virtio_driver(&virtio_rproc_serial);
+	if (err < 0) {
+		pr_err("Error %d registering virtio rproc serial driver\n",
+		       err);
+		goto unregister;
+	}
+	return 0;
+unregister:
+	unregister_virtio_driver(&virtio_console);
+free:
+	if (pdrvdata.debugfs_dir)
+		debugfs_remove_recursive(pdrvdata.debugfs_dir);
+	class_destroy(pdrvdata.class);
+	return err;
 }
 
 static void __exit fini(void)
 {
+	reclaim_dma_bufs();
+
 	unregister_virtio_driver(&virtio_console);
+	unregister_virtio_driver(&virtio_rproc_serial);
 
 	class_destroy(pdrvdata.class);
 	if (pdrvdata.debugfs_dir)
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 270fb22..cb28b52 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -37,5 +37,6 @@
 #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI		8 /* virtio scsi */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
+#define VIRTIO_ID_RPROC_SERIAL	11 /* virtio remoteproc serial link */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
1.7.5.4

