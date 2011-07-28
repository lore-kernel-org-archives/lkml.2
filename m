Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1G1O3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:29:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45948 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1G1O3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:29:38 -0400
From: Liu Yuan <namei.unix@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] vhost: Enable vhost-blk support
Date: Thu, 28 Jul 2011 22:29:06 +0800
Message-Id: <1311863346-4338-3-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

vhost-blk is an in-kernel accelerator for virtio-blk
device. This patch is the counterpart of the vhost-blk
module in the kernel. It basically does setup of the
vhost-blk, pass on the virtio buffer information via
/dev/vhost-blk.

Useage:
$:qemu -drvie file=path/to/image,if=virtio,aio=native...

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 Makefile.target |    2 +-
 hw/vhost_blk.c  |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 hw/vhost_blk.h  |   44 ++++++++++++++++++++++++++++
 hw/virtio-blk.c |   74 ++++++++++++++++++++++++++++++++++++++----------
 hw/virtio-blk.h |   15 ++++++++++
 hw/virtio-pci.c |   12 ++++++-
 6 files changed, 213 insertions(+), 18 deletions(-)
 create mode 100644 hw/vhost_blk.c
 create mode 100644 hw/vhost_blk.h

diff --git a/Makefile.target b/Makefile.target
index c511010..0f62d7e 100644
--- a/Makefile.target
+++ b/Makefile.target
@@ -198,7 +198,7 @@ obj-y = arch_init.o cpus.o monitor.o machine.o gdbstub.o vl.o balloon.o
 obj-$(CONFIG_NO_PCI) += pci-stub.o
 obj-$(CONFIG_PCI) += pci.o
 obj-$(CONFIG_VIRTIO) += virtio-blk.o virtio-balloon.o virtio-net.o virtio-serial-bus.o
-obj-y += vhost_net.o
+obj-y += vhost_net.o vhost_blk.o
 obj-$(CONFIG_VHOST_NET) += vhost.o
 obj-$(CONFIG_REALLY_VIRTFS) += 9pfs/virtio-9p-device.o
 obj-y += rwhandler.o
diff --git a/hw/vhost_blk.c b/hw/vhost_blk.c
new file mode 100644
index 0000000..31fb11f
--- /dev/null
+++ b/hw/vhost_blk.c
@@ -0,0 +1,84 @@
+#if 1
+#include <linux/vhost.h>
+#include <linux/kvm.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <linux/virtio_ring.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "vhost.h"
+#include "vhost_blk.h"
+
+struct vhost_blk * vhost_blk_init(void)
+{
+	struct vhost_blk *blk = qemu_mallocz(sizeof *blk);
+	int err;
+
+	err = open("/dev/vhost-blk", O_RDWR);
+	if (err < 0)
+		goto err_open;
+	blk->fd = err;
+	err = vhost_dev_init(&blk->dev, err, 1);
+	if (err < 0)
+		goto err_init;
+
+	blk->dev.vqs = blk->vqs;
+	blk->dev.nvqs = blk_vq_max;
+	return blk;
+err_init:
+	close(blk->fd);
+err_open:
+	perror("vhost_blk_init");
+	qemu_free(blk);
+	return NULL;
+}
+
+typedef struct BDRVRawState {
+    int fd;
+    int type;
+    int open_flags;
+#if defined(__linux__)
+    /* linux floppy specific */
+    int64_t fd_open_time;
+    int64_t fd_error_time;
+    int fd_got_error;
+    int fd_media_changed;
+#endif
+#ifdef CONFIG_LINUX_AIO
+    int use_aio;
+    void *aio_ctx;
+#endif
+    uint8_t *aligned_buf;
+    unsigned aligned_buf_size;
+#ifdef CONFIG_XFS
+    bool is_xfs : 1;
+#endif
+} BDRVRawState;
+
+int vhost_blk_start(struct vhost_blk *blk, VirtIODevice *device)
+{
+	VirtIOBlock *iob = (VirtIOBlock *)device;
+	BDRVRawState *raw = iob->bs->file->opaque;
+	struct vhost_vring_file f = {blk_vq_idx, raw->fd};
+	static int i = 0;
+	int ret;
+
+	ret = vhost_dev_start(&blk->dev, device);
+	if (ret < 0)
+		goto err_start;
+
+	ret = ioctl(blk->fd, VHOST_NET_SET_BACKEND, &f);
+	if (ret <0)
+		goto err_ioctl;
+
+	printf("%s: vhost-blk get started successfully (%d)\n", __func__, i++);
+	return ret;
+
+err_ioctl:
+	vhost_dev_stop(&blk->dev, device);
+err_start:
+	return ret;
+}
+#endif
diff --git a/hw/vhost_blk.h b/hw/vhost_blk.h
new file mode 100644
index 0000000..f437af5
--- /dev/null
+++ b/hw/vhost_blk.h
@@ -0,0 +1,44 @@
+#ifndef VHOST_BLK_H
+#define VHOST_BLK_H
+
+#include <errno.h>
+
+#include "virtio-blk.h"
+#include "vhost.h"
+
+enum {
+        blk_vq_idx = 0,
+        blk_vq_max = 1,
+};
+
+struct vhost_blk {
+        struct vhost_dev dev;
+        struct vhost_virtqueue vqs[blk_vq_max];
+	int fd;
+};
+
+# if 1
+extern struct vhost_blk * vhost_blk_init(void);
+extern int vhost_blk_start(struct vhost_blk *blk, VirtIODevice *device);
+static inline struct vhost_blk * to_vhost_blk(VirtIODevice *device)
+{
+	VirtIOBlock * iob = (VirtIOBlock *)device;
+	return iob->vblk;
+}
+# else
+static inline struct vhost_blk * vhost_blk_init(void);
+{
+	return NULL;
+}
+
+static inline int vhost_blk_start(struct vhost_blk *vblk, VirtIODevice *device)
+{
+	return -1;
+}
+
+static inline struct vhost_blk * to_vhost_blk(VirtIODevice *device)
+{
+	return NULL;
+}
+#endif
+#endif /* VHOST_BLK_H */
diff --git a/hw/virtio-blk.c b/hw/virtio-blk.c
index 6471ac8..a5f3a27 100644
--- a/hw/virtio-blk.c
+++ b/hw/virtio-blk.c
@@ -16,23 +16,32 @@
 #include "trace.h"
 #include "blockdev.h"
 #include "virtio-blk.h"
+#include "vhost_blk.h"
 #ifdef __linux__
 # include <scsi/sg.h>
 #endif
 
-typedef struct VirtIOBlock
-{
-    VirtIODevice vdev;
-    BlockDriverState *bs;
-    VirtQueue *vq;
-    void *rq;
-    QEMUBH *bh;
-    BlockConf *conf;
-    char *serial;
-    unsigned short sector_mask;
-    DeviceState *qdev;
-} VirtIOBlock;
-
+typedef struct BDRVRawState {
+    int fd;
+    int type;
+    int open_flags;
+#if defined(__linux__)
+    /* linux floppy specific */
+    int64_t fd_open_time;
+    int64_t fd_error_time;
+    int fd_got_error;
+    int fd_media_changed;
+#endif
+#ifdef CONFIG_LINUX_AIO
+    int use_aio;
+    void *aio_ctx;
+#endif
+    uint8_t *aligned_buf;
+    unsigned aligned_buf_size;
+#ifdef CONFIG_XFS
+    bool is_xfs : 1;
+#endif
+} BDRVRawState;
 static VirtIOBlock *to_virtio_blk(VirtIODevice *vdev)
 {
     return (VirtIOBlock *)vdev;
@@ -436,6 +445,29 @@ static void virtio_blk_dma_restart_cb(void *opaque, int running, int reason)
     }
 }
 
+#include <sys/ioctl.h>
+#include <linux/vhost.h>
+static void vhost_blk_reset(VirtIODevice *device)
+{
+	//int err;
+	struct vhost_blk *vblk = to_vhost_blk(device);
+
+	if (!vblk)
+		return;
+
+	if (!vblk->dev.started)
+		return;
+
+	vhost_dev_stop(&vblk->dev, device);
+	if (!ioctl(vblk->fd, VHOST_RESET_OWNER, NULL) &&
+	   !ioctl(vblk->fd, VHOST_SET_OWNER, NULL))
+		vblk->dev.acked_features = 0;
+	else
+		printf("%s %d fd %d\n", __func__, -errno, vblk->fd);
+
+	return;
+}
+
 static void virtio_blk_reset(VirtIODevice *vdev)
 {
     /*
@@ -443,6 +475,7 @@ static void virtio_blk_reset(VirtIODevice *vdev)
      * are per-device request lists.
      */
     qemu_aio_flush();
+    vhost_blk_reset(vdev);
 }
 
 /* coalesce internal state, copy to pci i/o region 0
@@ -482,20 +515,29 @@ static uint32_t virtio_blk_get_features(VirtIODevice *vdev, uint32_t features)
 
     if (bdrv_enable_write_cache(s->bs))
         features |= (1 << VIRTIO_BLK_F_WCACHE);
-    
+
     if (bdrv_is_read_only(s->bs))
         features |= 1 << VIRTIO_BLK_F_RO;
 
     return features;
 }
 
+static void virtio_blk_set_features(VirtIODevice *vdev, uint32_t val)
+{
+	VirtIOBlock *s = to_virtio_blk(vdev);
+	if (s->vblk) {
+		val &= ~(1 << VIRTIO_BLK_F_WCACHE);
+		s->vblk->dev.acked_features = val;
+	}
+}
+
 static void virtio_blk_save(QEMUFile *f, void *opaque)
 {
     VirtIOBlock *s = opaque;
     VirtIOBlockReq *req = s->rq;
 
     virtio_save(&s->vdev, f);
-    
+
     while (req) {
         qemu_put_sbyte(f, 1);
         qemu_put_buffer(f, (unsigned char*)&req->elem, sizeof(req->elem));
@@ -567,6 +609,7 @@ VirtIODevice *virtio_blk_init(DeviceState *dev, BlockConf *conf,
 
     s->vdev.get_config = virtio_blk_update_config;
     s->vdev.get_features = virtio_blk_get_features;
+    s->vdev.set_features = virtio_blk_set_features;
     s->vdev.reset = virtio_blk_reset;
     s->bs = conf->bs;
     s->conf = conf;
@@ -587,6 +630,7 @@ VirtIODevice *virtio_blk_init(DeviceState *dev, BlockConf *conf,
 
     add_boot_device_path(conf->bootindex, dev, "/disk@0,0");
 
+    s->vblk = vhost_blk_init();
     return &s->vdev;
 }
 
diff --git a/hw/virtio-blk.h b/hw/virtio-blk.h
index 5645d2b..cdaa0ef 100644
--- a/hw/virtio-blk.h
+++ b/hw/virtio-blk.h
@@ -16,6 +16,7 @@
 
 #include "virtio.h"
 #include "block.h"
+#include "blockdev.h"
 
 /* from Linux's linux/virtio_blk.h */
 
@@ -97,6 +98,20 @@ struct virtio_scsi_inhdr
     uint32_t residual;
 };
 
+typedef struct VirtIOBlock
+{
+    VirtIODevice vdev;
+    BlockDriverState *bs;
+    VirtQueue *vq;
+    void *rq;
+    QEMUBH *bh;
+    BlockConf *conf;
+    char *serial;
+    unsigned short sector_mask;
+    DeviceState *qdev;
+    struct vhost_blk *vblk;
+} VirtIOBlock;
+
 #ifdef __linux__
 #define DEFINE_VIRTIO_BLK_FEATURES(_state, _field) \
         DEFINE_VIRTIO_COMMON_FEATURES(_state, _field), \
diff --git a/hw/virtio-pci.c b/hw/virtio-pci.c
index c5bfb62..f653014 100644
--- a/hw/virtio-pci.c
+++ b/hw/virtio-pci.c
@@ -27,6 +27,8 @@
 #include "kvm.h"
 #include "blockdev.h"
 #include "virtio-pci.h"
+#include "vhost_blk.h"
+#include "vhost.h"
 
 /* from Linux's linux/virtio_pci.h */
 
@@ -162,6 +164,7 @@ static int virtio_pci_set_host_notifier_internal(VirtIOPCIProxy *proxy,
     VirtQueue *vq = virtio_get_queue(proxy->vdev, n);
     EventNotifier *notifier = virtio_queue_get_host_notifier(vq);
     int r;
+
     if (assign) {
         r = event_notifier_init(notifier, 1);
         if (r < 0) {
@@ -190,7 +193,7 @@ static int virtio_pci_set_host_notifier_internal(VirtIOPCIProxy *proxy,
         /* Handle the race condition where the guest kicked and we deassigned
          * before we got around to handling the kick.
          */
-        if (event_notifier_test_and_clear(notifier)) {
+        if (proxy->ioeventfd_started && event_notifier_test_and_clear(notifier)) {
             virtio_queue_notify_vq(vq);
         }
 
@@ -337,7 +340,12 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
         virtio_set_status(vdev, val & 0xFF);
 
         if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
-            virtio_pci_start_ioeventfd(proxy);
+	    struct vhost_blk *vblk = to_vhost_blk(vdev);
+	    if (vblk) {
+		    if (!vblk->dev.started)
+			vhost_blk_start(to_vhost_blk(vdev), vdev);
+	    } else
+		    virtio_pci_start_ioeventfd(proxy);
         }
 
         if (vdev->status == 0) {
-- 
1.7.5.1

