Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0LTB51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:57:27 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:53455 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0LTB5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u+kUBCfL9cuKrok7LBECQbHMt+ZPMRZoCmVYpRNAKWF2Gt46I+kA6QSKUAwuOCf0KJ
         xCMd+CHK2EPD5D5z7H/52XiiS2uEgdCloIzXB7Za1KpcZLM44v0+WXT9Olr0guab9HFR
         tH6NW72l44wfiWl3r7SoGFXo+chuAq0vUGUoY=
Message-ID: <4D0EB7F4.6070903@gmail.com>
Date: Mon, 20 Dec 2010 09:57:08 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); zh-CN; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: using hash table for active requests
References: <4D082FE9.7080407@gmail.com> <x49lj3qd79m.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lj3qd79m.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2010年12月16日 06:02, Jeff Moyer 写道:
> Li Yu <raise.sail@gmail.com> writes:
> 
>> This patch remove a TODO in fs/aio.c, that is to use hash table for
>> active requests.
> 
> It's remained a TODO item for this long because it hasn't really
> mattered in the past.  Was there other motivation for this patch besides
> the TODO comment?
> 

:), indeed, to solve a TODO is my major motivation.

>> I prefer add an iocb at tail of collision chain, so I do not use hlist
>> here.
> 
> Why do you prefer to add to the tail?  It makes more sense to add
> collisions at the head, since if you're going to cancel everything, you
> have a better chance of cancelling stuff that was queued later than
> earlier (assuming you can cancel anything at all, which for most cases,
> you can't).  Also, you're halving the number of buckets, so you should
> have a good reason.
> 

I misunderstanded major feature of these code ... it just only can speed up a bit for io_cancel() syscall.
However, the "add to tail" design is wrong here, I ever thinked each hash bucket acts as a FIFO queue, so add an element to tail of list can reduce dequeue time.

> What sort of testing did you do?
> 
> I've made some cursory comments below.  I'll more fully review this if
> you can provide a bit more justification and some proof of testing.  I'd
> be really surprised if this helped any real workloads, though.

Yes, I have some testings for this patches, it seem that its performance impact can be ignored, I tested by fio, iodepth=65535, size=1024m.

Thanks for your review time!

Yu

> 
> Cheers,
> Jeff
> 
>> +static int ioctx_active_reqs_init(struct kioctx *ctx)
>> +{
>> +	int i;
>> +
>> +	ctx->active_reqs_table = kmalloc(AIO_ACTREQ_BUCKETS*sizeof(struct list_head), GFP_KERNEL);
> 
> Fit this into 80 columns, please.  You may just want to run checkpatch
> over the whole thing.
> 
>> +static inline void aio_cancel_one(struct kioctx *ctx, struct kiocb *iocb)
> 
> I see no good reason to inline this.
> 
>> @@ -465,10 +506,12 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
>>  	/* Check if the completion queue has enough free space to
>>  	 * accept an event from this io.
>>  	 */
>> +	bucket = hash_long((unsigned long)tohash, AIO_ACTREQ_BUCKETS_SHIFT);
> 
> hash_ptr?
> 
>> -	struct list_head	active_reqs;	/* used for cancellation */
>> +	struct list_head*	active_reqs_table;	/* used for cancellation */
> 
> Coding Style
> 
