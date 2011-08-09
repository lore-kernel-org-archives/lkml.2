Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1HIRwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:52:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab1HIRwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:52:45 -0400
Date: Tue, 9 Aug 2011 13:52:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        dm-devel@redhat.com
Subject: Re: block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809175237.GA978@redhat.com>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
 <20110809174347.GA13293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809174347.GA13293@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 01:43:47PM -0400, Mike Snitzer wrote:
> On Tue, Aug 09 2011 at 12:13pm -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > On Tue, Aug 09, 2011 at 11:53:51AM -0400, Jeff Moyer wrote:
> > > Tejun Heo <tj@kernel.org> writes:
> > > > I'm a bit confused.  We still need ELEVATOR_INSERT_FLUSH fix for
> > > > insertion paths, right?  Or is blk_insert_cloned_request() supposed to
> > > > used only by request based dm which lives under the elevator?  If so,
> > > > it would be great to make that explicit in the comment.  Maybe just
> > > > renaming it to blk_insert_dm_cloned_request() would be better as it
> > > > wouldn't be safe for other cases anyway.
> > > 
> > > request-based dm is the only caller at present.  I'm not a fan of
> > > renaming the function, but I'm more than willing to comment it.
> > 
> > I'm still confused and don't think the patch is correct (you can't
> > turn off REQ_FUA without decomposing it to data + post flush).
> > 
> > Going through flush machinery twice is okay and I think is the right
> > thing to do.  At the upper queue, the request is decomposed to member
> > requests.  After decomposition, it's either REQ_FLUSH w/o data or data
> > request w/ or w/o REQ_FUA.  When the decomposed request reaches lower
> > queue, the lower queue will then either short-circuit it, execute
> > as-is or decompose data w/ REQ_FUA into data + REQ_FLUSH sequence.
> > 
> > AFAICS, the breakages are...
> > 
> > * ELEVATOR_INSERT_FLUSH not used properly from insert paths.
> > 
> > * Short circuit not kicking in for the dm requests. (the above and the
> >   policy patch should solve this, right?)
> > 
> > * BUG(!rq->bio || ...) in blk_insert_flush().  I think we can lift
> >   this restriction for empty REQ_FLUSH but also dm can just send down
> >   requests with empty bio.
> 
> [cc'ing dm-devel]
> 
> All of these issues have come to light because DM was not setting
> flush_flags based on the underlying device(s).  Now fixed in v3.1-rc1:
> ed8b752 dm table: set flush capability based on underlying devices
> 
> Given that commit, and that request-based DM is beneath the elevator, it
> seems any additional effort to have DM flushes re-enter the flush
> machinary is unnecessary.
> 
> We expect:
> 1) flushes to have gone through the flush machinary
> 2) no FLUSH/FUA should be entering underlying queues if not supported
> 
> I think it best to just document the expectation that any FLUSH/FUA
> request that enters blk_insert_cloned_request() will already match the
> queue that the request is being sent to.  One way to document it is to
> change Jeff's flag striping in to pure BUG_ON()s, e.g.:
> 
> ---
>  block/blk-core.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b627558..201bb27 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1710,6 +1710,14 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>  	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>  		return -EIO;
>  
> +	/*
> +	 * All FLUSH/FUA requests are expected to have gone through the
> +	 * flush machinary.  If a request's cmd_flags doesn't match the
> +	 * flush_flags of the underlying request_queue it is a bug.
> +	 */
> +	BUG_ON((rq->cmd_flags & REQ_FLUSH) && !(q->flush_flags & REQ_FLUSH));
> +	BUG_ON((rq->cmd_flags & REQ_FUA) && !(q->flush_flags & REQ_FUA));
> +

Actually this makes sense and is simple. :-) Is BUG_ON() too harsh, how
about WARN_ONCE() variants? To me system continues to work so warning 
is probably good enough.

Thanks
Vivek
