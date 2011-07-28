Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1G1PWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab1G1PWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:22:19 -0400
Date: Thu, 28 Jul 2011 18:22:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
Message-ID: <20110728152244.GA31888@redhat.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
 <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:29:05PM +0800, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> Vhost-blk driver is an in-kernel accelerator, intercepting the
> IO requests from KVM virtio-capable guests. It is based on the
> vhost infrastructure.
> 
> This is supposed to be a module over latest kernel tree, but it
> needs some symbols from fs/aio.c and fs/eventfd.c to compile with.
> So currently, after applying the patch, you need to *recomplie*
> the kernel.
> 
> Usage:
> $kernel-src: make M=drivers/vhost
> $kernel-src: sudo insmod drivers/vhost/vhost_blk.ko
> 
> After insmod, you'll see /dev/vhost-blk created. done!
> 
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>

Thanks, this is an interesting patch.

There are some coding style issues in this patch, could you please
change the code to match the kernel coding style?

In particular pls prefix functions macros etc with vhost_blk to avoid
confusion.

scripts/checkpatch.pl can find some, but not all, issues.

> ---
>  drivers/vhost/Makefile |    3 +
>  drivers/vhost/blk.c    |  568 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost.h  |   11 +
>  fs/aio.c               |   44 ++---
>  fs/eventfd.c           |    1 +
>  include/linux/aio.h    |   31 +++

As others said, core changes need to be split out
and get acks from relevant people.

Use scripts/get_maintainer.pl to get a list.


>  6 files changed, 631 insertions(+), 27 deletions(-)
>  create mode 100644 drivers/vhost/blk.c
> 
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index 72dd020..31f8b2e 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -1,2 +1,5 @@
>  obj-$(CONFIG_VHOST_NET) += vhost_net.o
> +obj-m += vhost_blk.o
> +
>  vhost_net-y := vhost.o net.o
> +vhost_blk-y := vhost.o blk.o
> diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
> new file mode 100644
> index 0000000..f3462be
> --- /dev/null
> +++ b/drivers/vhost/blk.c
> @@ -0,0 +1,568 @@
> +/* Copyright (C) 2011 Taobao, Inc.
> + * Author: Liu Yuan <tailai.ly@taobao.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * Vhost-blk driver is an in-kernel accelerator, intercepting the
> + * IO requests from KVM virtio-capable guests. It is based on the
> + * vhost infrastructure.
> + */
> +
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/virtio_net.h>
> +#include <linux/vhost.h>
> +#include <linux/eventfd.h>
> +#include <linux/mutex.h>
> +#include <linux/workqueue.h>
> +#include <linux/virtio_blk.h>
> +#include <linux/file.h>
> +#include <linux/mmu_context.h>
> +#include <linux/kthread.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/syscalls.h>
> +#include <linux/blkdev.h>
> +
> +#include "vhost.h"
> +
> +#define DEBUG 0
> +
> +#if DEBUG > 0
> +#define dprintk         printk
> +#else
> +#define dprintk(x...)   do { ; } while (0)
> +#endif

There are standard macros for these.

> +
> +enum {
> +	virtqueue_max = 1,
> +};
> +
> +#define MAX_EVENTS 128
> +
> +struct vhost_blk {
> +	struct vhost_virtqueue vq;
> +	struct vhost_dev dev;
> +	int should_stop;
> +	struct kioctx *ioctx;
> +	struct eventfd_ctx *ectx;
> +	struct file *efile;
> +	struct task_struct *worker;
> +};
> +
> +struct used_info {
> +	void *status;
> +	int head;
> +	int len;
> +};
> +
> +static struct io_event events[MAX_EVENTS];
> +
> +static void blk_flush(struct vhost_blk *blk)
> +{
> +       vhost_poll_flush(&blk->vq.poll);
> +}
> +
> +static long blk_set_features(struct vhost_blk *blk, u64 features)
> +{
> +	blk->dev.acked_features = features;
> +	return 0;
> +}
> +
> +static void blk_stop(struct vhost_blk *blk)
> +{
> +	struct vhost_virtqueue *vq = &blk->vq;
> +	struct file *f;
> +
> +	mutex_lock(&vq->mutex);
> +	f = rcu_dereference_protected(vq->private_data,
> +					lockdep_is_held(&vq->mutex));
> +	rcu_assign_pointer(vq->private_data, NULL);
> +	mutex_unlock(&vq->mutex);
> +
> +	if (f)
> +		fput(f);
> +}
> +
> +static long blk_set_backend(struct vhost_blk *blk, struct vhost_vring_file *backend)
> +{
> +	int idx = backend->index;
> +	struct vhost_virtqueue *vq = &blk->vq;
> +	struct file *file, *oldfile;
> +	int ret;
> +
> +	mutex_lock(&blk->dev.mutex);
> +	ret = vhost_dev_check_owner(&blk->dev);
> +	if (ret)
> +		goto err_dev;
> +	if (idx >= virtqueue_max) {
> +		ret = -ENOBUFS;
> +		goto err_dev;
> +	}
> +
> +	mutex_lock(&vq->mutex);
> +
> +	if (!vhost_vq_access_ok(vq)) {
> +		ret = -EFAULT;
> +		goto err_vq;
> +	}

NET used -1 backend to remove a backend.
I think it's a good idea, to make an operation reversible.

> +
> +	file = fget(backend->fd);

We need to verify that the file type passed makes sense.
For example, it's possible to create reference loops
by passng the vhost-blk fd.


> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto err_vq;
> +	}
> +
> +	oldfile = rcu_dereference_protected(vq->private_data,
> +						lockdep_is_held(&vq->mutex));
> +	if (file != oldfile)
> +		rcu_assign_pointer(vq->private_data, file);
> +
> +	mutex_unlock(&vq->mutex);
> +
> +	if (oldfile) {
> +		blk_flush(blk);
> +		fput(oldfile);
> +	}
> +
> +	mutex_unlock(&blk->dev.mutex);
> +	return 0;
> +err_vq:
> +	mutex_unlock(&vq->mutex);
> +err_dev:
> +	mutex_unlock(&blk->dev.mutex);
> +	return ret;
> +}
> +
> +static long blk_reset_owner(struct vhost_blk *b)
> +{
> +	int ret;
> +
> +        mutex_lock(&b->dev.mutex);
> +        ret = vhost_dev_check_owner(&b->dev);
> +        if (ret)
> +                goto err;
> +        blk_stop(b);
> +        blk_flush(b);
> +        ret = vhost_dev_reset_owner(&b->dev);
> +	if (b->worker) {
> +		b->should_stop = 1;
> +		smp_mb();
> +		eventfd_signal(b->ectx, 1);
> +	}
> +err:
> +        mutex_unlock(&b->dev.mutex);
> +        return ret;
> +}
> +
> +static int kernel_io_setup(unsigned nr_events, struct kioctx **ioctx)
> +{
> +	int ret = 0;
> +	*ioctx = ioctx_alloc(nr_events);
> +	if (IS_ERR(ioctx))
> +		ret = PTR_ERR(ioctx);
> +	return ret;
> +}
> +
> +static inline int kernel_read_events(struct kioctx *ctx, long min_nr, long nr, struct io_event *event,
> +			struct timespec *ts)
> +{
> +        mm_segment_t old_fs;
> +        int ret;
> +
> +        old_fs = get_fs();
> +        set_fs(get_ds());
> +	ret = read_events(ctx, min_nr, nr, event, ts);
> +        set_fs(old_fs);
> +
> +	return ret;
> +}
> +
> +static inline ssize_t io_event_ret(struct io_event *ev)
> +{
> +    return (ssize_t)(((uint64_t)ev->res2 << 32) | ev->res);
> +}
> +
> +static inline void aio_prep_req(struct kiocb *iocb, struct eventfd_ctx *ectx, struct file *file,
> +		struct iovec *iov, int nvecs, u64 offset, int opcode, struct used_info *ui)
> +{
> +	iocb->ki_filp = file;
> +	iocb->ki_eventfd = ectx;
> +	iocb->ki_pos = offset;
> +	iocb->ki_buf = (void *)iov;
> +	iocb->ki_left = iocb->ki_nbytes = nvecs;
> +	iocb->ki_opcode = opcode;
> +	iocb->ki_obj.user = ui;
> +}
> +
> +static inline int kernel_io_submit(struct vhost_blk *blk, struct iovec *iov, u64 nvecs, loff_t pos, int opcode, int head, int len)
> +{
> +	int ret = -EAGAIN;
> +	struct kiocb *req;
> +	struct kioctx *ioctx = blk->ioctx;
> +	struct used_info *ui = kzalloc(sizeof *ui, GFP_KERNEL);
> +	struct file *f = blk->vq.private_data;
> +
> +	try_get_ioctx(ioctx);
> +	atomic_long_inc_not_zero(&f->f_count);
> +	eventfd_ctx_get(blk->ectx);
> +
> +
> +	req = aio_get_req(ioctx); /* return 2 refs of req*/
> +	if (unlikely(!req))
> +		goto out;
> +
> +	ui->head = head;
> +	ui->status = blk->vq.iov[nvecs + 1].iov_base;
> +	ui->len = len;
> +	aio_prep_req(req, blk->ectx, f, iov, nvecs, pos, opcode, ui);
> +
> +	ret = aio_setup_iocb(req, 0);
> +	if (unlikely(ret))
> +		goto out_put_req;
> +
> +	spin_lock_irq(&ioctx->ctx_lock);
> +	if (unlikely(ioctx->dead)) {
> +		spin_unlock_irq(&ioctx->ctx_lock);
> +		ret = -EINVAL;
> +		goto out_put_req;
> +	}
> +
> +	aio_run_iocb(req);
> +	if (!list_empty(&ioctx->run_list)) {
> +		while (__aio_run_iocbs(ioctx))
> +			;
> +	}
> +	spin_unlock_irq(&ioctx->ctx_lock);
> +
> +	aio_put_req(req);
> +	put_ioctx(blk->ioctx);
> +
> +	return ret;
> +
> +out_put_req:
> +	aio_put_req(req);
> +	aio_put_req(req);
> +out:
> +	put_ioctx(blk->ioctx);
> +	return ret;
> +}
> +
> +static int blk_completion_worker(void *priv)
> +{
> +	struct vhost_blk *blk = priv;
> +	u64 count;
> +	int ret;
> +
> +	use_mm(blk->dev.mm);
> +	for (;;) {

It would be nicer to reuse the worker infrastructure
from vhost.c. In particular this one ignores cgroups that
the owner belongs to if any.
Does this one do anything that vhost.c doesn't?

> +		struct timespec ts = { 0 };
> +		int i, nr;
> +
> +		do {
> +		ret = eventfd_ctx_read(blk->ectx, 0, &count);
> +		} while (unlikely(ret == -ERESTARTSYS));
> +
> +		if (unlikely(blk->should_stop))
> +			break;
> +
> +		do {
> +		nr = kernel_read_events(blk->ioctx, count, MAX_EVENTS, events, &ts);
> +		} while (unlikely(nr == -EINTR));
> +		dprintk("%s, count %llu, nr %d\n", __func__, count, nr);
> +
> +		if (unlikely(nr < 0))
> +			continue;
> +
> +		for (i = 0; i < nr; i++) {
> +			struct used_info *u = (struct used_info *)events[i].obj;
> +			int len, status;
> +
> +			dprintk("%s, head %d complete in %d\n", __func__, u->head, i);
> +			len = io_event_ret(&events[i]);
> +			//status = u->len == len ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR;
> +			status = len > 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR;
> +			if (copy_to_user(u->status, &status, sizeof status)) {
> +				vq_err(&blk->vq, "%s failed to write status\n", __func__);
> +				BUG(); /* FIXME: maybe a bit radical? */

On an invalid userspace address?
You may very well say so.

> +			}
> +			vhost_add_used(&blk->vq, u->head, u->len);
> +			kfree(u);
> +		}
> +
> +		vhost_signal(&blk->dev, &blk->vq);
> +	}
> +	unuse_mm(blk->dev.mm);
> +	return 0;
> +}
> +
> +static int completion_thread_setup(struct vhost_blk *blk)
> +{
> +	int ret = 0;
> +	struct task_struct *worker;
> +	worker = kthread_create(blk_completion_worker, blk, "vhost-blk-%d", current->pid);
> +	if (IS_ERR(worker)) {
> +		ret = PTR_ERR(worker);
> +		goto err;
> +	}
> +	blk->worker = worker;
> +	blk->should_stop = 0;
> +	smp_mb();
> +	wake_up_process(worker);
> +err:
> +	return ret;
> +}
> +
> +static void completion_thread_destory(struct vhost_blk *blk)
> +{
> +	if (blk->worker) {
> +		blk->should_stop = 1;
> +		smp_mb();
> +		eventfd_signal(blk->ectx, 1);
> +	}
> +}
> +
> +
> +static long blk_set_owner(struct vhost_blk *blk)
> +{
> +	return completion_thread_setup(blk);
> +}
> +
> +static long vhost_blk_ioctl(struct file *f, unsigned int ioctl,
> +		unsigned long arg)
> +{
> +	struct vhost_blk *blk = f->private_data;
> +	struct vhost_vring_file backend;
> +	u64 features = VHOST_BLK_FEATURES;
> +	int ret = -EFAULT;
> +
> +	switch (ioctl) {
> +		case VHOST_NET_SET_BACKEND:
> +			if(copy_from_user(&backend, (void __user *)arg, sizeof backend))
> +				break;
> +			ret = blk_set_backend(blk, &backend);
> +			break;

Please create your own ioctl for this one.

> +		case VHOST_GET_FEATURES:
> +			features = VHOST_BLK_FEATURES;
> +			if (copy_to_user((void __user *)arg , &features, sizeof features))
> +				break;
> +			ret = 0;
> +			break;
> +		case VHOST_SET_FEATURES:
> +			if (copy_from_user(&features, (void __user *)arg, sizeof features))
> +				break;
> +			if (features & ~VHOST_BLK_FEATURES) {
> +				ret = -EOPNOTSUPP;
> +				break;
> +			}
> +			ret = blk_set_features(blk, features);
> +			break;
> +		case VHOST_RESET_OWNER:
> +			ret = blk_reset_owner(blk);
> +			break;
> +		default:
> +			mutex_lock(&blk->dev.mutex);
> +			ret = vhost_dev_ioctl(&blk->dev, ioctl, arg);
> +			if (!ret && ioctl == VHOST_SET_OWNER)
> +				ret = blk_set_owner(blk);
> +			blk_flush(blk);
> +			mutex_unlock(&blk->dev.mutex);
> +			break;
> +	}
> +	return ret;
> +}
> +
> +#define BLK_HDR 0
> +#define BLK_HDR_LEN 16
> +
> +static inline int do_request(struct vhost_virtqueue *vq, struct virtio_blk_outhdr *hdr,
> +		u64 nr_vecs, int head)
> +{
> +	struct file *f = vq->private_data;
> +	struct vhost_blk *blk = container_of(vq->dev, struct vhost_blk, dev);
> +	struct iovec *iov = &vq->iov[BLK_HDR + 1];
> +	loff_t pos = hdr->sector << 9;
> +	int ret = 0, len = 0, status;
> +//	int i;
> +
> +	dprintk("sector %llu, num %lu, type %d\n", hdr->sector, iov->iov_len / 512, hdr->type);
> +	//Guest virtio-blk driver dosen't use len currently.
> +	//for (i = 0; i < nr_vecs; i++) {
> +	//	len += iov[i].iov_len;
> +	//}
> +	switch (hdr->type) {
> +	case VIRTIO_BLK_T_OUT:
> +		kernel_io_submit(blk, iov, nr_vecs, pos, IOCB_CMD_PWRITEV, head, len);
> +		break;
> +	case VIRTIO_BLK_T_IN:
> +		kernel_io_submit(blk, iov, nr_vecs, pos, IOCB_CMD_PREADV, head, len);
> +		break;
> +	case VIRTIO_BLK_T_FLUSH:
> +		ret = vfs_fsync(f, 1);
> +		/* fall through */
> +	case VIRTIO_BLK_T_GET_ID:
> +		status = ret < 0 ? VIRTIO_BLK_S_IOERR :VIRTIO_BLK_S_OK;
> +		if ((vq->iov[nr_vecs + 1].iov_len != 1))
> +			BUG();

Why is this one a bug?


> +
> +		if (copy_to_user(vq->iov[nr_vecs + 1].iov_base, &status, sizeof status)) {
> +				vq_err(vq, "%s failed to write status!\n", __func__);
> +				vhost_discard_vq_desc(vq, 1);
> +				ret = -EFAULT;
> +				break;
> +			}
> +
> +		vhost_add_used_and_signal(&blk->dev, vq, head, ret);
> +		break;
> +	default:
> +		pr_info("%s, unsupported request type %d\n", __func__, hdr->type);
> +		vhost_discard_vq_desc(vq, 1);
> +		ret = -EFAULT;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static inline void handle_kick(struct vhost_blk *blk)
> +{
> +	struct vhost_virtqueue *vq = &blk->vq;
> +	struct virtio_blk_outhdr hdr;
> +	u64 nr_vecs;
> +	int in, out, head;
> +	struct blk_plug plug;
> +
> +	mutex_lock(&vq->mutex);
> +	vhost_disable_notify(&blk->dev, vq);
> +
> +	blk_start_plug(&plug);
> +	for (;;) {
> +		head = vhost_get_vq_desc(&blk->dev, vq, vq->iov,
> +				ARRAY_SIZE(vq->iov),
> +				&out, &in, NULL, NULL);
> +		/* No awailable descriptors from Guest? */
> +		if (head == vq->num) {
> +			if (unlikely(vhost_enable_notify(&blk->dev, vq))) {
> +				vhost_disable_notify(&blk->dev, vq);
> +				continue;
> +			}
> +			break;
> +		}
> +		if (unlikely(head < 0))
> +			break;
> +
> +		dprintk("head %d, in %d, out %d\n", head, in, out);
> +		if(unlikely(vq->iov[BLK_HDR].iov_len != BLK_HDR_LEN)) {
> +			vq_err(vq, "%s bad block header lengh!\n", __func__);
> +			vhost_discard_vq_desc(vq, 1);
> +			break;
> +		}
> +
> +		if (copy_from_user(&hdr, vq->iov[BLK_HDR].iov_base, sizeof hdr)) {
> +			vq_err(vq, "%s failed to get block header!\n", __func__);
> +			vhost_discard_vq_desc(vq, 1);
> +			break;
> +		}
> +
> +		if (hdr.type == VIRTIO_BLK_T_IN || hdr.type == VIRTIO_BLK_T_GET_ID)
> +			nr_vecs = in - 1;
> +		else
> +			nr_vecs = out - 1;
> +
> +		if (do_request(vq, &hdr, nr_vecs, head) < 0)
> +			break;
> +	}
> +	blk_finish_plug(&plug);
> +	mutex_unlock(&vq->mutex);
> +}
> +
> +static void handle_guest_kick(struct vhost_work *work)
> +{
> +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue, poll.work);
> +	struct vhost_blk *blk = container_of(vq->dev, struct vhost_blk, dev);
> +	handle_kick(blk);
> +}
> +
> +static void eventfd_setup(struct vhost_blk *blk)
> +{
> +	blk->efile = eventfd_file_create(0, 0);
> +	blk->ectx = eventfd_ctx_fileget(blk->efile);
> +}
> +
> +static int vhost_blk_open(struct inode *inode, struct file *f)
> +{
> +	int ret = -ENOMEM;
> +	struct vhost_blk *blk = kmalloc(sizeof *blk, GFP_KERNEL);
> +	if (!blk)
> +		goto err;
> +
> +	blk->vq.handle_kick = handle_guest_kick;
> +	ret = vhost_dev_init(&blk->dev, &blk->vq, virtqueue_max);
> +	if (ret < 0)
> +		goto err_init;
> +
> +	ret = kernel_io_setup(MAX_EVENTS, &blk->ioctx);
> +	if (ret < 0)
> +		goto err_io_setup;
> +
> +	eventfd_setup(blk);
> +	f->private_data = blk;
> +	return ret;
> +err_init:
> +err_io_setup:
> +	kfree(blk);
> +err:
> +	return ret;
> +}
> +
> +static void eventfd_destroy(struct vhost_blk *blk)
> +{
> +	eventfd_ctx_put(blk->ectx);
> +	fput(blk->efile);
> +}
> +
> +static int vhost_blk_release(struct inode *inode, struct file *f)
> +{
> +	struct vhost_blk *blk = f->private_data;
> +
> +	blk_stop(blk);
> +	blk_flush(blk);
> +	vhost_dev_cleanup(&blk->dev);
> +	/* Yet another flush? See comments in vhost_net_release() */
> +	blk_flush(blk);
> +	completion_thread_destory(blk);
> +	eventfd_destroy(blk);
> +	kfree(blk);
> +
> +	return 0;
> +}
> +
> +const static struct file_operations vhost_blk_fops = {
> +	.owner          = THIS_MODULE,
> +	.release        = vhost_blk_release,
> +	.open           = vhost_blk_open,
> +	.unlocked_ioctl = vhost_blk_ioctl,
> +	.llseek		= noop_llseek,
> +};
> +
> +
> +static struct miscdevice vhost_blk_misc = {
> +	234,

Don't get a major unless you really must.

> +	"vhost-blk",
> +	&vhost_blk_fops,

And use C99 initializers.

> +};
> +
> +int vhost_blk_init(void)
> +{
> +	return misc_register(&vhost_blk_misc);
> +}
> +void vhost_blk_exit(void)
> +{
> +	misc_deregister(&vhost_blk_misc);
> +}
> +
> +module_init(vhost_blk_init);
> +module_exit(vhost_blk_exit);
> +
> +MODULE_VERSION("0.0.1");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Liu Yuan");
> +MODULE_DESCRIPTION("Host kernel accelerator for virtio_blk");
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 8e03379..9e17152 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -12,6 +12,7 @@
>  #include <linux/virtio_config.h>
>  #include <linux/virtio_ring.h>
>  #include <asm/atomic.h>
> +#include <linux/virtio_blk.h>
>  
>  struct vhost_device;
>  
> @@ -174,6 +175,16 @@ enum {
>  			 (1ULL << VHOST_F_LOG_ALL) |
>  			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>  			 (1ULL << VIRTIO_NET_F_MRG_RXBUF),
> +
> +	VHOST_BLK_FEATURES =	(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> +				(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> +				(1ULL << VIRTIO_RING_F_EVENT_IDX) |
> +				(1ULL << VIRTIO_BLK_F_SEG_MAX) |
> +				(1ULL << VIRTIO_BLK_F_GEOMETRY) |
> +				(1ULL << VIRTIO_BLK_F_TOPOLOGY) |
> +				(1ULL << VIRTIO_BLK_F_SCSI) |
> +				(1ULL << VIRTIO_BLK_F_BLK_SIZE),
> +
>  };
>  
>  static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
> diff --git a/fs/aio.c b/fs/aio.c
> index e29ec48..534d396 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -215,7 +215,7 @@ static void ctx_rcu_free(struct rcu_head *head)
>   *	Called when the last user of an aio context has gone away,
>   *	and the struct needs to be freed.
>   */
> -static void __put_ioctx(struct kioctx *ctx)
> +void __put_ioctx(struct kioctx *ctx)
>  {
>  	BUG_ON(ctx->reqs_active);
>  
> @@ -227,29 +227,12 @@ static void __put_ioctx(struct kioctx *ctx)
>  	pr_debug("__put_ioctx: freeing %p\n", ctx);
>  	call_rcu(&ctx->rcu_head, ctx_rcu_free);
>  }
> -
> -static inline void get_ioctx(struct kioctx *kioctx)
> -{
> -	BUG_ON(atomic_read(&kioctx->users) <= 0);
> -	atomic_inc(&kioctx->users);
> -}
> -
> -static inline int try_get_ioctx(struct kioctx *kioctx)
> -{
> -	return atomic_inc_not_zero(&kioctx->users);
> -}
> -
> -static inline void put_ioctx(struct kioctx *kioctx)
> -{
> -	BUG_ON(atomic_read(&kioctx->users) <= 0);
> -	if (unlikely(atomic_dec_and_test(&kioctx->users)))
> -		__put_ioctx(kioctx);
> -}
> +EXPORT_SYMBOL(__put_ioctx);
>  
>  /* ioctx_alloc
>   *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
>   */
> -static struct kioctx *ioctx_alloc(unsigned nr_events)
> +struct kioctx *ioctx_alloc(unsigned nr_events)
>  {
>  	struct mm_struct *mm;
>  	struct kioctx *ctx;
> @@ -327,6 +310,7 @@ out_freectx:
>  	dprintk("aio: error allocating ioctx %p\n", ctx);
>  	return ctx;
>  }
> +EXPORT_SYMBOL(ioctx_alloc);
>  
>  /* aio_cancel_all
>   *	Cancels all outstanding aio requests on an aio context.  Used 
> @@ -437,7 +421,7 @@ void exit_aio(struct mm_struct *mm)
>   * This prevents races between the aio code path referencing the
>   * req (after submitting it) and aio_complete() freeing the req.
>   */
> -static struct kiocb *__aio_get_req(struct kioctx *ctx)
> +struct kiocb *__aio_get_req(struct kioctx *ctx)
>  {
>  	struct kiocb *req = NULL;
>  	struct aio_ring *ring;
> @@ -480,7 +464,7 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
>  	return req;
>  }
>  
> -static inline struct kiocb *aio_get_req(struct kioctx *ctx)
> +struct kiocb *aio_get_req(struct kioctx *ctx)
>  {
>  	struct kiocb *req;
>  	/* Handle a potential starvation case -- should be exceedingly rare as 
> @@ -494,6 +478,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
>  	}
>  	return req;
>  }
> +EXPORT_SYMBOL(aio_get_req);
>  
>  static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
>  {
> @@ -659,7 +644,7 @@ static inline int __queue_kicked_iocb(struct kiocb *iocb)
>   * simplifies the coding of individual aio operations as
>   * it avoids various potential races.
>   */
> -static ssize_t aio_run_iocb(struct kiocb *iocb)
> +ssize_t aio_run_iocb(struct kiocb *iocb)
>  {
>  	struct kioctx	*ctx = iocb->ki_ctx;
>  	ssize_t (*retry)(struct kiocb *);
> @@ -753,6 +738,7 @@ out:
>  	}
>  	return ret;
>  }
> +EXPORT_SYMBOL(aio_run_iocb);
>  
>  /*
>   * __aio_run_iocbs:
> @@ -761,7 +747,7 @@ out:
>   * Assumes it is operating within the aio issuer's mm
>   * context.
>   */
> -static int __aio_run_iocbs(struct kioctx *ctx)
> +int __aio_run_iocbs(struct kioctx *ctx)
>  {
>  	struct kiocb *iocb;
>  	struct list_head run_list;
> @@ -784,6 +770,7 @@ static int __aio_run_iocbs(struct kioctx *ctx)
>  		return 1;
>  	return 0;
>  }
> +EXPORT_SYMBOL(__aio_run_iocbs);
>  
>  static void aio_queue_work(struct kioctx * ctx)
>  {
> @@ -1074,7 +1061,7 @@ static inline void clear_timeout(struct aio_timeout *to)
>  	del_singleshot_timer_sync(&to->timer);
>  }
>  
> -static int read_events(struct kioctx *ctx,
> +int read_events(struct kioctx *ctx,
>  			long min_nr, long nr,
>  			struct io_event __user *event,
>  			struct timespec __user *timeout)
> @@ -1190,11 +1177,12 @@ out:
>  	destroy_timer_on_stack(&to.timer);
>  	return i ? i : ret;
>  }
> +EXPORT_SYMBOL(read_events);
>  
>  /* Take an ioctx and remove it from the list of ioctx's.  Protects 
>   * against races with itself via ->dead.
>   */
> -static void io_destroy(struct kioctx *ioctx)
> +void io_destroy(struct kioctx *ioctx)
>  {
>  	struct mm_struct *mm = current->mm;
>  	int was_dead;
> @@ -1221,6 +1209,7 @@ static void io_destroy(struct kioctx *ioctx)
>  	wake_up_all(&ioctx->wait);
>  	put_ioctx(ioctx);	/* once for the lookup */
>  }
> +EXPORT_SYMBOL(io_destroy);
>  
>  /* sys_io_setup:
>   *	Create an aio_context capable of receiving at least nr_events.
> @@ -1423,7 +1412,7 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb)
>   *	Performs the initial checks and aio retry method
>   *	setup for the kiocb at the time of io submission.
>   */
> -static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
> +ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
>  {
>  	struct file *file = kiocb->ki_filp;
>  	ssize_t ret = 0;
> @@ -1513,6 +1502,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(aio_setup_iocb);
>  
>  static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  			 struct iocb *iocb, bool compat)
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index d9a5917..6343bc9 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -406,6 +406,7 @@ struct file *eventfd_file_create(unsigned int count, int flags)
>  
>  	return file;
>  }
> +EXPORT_SYMBOL_GPL(eventfd_file_create);

You can avoid the need for this export if you pass
the eventfd in from userspace.

>  
>  SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
>  {
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 7a8db41..d63bc04 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -214,6 +214,37 @@ struct mm_struct;
>  extern void exit_aio(struct mm_struct *mm);
>  extern long do_io_submit(aio_context_t ctx_id, long nr,
>  			 struct iocb __user *__user *iocbpp, bool compat);
> +extern void __put_ioctx(struct kioctx *ctx);
> +extern struct kioctx *ioctx_alloc(unsigned nr_events);
> +extern struct kiocb *aio_get_req(struct kioctx *ctx);
> +extern ssize_t aio_run_iocb(struct kiocb *iocb);
> +extern int __aio_run_iocbs(struct kioctx *ctx);
> +extern int read_events(struct kioctx *ctx,
> +                        long min_nr, long nr,
> +                        struct io_event __user *event,
> +                        struct timespec __user *timeout);
> +extern void io_destroy(struct kioctx *ioctx);
> +extern ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat);
> +extern void __put_ioctx(struct kioctx *ctx);
> +
> +static inline void get_ioctx(struct kioctx *kioctx)
> +{
> +        BUG_ON(atomic_read(&kioctx->users) <= 0);
> +        atomic_inc(&kioctx->users);
> +}
> +
> +static inline int try_get_ioctx(struct kioctx *kioctx)
> +{
> +        return atomic_inc_not_zero(&kioctx->users);
> +}
> +
> +static inline void put_ioctx(struct kioctx *kioctx)
> +{
> +        BUG_ON(atomic_read(&kioctx->users) <= 0);
> +        if (unlikely(atomic_dec_and_test(&kioctx->users)))
> +                __put_ioctx(kioctx);
> +}
> +
>  #else
>  static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
>  static inline int aio_put_req(struct kiocb *iocb) { return 0; }
> -- 
> 1.7.5.1
