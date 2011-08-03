Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1HCBT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 21:19:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42577 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1HCBTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 21:19:51 -0400
MIME-Version: 1.0
In-Reply-To: <x49oc07sija.fsf@segfault.boston.devel.redhat.com>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	<x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
	<20110802181739.GE6399@redhat.com>
	<x49ty9zsm1n.fsf@segfault.boston.devel.redhat.com>
	<20110802184125.GF6399@redhat.com>
	<x49oc07sija.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 3 Aug 2011 09:19:50 +0800
X-Google-Sender-Auth: 38bPd7dgcvLSV1zgsIUdXtxaxIA
Message-ID: <CANejiEXAGC49h4r3qnQe0kyV-hOQfN3ehhorAztqnwtv5PQ9UA@mail.gmail.com>
Subject: Re: [patch] blk-flush: fix flush policy calculation
From: Shaohua Li <shli@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/3 Jeff Moyer <jmoyer@redhat.com>:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
>>> In testing, I did this:
>>>
>>> @@ -1817,6 +1817,14 @@ int blk_insert_cloned_request(struct
>>> request_queue *q, struct request *rq)
>>>                 return -EIO;
>>>  #endif
>>>
>>> +       if ((rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) && !q->flush_flags) {
>>> +               rq->cmd_flags &= ~(REQ_FLUSH|REQ_FUA);
>>> +               if (!blk_rq_bytes(rq)) {
>>> +                       blk_end_request(rq, 0, 0);
>>> +                       return 0;
>>> +               }
>>> +       }
>>> +
>>
>> Will it make more sense to take care resetting flush/fua flags in
>> blk_insert_flush()
>
> Yes, that's much cleaner.
agreed. doing at blk_insert_flush makes a lot of sense, maybe we have
similar issue
like blk_insert_cloned_request in the future.

>> and also the part which will end the request if request is empty.
>
> Mmm-hmm.
>
> I tried this, and it blew up in my face.  ;-)  Cloned requests from
> device-mapper-land have rq->end_io filled in, which causes
> blk_insert_flush to BUG here:
>
>        BUG_ON(rq->end_io);
>
> So, we can take the usual route of trying to squirrel away a pointer,
> and reinstate that after the flush_data_end_io.  Or, perhaps someone has
> a more clever idea, that might keep us from further expanding struct
> request...?
we still have space at request->rb_node union. And since flush request
doesn't go to io scheduler, we can use the space.

Thanks,
Shaohua
