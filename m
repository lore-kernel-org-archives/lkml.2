Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1CYSzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1CYSzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:55:09 -0400
Date: Fri, 25 Mar 2011 14:54:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        tj@kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: elevator private data for REQ_FLUSH
Message-ID: <20110325185455.GA2969@redhat.com>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
 <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8CB9C9.5010208@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25 2011 at 11:50am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2011-03-25 16:40, Mike Snitzer wrote:
> > On Fri, Mar 25 2011 at 11:22am -0400,
> > Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> >> On 2011.03.25 at 17:15 +0200, Sergey Senozhatsky wrote:
> >>> Hello,
> >>>
> >>> Commit
> >>>     9d5a4e946ce5352f19400b6370f4cd8e72806278
> >>>     block: skip elevator data initialization for flush requests
> >>>     
> >>>     Skip elevator initialization for flush requests by passing priv=0 to
> >>>     blk_alloc_request() in get_request().  As such elv_set_request() is
> >>>     never called for flush requests.
> >>>
> >>> introduced priv flag, to skip elevator_private data init for FLUSH requests.
> >>> This, I guess, lead to NULL pointer deref on my machine in cfq_insert_request,
> >>> which requires elevator_private to be set:
> >>>
> >>>   1 [   78.982169] Call Trace:                                                                                                                                                                                                     
> >>>   2 [   78.982178]  [<ffffffff8122d1fe>] cfq_insert_request+0x4e/0x47d
> >>>   3 [   78.982184]  [<ffffffff8123e139>] ? do_raw_spin_lock+0x6b/0x122
> >>
> >>> Should we in that case use ELEVATOR_INSERT_FLUSH for REQ_FLUSH | REQ_FUA requests
> >>> (like below)?
> >>>
> >>> ---
> >>>
> >>>  block/elevator.c |    2 ++
> >>>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/block/elevator.c b/block/elevator.c
> >>> index c387d31..b17e577 100644
> >>> --- a/block/elevator.c
> >>> +++ b/block/elevator.c
> >>> @@ -734,6 +734,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
> >>>  			q->end_sector = rq_end_sector(rq);
> >>>  			q->boundary_rq = rq;
> >>>  		}
> >>> +	} else if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
> >>> +		where = ELEVATOR_INSERT_FLUSH;
> >>>  	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
> >>>  		    where == ELEVATOR_INSERT_SORT)
> >>>  		where = ELEVATOR_INSERT_BACK;
> >>
> >> Thanks. That solves all (corruption-) problems that I reported earlier in an other
> >> thread. 
> > 
> > So the flush-merge changes introduced ELEVATOR_INSERT_FLUSH (via commit
> > ae1b1539).  And the flush bio will now get ELEVATOR_INSERT_FLUSH in
> > __make_request().
> > 
> > So it is interesting that the flush is getting inserted in the elevator
> > at all.  AFAIK that shouldn't be (and historically hasn't been) the
> > case.
> > 
> > Combination of onstack plug changes?
> 
> It is, it forces a sort insert. I'll fix this up, I'm relieved we have a
> good handle on this issue now.

Should we also add a safety net to avoid the potential for future silent
corruption, etc?  E.g.:

---
 block/elevator.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index c387d31..86d258e 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -657,6 +657,9 @@ void elv_quiesce_end(struct request_queue *q)
 
 void elv_insert(struct request_queue *q, struct request *rq, int where)
 {
+	BUG_ON(rq->cmd_flags & (REQ_FLUSH | REQ_FUA) &&
+	       where != ELEVATOR_INSERT_FLUSH);
+
 	trace_block_rq_insert(q, rq);
 
 	rq->q = q;
