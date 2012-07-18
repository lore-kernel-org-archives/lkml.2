Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab2GRBU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 21:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab2GRBUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 21:20:49 -0400
Message-ID: <50060FE8.4040607@redhat.com>
Date: Wed, 18 Jul 2012 09:22:48 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
References: <1342169711-12386-1-git-send-email-asias@redhat.com> <1342169711-12386-6-git-send-email-asias@redhat.com> <x49mx2yyzi5.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mx2yyzi5.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 03:10 AM, Jeff Moyer wrote:
> Asias He <asias@redhat.com> writes:
>
>> vhost-blk is a in kernel virito-blk device accelerator.
>>
>> This patch is based on Liu Yuan's implementation with various
>> improvements and bug fixes. Notably, this patch makes guest notify and
>> host completion processing in parallel which gives about 60% performance
>> improvement compared to Liu Yuan's implementation.
>
> So, first off, some basic questions.  Is it correct to assume that you
> tested this with buffered I/O (files opened *without* O_DIRECT)?
>  I'm pretty sure that if you used O_DIRECT, you'd run into problems (which
> are solved by the patch set posted by Shaggy, based on Zach Brown's work
> of many moons ago).  Note that, with buffered I/O, the submission path
> is NOT asynchronous.  So, any speedups you've reported are extremely
> suspect.  ;-)

I always used O_DIRECT to test this patchset. And I mostly used raw 
block device as guest image. Is this the reason why I did not hit the 
problem you mentioned. Btw, I do have run this patchset on image based 
file. I still do not see problems like IO hangs.

> Next, did you look at Shaggy's patch set?  I think it would be best to
> focus your efforts on testing *that*, and implementing your work on top
> of it.

I guess you mean this one:

http://marc.info/?l=linux-fsdevel&m=133312234313122

I did not notice that until James pointed that out.

I talked with Zach and Shaggy. Shaggy said he is still working on that 
patch set and will send that patch out soon.


> Having said that, I did do some review of this patch, inlined below.

Thanks, Jeff!

>> +static int vhost_blk_setup(struct vhost_blk *blk)
>> +{
>> +	struct kioctx *ctx;
>> +
>> +	if (blk->ioctx)
>> +		return 0;
>> +
>> +	blk->ioevent_nr = blk->vq.num;
>> +	ctx = ioctx_alloc(blk->ioevent_nr);
>> +	if (IS_ERR(ctx)) {
>> +		pr_err("Failed to ioctx_alloc");
>> +		return PTR_ERR(ctx);
>> +	}
>> +	put_ioctx(ctx);
>> +	blk->ioctx = ctx;
>> +
>> +	blk->ioevent = kmalloc(sizeof(struct io_event) * blk->ioevent_nr,
>> +			       GFP_KERNEL);
>> +	if (!blk->ioevent) {
>> +		pr_err("Failed to allocate memory for io_events");
>> +		return -ENOMEM;
>
> You've just leaked blk->ioctx.

Yes. Will fix.

>> +	}
>> +
>> +	blk->reqs = kmalloc(sizeof(struct vhost_blk_req) * blk->ioevent_nr,
>> +			    GFP_KERNEL);
>> +	if (!blk->reqs) {
>> +		pr_err("Failed to allocate memory for vhost_blk_req");
>> +		return -ENOMEM;
>
> And here.

Yes. Will fix.

>
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> [snip]
>> +static int vhost_blk_io_submit(struct vhost_blk *blk, struct file *file,
>> +			       struct vhost_blk_req *req,
>> +			       struct iovec *iov, u64 nr_vecs, loff_t offset,
>> +			       int opcode)
>> +{
>> +	struct kioctx *ioctx = blk->ioctx;
>> +	mm_segment_t oldfs = get_fs();
>> +	struct kiocb_batch batch;
>> +	struct blk_plug plug;
>> +	struct kiocb *iocb;
>> +	int ret;
>> +
>> +	if (!try_get_ioctx(ioctx)) {
>> +		pr_info("Failed to get ioctx");
>> +		return -EAGAIN;
>> +	}
>
> Using try_get_ioctx directly gives me a slightly uneasy feeling.  I
> understand that you don't need to do the lookup, but at least wrap it
> and check for ->dead.

OK.

>
>> +
>> +	atomic_long_inc_not_zero(&file->f_count);
>> +	eventfd_ctx_get(blk->ectx);
>> +
>> +	/* TODO: batch to 1 is not good! */
>
> Agreed.  You should setup the batching in vhost_blk_handle_guest_kick.
> The way you've written the code, the batching is not at all helpful.

Yes. that's why there is a TODO.

>> +	kiocb_batch_init(&batch, 1);
>> +	blk_start_plug(&plug);
>> +
>> +	iocb = aio_get_req(ioctx, &batch);
>> +	if (unlikely(!iocb)) {
>> +		ret = -EAGAIN;
>> +		goto out;
>> +	}
>> +
>> +	iocb->ki_filp	= file;
>> +	iocb->ki_pos	= offset;
>> +	iocb->ki_buf	= (void *)iov;
>> +	iocb->ki_left	= nr_vecs;
>> +	iocb->ki_nbytes	= nr_vecs;
>> +	iocb->ki_opcode	= opcode;
>> +	iocb->ki_obj.user = req;
>> +	iocb->ki_eventfd  = blk->ectx;
>> +
>> +	set_fs(KERNEL_DS);
>> +	ret = aio_setup_iocb(iocb, false);
>> +	set_fs(oldfs);
>> +	if (unlikely(ret))
>> +		goto out_put_iocb;
>> +
>> +	spin_lock_irq(&ioctx->ctx_lock);
>> +	if (unlikely(ioctx->dead)) {
>> +		spin_unlock_irq(&ioctx->ctx_lock);
>> +		ret = -EINVAL;
>> +		goto out_put_iocb;
>> +	}
>> +	aio_run_iocb(iocb);
>> +	spin_unlock_irq(&ioctx->ctx_lock);
>> +
>> +	aio_put_req(iocb);
>> +
>> +	blk_finish_plug(&plug);
>> +	kiocb_batch_free(ioctx, &batch);
>> +	put_ioctx(ioctx);
>> +
>> +	return ret;
>> +out_put_iocb:
>> +	aio_put_req(iocb); /* Drop extra ref to req */
>> +	aio_put_req(iocb); /* Drop I/O ref to req */
>> +out:
>> +	put_ioctx(ioctx);
>> +	return ret;
>> +}
>> +
>
> You've duplicated a lot of io_submit_one.  I'd rather see that factored
> out than to have to maintain two copies.

Agree.

> Again, what I'd *really* like to see is you rebase on top of Shaggy's
> work.

Sure. Let's wait for Shaggy's new version.


-- 
Asias


