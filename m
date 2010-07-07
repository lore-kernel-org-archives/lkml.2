Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0GGPwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0GGPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:52:07 -0400
Date: Wed, 7 Jul 2010 11:52:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
Message-ID: <20100707155200.GH2474@redhat.com>
References: <1278516227-1643-1-git-send-email-czoccolo@gmail.com>
 <1278516227-1643-2-git-send-email-czoccolo@gmail.com>
 <20100707154631.GG2474@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707154631.GG2474@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:46:31AM -0400, Vivek Goyal wrote:
> On Wed, Jul 07, 2010 at 05:23:47PM +0200, Corrado Zoccolo wrote:
> > RQ_NOIDLE flag is meaningful and should be honored for SYNC_WORKLOAD,
> > without further checks.
> > RQ_NOIDLE can be used to mark the last request of a sequence for which
> > - we want to idle between the requests of the sequence, to keep locality
> > - we don't want to idle after the sequence, because we know that no new
> >   nearby requests will follow, so we should switch servicing other
> >   queues.
> 
> Corrado, in higher layers any WRITE_SYNC request currently is marked
> as RQ_NOIDLE. At that point it is just not known whether there will be
> another request after this or not. So I would not think of RQ_NOIDLE
> as being conclusively telling us that this is last request in the
> sequence.
> 
> I think requst being WRITE_SYNC, we just don't know if the application
> is going to write more or not immediately. fsync, O_SYNC etc fall in
> this category.
> 
> But in general I like the idea of getting rid of idling on as many cases
> as possiblle. Jeff's recent posting to fix fsync issue depends on idling
> even on WRITE_SYNC queues so your patch and his patchsets are
> fundamentally incompatible.
> 
> Whether to idle on WRITE_SYNC or not, I will leave it to Jens (I just
> don't know the answer to that question. :-)). But in general I want to
> get rid of idling as much as possible otherwise it becomes a serious
> bottleneck in any kind of performance testing on higher end storage.
> 
> At the same time not idling runs the risk of process doing WRITE_SYNC
> not getting fair share in presence of sequential readers if writer does
> not keep the queue busy.
> 
> I will do some testing with this patchset little later.

Hmm..., noticed that you are still using Jens's old mail id. Fixing it.

Thanks
Vivek
> 
> > This patch fixes this behaviour, making it similar to how it behaved
> > before 8e55063, but still fixing the corner cases that were the
> > motivation for it.
> > 
> > Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> > ---
> >  block/cfq-iosched.c |   15 ++++++++++-----
> >  1 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 5ef9a5d..cac3afb 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -3356,12 +3356,17 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
> >  				cfqd->noidle_tree_requires_idle |= bitmask;
> >  
> >  			/*
> > -			 * Idling is enabled for SYNC_WORKLOAD.
> > -			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
> > -			 * only if we processed at least one !rq_noidle request
> > +			 * Idling is enabled for:
> > +			 * - the last sync queue of a group
> > +			 * - SYNC_WORKLOAD queues, for !rq_noidle requests
> > +			 * - SYNC_NOIDLE_WORKLOAD "at the end of the tree"
> > +			 *   if at least one queue sent !rq_noidle requests
> > +			 *   not followed by at least one rq_noidle request.
> >  			 */
> > -			if (cfqd->serving_type == SYNC_WORKLOAD
> > -			    || cfqd->noidle_tree_requires_idle
> > +			if ((cfqd->serving_type == SYNC_WORKLOAD
> > +			     && !rq_noidle(rq))
> > +			    || (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
> > +				&& cfqd->noidle_tree_requires_idle)
> >  			    || cfqq->cfqg->nr_cfqq == 1)
> >  				cfq_arm_slice_timer(cfqd);
> >  		}
> > -- 
> > 1.6.4.4
