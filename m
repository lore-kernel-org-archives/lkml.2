Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab1I2P0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab1I2P0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:26:32 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 03/11] virtio: console: Move out vq and vq buf removal into separate functions
Date: Thu, 29 Sep 2011 20:55:59 +0530
Message-Id: <0a2d771476bbbb1b2c9e9b78980e89d8726dba50.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This common code will be shared with the PM freeze function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/virtio_console.c |   68 ++++++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 7f2c6e5..1bef060 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1270,6 +1270,20 @@ static void remove_port(struct kref *kref)
 	kfree(port);
 }
 
+static void remove_port_data(struct port *port)
+{
+	struct port_buffer *buf;
+
+	/* Remove unused data this port might have received. */
+	discard_port_data(port);
+
+	reclaim_consumed_buffers(port);
+
+	/* Remove buffers we queued up for the Host to send us data in. */
+	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
+		free_buf(buf);
+}
+
 /*
  * Port got unplugged.  Remove port from portdev's list and drop the
  * kref reference.  If no userspace has this port opened, it will
@@ -1277,8 +1291,6 @@ static void remove_port(struct kref *kref)
  */
 static void unplug_port(struct port *port)
 {
-	struct port_buffer *buf;
-
 	spin_lock_irq(&port->portdev->ports_lock);
 	list_del(&port->list);
 	spin_unlock_irq(&port->portdev->ports_lock);
@@ -1299,14 +1311,7 @@ static void unplug_port(struct port *port)
 		hvc_remove(port->cons.hvc);
 	}
 
-	/* Remove unused data this port might have received. */
-	discard_port_data(port);
-
-	reclaim_consumed_buffers(port);
-
-	/* Remove buffers we queued up for the Host to send us data in. */
-	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
-		free_buf(buf);
+	remove_port_data(port);
 
 	/*
 	 * We should just assume the device itself has gone off --
@@ -1658,6 +1663,28 @@ static const struct file_operations portdev_fops = {
 	.owner = THIS_MODULE,
 };
 
+static void remove_vqs(struct ports_device *portdev)
+{
+	portdev->vdev->config->del_vqs(portdev->vdev);
+	kfree(portdev->in_vqs);
+	kfree(portdev->out_vqs);
+}
+
+static void remove_controlq_data(struct ports_device *portdev)
+{
+	struct port_buffer *buf;
+	unsigned int len;
+
+	if (!use_multiport(portdev))
+		return;
+
+	while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
+		free_buf(buf);
+
+	while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
+		free_buf(buf);
+}
+
 /*
  * Once we're further in boot, we get probed like any other virtio
  * device.
@@ -1765,9 +1792,7 @@ free_vqs:
 	/* The host might want to notify mgmt sw about device add failure */
 	__send_control_msg(portdev, VIRTIO_CONSOLE_BAD_ID,
 			   VIRTIO_CONSOLE_DEVICE_READY, 0);
-	vdev->config->del_vqs(vdev);
-	kfree(portdev->in_vqs);
-	kfree(portdev->out_vqs);
+	remove_vqs(portdev);
 free_chrdev:
 	unregister_chrdev(portdev->chr_major, "virtio-portsdev");
 free:
@@ -1805,21 +1830,8 @@ static void virtcons_remove(struct virtio_device *vdev)
 	 * have to just stop using the port, as the vqs are going
 	 * away.
 	 */
-	if (use_multiport(portdev)) {
-		struct port_buffer *buf;
-		unsigned int len;
-
-		while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
-			free_buf(buf);
-
-		while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
-			free_buf(buf);
-	}
-
-	vdev->config->del_vqs(vdev);
-	kfree(portdev->in_vqs);
-	kfree(portdev->out_vqs);
-
+	remove_controlq_data(portdev);
+	remove_vqs(portdev);
 	kfree(portdev);
 }
 
-- 
1.7.6.2

