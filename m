Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2J3Iws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:52:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56340 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab2J3IwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:52:05 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH v8 2/3] virtio_console: Add support for remoteproc serial
Date: Tue, 30 Oct 2012 09:51:52 +0100
Message-Id: <1351587113-2566-3-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
References: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
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
Acked-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/virtio_console.c   |  190 ++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/virtio_ids.h |    1 +
 2 files changed, 169 insertions(+), 22 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index b84390f..9ebadcb 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -37,8 +37,12 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/kconfig.h>
 #include "../tty/hvc/hvc_console.h"
 
+#define is_rproc_enabled IS_ENABLED(CONFIG_REMOTEPROC)
+
 /*
  * This is a global struct for storing common data for all the devices
  * this driver handles.
@@ -112,6 +116,15 @@ struct port_buffer {
 	/* offset in the buf from which to consume data */
 	size_t offset;
 
+	/* DMA address of buffer */
+	dma_addr_t dma;
+
+	/* Device we got DMA memory from */
+	struct device *dev;
+
+	/* List of pending dma buffers to free */
+	struct list_head list;
+
 	/* If sgpages == 0 then buf is used */
 	unsigned int sgpages;
 
@@ -331,6 +344,11 @@ static bool is_console_port(struct port *port)
 	return false;
 }
 
+static bool is_rproc_serial(const struct virtio_device *vdev)
+{
+	return is_rproc_enabled && vdev->id.device == VIRTIO_ID_RPROC_SERIAL;
+}
+
 static inline bool use_multiport(struct ports_device *portdev)
 {
 	/*
@@ -342,11 +360,13 @@ static inline bool use_multiport(struct ports_device *portdev)
 	return portdev->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
-static void free_buf(struct port_buffer *buf)
+static DEFINE_SPINLOCK(dma_bufs_lock);
+static LIST_HEAD(pending_free_dma_bufs);
+
+static void free_buf(struct port_buffer *buf, bool can_sleep)
 {
 	unsigned int i;
 
-	kfree(buf->buf);
 	for (i = 0; i < buf->sgpages; i++) {
 		struct page *page = sg_page(&buf->sg[i]);
 		if (!page)
@@ -354,14 +374,57 @@ static void free_buf(struct port_buffer *buf)
 		put_page(page);
 	}
 
+	if (!buf->dev) {
+		kfree(buf->buf);
+	} else if (is_rproc_enabled) {
+		unsigned long flags;
+
+		/* dma_free_coherent requires interrupts to be enabled. */
+		if (!can_sleep) {
+			/* queue up dma-buffers to be freed later */
+			spin_lock_irqsave(&dma_bufs_lock, flags);
+			list_add_tail(&buf->list, &pending_free_dma_bufs);
+			spin_unlock_irqrestore(&dma_bufs_lock, flags);
+			return;
+		}
+		dma_free_coherent(buf->dev, buf->size, buf->buf, buf->dma);
+
+		/* Release device refcnt and allow it to be freed */
+		put_device(buf->dev);
+	}
+
 	kfree(buf);
 }
 
+static void reclaim_dma_bufs(void)
+{
+	unsigned long flags;
+	struct port_buffer *buf, *tmp;
+	LIST_HEAD(tmp_list);
+
+	if (list_empty(&pending_free_dma_bufs))
+		return;
+
+	/* Create a copy of the pending_free_dma_bufs while holding the lock */
+	spin_lock_irqsave(&dma_bufs_lock, flags);
+	list_cut_position(&tmp_list, &pending_free_dma_bufs,
+			  pending_free_dma_bufs.prev);
+	spin_unlock_irqrestore(&dma_bufs_lock, flags);
+
+	/* Release the dma buffers, without irqs enabled */
+	list_for_each_entry_safe(buf, tmp, &tmp_list, list) {
+		list_del(&buf->list);
+		free_buf(buf, true);
+	}
+}
+
 static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
 				     int pages)
 {
 	struct port_buffer *buf;
 
+	reclaim_dma_bufs();
+
 	/*
 	 * Allocate buffer and the sg list. The sg list array is allocated
 	 * directly after the port_buffer struct.
@@ -373,11 +436,34 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
 
 	buf->sgpages = pages;
 	if (pages > 0) {
+		buf->dev = NULL;
 		buf->buf = NULL;
 		return buf;
 	}
 
-	buf->buf = kmalloc(buf_size, GFP_KERNEL);
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
+		/* Increase device refcnt to avoid freeing it */
+		get_device(buf->dev);
+		buf->buf = dma_alloc_coherent(buf->dev, buf_size, &buf->dma,
+					      GFP_KERNEL);
+	} else {
+		buf->dev = NULL;
+		buf->buf = kmalloc(buf_size, GFP_KERNEL);
+	}
+
 	if (!buf->buf)
 		goto free_buf;
 	buf->len = 0;
@@ -444,7 +530,7 @@ static void discard_port_data(struct port *port)
 		port->stats.bytes_discarded += buf->len - buf->offset;
 		if (add_inbuf(port->in_vq, buf) < 0) {
 			err++;
-			free_buf(buf);
+			free_buf(buf, false);
 		}
 		port->inbuf = NULL;
 		buf = get_inbuf(port);
@@ -516,7 +602,7 @@ static void reclaim_consumed_buffers(struct port *port)
 		return;
 	}
 	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
-		free_buf(buf);
+		free_buf(buf, false);
 		port->outvq_full = false;
 	}
 }
@@ -763,7 +849,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 		goto out;
 
 free_buf:
-	free_buf(buf);
+	free_buf(buf, true);
 out:
 	return ret;
 }
@@ -837,6 +923,15 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 		.u.data = &sgl,
 	};
 
+	/*
+	 * Rproc_serial does not yet support splice. To support splice
+	 * pipe_to_sg() must allocate dma-buffers and copy content from
+	 * regular pages to dma pages. And alloc_buf and free_buf must
+	 * support allocating and freeing such a list of dma-buffers.
+	 */
+	if (is_rproc_serial(port->out_vq->vdev))
+		return -EINVAL;
+
 	ret = wait_port_writable(port, filp->f_flags & O_NONBLOCK);
 	if (ret < 0)
 		return ret;
@@ -855,7 +950,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 		ret = __send_to_port(port, buf->sg, sgl.n, sgl.len, buf, true);
 
 	if (unlikely(ret <= 0))
-		kfree(sgl.sg);
+		free_buf(buf, true);
 	return ret;
 }
 
@@ -904,6 +999,7 @@ static int port_fops_release(struct inode *inode, struct file *filp)
 	reclaim_consumed_buffers(port);
 	spin_unlock_irq(&port->outvq_lock);
 
+	reclaim_dma_bufs();
 	/*
 	 * Locks aren't necessary here as a port can't be opened after
 	 * unplug, and if a port isn't unplugged, a kref would already
@@ -1055,7 +1151,10 @@ static void resize_console(struct port *port)
 		return;
 
 	vdev = port->portdev->vdev;
-	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
+
+	/* Don't test F_SIZE at all if we're rproc: not a valid feature! */
+	if (!is_rproc_serial(vdev) &&
+	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
 		hvc_resize(port->cons.hvc, port->cons.ws);
 }
 
@@ -1247,7 +1346,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 		ret = add_inbuf(vq, buf);
 		if (ret < 0) {
 			spin_unlock_irq(lock);
-			free_buf(buf);
+			free_buf(buf, true);
 			break;
 		}
 		nr_added_bufs++;
@@ -1335,10 +1434,18 @@ static int add_port(struct ports_device *portdev, u32 id)
 		goto free_device;
 	}
 
-	/*
-	 * If we're not using multiport support, this has to be a console port
-	 */
-	if (!use_multiport(port->portdev)) {
+	if (is_rproc_serial(port->portdev->vdev))
+		/*
+		 * For rproc_serial assume remote processor is connected.
+		 * rproc_serial does not want the console port, only
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
@@ -1371,7 +1478,7 @@ static int add_port(struct ports_device *portdev, u32 id)
 
 free_inbufs:
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+		free_buf(buf, true);
 free_device:
 	device_destroy(pdrvdata.class, port->dev->devt);
 free_cdev:
@@ -1413,7 +1520,7 @@ static void remove_port_data(struct port *port)
 
 	/* Remove buffers we queued up for the Host to send us data in. */
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+		free_buf(buf, true);
 }
 
 /*
@@ -1615,7 +1722,7 @@ static void control_work_handler(struct work_struct *work)
 		if (add_inbuf(portdev->c_ivq, buf) < 0) {
 			dev_warn(&portdev->vdev->dev,
 				 "Error adding buffer to queue\n");
-			free_buf(buf);
+			free_buf(buf, false);
 		}
 	}
 	spin_unlock(&portdev->cvq_lock);
@@ -1811,10 +1918,10 @@ static void remove_controlq_data(struct ports_device *portdev)
 		return;
 
 	while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
-		free_buf(buf);
+		free_buf(buf, true);
 
 	while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
-		free_buf(buf);
+		free_buf(buf, true);
 }
 
 /*
@@ -1861,11 +1968,15 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 
 	multiport = false;
 	portdev->config.max_nr_ports = 1;
-	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
-			      offsetof(struct virtio_console_config,
-				       max_nr_ports),
-			      &portdev->config.max_nr_ports) == 0)
+
+	/* Don't test MULTIPORT at all if we're rproc: not a valid feature! */
+	if (!is_rproc_serial(vdev) &&
+	    virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
+				  offsetof(struct virtio_console_config,
+					   max_nr_ports),
+				  &portdev->config.max_nr_ports) == 0) {
 		multiport = true;
+	}
 
 	err = init_vqs(portdev);
 	if (err < 0) {
@@ -1975,6 +2086,16 @@ static unsigned int features[] = {
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
@@ -2059,6 +2180,20 @@ static struct virtio_driver virtio_console = {
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
@@ -2083,7 +2218,15 @@ static int __init init(void)
 		pr_err("Error %d registering virtio driver\n", err);
 		goto free;
 	}
+	err = register_virtio_driver(&virtio_rproc_serial);
+	if (err < 0) {
+		pr_err("Error %d registering virtio rproc serial driver\n",
+		       err);
+		goto unregister;
+	}
 	return 0;
+unregister:
+	unregister_virtio_driver(&virtio_console);
 free:
 	if (pdrvdata.debugfs_dir)
 		debugfs_remove_recursive(pdrvdata.debugfs_dir);
@@ -2093,7 +2236,10 @@ free:
 
 static void __exit fini(void)
 {
+	reclaim_dma_bufs();
+
 	unregister_virtio_driver(&virtio_console);
+	unregister_virtio_driver(&virtio_rproc_serial);
 
 	class_destroy(pdrvdata.class);
 	if (pdrvdata.debugfs_dir)
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 270fb22..a7630d0 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -37,5 +37,6 @@
 #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI		8 /* virtio scsi */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
+#define VIRTIO_ID_RPROC_SERIAL 11 /* virtio remoteproc serial link */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
1.7.9.5

