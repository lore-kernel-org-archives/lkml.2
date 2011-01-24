Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1AXTgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:36:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1AXTgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:36 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 24 Jan 2011 14:36:30 -0500
In-Reply-To: <1295659049-2688-5-git-send-email-jaxboe@fusionio.com> (Jens
	Axboe's message of "Sat, 22 Jan 2011 01:17:23 +0000")
Message-ID: <x49tygyf60x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

This looks mostly good.  I just have a couple of questions, listed below.

> +/*
> + * Attempts to merge with the plugged list in the current process. Returns
> + * true if merge was succesful, otherwise false.
> + */
> +static bool check_plug_merge(struct task_struct *tsk, struct request_queue *q,
> +			     struct bio *bio)
> +{

Would a better name for this function be attempt_plug_merge?

> +	plug = current->plug;
> +	if (plug && !sync) {
> +		if (!plug->should_sort && !list_empty(&plug->list)) {
> +			struct request *__rq;
> +
> +			__rq = list_entry_rq(plug->list.prev);
> +			if (__rq->q != q)
> +				plug->should_sort = 1;

[snip]

> +static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
> +{
> +	struct request *rqa = container_of(a, struct request, queuelist);
> +	struct request *rqb = container_of(b, struct request, queuelist);
> +
> +	return !(rqa->q == rqb->q);
> +}


> +static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
> +{

[snip]

> +	if (plug->should_sort)
> +		list_sort(NULL, &plug->list, plug_rq_cmp);

The other way to do this is to just keep track of which queues you need
to run after exhausting the plug list.  Is it safe to assume you've done
things this way to keep each request queue's data structures cache hot
while working on it?

> +static inline void blk_flush_plug(struct task_struct *tsk)
> +{
> +	struct blk_plug *plug = tsk->plug;
> +
> +	if (unlikely(plug))
> +		__blk_flush_plug(tsk, plug);
> +}

Why is that unlikely?

Cheers,
Jeff
