Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1ECGog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:44:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:15273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1ECGoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,307,1301900400"; 
   d="scan'208";a="741459066"
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20110430143758.GK29280@htj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
	 <20110422233204.GB1576@mtj.dyndns.org>
	 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
	 <20110425085827.GB17734@mtj.dyndns.org>
	 <20110425091311.GC17734@mtj.dyndns.org>
	 <1303778790.3981.283.camel@sli10-conroe>
	 <20110426104843.GB878@htj.dyndns.org>
	 <1303977055.3981.587.camel@sli10-conroe>
	 <20110430143758.GK29280@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 14:44:31 +0800
Message-ID: <1304405071.3828.11.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On Thu, Apr 28, 2011 at 03:50:55PM +0800, Shaohua Li wrote:
> > Index: linux/block/blk-flush.c
> > ===================================================================
> > --- linux.orig/block/blk-flush.c	2011-04-28 10:23:12.000000000 +0800
> > +++ linux/block/blk-flush.c	2011-04-28 14:12:50.000000000 +0800
> > @@ -158,6 +158,17 @@ static bool blk_flush_complete_seq(struc
> >  	switch (seq) {
> >  	case REQ_FSEQ_PREFLUSH:
> >  	case REQ_FSEQ_POSTFLUSH:
> > +		/*
> > +		 * If queue doesn't support queueable flush request, we just
> > +		 * merge the flush with running flush. For such queue, there
> > +		 * are no normal requests running when flush request is
> > +		 * running, so this still guarantees the correctness.
> > +		 */
> > +		if (!blk_queue_flush_queueable(q)) {
> > +			list_move_tail(&rq->flush.list,
> > +				&q->flush_queue[q->flush_running_idx]);
> > +			break;
> > +		}
> 
> As I've said several times already, I really don't like this magic
> being done in the completion path.  Can't you detect the condition on
> issue of the second/following flush and append it to the running list?
hmm, don't understand it. blk_flush_complete_seq is called when the
second flush is issued. or do you mean do this when the second flush is
issued to disk? but when the second flush is issued the first flush is
already finished.

> If you already have tried that but this way still seems better, can
> you please explain why?
> 
> Also, this is a separate logic.  Please put it in a separate patch.
> The first patch should implement queue holding while flushing, which
> should remove the regression, right?
ok. holding queue has no performance gain in my test, but it reduced a
lot of request requeue.

> The second patch can optimize back-to-back execution, which might or
> might not buy us tangible performance gain, so it would be nice to
> have some measurement for this change.  Also, this logic isn't
> necessarily related with queueability of flushes, right?  As such, I
> think it would be better for it to be implemented separately from the
> queueability thing, unless doing such increases complexity too much.
> 
> > Index: linux/include/linux/blkdev.h
> > ===================================================================
> > --- linux.orig/include/linux/blkdev.h	2011-04-28 10:23:12.000000000 +0800
> > +++ linux/include/linux/blkdev.h	2011-04-28 10:32:54.000000000 +0800
> > @@ -364,6 +364,13 @@ struct request_queue
> >  	 * for flush operations
> >  	 */
> >  	unsigned int		flush_flags;
> > +	unsigned int		flush_not_queueable:1;
> > +	/*
> > +	 * flush_exclusive_running and flush_queue_delayed are only meaningful
> > +	 * when flush request isn't queueable
> > +	 */
> > +	unsigned int		flush_exclusive_running:1;
> > +	unsigned int		flush_queue_delayed:1;
> 
> Hmmm... why do you need separate ->flush_exclusive_running?  Doesn't
> pending_idx != running_idx already have the same information?
when pending_idx != running_idx, flush request is added into queue tail,
but this doesn't mean flush request is dispatched to disk. there might
be other requests in the queue head, which we should dispatch. And flush
request might be reqeueud. Just checking pending_idx != running_idx will
cause queue hang because we thought flush is dispatched and then hold
the queue, but actually flush isn't dispatched yet, the queue should
dispatch other normal requests.

Thanks,
Shaohua

