Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1HBTq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1HBTqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:46:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	<x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
	<20110802181739.GE6399@redhat.com>
	<x49ty9zsm1n.fsf@segfault.boston.devel.redhat.com>
	<20110802184125.GF6399@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 02 Aug 2011 15:46:49 -0400
In-Reply-To: <20110802184125.GF6399@redhat.com> (Vivek Goyal's message of
	"Tue, 2 Aug 2011 14:41:25 -0400")
Message-ID: <x49oc07sija.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

>> In testing, I did this:
>> 
>> @@ -1817,6 +1817,14 @@ int blk_insert_cloned_request(struct
>> request_queue *q, struct request *rq)
>>                 return -EIO;
>>  #endif
>>  
>> +       if ((rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) && !q->flush_flags) {
>> +               rq->cmd_flags &= ~(REQ_FLUSH|REQ_FUA);
>> +               if (!blk_rq_bytes(rq)) {
>> +                       blk_end_request(rq, 0, 0);
>> +                       return 0;
>> +               }
>> +       }
>> +
>
> Will it make more sense to take care resetting flush/fua flags in
> blk_insert_flush()

Yes, that's much cleaner.

> and also the part which will end the request if request is empty.

Mmm-hmm.

I tried this, and it blew up in my face.  ;-)  Cloned requests from
device-mapper-land have rq->end_io filled in, which causes
blk_insert_flush to BUG here:

        BUG_ON(rq->end_io);

So, we can take the usual route of trying to squirrel away a pointer,
and reinstate that after the flush_data_end_io.  Or, perhaps someone has
a more clever idea, that might keep us from further expanding struct
request...?

Cheers,
Jeff
