Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0LBTT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:19:56 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34701 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0LBTTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:19:55 -0500
Date: Thu, 2 Dec 2010 11:00:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost test module
Message-ID: <20101202190037.GH2085@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101129170431.GA4027@redhat.com>
 <20101129170901.GB4027@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129170901.GB4027@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 07:09:01PM +0200, Michael S. Tsirkin wrote:
> This adds a test module for vhost infrastructure.
> Intentionally not tied to kbuild to prevent people
> from installing and loading it accidentally.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

On question below.

> ---
> 
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> new file mode 100644
> index 0000000..099f302
> --- /dev/null
> +++ b/drivers/vhost/test.c
> @@ -0,0 +1,320 @@
> +/* Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * test virtio server in host kernel.
> + */
> +
> +#include <linux/compat.h>
> +#include <linux/eventfd.h>
> +#include <linux/vhost.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/workqueue.h>
> +#include <linux/rcupdate.h>
> +#include <linux/file.h>
> +#include <linux/slab.h>
> +
> +#include "test.h"
> +#include "vhost.c"
> +
> +/* Max number of bytes transferred before requeueing the job.
> + * Using this limit prevents one virtqueue from starving others. */
> +#define VHOST_TEST_WEIGHT 0x80000
> +
> +enum {
> +	VHOST_TEST_VQ = 0,
> +	VHOST_TEST_VQ_MAX = 1,
> +};
> +
> +struct vhost_test {
> +	struct vhost_dev dev;
> +	struct vhost_virtqueue vqs[VHOST_TEST_VQ_MAX];
> +};
> +
> +/* Expects to be always run from workqueue - which acts as
> + * read-size critical section for our kind of RCU. */
> +static void handle_vq(struct vhost_test *n)
> +{
> +	struct vhost_virtqueue *vq = &n->dev.vqs[VHOST_TEST_VQ];
> +	unsigned out, in;
> +	int head;
> +	size_t len, total_len = 0;
> +	void *private;
> +
> +	private = rcu_dereference_check(vq->private_data, 1);

Any chance of a check for running in a workqueue?  If I remember correctly,
the ->lockdep_map field in the work_struct structure allows you to create
the required lockdep expression.

							Thanx, Paul

> +	if (!private)
> +		return;
> +
> +	mutex_lock(&vq->mutex);
> +	vhost_disable_notify(vq);
> +
> +	for (;;) {
> +		head = vhost_get_vq_desc(&n->dev, vq, vq->iov,
> +					 ARRAY_SIZE(vq->iov),
> +					 &out, &in,
> +					 NULL, NULL);
> +		/* On error, stop handling until the next kick. */
> +		if (unlikely(head < 0))
> +			break;
> +		/* Nothing new?  Wait for eventfd to tell us they refilled. */
> +		if (head == vq->num) {
> +			if (unlikely(vhost_enable_notify(vq))) {
> +				vhost_disable_notify(vq);
> +				continue;
> +			}
> +			break;
> +		}
> +		if (in) {
> +			vq_err(vq, "Unexpected descriptor format for TX: "
> +			       "out %d, int %d\n", out, in);
> +			break;
> +		}
> +		len = iov_length(vq->iov, out);
> +		/* Sanity check */
> +		if (!len) {
> +			vq_err(vq, "Unexpected 0 len for TX\n");
> +			break;
> +		}
> +		vhost_add_used_and_signal(&n->dev, vq, head, 0);
> +		total_len += len;
> +		if (unlikely(total_len >= VHOST_TEST_WEIGHT)) {
> +			vhost_poll_queue(&vq->poll);
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&vq->mutex);
> +}
> +
> +static void handle_vq_kick(struct vhost_work *work)
> +{
> +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> +						  poll.work);
> +	struct vhost_test *n = container_of(vq->dev, struct vhost_test, dev);
> +
> +	handle_vq(n);
> +}
> +
> +static int vhost_test_open(struct inode *inode, struct file *f)
> +{
> +	struct vhost_test *n = kmalloc(sizeof *n, GFP_KERNEL);
> +	struct vhost_dev *dev;
> +	int r;
> +
> +	if (!n)
> +		return -ENOMEM;
> +
> +	dev = &n->dev;
> +	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> +	r = vhost_dev_init(dev, n->vqs, VHOST_TEST_VQ_MAX);
> +	if (r < 0) {
> +		kfree(n);
> +		return r;
> +	}
> +
> +	f->private_data = n;
> +
> +	return 0;
> +}
> +
> +static void *vhost_test_stop_vq(struct vhost_test *n,
> +				struct vhost_virtqueue *vq)
> +{
> +	void *private;
> +
> +	mutex_lock(&vq->mutex);
> +	private = rcu_dereference_protected(vq->private_data,
> +					 lockdep_is_held(&vq->mutex));
> +	rcu_assign_pointer(vq->private_data, NULL);
> +	mutex_unlock(&vq->mutex);
> +	return private;
> +}
> +
> +static void vhost_test_stop(struct vhost_test *n, void **privatep)
> +{
> +	*privatep = vhost_test_stop_vq(n, n->vqs + VHOST_TEST_VQ);
> +}
> +
> +static void vhost_test_flush_vq(struct vhost_test *n, int index)
> +{
> +	vhost_poll_flush(&n->dev.vqs[index].poll);
> +}
> +
> +static void vhost_test_flush(struct vhost_test *n)
> +{
> +	vhost_test_flush_vq(n, VHOST_TEST_VQ);
> +}
> +
> +static int vhost_test_release(struct inode *inode, struct file *f)
> +{
> +	struct vhost_test *n = f->private_data;
> +	void  *private;
> +
> +	vhost_test_stop(n, &private);
> +	vhost_test_flush(n);
> +	vhost_dev_cleanup(&n->dev);
> +	/* We do an extra flush before freeing memory,
> +	 * since jobs can re-queue themselves. */
> +	vhost_test_flush(n);
> +	kfree(n);
> +	return 0;
> +}
> +
> +static long vhost_test_run(struct vhost_test *n, int test)
> +{
> +	void *priv, *oldpriv;
> +	struct vhost_virtqueue *vq;
> +	int r, index;
> +
> +	if (test < 0 || test > 1)
> +		return -EINVAL;
> +
> +	mutex_lock(&n->dev.mutex);
> +	r = vhost_dev_check_owner(&n->dev);
> +	if (r)
> +		goto err;
> +
> +	for (index = 0; index < n->dev.nvqs; ++index) {
> +		/* Verify that ring has been setup correctly. */
> +		if (!vhost_vq_access_ok(&n->vqs[index])) {
> +			r = -EFAULT;
> +			goto err;
> +		}
> +	}
> +
> +	for (index = 0; index < n->dev.nvqs; ++index) {
> +		vq = n->vqs + index;
> +		mutex_lock(&vq->mutex);
> +		priv = test ? n : NULL;
> +
> +		/* start polling new socket */
> +		oldpriv = rcu_dereference_protected(vq->private_data,
> +						    lockdep_is_held(&vq->mutex));
> +		rcu_assign_pointer(vq->private_data, priv);
> +
> +		mutex_unlock(&vq->mutex);
> +
> +		if (oldpriv) {
> +			vhost_test_flush_vq(n, index);
> +		}
> +	}
> +
> +	mutex_unlock(&n->dev.mutex);
> +	return 0;
> +
> +err:
> +	mutex_unlock(&n->dev.mutex);
> +	return r;
> +}
> +
> +static long vhost_test_reset_owner(struct vhost_test *n)
> +{
> +	void *priv = NULL;
> +	long err;
> +	mutex_lock(&n->dev.mutex);
> +	err = vhost_dev_check_owner(&n->dev);
> +	if (err)
> +		goto done;
> +	vhost_test_stop(n, &priv);
> +	vhost_test_flush(n);
> +	err = vhost_dev_reset_owner(&n->dev);
> +done:
> +	mutex_unlock(&n->dev.mutex);
> +	return err;
> +}
> +
> +static int vhost_test_set_features(struct vhost_test *n, u64 features)
> +{
> +	mutex_lock(&n->dev.mutex);
> +	if ((features & (1 << VHOST_F_LOG_ALL)) &&
> +	    !vhost_log_access_ok(&n->dev)) {
> +		mutex_unlock(&n->dev.mutex);
> +		return -EFAULT;
> +	}
> +	n->dev.acked_features = features;
> +	smp_wmb();
> +	vhost_test_flush(n);
> +	mutex_unlock(&n->dev.mutex);
> +	return 0;
> +}
> +
> +static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
> +			     unsigned long arg)
> +{
> +	struct vhost_test *n = f->private_data;
> +	void __user *argp = (void __user *)arg;
> +	u64 __user *featurep = argp;
> +	int test;
> +	u64 features;
> +	int r;
> +	switch (ioctl) {
> +	case VHOST_TEST_RUN:
> +		if (copy_from_user(&test, argp, sizeof test))
> +			return -EFAULT;
> +		return vhost_test_run(n, test);
> +	case VHOST_GET_FEATURES:
> +		features = VHOST_FEATURES;
> +		if (copy_to_user(featurep, &features, sizeof features))
> +			return -EFAULT;
> +		return 0;
> +	case VHOST_SET_FEATURES:
> +		if (copy_from_user(&features, featurep, sizeof features))
> +			return -EFAULT;
> +		if (features & ~VHOST_FEATURES)
> +			return -EOPNOTSUPP;
> +		return vhost_test_set_features(n, features);
> +	case VHOST_RESET_OWNER:
> +		return vhost_test_reset_owner(n);
> +	default:
> +		mutex_lock(&n->dev.mutex);
> +		r = vhost_dev_ioctl(&n->dev, ioctl, arg);
> +		vhost_test_flush(n);
> +		mutex_unlock(&n->dev.mutex);
> +		return r;
> +	}
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long vhost_test_compat_ioctl(struct file *f, unsigned int ioctl,
> +				   unsigned long arg)
> +{
> +	return vhost_test_ioctl(f, ioctl, (unsigned long)compat_ptr(arg));
> +}
> +#endif
> +
> +static const struct file_operations vhost_test_fops = {
> +	.owner          = THIS_MODULE,
> +	.release        = vhost_test_release,
> +	.unlocked_ioctl = vhost_test_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl   = vhost_test_compat_ioctl,
> +#endif
> +	.open           = vhost_test_open,
> +	.llseek		= noop_llseek,
> +};
> +
> +static struct miscdevice vhost_test_misc = {
> +	MISC_DYNAMIC_MINOR,
> +	"vhost-test",
> +	&vhost_test_fops,
> +};
> +
> +static int vhost_test_init(void)
> +{
> +	return misc_register(&vhost_test_misc);
> +}
> +module_init(vhost_test_init);
> +
> +static void vhost_test_exit(void)
> +{
> +	misc_deregister(&vhost_test_misc);
> +}
> +module_exit(vhost_test_exit);
> +
> +MODULE_VERSION("0.0.1");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Michael S. Tsirkin");
> +MODULE_DESCRIPTION("Host kernel side for virtio simulator");
> diff --git a/drivers/vhost/test.h b/drivers/vhost/test.h
> new file mode 100644
> index 0000000..1fef5df
> --- /dev/null
> +++ b/drivers/vhost/test.h
> @@ -0,0 +1,7 @@
> +#ifndef LINUX_VHOST_TEST_H
> +#define LINUX_VHOST_TEST_H
> +
> +/* Start a given test on the virtio null device. 0 stops all tests. */
> +#define VHOST_TEST_RUN _IOW(VHOST_VIRTIO, 0x31, int)
> +
> +#endif
> diff --git a/tools/virtio/vhost_test/Makefile b/tools/virtio/vhost_test/Makefile
> new file mode 100644
> index 0000000..a1d35b8
> --- /dev/null
> +++ b/tools/virtio/vhost_test/Makefile
> @@ -0,0 +1,2 @@
> +obj-m += vhost_test.o
> +EXTRA_CFLAGS += -Idrivers/vhost
> diff --git a/tools/virtio/vhost_test/vhost_test.c b/tools/virtio/vhost_test/vhost_test.c
> new file mode 100644
> index 0000000..1873518
> --- /dev/null
> +++ b/tools/virtio/vhost_test/vhost_test.c
> @@ -0,0 +1 @@
> +#include "test.c"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
