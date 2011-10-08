Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1JHQOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 12:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1JHQOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 12:14:37 -0400
Date: Sat, 8 Oct 2011 12:14:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Subject: Re: Block regression since 3.1-rc3
Message-ID: <20111008161421.GA5743@redhat.com>
References: <1317397918.27140.15.camel@localhost>
 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
 <1317729761.25998.4.camel@localhost>
 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08 2011 at  7:02am -0400,
Shaohua Li <shli@kernel.org> wrote:

> Looks the dm request based flush logic is broken.
> 
> saved_make_request_fn
>   __make_request
>     blk_insert_flush
> but blk_insert_flush doesn't put the original request to list, instead, the
> q->flush_rq is in list.
> then
> dm_request_fn
>   blk_peek_request
>     dm_prep_fn
>       clone_rq
>   map_request
>     blk_insert_cloned_request
> so q->flush_rq is cloned, and get dispatched. but we can't clone q->flush_rq
> and use it to do flush. map_request even could assign a different blockdev to
> the cloned request.

You haven't explained why cloning q->flush_rq is broken.  What is the
problem with map_request changing the blockdev?  For the purposes of
request-based DM the flush machinery has already managed the processing
of the flush at the higher level request_queue.

By the time request-based DM is cloning a flush request it really has no
need to reenter the flush machinery (even though Tejun wants it to --
but in practice it doesn't buy us anything because we never stack
request-based DM at the moment.  Instead it showcases how brittle this
path is).

> Clone q->flush_rq is absolutely wrong.

I'm still missing the _why_.

Taking a step back:

Unless others have an immediate ah-ha moment, I'd suggest we revert
commit 4853abaae7e4a2a (block: fix flush machinery for stacking drivers
with differring flush flags).  Whereby avoiding unnecessarily reentering
the flush machinery.

If commit ed8b752bccf256 (dm table: set flush capability based on
underlying devices) is in place the flush gets fed directly to
scsi_request_fn, which is fine because the request-based DM's
request_queue's flush_flags reflect the flush capabilities of the
underlying device(s).

We are then covered relative to the only request-based DM use-case
people care about (e.g. dm-multipath, which doesn't use stacked
request-based DM).

We can revisit upholding the purity of the flush machinery for stacked
devices in >= 3.2.
