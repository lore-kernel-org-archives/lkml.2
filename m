Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab0KPMfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:35:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab0KPMfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:35:16 -0500
Date: Tue, 16 Nov 2010 14:34:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] tools/virtio: virtio_ring testing tool
Message-ID: <20101116123455.GA22446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a virtio simulator:
- adds stubs for enough support functions to compile
  virtio ring in userspace.
- Adds a stub vhost based module this can talk to.

This should help us decide things like which ring layout
works best.

Communication is currently done using an eventfd descriptor.
This means there's a shared spinlock there: what I would like to do
in the future, is run this under kvm and use interrupt injection and
io for communication, to make it more real-life and avoid lock
contention.

This patchset applies on top of vhost-net-next branch in my tree.
In particular you must have commits:
commit 64e1c80748afca3b4818ebb232a9668bf529886d
    vhost-net: batch use/unuse mm
commit 533a19b4b88fcf81da3106b94f0ac4ac8b33a248
    vhost: put mm after thread stop

I still haven't decided whether tools/virtio is a good place for this
code. In particular I think it might make sense to move
at least the stub vhost_null module to drivers/vhost.
For development, it was nice to have everything under a single
directory, though. Maybe move userspace somewhere there too?

I think it's probably best to keep this part of kernel tree,
to avoid version skew and so we don't need to commit to
any kind of API.
Comments?

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/Makefile            |   11 ++
 tools/virtio/linux/device.h      |    2 +
 tools/virtio/linux/slab.h        |    2 +
 tools/virtio/linux/virtio.h      |  223 ++++++++++++++++++++++++++
 tools/virtio/vhost_null/Makefile |    3 +
 tools/virtio/vhost_null/null.c   |  320 ++++++++++++++++++++++++++++++++++++++
 tools/virtio/vhost_null/null.h   |    7 +
 tools/virtio/virtio_test.c       |  198 +++++++++++++++++++++++
 8 files changed, 766 insertions(+), 0 deletions(-)
 create mode 100644 tools/virtio/Makefile
 create mode 100644 tools/virtio/linux/device.h
 create mode 100644 tools/virtio/linux/slab.h
 create mode 100644 tools/virtio/linux/virtio.h
 create mode 100644 tools/virtio/vhost_null/Makefile
 create mode 100644 tools/virtio/vhost_null/null.c
 create mode 100644 tools/virtio/vhost_null/null.h
 create mode 100644 tools/virtio/virtio_test.c

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
new file mode 100644
index 0000000..031f92d
--- /dev/null
+++ b/tools/virtio/Makefile
@@ -0,0 +1,11 @@
+all: test mod
+test: virtio_test
+virtio_test: virtio_ring.o virtio_test.o
+CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow  -MMD
+vpath %.c ../../drivers/virtio
+mod:
+	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_null
+.PHONY: all test mod clean
+clean:
+	${RM} *.o vhost_null/*.o vhost_null/.*.cmd *.d
+-include *.d
diff --git a/tools/virtio/linux/device.h b/tools/virtio/linux/device.h
new file mode 100644
index 0000000..4ad7e1d
--- /dev/null
+++ b/tools/virtio/linux/device.h
@@ -0,0 +1,2 @@
+#ifndef LINUX_DEVICE_H
+#endif
diff --git a/tools/virtio/linux/slab.h b/tools/virtio/linux/slab.h
new file mode 100644
index 0000000..81baeac
--- /dev/null
+++ b/tools/virtio/linux/slab.h
@@ -0,0 +1,2 @@
+#ifndef LINUX_SLAB_H
+#endif
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
new file mode 100644
index 0000000..669bcdd
--- /dev/null
+++ b/tools/virtio/linux/virtio.h
@@ -0,0 +1,223 @@
+#ifndef LINUX_VIRTIO_H
+#define LINUX_VIRTIO_H
+
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <string.h>
+#include <assert.h>
+
+#include <linux/types.h>
+#include <errno.h>
+
+typedef unsigned long long dma_addr_t;
+
+struct scatterlist {
+	unsigned long	page_link;
+	unsigned int	offset;
+	unsigned int	length;
+	dma_addr_t	dma_address;
+};
+
+struct page {
+	unsigned long long dummy;
+};
+
+#define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
+
+/* Physical == Virtual */
+#define virt_to_phys(p) ((unsigned long)p)
+#define phys_to_virt(a) ((void *)(unsigned long)(a))
+/* Page address: Virtual / 4K */
+#define virt_to_page(p) ((struct page*)((virt_to_phys(p) / 4096) * \
+					sizeof(struct page)))
+#define offset_in_page(p) (((unsigned long)p) % 4096)
+#define sg_phys(sg) ((sg->page_link & ~0x3) / sizeof(struct page) * 4096 + \
+		     sg->offset)
+static inline void sg_mark_end(struct scatterlist *sg)
+{
+	/*
+	 * Set termination bit, clear potential chain bit
+	 */
+	sg->page_link |= 0x02;
+	sg->page_link &= ~0x01;
+}
+static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
+{
+	memset(sgl, 0, sizeof(*sgl) * nents);
+	sg_mark_end(&sgl[nents - 1]);
+}
+static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
+{
+	unsigned long page_link = sg->page_link & 0x3;
+
+	/*
+	 * In order for the low bit stealing approach to work, pages
+	 * must be aligned at a 32-bit boundary as a minimum.
+	 */
+	BUG_ON((unsigned long) page & 0x03);
+	sg->page_link = page_link | (unsigned long) page;
+}
+
+static inline void sg_set_page(struct scatterlist *sg, struct page *page,
+			       unsigned int len, unsigned int offset)
+{
+	sg_assign_page(sg, page);
+	sg->offset = offset;
+	sg->length = len;
+}
+
+static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
+			      unsigned int buflen)
+{
+	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
+}
+
+static inline void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
+{
+	sg_init_table(sg, 1);
+	sg_set_buf(sg, buf, buflen);
+}
+
+typedef __u16 u16;
+
+typedef enum {
+	GFP_KERNEL,
+	GFP_ATOMIC,
+} gfp_t;
+typedef enum {
+	IRQ_NONE,
+	IRQ_HANDLED
+} irqreturn_t;
+
+static inline void *kmalloc(size_t s, gfp_t gfp)
+{
+	return malloc(s);
+}
+
+static inline void kfree(void *p)
+{
+	free(p);
+}
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+#define uninitialized_var(x) x = x
+
+# ifndef likely
+#  define likely(x)	(__builtin_expect(!!(x), 1))
+# endif
+# ifndef unlikely
+#  define unlikely(x)	(__builtin_expect(!!(x), 0))
+# endif
+
+#define pr_err(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#ifdef DEBUG
+#define pr_debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#else
+#define pr_debug(format, ...) do {} while (0)
+#endif
+#define dev_err(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#define dev_warn(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+
+/* TODO: empty stubs for now. Broken but enough for virtio_ring.c */
+#define list_add_tail(a, b) do {} while (0)
+#define list_del(a) do {} while (0)
+
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#define BITS_PER_LONG (sizeof(long) * BITS_PER_BYTE)
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+/* TODO: Not atomic as it should be:
+ * we don't use this for anything important. */
+static inline void clear_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+	*p &= ~mask;
+}
+
+static inline int test_bit(int nr, const volatile unsigned long *addr)
+{
+        return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+}
+
+/* The only feature we care to support */
+#define virtio_has_feature(dev, feature) \
+	test_bit((feature), (dev)->features)
+/* end of stubs */
+
+struct virtio_device {
+	void *dev;
+	unsigned long features[1];
+};
+
+struct virtqueue {
+	/* TODO: commented as list macros are empty stubs for now.
+	 * Broken but enough for virtio_ring.c
+	 * struct list_head list; */
+	void (*callback)(struct virtqueue *vq);
+	const char *name;
+	struct virtio_device *vdev;
+	void *priv;
+};
+
+#define EXPORT_SYMBOL_GPL(__EXPORT_SYMBOL_GPL_name) \
+	void __EXPORT_SYMBOL_GPL##__EXPORT_SYMBOL_GPL_name() { \
+}
+#define MODULE_LICENSE(__MODULE_LICENSE_value) \
+	const char *__MODULE_LICENSE_name = __MODULE_LICENSE_value
+
+#define CONFIG_SMP
+
+#if defined(__i386__) || defined(__x86_64__)
+#define barrier() asm volatile("" ::: "memory")
+#define mb() __sync_synchronize()
+
+#define smp_mb()	mb()
+# define smp_rmb()	barrier()
+# define smp_wmb()	barrier()
+#else
+#error Please fill in barrier macros
+#endif
+
+/* Interfaces exported by virtio_ring. */
+int virtqueue_add_buf_gfp(struct virtqueue *vq,
+			  struct scatterlist sg[],
+			  unsigned int out_num,
+			  unsigned int in_num,
+			  void *data,
+			  gfp_t gfp);
+
+static inline int virtqueue_add_buf(struct virtqueue *vq,
+				    struct scatterlist sg[],
+				    unsigned int out_num,
+				    unsigned int in_num,
+				    void *data)
+{
+	return virtqueue_add_buf_gfp(vq, sg, out_num, in_num, data, GFP_ATOMIC);
+}
+
+void virtqueue_kick(struct virtqueue *vq);
+
+void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
+
+void virtqueue_disable_cb(struct virtqueue *vq);
+
+bool virtqueue_enable_cb(struct virtqueue *vq);
+
+void *virtqueue_detach_unused_buf(struct virtqueue *vq);
+struct virtqueue *vring_new_virtqueue(unsigned int num,
+				      unsigned int vring_align,
+				      struct virtio_device *vdev,
+				      void *pages,
+				      void (*notify)(struct virtqueue *vq),
+				      void (*callback)(struct virtqueue *vq),
+				      const char *name);
+void vring_del_virtqueue(struct virtqueue *vq);
+
+#endif
diff --git a/tools/virtio/vhost_null/Makefile b/tools/virtio/vhost_null/Makefile
new file mode 100644
index 0000000..1f2b5ba
--- /dev/null
+++ b/tools/virtio/vhost_null/Makefile
@@ -0,0 +1,3 @@
+obj-m += vhost_null.o
+vhost_null-y := null.o
+EXTRA_CFLAGS += -Idrivers/vhost
diff --git a/tools/virtio/vhost_null/null.c b/tools/virtio/vhost_null/null.c
new file mode 100644
index 0000000..46839a5
--- /dev/null
+++ b/tools/virtio/vhost_null/null.c
@@ -0,0 +1,320 @@
+/* Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * virtio-net server in host kernel.
+ */
+
+#include <linux/compat.h>
+#include <linux/eventfd.h>
+#include <linux/vhost.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/rcupdate.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+
+#include "null.h"
+#include "vhost.c"
+
+/* Max number of bytes transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others. */
+#define VHOST_NULL_WEIGHT 0x80000
+
+enum {
+	VHOST_NULL_VQ = 0,
+	VHOST_NULL_VQ_MAX = 1,
+};
+
+struct vhost_null {
+	struct vhost_dev dev;
+	struct vhost_virtqueue vqs[VHOST_NULL_VQ_MAX];
+};
+
+/* Expects to be always run from workqueue - which acts as
+ * read-size critical section for our kind of RCU. */
+static void handle_vq(struct vhost_null *n)
+{
+	struct vhost_virtqueue *vq = &n->dev.vqs[VHOST_NULL_VQ];
+	unsigned out, in;
+	int head;
+	size_t len, total_len = 0;
+	void *private;
+
+	private = rcu_dereference_check(vq->private_data, 1);
+	if (!private)
+		return;
+
+	mutex_lock(&vq->mutex);
+	vhost_disable_notify(vq);
+
+	for (;;) {
+		head = vhost_get_vq_desc(&n->dev, vq, vq->iov,
+					 ARRAY_SIZE(vq->iov),
+					 &out, &in,
+					 NULL, NULL);
+		/* On error, stop handling until the next kick. */
+		if (unlikely(head < 0))
+			break;
+		/* Nothing new?  Wait for eventfd to tell us they refilled. */
+		if (head == vq->num) {
+			if (unlikely(vhost_enable_notify(vq))) {
+				vhost_disable_notify(vq);
+				continue;
+			}
+			break;
+		}
+		if (in) {
+			vq_err(vq, "Unexpected descriptor format for TX: "
+			       "out %d, int %d\n", out, in);
+			break;
+		}
+		len = iov_length(vq->iov, out);
+		/* Sanity check */
+		if (!len) {
+			vq_err(vq, "Unexpected 0 len for TX\n");
+			break;
+		}
+		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		total_len += len;
+		if (unlikely(total_len >= VHOST_NULL_WEIGHT)) {
+			vhost_poll_queue(&vq->poll);
+			break;
+		}
+	}
+
+	mutex_unlock(&vq->mutex);
+}
+
+static void handle_vq_kick(struct vhost_work *work)
+{
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						  poll.work);
+	struct vhost_null *n = container_of(vq->dev, struct vhost_null, dev);
+
+	handle_vq(n);
+}
+
+static int vhost_null_open(struct inode *inode, struct file *f)
+{
+	struct vhost_null *n = kmalloc(sizeof *n, GFP_KERNEL);
+	struct vhost_dev *dev;
+	int r;
+
+	if (!n)
+		return -ENOMEM;
+
+	dev = &n->dev;
+	n->vqs[VHOST_NULL_VQ].handle_kick = handle_vq_kick;
+	r = vhost_dev_init(dev, n->vqs, VHOST_NULL_VQ_MAX);
+	if (r < 0) {
+		kfree(n);
+		return r;
+	}
+
+	f->private_data = n;
+
+	return 0;
+}
+
+static void *vhost_null_stop_vq(struct vhost_null *n,
+				struct vhost_virtqueue *vq)
+{
+	void *private;
+
+	mutex_lock(&vq->mutex);
+	private = rcu_dereference_protected(vq->private_data,
+					 lockdep_is_held(&vq->mutex));
+	rcu_assign_pointer(vq->private_data, NULL);
+	mutex_unlock(&vq->mutex);
+	return private;
+}
+
+static void vhost_null_stop(struct vhost_null *n, void **privatep)
+{
+	*privatep = vhost_null_stop_vq(n, n->vqs + VHOST_NULL_VQ);
+}
+
+static void vhost_null_flush_vq(struct vhost_null *n, int index)
+{
+	vhost_poll_flush(&n->dev.vqs[index].poll);
+}
+
+static void vhost_null_flush(struct vhost_null *n)
+{
+	vhost_null_flush_vq(n, VHOST_NULL_VQ);
+}
+
+static int vhost_null_release(struct inode *inode, struct file *f)
+{
+	struct vhost_null *n = f->private_data;
+	void  *private;
+
+	vhost_null_stop(n, &private);
+	vhost_null_flush(n);
+	vhost_dev_cleanup(&n->dev);
+	/* We do an extra flush before freeing memory,
+	 * since jobs can re-queue themselves. */
+	vhost_null_flush(n);
+	kfree(n);
+	return 0;
+}
+
+static long vhost_null_run(struct vhost_null *n, int test)
+{
+	void *priv, *oldpriv;
+	struct vhost_virtqueue *vq;
+	int r, index;
+
+	if (test < 0 || test > 1)
+		return -EINVAL;
+
+	mutex_lock(&n->dev.mutex);
+	r = vhost_dev_check_owner(&n->dev);
+	if (r)
+		goto err;
+
+	for (index = 0; index < n->dev.nvqs; ++index) {
+		/* Verify that ring has been setup correctly. */
+		if (!vhost_vq_access_ok(&n->vqs[index])) {
+			r = -EFAULT;
+			goto err;
+		}
+	}
+
+	for (index = 0; index < n->dev.nvqs; ++index) {
+		vq = n->vqs + index;
+		mutex_lock(&vq->mutex);
+		priv = test ? n : NULL;
+
+		/* start polling new socket */
+		oldpriv = rcu_dereference_protected(vq->private_data,
+						    lockdep_is_held(&vq->mutex));
+		rcu_assign_pointer(vq->private_data, priv);
+
+		mutex_unlock(&vq->mutex);
+
+		if (oldpriv) {
+			vhost_null_flush_vq(n, index);
+		}
+	}
+
+	mutex_unlock(&n->dev.mutex);
+	return 0;
+
+err:
+	mutex_unlock(&n->dev.mutex);
+	return r;
+}
+
+static long vhost_null_reset_owner(struct vhost_null *n)
+{
+	void *priv = NULL;
+	long err;
+	mutex_lock(&n->dev.mutex);
+	err = vhost_dev_check_owner(&n->dev);
+	if (err)
+		goto done;
+	vhost_null_stop(n, &priv);
+	vhost_null_flush(n);
+	err = vhost_dev_reset_owner(&n->dev);
+done:
+	mutex_unlock(&n->dev.mutex);
+	return err;
+}
+
+static int vhost_null_set_features(struct vhost_null *n, u64 features)
+{
+	mutex_lock(&n->dev.mutex);
+	if ((features & (1 << VHOST_F_LOG_ALL)) &&
+	    !vhost_log_access_ok(&n->dev)) {
+		mutex_unlock(&n->dev.mutex);
+		return -EFAULT;
+	}
+	n->dev.acked_features = features;
+	smp_wmb();
+	vhost_null_flush(n);
+	mutex_unlock(&n->dev.mutex);
+	return 0;
+}
+
+static long vhost_null_ioctl(struct file *f, unsigned int ioctl,
+			     unsigned long arg)
+{
+	struct vhost_null *n = f->private_data;
+	void __user *argp = (void __user *)arg;
+	u64 __user *featurep = argp;
+	int test;
+	u64 features;
+	int r;
+	switch (ioctl) {
+	case VHOST_NULL_RUN:
+		if (copy_from_user(&test, argp, sizeof test))
+			return -EFAULT;
+		return vhost_null_run(n, test);
+	case VHOST_GET_FEATURES:
+		features = VHOST_FEATURES;
+		if (copy_to_user(featurep, &features, sizeof features))
+			return -EFAULT;
+		return 0;
+	case VHOST_SET_FEATURES:
+		if (copy_from_user(&features, featurep, sizeof features))
+			return -EFAULT;
+		if (features & ~VHOST_FEATURES)
+			return -EOPNOTSUPP;
+		return vhost_null_set_features(n, features);
+	case VHOST_RESET_OWNER:
+		return vhost_null_reset_owner(n);
+	default:
+		mutex_lock(&n->dev.mutex);
+		r = vhost_dev_ioctl(&n->dev, ioctl, arg);
+		vhost_null_flush(n);
+		mutex_unlock(&n->dev.mutex);
+		return r;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long vhost_null_compat_ioctl(struct file *f, unsigned int ioctl,
+				   unsigned long arg)
+{
+	return vhost_null_ioctl(f, ioctl, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static const struct file_operations vhost_null_fops = {
+	.owner          = THIS_MODULE,
+	.release        = vhost_null_release,
+	.unlocked_ioctl = vhost_null_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = vhost_null_compat_ioctl,
+#endif
+	.open           = vhost_null_open,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice vhost_null_misc = {
+	MISC_DYNAMIC_MINOR,
+	"vhost-null",
+	&vhost_null_fops,
+};
+
+static int vhost_null_init(void)
+{
+	return misc_register(&vhost_null_misc);
+}
+module_init(vhost_null_init);
+
+static void vhost_null_exit(void)
+{
+	misc_deregister(&vhost_null_misc);
+}
+module_exit(vhost_null_exit);
+
+MODULE_VERSION("0.0.1");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Michael S. Tsirkin");
+MODULE_DESCRIPTION("Host kernel side for virtio simulator");
diff --git a/tools/virtio/vhost_null/null.h b/tools/virtio/vhost_null/null.h
new file mode 100644
index 0000000..f39e3e1
--- /dev/null
+++ b/tools/virtio/vhost_null/null.h
@@ -0,0 +1,7 @@
+#ifndef LINUX_VHOST_NULL_H
+#define LINUX_VHOST_NULL_H
+
+/* Start a given test on the virtio null device. 0 stops all tests. */
+#define VHOST_NULL_RUN _IOW(VHOST_VIRTIO, 0x31, int)
+
+#endif
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
new file mode 100644
index 0000000..0f6cdcb
--- /dev/null
+++ b/tools/virtio/virtio_test.c
@@ -0,0 +1,198 @@
+#define _GNU_SOURCE
+#include <string.h>
+#include <poll.h>
+#include <sys/eventfd.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <linux/vhost.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ring.h>
+#include <vhost_null/null.h>
+
+struct vq_info {
+	int kick;
+	int call;
+	int num;
+	int idx;
+	void *ring;
+	/* copy used for control */
+	struct vring vring;
+	struct virtqueue *vq;
+};
+
+struct vdev_info {
+	struct virtio_device vdev;
+	int control;
+	struct pollfd fds[1];
+	struct vq_info vqs[1];
+	int nvqs;
+	void *buf;
+	size_t buf_size;
+	struct vhost_memory *mem;
+};
+
+void vq_notify(struct virtqueue *vq)
+{
+	struct vq_info *info = vq->priv;
+	unsigned long long v = 1;
+	int r;
+	r = write(info->kick, &v, sizeof v);
+	assert(r == sizeof v);
+}
+
+void vq_callback(struct virtqueue *vq)
+{
+}
+
+
+void vhost_vq_setup(struct vdev_info *dev, struct vq_info *info)
+{
+	struct vhost_vring_state state = { .index = info->idx };
+	struct vhost_vring_file file = { .index = info->idx };
+	unsigned long long features = dev->vdev.features[0];
+	struct vhost_vring_addr addr = {
+		.index = info->idx,
+		.desc_user_addr = (uint64_t)(unsigned long)info->vring.desc,
+		.avail_user_addr = (uint64_t)(unsigned long)info->vring.avail,
+		.used_user_addr = (uint64_t)(unsigned long)info->vring.used,
+	};
+	int r;
+	r = ioctl(dev->control, VHOST_SET_FEATURES, &features);
+	assert(r >= 0);
+	state.num = info->vring.num;
+	r = ioctl(dev->control, VHOST_SET_VRING_NUM, &state);
+	assert(r >= 0);
+	state.num = 0;
+	r = ioctl(dev->control, VHOST_SET_VRING_BASE, &state);
+	assert(r >= 0);
+	r = ioctl(dev->control, VHOST_SET_VRING_ADDR, &addr);
+	assert(r >= 0);
+	file.fd = info->kick;
+	r = ioctl(dev->control, VHOST_SET_VRING_KICK, &file);
+	assert(r >= 0);
+	file.fd = info->call;
+	r = ioctl(dev->control, VHOST_SET_VRING_CALL, &file);
+	assert(r >= 0);
+}
+
+static void vq_info_add(struct vdev_info *dev, int num)
+{
+	struct vq_info *info = &dev->vqs[dev->nvqs];
+	int r;
+	info->idx = dev->nvqs;
+	info->kick = eventfd(0, EFD_NONBLOCK);
+	info->call = eventfd(0, EFD_NONBLOCK);
+	r = posix_memalign(&info->ring, 4096, vring_size(num, 4096));
+	assert(r >= 0);
+	memset(info->ring, 0, vring_size(num, 4096));
+	vring_init(&info->vring, num, info->ring, 4096);
+	info->vq = vring_new_virtqueue(info->vring.num, 4096, &dev->vdev, info->ring,
+				       vq_notify, vq_callback, "test");
+	assert(info->vq);
+	info->vq->priv = info;
+	vhost_vq_setup(dev, info);
+	dev->fds[info->idx].fd = info->call;
+	dev->fds[info->idx].events = POLLIN;
+	dev->nvqs++;
+}
+
+static void vdev_info_init(struct vdev_info* dev)
+{
+	int r;
+	memset(dev, 0, sizeof *dev);
+	dev->vdev.features[0] = 1UL << VIRTIO_RING_F_INDIRECT_DESC;
+	dev->buf_size = 1024;
+	dev->buf = malloc(dev->buf_size);
+	assert(dev->buf);
+        dev->control = open("/dev/vhost-null", O_RDWR);
+	assert(dev->control >= 0);
+	r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
+	assert(r >= 0);
+	dev->mem = malloc(offsetof(struct vhost_memory, regions) +
+			  sizeof dev->mem->regions[0]);
+	assert(dev->mem);
+	memset(dev->mem, 0, offsetof(struct vhost_memory, regions) +
+                          sizeof dev->mem->regions[0]);
+	dev->mem->nregions = 1;
+	dev->mem->regions[0].guest_phys_addr = (long)dev->buf;
+	dev->mem->regions[0].userspace_addr = (long)dev->buf;
+	dev->mem->regions[0].memory_size = dev->buf_size;
+	r = ioctl(dev->control, VHOST_SET_MEM_TABLE, dev->mem);
+	assert(r >= 0);
+}
+
+/* TODO: this is pretty bad: we get a cache line bounce
+ * for the wait queue on poll and another one on read,
+ * plus the read which is there just to clear the
+ * current state. */
+static void wait_for_interrupt(struct vdev_info *dev)
+{
+	int i;
+	unsigned long long val;
+	poll(dev->fds, dev->nvqs, -1);
+	for (i = 0; i < dev->nvqs; ++i)
+		if (dev->fds[i].revents & POLLIN) {
+			read(dev->fds[i].fd, &val, sizeof val);
+		}
+}
+
+static void run_test(struct vdev_info *dev, struct vq_info *vq, int bufs)
+{
+	struct scatterlist sl;
+	long started = 0, completed = 0;
+	long completed_before;
+	int r, test = 1;
+	unsigned len;
+	r = ioctl(dev->control, VHOST_NULL_RUN, &test);
+	assert(r >= 0);
+	for (;;) {
+		virtqueue_disable_cb(vq->vq);
+		completed_before = completed;
+		do {
+			if (started < bufs) {
+				sg_init_one(&sl, dev->buf, dev->buf_size);
+				r = virtqueue_add_buf(vq->vq, &sl, 1, 0,
+						      dev->buf + started);
+				if (likely(r >= 0)) {
+					++started;
+					virtqueue_kick(vq->vq);
+				}
+			} else
+				r = -1;
+
+			/* Flush out completed bufs if any */
+			if (virtqueue_get_buf(vq->vq, &len)) {
+				++completed;
+				r = 0;
+			}
+			
+		} while (r >= 0);
+		if (completed == completed_before)
+			fprintf(stderr, "spurious wakeup: completed 0x%lx started 0x%lx\n",
+				completed, started);
+		assert(completed <= bufs);
+		assert(started <= bufs);
+		if (completed == bufs)
+			break;
+		if (virtqueue_enable_cb(vq->vq)) {
+			wait_for_interrupt(dev);
+		}
+	}
+	test = 0;
+	r = ioctl(dev->control, VHOST_NULL_RUN, &test);
+	assert(r >= 0);
+}
+
+int main(int argc, char **argv)
+{
+	struct vdev_info dev;
+	vdev_info_init(&dev);
+	vq_info_add(&dev, 256);
+	run_test(&dev, &dev.vqs[0], 0x100000);
+	return 0;
+}
-- 
1.7.3.2.91.g446ac
