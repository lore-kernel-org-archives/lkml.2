Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1I2Ptt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1I2Pts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:49:48 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 04/11] virtio: console: Add freeze and restore handlers to support S4
Date: Thu, 29 Sep 2011 21:19:37 +0530
Message-Id: <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317311033.git.amit.shah@redhat.com>
References: <cover.1317311033.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all vqs and associated buffers in the freeze callback which
prepares us to go into hibernation state.  On restore, re-create all the
vqs and populate the input vqs with buffers to get to the pre-hibernate
state.

Note: Any outstanding unconsumed buffers are discarded; which means
there's a possibility of data loss in case the host or the guest didn't
consume any data already present in the vqs.  This can be addressed in a
later patch series, perhaps in virtio common code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/virtio_console.c |   55 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 1bef060..e0b3a28 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1845,6 +1845,57 @@ static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_MULTIPORT,
 };
 
+#ifdef CONFIG_PM
+static int virtcons_freeze(struct virtio_device *vdev)
+{
+	struct ports_device *portdev;
+	struct port *port;
+
+	portdev = vdev->priv;
+
+	remove_controlq_data(portdev);
+
+	list_for_each_entry(port, &portdev->ports, list) {
+		/*
+		 * We'll ask the host later if the new invocation has
+		 * the port opened or closed.
+		 */
+		port->host_connected = false;
+		remove_port_data(port);
+	}
+	remove_vqs(portdev);
+
+	return 0;
+}
+
+static int virtcons_restore(struct virtio_device *vdev)
+{
+	struct ports_device *portdev;
+	struct port *port;
+	int ret;
+
+	portdev = vdev->priv;
+
+	ret = init_vqs(portdev);
+	if (ret)
+		return ret;
+
+	if (use_multiport(portdev))
+		fill_queue(portdev->c_ivq, &portdev->cvq_lock);
+
+	list_for_each_entry(port, &portdev->ports, list) {
+		port->in_vq = portdev->in_vqs[port->id];
+		port->out_vq = portdev->out_vqs[port->id];
+
+		fill_queue(port->in_vq, &port->inbuf_lock);
+
+		/* Get port open/close status on the host */
+		send_control_msg(port, VIRTIO_CONSOLE_PORT_READY, 1);
+	}
+	return 0;
+}
+#endif
+
 static struct virtio_driver virtio_console = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
@@ -1854,6 +1905,10 @@ static struct virtio_driver virtio_console = {
 	.probe =	virtcons_probe,
 	.remove =	virtcons_remove,
 	.config_changed = config_intr,
+#ifdef CONFIG_PM
+	.freeze =	virtcons_freeze,
+	.restore =	virtcons_restore,
+#endif
 };
 
 static int __init init(void)
-- 
1.7.6.2

