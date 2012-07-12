Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab2GLPns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947Ab2GLPnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:43:46 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>
Subject: [PATCH 3/5] vhost: Make vhost a separate module
Date: Thu, 12 Jul 2012 23:45:29 +0800
Message-Id: <1342107931-28476-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, vhost-net is the only consumer of vhost infrastructure. So
vhost infrastructure and vhost-net driver are in a single module.

Separating this as a vhost.ko module and a vhost-net.ko module makes it
is easier to share code with other vhost drivers, e.g. vhost-blk.ko,
tcm-vhost.ko.

Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/vhost/Kconfig  |   10 +++++++++-
 drivers/vhost/Makefile |    4 +++-
 drivers/vhost/vhost.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h  |    1 +
 4 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index e4e2fd1..c387067 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,6 +1,14 @@
+config VHOST
+	tristate "Host kernel accelerator for virtio (EXPERIMENTAL)"
+	---help---
+	  This kernel module can be loaded in host kernel to accelerate
+	  guest networking and block.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called vhost_net.
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
-	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
+	depends on VHOST && NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index 72dd020..cd36885 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -1,2 +1,4 @@
+obj-$(CONFIG_VHOST)	+= vhost.o
 obj-$(CONFIG_VHOST_NET) += vhost_net.o
-vhost_net-y := vhost.o net.o
+
+vhost_net-y		:= net.o
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 112156f..6e9f586 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/cgroup.h>
+#include <linux/module.h>
 
 #include <linux/net.h>
 #include <linux/if_packet.h>
@@ -84,6 +85,7 @@ void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 
 	vhost_work_init(&poll->work, fn);
 }
+EXPORT_SYMBOL_GPL(vhost_poll_init);
 
 /* Start polling a file. We add ourselves to file's wait queue. The caller must
  * keep a reference to a file until after vhost_poll_stop is called. */
@@ -95,6 +97,7 @@ void vhost_poll_start(struct vhost_poll *poll, struct file *file)
 	if (mask)
 		vhost_poll_wakeup(&poll->wait, 0, 0, (void *)mask);
 }
+EXPORT_SYMBOL_GPL(vhost_poll_start);
 
 /* Stop polling a file. After this function returns, it becomes safe to drop the
  * file reference. You must also flush afterwards. */
@@ -102,6 +105,7 @@ void vhost_poll_stop(struct vhost_poll *poll)
 {
 	remove_wait_queue(poll->wqh, &poll->wait);
 }
+EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
 static bool vhost_work_seq_done(struct vhost_dev *dev, struct vhost_work *work,
 				unsigned seq)
@@ -136,6 +140,7 @@ void vhost_poll_flush(struct vhost_poll *poll)
 {
 	vhost_work_flush(poll->dev, &poll->work);
 }
+EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
 static inline void vhost_work_queue(struct vhost_dev *dev,
 				    struct vhost_work *work)
@@ -155,6 +160,7 @@ void vhost_poll_queue(struct vhost_poll *poll)
 {
 	vhost_work_queue(poll->dev, &poll->work);
 }
+EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
@@ -251,6 +257,7 @@ void vhost_enable_zcopy(int vq)
 {
 	vhost_zcopy_mask |= 0x1 << vq;
 }
+EXPORT_SYMBOL_GPL(vhost_enable_zcopy);
 
 /* Helper to allocate iovec buffers for all vqs. */
 static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
@@ -322,6 +329,7 @@ long vhost_dev_init(struct vhost_dev *dev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_dev_init);
 
 /* Caller should have device mutex */
 long vhost_dev_check_owner(struct vhost_dev *dev)
@@ -329,6 +337,7 @@ long vhost_dev_check_owner(struct vhost_dev *dev)
 	/* Are you the owner? If not, I don't think you mean to do that */
 	return dev->mm == current->mm ? 0 : -EPERM;
 }
+EXPORT_SYMBOL_GPL(vhost_dev_check_owner);
 
 struct vhost_attach_cgroups_struct {
 	struct vhost_work work;
@@ -414,6 +423,7 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
 	RCU_INIT_POINTER(dev->memory, memory);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);
 
 /* In case of DMA done not in order in lower device driver for some reason.
  * upend_idx is used to track end of used idx, done_idx is used to track head
@@ -438,6 +448,7 @@ int vhost_zerocopy_signal_used(struct vhost_virtqueue *vq)
 		vq->done_idx = i;
 	return j;
 }
+EXPORT_SYMBOL_GPL(vhost_zerocopy_signal_used);
 
 /* Caller should have device mutex if and only if locked is set */
 void vhost_dev_cleanup(struct vhost_dev *dev, bool locked)
@@ -489,6 +500,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev, bool locked)
 		mmput(dev->mm);
 	dev->mm = NULL;
 }
+EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
 
 static int log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
 {
@@ -574,6 +586,7 @@ int vhost_log_access_ok(struct vhost_dev *dev)
 				       lockdep_is_held(&dev->mutex));
 	return memory_access_ok(dev, mp, 1);
 }
+EXPORT_SYMBOL_GPL(vhost_log_access_ok);
 
 /* Verify access for write logging. */
 /* Caller should have vq mutex and device mutex */
@@ -599,6 +612,7 @@ int vhost_vq_access_ok(struct vhost_virtqueue *vq)
 	return vq_access_ok(vq->dev, vq->num, vq->desc, vq->avail, vq->used) &&
 		vq_log_access_ok(vq->dev, vq, vq->log_base);
 }
+EXPORT_SYMBOL_GPL(vhost_vq_access_ok);
 
 static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 {
@@ -909,6 +923,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, unsigned long arg)
 done:
 	return r;
 }
+EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
 
 static const struct vhost_memory_region *find_region(struct vhost_memory *mem,
 						     __u64 addr, __u32 len)
@@ -1000,6 +1015,7 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 	BUG();
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_log_write);
 
 static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 {
@@ -1051,6 +1067,7 @@ int vhost_init_used(struct vhost_virtqueue *vq)
 	vq->signalled_used_valid = false;
 	return get_user(vq->last_used_idx, &vq->used->idx);
 }
+EXPORT_SYMBOL_GPL(vhost_init_used);
 
 static int translate_desc(struct vhost_dev *dev, u64 addr, u32 len,
 			  struct iovec iov[], int iov_size)
@@ -1327,12 +1344,14 @@ int vhost_get_vq_desc(struct vhost_dev *dev, struct vhost_virtqueue *vq,
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 	return head;
 }
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
 	vq->last_avail_idx -= n;
 }
+EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
@@ -1381,6 +1400,7 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 		vq->signalled_used_valid = false;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_add_used);
 
 static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    struct vring_used_elem *heads,
@@ -1450,6 +1470,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	return r;
 }
+EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
 static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
@@ -1494,6 +1515,7 @@ void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	if (vq->call_ctx && vhost_notify(dev, vq))
 		eventfd_signal(vq->call_ctx, 1);
 }
+EXPORT_SYMBOL_GPL(vhost_signal);
 
 /* And here's the combo meal deal.  Supersize me! */
 void vhost_add_used_and_signal(struct vhost_dev *dev,
@@ -1503,6 +1525,7 @@ void vhost_add_used_and_signal(struct vhost_dev *dev,
 	vhost_add_used(vq, head, len);
 	vhost_signal(dev, vq);
 }
+EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
 
 /* multi-buffer version of vhost_add_used_and_signal */
 void vhost_add_used_and_signal_n(struct vhost_dev *dev,
@@ -1512,6 +1535,7 @@ void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 	vhost_add_used_n(vq, heads, count);
 	vhost_signal(dev, vq);
 }
+EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
 
 /* OK, now we need to know about added descriptors. */
 bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
@@ -1549,6 +1573,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 
 	return avail_idx != vq->avail_idx;
 }
+EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
 /* We don't need to be notified again. */
 void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
@@ -1565,6 +1590,7 @@ void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 			       &vq->used->flags, r);
 	}
 }
+EXPORT_SYMBOL_GPL(vhost_disable_notify);
 
 static void vhost_zerocopy_done_signal(struct kref *kref)
 {
@@ -1588,11 +1614,13 @@ struct vhost_ubuf_ref *vhost_ubuf_alloc(struct vhost_virtqueue *vq,
 	ubufs->vq = vq;
 	return ubufs;
 }
+EXPORT_SYMBOL_GPL(vhost_ubuf_alloc);
 
 void vhost_ubuf_put(struct vhost_ubuf_ref *ubufs)
 {
 	kref_put(&ubufs->kref, vhost_zerocopy_done_signal);
 }
+EXPORT_SYMBOL_GPL(vhost_ubuf_put);
 
 void vhost_ubuf_put_and_wait(struct vhost_ubuf_ref *ubufs)
 {
@@ -1600,6 +1628,7 @@ void vhost_ubuf_put_and_wait(struct vhost_ubuf_ref *ubufs)
 	wait_event(ubufs->wait, !atomic_read(&ubufs->kref.refcount));
 	kfree(ubufs);
 }
+EXPORT_SYMBOL_GPL(vhost_ubuf_put_and_wait);
 
 void vhost_zerocopy_callback(struct ubuf_info *ubuf)
 {
@@ -1611,3 +1640,22 @@ void vhost_zerocopy_callback(struct ubuf_info *ubuf)
 	vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 	kref_put(&ubufs->kref, vhost_zerocopy_done_signal);
 }
+EXPORT_SYMBOL_GPL(vhost_zerocopy_callback);
+
+static int __init vhost_init(void)
+{
+	return 0;
+}
+
+static void __exit vhost_exit(void)
+{
+	return;
+}
+
+module_init(vhost_init);
+module_exit(vhost_exit);
+
+MODULE_VERSION("0.0.1");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Michael S. Tsirkin");
+MODULE_DESCRIPTION("Host kernel accelerator for virtio");
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8de1fd5..c5c7fb0 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -12,6 +12,7 @@
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
 #include <linux/atomic.h>
+#include <linux/virtio_net.h>
 
 /* This is for zerocopy, used buffer len is set to 1 when lower device DMA
  * done */
-- 
1.7.10.4

