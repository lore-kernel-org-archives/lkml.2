Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1DYBdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 21:33:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:52897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab1DYBda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 21:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,264,1301900400"; 
   d="scan'208";a="424798664"
Date: Mon, 25 Apr 2011 09:33:28 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110425013328.GA17315@sli10-conroe.sh.intel.com>
References: <1303202686.3981.216.camel@sli10-conroe>
 <20110422233204.GB1576@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422233204.GB1576@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, Apr 23, 2011 at 07:32:04AM +0800, Tejun Heo wrote: 
> > +	list_splice_init(&q->flush_queue[q->flush_running_idx], &proceed_list);
> > +	/*
> > +	 * If queue doesn't support queueable flush request, we can push the
> > +	 * pending requests to the next stage too. For such queue, there are no
> > +	 * normal requests running when flush request is running, so this still
> > +	 * guarantees the correctness.
> > +	 */
> > +	if (!blk_queue_flush_queueable(q))
> > +		list_splice_tail_init(&q->flush_queue[q->flush_pending_idx],
> > +			&proceed_list);
> 
> I can't see how this is safe.  Request completion is decoupled from
> issue.  What prevents low level driver from take in other requests
> before control hits here?  And even if that holds for the current
> implementation, that's hardly something which can be guaranteed from
> !flush_queueable.  Am I missing something?
Say in one operation of fs, we issue write r1 and r2, after they finishes,
we issue flush f1. In another operation, we issue write r3 and r4, after
they finishes, we issue flush f2.
operation 1: r1 r2  f1
operation 2:  r3 r4  f2
At the time f1 finishes and f2 is in queue, we can make sure two things:
1. r3 and r4 is already finished, otherwise f2 will not be queued.
2. r3 and r4 should be finished before f1. We can only deliver one request
out for non-queueable request, so either f1 is dispatched after r3 and r4
are finished or before r3 and r4 are finished. Because of item1, f1 is
dispatched after r3 and r4 are finished.
>From the two items, when f1 is finished, we can let f2 finished, because
f1 should flush disk cache out for all requests from r1 to r4.
 
> This kind of micro optimization is gonna bring very painful bugs which
> are extremely difficult to reproduce and track down.  It scares the
> hell out of me.  It's gonna silently skip flushes where it shouldn't.
> 
> If you wanna optimize this case, a much better way would be
> implementing back-to-back flush optimization properly such that when
> block layer detects two flushes back-to-back and _KNOWS_ that no
> request has been issued inbetween, the second one is handled as noop.
> Mark the queue clean on flush, dirty on any other request and if the
> queue is clean all flushes can be completed immediately on issue which
> would also allow us to avoid the whole queue at the front or back
> issue without bothering low level drivers at all.
If flush is queueable, I'm not sure if we can do the optimization. For example,
we dispatch 32 requests in the meantime. and the last request is flush, can
the hardware guarantee the cache for the first 31 requests are flushed out?
On the other hand, my optimization works even there are write requests in
between the back-to-back flush.

Thanks,
Shaohua
