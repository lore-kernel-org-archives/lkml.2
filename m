Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1JIIMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 04:12:55 -0400
Received: from websrv.saout.de ([78.46.99.52]:46907 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1JIIMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 04:12:50 -0400
Subject: Re: Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: Shaohua Li <shli@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CANejiEV+Joc7qvWr1DF4cOR61GKy8MLX4TT4oWh7pxMkhb74Qg@mail.gmail.com>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	 <1317729761.25998.4.camel@localhost>
	 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	 <20111008161421.GA5743@redhat.com>
	 <CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
	 <CANejiEV+Joc7qvWr1DF4cOR61GKy8MLX4TT4oWh7pxMkhb74Qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 10:12:03 +0200
Message-ID: <1318147923.22902.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,

> >>> Looks the dm request based flush logic is broken.
> >>>
> >>> saved_make_request_fn
> >>>   __make_request
> >>>     blk_insert_flush
> >>> but blk_insert_flush doesn't put the original request to list, instead, the
> >>> q->flush_rq is in list.
> >>> then
> >>> dm_request_fn
> >>>   blk_peek_request
> >>>     dm_prep_fn
> >>>       clone_rq
> >>>   map_request
> >>>     blk_insert_cloned_request
> >>> so q->flush_rq is cloned, and get dispatched. but we can't clone q->flush_rq
> >>> and use it to do flush. map_request even could assign a different blockdev to
> >>> the cloned request.
> >>
> >> You haven't explained why cloning q->flush_rq is broken.  What is the
> >> problem with map_request changing the blockdev?  For the purposes of
> >> request-based DM the flush machinery has already managed the processing
> >> of the flush at the higher level request_queue.
> > hmm, looks I overlook the issue. cloned flush_rq has some problems but can
> > be fixed.
> > 1. it doesn't set requet->bio, request->bio_tail
> > 2. REQ_CLONE_MASK should set REQ_FLUSH_SEQ
> oh, don't need set REQ_FLUSH_SEQ, the low level queue will set it
> anyway. sorry for
> the noise. Jeff's patch looks ok then.

Just for the record: I tried your latest patch and it indeed makes the
crasher go away. However, things are getting horribly slow (hangs for
like 20 seconds when writing), at least for GFS2. This is probably
because the queue isn't kicked, like you stated in your most recent
comment, I guess.

Also for the record: Jeff's patch causes other crashes on my machine
(already posted), so while it might be fine from a technical point of
view, it still has issues in its current form. Jeff is working on it.

Thanks,
	Christophe


