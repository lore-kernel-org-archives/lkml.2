Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab2GQTLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab2GQTLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:11:01 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
	<1342169711-12386-6-git-send-email-asias@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 17 Jul 2012 15:10:58 -0400
In-Reply-To: <1342169711-12386-6-git-send-email-asias@redhat.com> (Asias He's
	message of "Fri, 13 Jul 2012 16:55:11 +0800")
Message-ID: <x49mx2yyzi5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asias He <asias@redhat.com> writes:

> vhost-blk is a in kernel virito-blk device accelerator.
>
> This patch is based on Liu Yuan's implementation with various
> improvements and bug fixes. Notably, this patch makes guest notify and
> host completion processing in parallel which gives about 60% performance
> improvement compared to Liu Yuan's implementation.

So, first off, some basic questions.  Is it correct to assume that you
tested this with buffered I/O (files opened *without* O_DIRECT)?  I'm
pretty sure that if you used O_DIRECT, you'd run into problems (which
are solved by the patch set posted by Shaggy, based on Zach Brown's work
of many moons ago).  Note that, with buffered I/O, the submission path
is NOT asynchronous.  So, any speedups you've reported are extremely
suspect.  ;-)

Next, did you look at Shaggy's patch set?  I think it would be best to
focus your efforts on testing *that*, and implementing your work on top
of it.

Having said that, I did do some review of this patch, inlined below.

> +static int vhost_blk_setup(struct vhost_blk *blk)
> +{
> +	struct kioctx *ctx;
> +
> +	if (blk->ioctx)
> +		return 0;
> +
> +	blk->ioevent_nr = blk->vq.num;
> +	ctx = ioctx_alloc(blk->ioevent_nr);
> +	if (IS_ERR(ctx)) {
> +		pr_err("Failed to ioctx_alloc");
> +		return PTR_ERR(ctx);
> +	}
> +	put_ioctx(ctx);
> +	blk->ioctx = ctx;
> +
> +	blk->ioevent = kmalloc(sizeof(struct io_event) * blk->ioevent_nr,
> +			       GFP_KERNEL);
> +	if (!blk->ioevent) {
> +		pr_err("Failed to allocate memory for io_events");
> +		return -ENOMEM;

You've just leaked blk->ioctx.

> +	}
> +
> +	blk->reqs = kmalloc(sizeof(struct vhost_blk_req) * blk->ioevent_nr,
> +			    GFP_KERNEL);
> +	if (!blk->reqs) {
> +		pr_err("Failed to allocate memory for vhost_blk_req");
> +		return -ENOMEM;

And here.

> +	}
> +
> +	return 0;
> +}
> +
[snip]
> +static int vhost_blk_io_submit(struct vhost_blk *blk, struct file *file,
> +			       struct vhost_blk_req *req,
> +			       struct iovec *iov, u64 nr_vecs, loff_t offset,
> +			       int opcode)
> +{
> +	struct kioctx *ioctx = blk->ioctx;
> +	mm_segment_t oldfs = get_fs();
> +	struct kiocb_batch batch;
> +	struct blk_plug plug;
> +	struct kiocb *iocb;
> +	int ret;
> +
> +	if (!try_get_ioctx(ioctx)) {
> +		pr_info("Failed to get ioctx");
> +		return -EAGAIN;
> +	}

Using try_get_ioctx directly gives me a slightly uneasy feeling.  I
understand that you don't need to do the lookup, but at least wrap it
and check for ->dead.

> +
> +	atomic_long_inc_not_zero(&file->f_count);
> +	eventfd_ctx_get(blk->ectx);
> +
> +	/* TODO: batch to 1 is not good! */

Agreed.  You should setup the batching in vhost_blk_handle_guest_kick.
The way you've written the code, the batching is not at all helpful.

> +	kiocb_batch_init(&batch, 1);
> +	blk_start_plug(&plug);
> +
> +	iocb = aio_get_req(ioctx, &batch);
> +	if (unlikely(!iocb)) {
> +		ret = -EAGAIN;
> +		goto out;
> +	}
> +
> +	iocb->ki_filp	= file;
> +	iocb->ki_pos	= offset;
> +	iocb->ki_buf	= (void *)iov;
> +	iocb->ki_left	= nr_vecs;
> +	iocb->ki_nbytes	= nr_vecs;
> +	iocb->ki_opcode	= opcode;
> +	iocb->ki_obj.user = req;
> +	iocb->ki_eventfd  = blk->ectx;
> +
> +	set_fs(KERNEL_DS);
> +	ret = aio_setup_iocb(iocb, false);
> +	set_fs(oldfs);
> +	if (unlikely(ret))
> +		goto out_put_iocb;
> +
> +	spin_lock_irq(&ioctx->ctx_lock);
> +	if (unlikely(ioctx->dead)) {
> +		spin_unlock_irq(&ioctx->ctx_lock);
> +		ret = -EINVAL;
> +		goto out_put_iocb;
> +	}
> +	aio_run_iocb(iocb);
> +	spin_unlock_irq(&ioctx->ctx_lock);
> +
> +	aio_put_req(iocb);
> +
> +	blk_finish_plug(&plug);
> +	kiocb_batch_free(ioctx, &batch);
> +	put_ioctx(ioctx);
> +
> +	return ret;
> +out_put_iocb:
> +	aio_put_req(iocb); /* Drop extra ref to req */
> +	aio_put_req(iocb); /* Drop I/O ref to req */
> +out:
> +	put_ioctx(ioctx);
> +	return ret;
> +}
> +

You've duplicated a lot of io_submit_one.  I'd rather see that factored
out than to have to maintain two copies.

Again, what I'd *really* like to see is you rebase on top of Shaggy's
work.

Cheers,
Jeff
