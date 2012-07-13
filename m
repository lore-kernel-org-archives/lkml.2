Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2GMIyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab2GMIy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:54:29 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
Date: Fri, 13 Jul 2012 16:55:11 +0800
Message-Id: <1342169711-12386-6-git-send-email-asias@redhat.com>
In-Reply-To: <1342169711-12386-1-git-send-email-asias@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost-blk is a in kernel virito-blk device accelerator.

This patch is based on Liu Yuan's implementation with various
improvements and bug fixes. Notably, this patch makes guest notify and
host completion processing in parallel which gives about 60% performance
improvement compared to Liu Yuan's implementation.

Performance evaluation:
-----------------------------
The comparison is between kvm tool with usersapce implementation and kvm
tool with vhost-blk.

1) Fio with libaio ioengine on Fusion IO device
With bio-based IO path, sequential read/write, random read/write
IOPS boost         : 8.4%, 15.3%, 10.4%, 14.6%
Latency improvement: 8.5%, 15.4%, 10.4%, 15.1%

2) Fio with vsync ioengine on Fusion IO device
With bio-based IO path, sequential read/write, random read/write
IOPS boost         : 10.5%, 4.8%, 5.2%, 5.6%
Latency improvement: 11.4%, 5.0%, 5.2%, 5.8%

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/vhost/Kconfig  |   10 +
 drivers/vhost/Makefile |    2 +
 drivers/vhost/blk.c    |  600 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h  |    5 +
 include/linux/vhost.h  |    3 +
 5 files changed, 620 insertions(+)
 create mode 100644 drivers/vhost/blk.c

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index c387067..fa071a8 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -16,4 +16,14 @@ config VHOST_NET
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called vhost_net.
+config VHOST_BLK
+	tristate "Host kernel accelerator for virtio blk (EXPERIMENTAL)"
+	depends on VHOST && BLOCK && AIO && EVENTFD && EXPERIMENTAL
+	---help---
+	  This kernel module can be loaded in host kernel to accelerate
+	  guest block with virtio_blk. Not to be confused with virtio_blk
+	  module itself which needs to be loaded in guest kernel.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called vhost_blk.
 
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index cd36885..aa461d5 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -1,4 +1,6 @@
 obj-$(CONFIG_VHOST)	+= vhost.o
 obj-$(CONFIG_VHOST_NET) += vhost_net.o
+obj-$(CONFIG_VHOST_BLK) += vhost_blk.o
 
 vhost_net-y		:= net.o
+vhost_blk-y		:= blk.o
diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
new file mode 100644
index 0000000..6a94894
--- /dev/null
+++ b/drivers/vhost/blk.c
@@ -0,0 +1,600 @@
+/*
+ * Copyright (C) 2011 Taobao, Inc.
+ * Author: Liu Yuan <tailai.ly@taobao.com>
+ *
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Author: Asias He <asias@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * virtio-blk server in host kernel.
+ */
+
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/vhost.h>
+#include <linux/virtio_blk.h>
+#include <linux/eventfd.h>
+#include <linux/mutex.h>
+#include <linux/file.h>
+#include <linux/mmu_context.h>
+#include <linux/anon_inodes.h>
+#include <linux/kthread.h>
+#include <linux/blkdev.h>
+
+#include "vhost.h"
+
+#define BLK_HDR	0
+
+enum {
+	VHOST_BLK_VQ_REQ = 0,
+	VHOST_BLK_VQ_MAX = 1,
+};
+
+struct vhost_blk_req {
+	u16 head;
+	u8 *status;
+};
+
+struct vhost_blk {
+	struct task_struct *worker_host_kick;
+	struct task_struct *worker;
+	struct vhost_blk_req *reqs;
+	struct vhost_virtqueue vq;
+	struct eventfd_ctx *ectx;
+	struct io_event *ioevent;
+	struct kioctx *ioctx;
+	struct vhost_dev dev;
+	struct file *efile;
+	u64 ioevent_nr;
+	bool stop;
+};
+
+static inline int vhost_blk_read_events(struct vhost_blk *blk, long nr)
+{
+	mm_segment_t old_fs = get_fs();
+	int ret;
+
+	set_fs(KERNEL_DS);
+	ret = read_events(blk->ioctx, nr, nr, blk->ioevent, NULL);
+	set_fs(old_fs);
+
+	return ret;
+}
+
+static int vhost_blk_setup(struct vhost_blk *blk)
+{
+	struct kioctx *ctx;
+
+	if (blk->ioctx)
+		return 0;
+
+	blk->ioevent_nr = blk->vq.num;
+	ctx = ioctx_alloc(blk->ioevent_nr);
+	if (IS_ERR(ctx)) {
+		pr_err("Failed to ioctx_alloc");
+		return PTR_ERR(ctx);
+	}
+	put_ioctx(ctx);
+	blk->ioctx = ctx;
+
+	blk->ioevent = kmalloc(sizeof(struct io_event) * blk->ioevent_nr,
+			       GFP_KERNEL);
+	if (!blk->ioevent) {
+		pr_err("Failed to allocate memory for io_events");
+		return -ENOMEM;
+	}
+
+	blk->reqs = kmalloc(sizeof(struct vhost_blk_req) * blk->ioevent_nr,
+			    GFP_KERNEL);
+	if (!blk->reqs) {
+		pr_err("Failed to allocate memory for vhost_blk_req");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static inline int vhost_blk_set_status(struct vhost_blk *blk, u8 *statusp,
+				       u8 status)
+{
+	if (copy_to_user(statusp, &status, sizeof(status))) {
+		vq_err(&blk->vq, "Failed to write status\n");
+		vhost_discard_vq_desc(&blk->vq, 1);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static void vhost_blk_enable_vq(struct vhost_blk *blk,
+				struct vhost_virtqueue *vq)
+{
+	wake_up_process(blk->worker_host_kick);
+}
+
+static int vhost_blk_io_submit(struct vhost_blk *blk, struct file *file,
+			       struct vhost_blk_req *req,
+			       struct iovec *iov, u64 nr_vecs, loff_t offset,
+			       int opcode)
+{
+	struct kioctx *ioctx = blk->ioctx;
+	mm_segment_t oldfs = get_fs();
+	struct kiocb_batch batch;
+	struct blk_plug plug;
+	struct kiocb *iocb;
+	int ret;
+
+	if (!try_get_ioctx(ioctx)) {
+		pr_info("Failed to get ioctx");
+		return -EAGAIN;
+	}
+
+	atomic_long_inc_not_zero(&file->f_count);
+	eventfd_ctx_get(blk->ectx);
+
+	/* TODO: batch to 1 is not good! */
+	kiocb_batch_init(&batch, 1);
+	blk_start_plug(&plug);
+
+	iocb = aio_get_req(ioctx, &batch);
+	if (unlikely(!iocb)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	iocb->ki_filp	= file;
+	iocb->ki_pos	= offset;
+	iocb->ki_buf	= (void *)iov;
+	iocb->ki_left	= nr_vecs;
+	iocb->ki_nbytes	= nr_vecs;
+	iocb->ki_opcode	= opcode;
+	iocb->ki_obj.user = req;
+	iocb->ki_eventfd  = blk->ectx;
+
+	set_fs(KERNEL_DS);
+	ret = aio_setup_iocb(iocb, false);
+	set_fs(oldfs);
+	if (unlikely(ret))
+		goto out_put_iocb;
+
+	spin_lock_irq(&ioctx->ctx_lock);
+	if (unlikely(ioctx->dead)) {
+		spin_unlock_irq(&ioctx->ctx_lock);
+		ret = -EINVAL;
+		goto out_put_iocb;
+	}
+	aio_run_iocb(iocb);
+	spin_unlock_irq(&ioctx->ctx_lock);
+
+	aio_put_req(iocb);
+
+	blk_finish_plug(&plug);
+	kiocb_batch_free(ioctx, &batch);
+	put_ioctx(ioctx);
+
+	return ret;
+out_put_iocb:
+	aio_put_req(iocb); /* Drop extra ref to req */
+	aio_put_req(iocb); /* Drop I/O ref to req */
+out:
+	put_ioctx(ioctx);
+	return ret;
+}
+
+static void vhost_blk_flush(struct vhost_blk *blk)
+{
+	vhost_poll_flush(&blk->vq.poll);
+}
+
+static struct file *vhost_blk_stop_vq(struct vhost_blk *blk,
+				      struct vhost_virtqueue *vq)
+{
+	struct file *file;
+
+	mutex_lock(&vq->mutex);
+	file = rcu_dereference_protected(vq->private_data,
+			lockdep_is_held(&vq->mutex));
+	rcu_assign_pointer(vq->private_data, NULL);
+	mutex_unlock(&vq->mutex);
+
+	return file;
+
+}
+
+static inline void vhost_blk_stop(struct vhost_blk *blk, struct file **file)
+{
+
+	*file = vhost_blk_stop_vq(blk, &blk->vq);
+}
+
+/* Handle guest request */
+static int vhost_blk_do_req(struct vhost_virtqueue *vq,
+			    struct virtio_blk_outhdr *hdr,
+			    u16 head, u16 out, u16 in,
+			    struct file *file)
+{
+	struct vhost_blk *blk = container_of(vq->dev, struct vhost_blk, dev);
+	struct iovec *iov = &vq->iov[BLK_HDR + 1];
+	loff_t offset = hdr->sector << 9;
+	struct vhost_blk_req *req;
+	u64 nr_vecs;
+	int ret = 0;
+	u8 status;
+
+	if (hdr->type == VIRTIO_BLK_T_IN || hdr->type == VIRTIO_BLK_T_GET_ID)
+		nr_vecs = in - 1;
+	else
+		nr_vecs = out - 1;
+
+	req		= &blk->reqs[head];
+	req->head	= head;
+	req->status	= blk->vq.iov[nr_vecs + 1].iov_base;
+
+	switch (hdr->type) {
+	case VIRTIO_BLK_T_OUT:
+		ret = vhost_blk_io_submit(blk, file, req, iov, nr_vecs, offset,
+					  IOCB_CMD_PWRITEV);
+		break;
+	case VIRTIO_BLK_T_IN:
+		ret = vhost_blk_io_submit(blk, file, req, iov, nr_vecs, offset,
+					  IOCB_CMD_PREADV);
+		break;
+	case VIRTIO_BLK_T_FLUSH:
+		ret = vfs_fsync(file, 1);
+		status = ret < 0 ? VIRTIO_BLK_S_IOERR : VIRTIO_BLK_S_OK;
+		ret = vhost_blk_set_status(blk, req->status, status);
+		if (!ret)
+			vhost_add_used_and_signal(&blk->dev, vq, head, ret);
+		break;
+	case VIRTIO_BLK_T_GET_ID:
+		/* TODO: need a real ID string */
+		ret = snprintf(vq->iov[BLK_HDR + 1].iov_base,
+			       VIRTIO_BLK_ID_BYTES, "VHOST-BLK-DISK");
+		status = ret < 0 ? VIRTIO_BLK_S_IOERR : VIRTIO_BLK_S_OK;
+		ret = vhost_blk_set_status(blk, req->status, status);
+		if (!ret)
+			vhost_add_used_and_signal(&blk->dev, vq, head,
+						  VIRTIO_BLK_ID_BYTES);
+		break;
+	default:
+		pr_warn("Unsupported request type %d\n", hdr->type);
+		vhost_discard_vq_desc(vq, 1);
+		ret = -EFAULT;
+		break;
+	}
+
+	return ret;
+}
+
+/* Guest kick us for IO request */
+static void vhost_blk_handle_guest_kick(struct vhost_work *work)
+{
+	struct virtio_blk_outhdr hdr;
+	struct vhost_virtqueue *vq;
+	struct vhost_blk *blk;
+	struct file *f;
+	int in, out;
+	u16 head;
+
+	vq = container_of(work, struct vhost_virtqueue, poll.work);
+	blk = container_of(vq->dev, struct vhost_blk, dev);
+
+	/* TODO: check that we are running from vhost_worker? */
+	f = rcu_dereference_check(vq->private_data, 1);
+	if (!f)
+		return;
+
+	vhost_disable_notify(&blk->dev, vq);
+	for (;;) {
+		head = vhost_get_vq_desc(&blk->dev, vq, vq->iov,
+					 ARRAY_SIZE(vq->iov),
+					 &out, &in, NULL, NULL);
+		if (unlikely(head < 0))
+			break;
+
+		if (unlikely(head == vq->num)) {
+			if (unlikely(vhost_enable_notify(&blk->dev, vq))) {
+				vhost_disable_notify(&blk->dev, vq);
+				continue;
+			}
+			break;
+		}
+
+		if (unlikely(vq->iov[BLK_HDR].iov_len != sizeof(hdr))) {
+			vq_err(vq, "Bad block header lengh!\n");
+			vhost_discard_vq_desc(vq, 1);
+			break;
+		}
+
+		if (unlikely(copy_from_user(&hdr, vq->iov[BLK_HDR].iov_base,
+					    sizeof(hdr)))) {
+			vq_err(vq, "Failed to get block header!\n");
+			vhost_discard_vq_desc(vq, 1);
+			break;
+		}
+
+
+		if (unlikely(vhost_blk_do_req(vq, &hdr, head, out, in, f) < 0))
+			break;
+	}
+}
+
+/* Complete the IO request */
+static int vhost_blk_host_kick_thread(void *data)
+{
+	mm_segment_t oldfs = get_fs();
+	struct vhost_blk *blk = data;
+	struct vhost_virtqueue *vq;
+	struct vhost_blk_req *req;
+	struct io_event *e;
+	int ret, i, len;
+	u64 count, nr;
+	u8 status;
+
+	vq = &blk->vq;
+	set_fs(USER_DS);
+	use_mm(blk->dev.mm);
+	for (;;) {
+		do {
+			ret = eventfd_ctx_read(blk->ectx, 0, &count);
+			if (unlikely(kthread_should_stop() || blk->stop))
+				goto out;
+		} while (ret != 0);
+
+		do {
+			nr = vhost_blk_read_events(blk,
+						   min(count, blk->ioevent_nr));
+			if (unlikely(nr <= 0))
+				continue;
+			count -= nr;
+
+			for (i = 0; i < nr; i++) {
+				e = &blk->ioevent[i];
+				req = (void *)e->obj;
+				len = e->res;
+				status = len > 0 ? VIRTIO_BLK_S_OK :
+						   VIRTIO_BLK_S_IOERR;
+				ret = copy_to_user(req->status, &status,
+						   sizeof(status));
+				if (unlikely(ret)) {
+					vq_err(&blk->vq,
+					       "Failed to write status\n");
+					continue;
+				}
+				vhost_add_used(&blk->vq, req->head, len);
+			}
+			vhost_signal(&blk->dev, &blk->vq);
+		} while (count > 0);
+	}
+
+out:
+	unuse_mm(blk->dev.mm);
+	set_fs(oldfs);
+	return 0;
+}
+
+static int vhost_blk_open(struct inode *inode, struct file *file)
+{
+	struct vhost_blk *blk;
+	int ret;
+
+	blk = kzalloc(sizeof(*blk), GFP_KERNEL);
+	if (!blk) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	blk->vq.handle_kick = vhost_blk_handle_guest_kick;
+
+	ret = vhost_dev_init(&blk->dev, &blk->vq, VHOST_BLK_VQ_MAX);
+	if (ret < 0)
+		goto out_dev;
+	/*
+	 * Create an eventfd which is used by aio code to
+	 * notify guest when request is completed.
+	 */
+	blk->efile = eventfd_file_create(0, 0);
+	if (IS_ERR(blk->efile))
+		goto out_dev;
+	blk->ectx = eventfd_ctx_fileget(blk->efile);
+	if (IS_ERR(blk->ectx))
+		goto out_dev;
+
+	file->private_data = blk;
+
+	blk->worker_host_kick = kthread_create(vhost_blk_host_kick_thread,
+			blk, "vhost-blk-%d", current->pid);
+	if (IS_ERR(blk->worker_host_kick)) {
+		ret = PTR_ERR(blk->worker_host_kick);
+		goto out_dev;
+	}
+
+	return ret;
+out_dev:
+	kfree(blk);
+out:
+	return ret;
+}
+
+static int vhost_blk_release(struct inode *inode, struct file *f)
+{
+	struct vhost_blk *blk = f->private_data;
+	struct file *file;
+
+	vhost_blk_stop(blk, &file);
+	vhost_blk_flush(blk);
+	vhost_dev_cleanup(&blk->dev, false);
+	if (file)
+		fput(file);
+
+	blk->stop = true;
+	eventfd_signal(blk->ectx, 1);
+	kthread_stop(blk->worker_host_kick);
+
+	eventfd_ctx_put(blk->ectx);
+	if (blk->efile)
+		fput(blk->efile);
+
+	kfree(blk->ioevent);
+	kfree(blk->reqs);
+	kfree(blk);
+
+	return 0;
+}
+
+static int vhost_blk_set_features(struct vhost_blk *blk, u64 features)
+{
+	mutex_lock(&blk->dev.mutex);
+	blk->dev.acked_features = features;
+	mutex_unlock(&blk->dev.mutex);
+
+	return 0;
+}
+
+static long vhost_blk_set_backend(struct vhost_blk *blk, unsigned index, int fd)
+{
+	struct vhost_virtqueue *vq = &blk->vq;
+	struct file *file, *oldfile;
+	int ret;
+
+	mutex_lock(&blk->dev.mutex);
+	ret = vhost_dev_check_owner(&blk->dev);
+	if (ret)
+		goto out_dev;
+
+	if (index >= VHOST_BLK_VQ_MAX) {
+		ret = -ENOBUFS;
+		goto out_dev;
+	}
+
+	mutex_lock(&vq->mutex);
+
+	if (!vhost_vq_access_ok(vq)) {
+		ret = -EFAULT;
+		goto out_vq;
+	}
+
+	file = fget(fd);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out_vq;
+	}
+
+	oldfile = rcu_dereference_protected(vq->private_data,
+			lockdep_is_held(&vq->mutex));
+	if (file != oldfile) {
+		rcu_assign_pointer(vq->private_data, file);
+		vhost_blk_enable_vq(blk, vq);
+
+		ret = vhost_init_used(vq);
+		if (ret)
+			goto out_vq;
+	}
+
+	mutex_unlock(&vq->mutex);
+
+	if (oldfile) {
+		vhost_blk_flush(blk);
+		fput(oldfile);
+	}
+
+	mutex_unlock(&blk->dev.mutex);
+	return 0;
+
+out_vq:
+	mutex_unlock(&vq->mutex);
+out_dev:
+	mutex_unlock(&blk->dev.mutex);
+	return ret;
+}
+
+static long vhost_blk_reset_owner(struct vhost_blk *blk)
+{
+	struct file *file = NULL;
+	int err;
+
+	mutex_lock(&blk->dev.mutex);
+	err = vhost_dev_check_owner(&blk->dev);
+	if (err)
+		goto done;
+	vhost_blk_stop(blk, &file);
+	vhost_blk_flush(blk);
+	err = vhost_dev_reset_owner(&blk->dev);
+done:
+	mutex_unlock(&blk->dev.mutex);
+	if (file)
+		fput(file);
+	return err;
+}
+
+static long vhost_blk_ioctl(struct file *f, unsigned int ioctl,
+			    unsigned long arg)
+{
+	struct vhost_blk *blk = f->private_data;
+	void __user *argp = (void __user *)arg;
+	struct vhost_vring_file backend;
+	u64 __user *featurep = argp;
+	u64 features;
+	int ret;
+
+	switch (ioctl) {
+	case VHOST_BLK_SET_BACKEND:
+		if (copy_from_user(&backend, argp, sizeof backend))
+			return -EFAULT;
+		return vhost_blk_set_backend(blk, backend.index, backend.fd);
+	case VHOST_GET_FEATURES:
+		features = VHOST_BLK_FEATURES;
+		if (copy_to_user(featurep, &features, sizeof features))
+			return -EFAULT;
+		return 0;
+	case VHOST_SET_FEATURES:
+		if (copy_from_user(&features, featurep, sizeof features))
+			return -EFAULT;
+		if (features & ~VHOST_BLK_FEATURES)
+			return -EOPNOTSUPP;
+		return vhost_blk_set_features(blk, features);
+	case VHOST_RESET_OWNER:
+		return vhost_blk_reset_owner(blk);
+	default:
+		mutex_lock(&blk->dev.mutex);
+		ret = vhost_dev_ioctl(&blk->dev, ioctl, arg);
+		if (!ret && ioctl == VHOST_SET_VRING_NUM)
+			ret = vhost_blk_setup(blk);
+		vhost_blk_flush(blk);
+		mutex_unlock(&blk->dev.mutex);
+		return ret;
+	}
+}
+
+static const struct file_operations vhost_blk_fops = {
+	.owner          = THIS_MODULE,
+	.open           = vhost_blk_open,
+	.release        = vhost_blk_release,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl = vhost_blk_ioctl,
+};
+
+static struct miscdevice vhost_blk_misc = {
+	MISC_DYNAMIC_MINOR,
+	"vhost-blk",
+	&vhost_blk_fops,
+};
+
+int vhost_blk_init(void)
+{
+	return misc_register(&vhost_blk_misc);
+}
+
+void vhost_blk_exit(void)
+{
+	misc_deregister(&vhost_blk_misc);
+}
+
+module_init(vhost_blk_init);
+module_exit(vhost_blk_exit);
+
+MODULE_VERSION("0.0.2");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Asias He");
+MODULE_DESCRIPTION("Host kernel accelerator for virtio_blk");
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index cc046a9..1d4db7b 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -205,6 +205,11 @@ enum {
 				(1ULL << VHOST_F_LOG_ALL) |
 				(1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 				(1ULL << VIRTIO_NET_F_MRG_RXBUF),
+
+	VHOST_BLK_FEATURES =	(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
+				(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
+				(1ULL << VIRTIO_RING_F_EVENT_IDX) |
+				(1ULL << VHOST_F_LOG_ALL),
 };
 
 static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
diff --git a/include/linux/vhost.h b/include/linux/vhost.h
index e847f1e..5869728 100644
--- a/include/linux/vhost.h
+++ b/include/linux/vhost.h
@@ -121,6 +121,9 @@ struct vhost_memory {
  * device.  This can be used to stop the ring (e.g. for migration). */
 #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vring_file)
 
+/* VHOST_BLK specific defines */
+#define VHOST_BLK_SET_BACKEND _IOW(VHOST_VIRTIO, 0x40, struct vhost_vring_file)
+
 /* Feature bits */
 /* Log all write descriptors. Can be changed while device is active. */
 #define VHOST_F_LOG_ALL 26
-- 
1.7.10.4

