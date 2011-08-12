Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1HLRBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:01:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1HLRBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:01:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, msnitzer@redhat.com,
        vgoyal@redhat.com
Subject: Re: [patch] block: fix flush machinery for stacking drivers with differring flush flags
References: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
	<CANejiEVwvO5csrNCHEjcTzUj6ZeuVjHB6Bdavhn-axAyTj144Q@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Aug 2011 13:01:18 -0400
In-Reply-To: <CANejiEVwvO5csrNCHEjcTzUj6ZeuVjHB6Bdavhn-axAyTj144Q@mail.gmail.com>
	(Shaohua Li's message of "Thu, 11 Aug 2011 08:56:37 +0800")
Message-ID: <x49bovupns1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shli@kernel.org> writes:

> 2011/8/10 Jeff Moyer <jmoyer@redhat.com>:
>> @@ -320,6 +319,7 @@ void blk_insert_flush(struct request *rq)
>>        if ((policy & REQ_FSEQ_DATA) &&
>>            !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
>>                list_add_tail(&rq->queuelist, &q->queue_head);
>> +               blk_run_queue_async(q);
> A minor issue. I can understand this is required for
> blk_insert_cloned_request() because INSERT_BACK will run
> queue but INSERT_FLUSH doesn't. But sounds we don't need
> run queue for normal requests. Either __make_request will run
> queue (task has plug list) or flush_plug will run queue. delaying
> run queue has its benefit. can we do the runqueue in
> blk_insert_cloned_request() if this is a INSERT_FLUSH.

Well, the only time we need to run the queue is when the request has
data, has REQ_FUA set, and the underlying queue's flush flags contain
only REQ_FUA.  In code:

if (rq->cmd_flags & REQ_FUA && q->flush_flags == REQ_FUA)
	blk_run_queue_async(q);

If that was added to blk_insert_cloned_request, we could get rid of the
blk_run_queue_async in blk_insert_flush.  However, I think Tejun will
object due to the layering violation for the same reason he doesn't like
my handling of empty flushes in blk_insert_cloned_request.

Tejun?

Cheers,
Jeff
