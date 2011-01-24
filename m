Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1AXVXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:23:45 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:51821 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab1AXVXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:23:44 -0500
X-ASG-Debug-ID: 1295904222-01de280c5332930001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D3DEDDA.3000209@fusionio.com>
Date: Mon, 24 Jan 2011 22:23:38 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-5-git-send-email-jaxboe@fusionio.com> <x49tygyf60x.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
In-Reply-To: <x49tygyf60x.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1295904222
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.53335
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-24 20:36, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
> This looks mostly good.  I just have a couple of questions, listed below.
> 
>> +/*
>> + * Attempts to merge with the plugged list in the current process. Returns
>> + * true if merge was succesful, otherwise false.
>> + */
>> +static bool check_plug_merge(struct task_struct *tsk, struct request_queue *q,
>> +			     struct bio *bio)
>> +{
> 
> Would a better name for this function be attempt_plug_merge?

Most likely :-). I'll change it.

>> +	plug = current->plug;
>> +	if (plug && !sync) {
>> +		if (!plug->should_sort && !list_empty(&plug->list)) {
>> +			struct request *__rq;
>> +
>> +			__rq = list_entry_rq(plug->list.prev);
>> +			if (__rq->q != q)
>> +				plug->should_sort = 1;
> 
> [snip]
> 
>> +static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
>> +{
>> +	struct request *rqa = container_of(a, struct request, queuelist);
>> +	struct request *rqb = container_of(b, struct request, queuelist);
>> +
>> +	return !(rqa->q == rqb->q);
>> +}
> 
> 
>> +static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
>> +{
> 
> [snip]
> 
>> +	if (plug->should_sort)
>> +		list_sort(NULL, &plug->list, plug_rq_cmp);
> 
> The other way to do this is to just keep track of which queues you need
> to run after exhausting the plug list.  Is it safe to assume you've done
> things this way to keep each request queue's data structures cache hot
> while working on it?

But then you get into memory problems as well, as the number of
different queues could (potentially) be huge. In reality they will not
be, but it's something that has to be handled. And if you track those
queues, that still means you have to grab each queue lock twice instead
of just once.

There are probably areas where the double lock approach may be faster
than spending cycles on a sort, but in practice I think the sort will be
faster. It's something we can play with, though.

>> +static inline void blk_flush_plug(struct task_struct *tsk)
>> +{
>> +	struct blk_plug *plug = tsk->plug;
>> +
>> +	if (unlikely(plug))
>> +		__blk_flush_plug(tsk, plug);
>> +}
> 
> Why is that unlikely?

Main caller is the CPU scheduler, when someone is scheduled out. So the
logic is that unless you're very IO intensive, you'll be more likely to
go to sleep without anything waiting on the plug list than not. This
puts it out-of-line in the CPU scheduler, to keep the cost to a minimum.

-- 
Jens Axboe

