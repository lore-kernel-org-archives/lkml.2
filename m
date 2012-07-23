Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2GWUcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:32:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62678 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2GWUc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:32:29 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: rusty@rustcorp.com.au, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, anthony@codemonkey.ws,
        wency@cn.fujitsu.com, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 1/2] virtio: Introduce virtio-notifier
Date: Mon, 23 Jul 2012 22:32:40 +0200
Message-Id: <1343075561-29316-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[TODO: Find a better name]

virtio-notifier is a new driver which provides guests the ability to report
critical events such as a panic or OOM to the host.

The driver also provides an "echo" channel which is primed with a buffer when
the driver is initialized, and allows the host to "ping" the guest to make
sure the guest is still alive and well.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/virtio/Kconfig           |   11 +++
 drivers/virtio/Makefile          |    1 +
 drivers/virtio/virtio_notifier.c |  135 ++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_ids.h       |    1 +
 include/linux/virtio_notifier.h  |   15 ++++
 5 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/virtio_notifier.c
 create mode 100644 include/linux/virtio_notifier.h

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 1a61939..1be8f93 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -46,4 +46,15 @@ config VIRTIO_BALLOON
 
  	 If unsure, say N.
 
+config VIRTIO_NOTIFIER
+	tristate "Virtio notifier driver (EXPERIMENTAL)"
+	select VIRTIO
+	select VIRTIO_RING
+	---help---
+	This driver provides support for passing improtant notifications such as
+	notification about guest PANIC or OOM back to the host.
+
+	Also, the driver provides a mechanism to detect lockups in the guest (similar
+	to a watchdog), notifying the host about such lockups.
+
 endmenu
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 5a4c63c..7b77d0b 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
+obj-$(CONFIG_VIRTIO_NOTIFIER) += virtio_notifier.o
diff --git a/drivers/virtio/virtio_notifier.c b/drivers/virtio/virtio_notifier.c
new file mode 100644
index 0000000..77393c5
--- /dev/null
+++ b/drivers/virtio/virtio_notifier.c
@@ -0,0 +1,135 @@
+/*
+ * Notifier/watchdog driver for virtio
+ *  Copyright (C) 2012 Sasha Levin
+ */
+
+#include <linux/err.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock.h>
+#include <linux/virtio.h>
+#include <linux/virtio_notifier.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/oom.h>
+
+static struct virtqueue *echo, *notif;
+static u32 notif_cnt[VIRTIO_NOTIF_CNT];
+static u64 echo_val;
+
+static void notif_done(struct virtqueue *vq)
+{
+}
+
+static void echo_done(struct virtqueue *vq)
+{
+	struct scatterlist sg;
+
+        sg_init_one(&sg, &echo_val, sizeof(echo_val));
+	if (virtqueue_add_buf(echo, &sg, 1, 0, echo, GFP_KERNEL) < 0)
+		BUG();
+
+	virtqueue_kick(echo);
+}
+
+static void notify_host(int notification)
+{
+	struct scatterlist sg;
+
+	notif_cnt[notification]++;
+
+        sg_init_one(&sg, notif_cnt, sizeof(notif_cnt));
+
+	if (virtqueue_add_buf(notif, &sg, 0, 1, notif, GFP_KERNEL) < 0)
+		BUG();
+
+	virtqueue_kick(notif);
+}
+
+static int virtio_notif_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	notify_host(VIRTIO_NOTIF_PANIC);
+
+	return NOTIFY_DONE;
+}
+
+static int virtio_notif_oom(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	notify_host(VIRTIO_NOTIF_OOM);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block virtio_notif_panic_block = {
+        .notifier_call = virtio_notif_panic,
+};
+
+static struct notifier_block virtio_notif_oom_block = {
+	.notifier_call = virtio_notif_oom,
+};
+
+static int virtnotif_probe(struct virtio_device *vdev)
+{
+	int err;
+	struct virtqueue *vqs[2];
+	vq_callback_t *callbacks[] = { notif_done, echo_done };
+	const char *names[] = { "notif", "echo" };
+	struct scatterlist sg;
+	
+	/* We expect two virtqueue. */
+	err = vdev->config->find_vqs(vdev, 2, vqs, callbacks, names);
+	if (err)
+		return err;
+
+	notif = vqs[0];
+	echo = vqs[1];
+
+	/*
+	 * Prime this virtqueue with one buffer so the hypervisor can
+	 * use it to signal us later.
+	 */
+	sg_init_one(&sg, &echo_val, sizeof(echo_val));
+	if (virtqueue_add_buf(echo, &sg, 1, 0, echo, GFP_KERNEL) < 0)
+		BUG();
+
+	virtqueue_kick(echo);
+
+	atomic_notifier_chain_register(&panic_notifier_list, &virtio_notif_panic_block);
+	register_oom_notifier(&virtio_notif_oom_block);
+
+	return 0;
+}
+
+static void __devexit virtnotif_remove(struct virtio_device *vdev)
+{
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
+}
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_NOTIFIER, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_notifier_driver = {
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table =	id_table,
+	.probe =	virtnotif_probe,
+	.remove =	__devexit_p(virtnotif_remove),
+};
+
+static int __init init(void)
+{
+	return register_virtio_driver(&virtio_notifier_driver);
+}
+
+static void __exit fini(void)
+{
+	unregister_virtio_driver(&virtio_notifier_driver);
+}
+module_init(init);
+module_exit(fini);
+
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("Virtio notifier driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 7529b85..553edf9 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -34,6 +34,7 @@
 #define VIRTIO_ID_CONSOLE	3 /* virtio console */
 #define VIRTIO_ID_RNG		4 /* virtio ring */
 #define VIRTIO_ID_BALLOON	5 /* virtio balloon */
+#define VIRTIO_ID_NOTIFIER      6 /* virtio notifier */
 #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI		8 /* virtio scsi */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
diff --git a/include/linux/virtio_notifier.h b/include/linux/virtio_notifier.h
new file mode 100644
index 0000000..ad5bcf7
--- /dev/null
+++ b/include/linux/virtio_notifier.h
@@ -0,0 +1,15 @@
+#ifndef _LINUX_VIRTIO_NOTIFIER_H
+#define _LINUX_VIRTIO_NOTIFIER_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers. */
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+enum virtio_notifications {
+	VIRTIO_NOTIF_PANIC,
+	VIRTIO_NOTIF_OOM,
+
+	VIRTIO_NOTIF_CNT
+};
+
+#endif /* _LINUX_VIRTIO_RNG_H */
-- 
1.7.8.6

