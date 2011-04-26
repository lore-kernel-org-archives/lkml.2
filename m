Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1DZAmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:42:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:10336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab1DZAmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:42:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="425366766"
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20110425085827.GB17734@mtj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
	 <20110422233204.GB1576@mtj.dyndns.org>
	 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
	 <20110425085827.GB17734@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 08:42:39 +0800
Message-ID: <1303778559.3981.279.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 16:58 +0800, Tejun Heo wrote:
> Hello,
> 
> (cc'ing Darrick)
> 
> On Mon, Apr 25, 2011 at 09:33:28AM +0800, Shaohua Li wrote:
> > Say in one operation of fs, we issue write r1 and r2, after they finishes,
> > we issue flush f1. In another operation, we issue write r3 and r4, after
> > they finishes, we issue flush f2.
> > operation 1: r1 r2  f1
> > operation 2:  r3 r4  f2
> > At the time f1 finishes and f2 is in queue, we can make sure two things:
> > 1. r3 and r4 is already finished, otherwise f2 will not be queued.
> > 2. r3 and r4 should be finished before f1. We can only deliver one request
> > out for non-queueable request, so either f1 is dispatched after r3 and r4
> > are finished or before r3 and r4 are finished. Because of item1, f1 is
> > dispatched after r3 and r4 are finished.
> > From the two items, when f1 is finished, we can let f2 finished, because
> > f1 should flush disk cache out for all requests from r1 to r4.
> 
> What I was saying is that request completion is decoupled from driver
> fetching requests from block layer and that the order of completion
> doesn't necessarily follow the order of execution.  IOW, nothing
> guarantees that FLUSH completion code would run before the low level
> driver fetches the next command and _completes_ it, in which case your
> code would happily mark flush complete after write without actually
> doing it.
What I described is in the background of non-queueable flush request.
For queueable flush, this definitely isn't correct.

> And, in general, I feel uncomfortable with this type of approach, it's
> extremely fragile and difficult to understand and verify, and doesn't
> match at all with the rest of the code.  If you think you can exploit
> certain ordering constraint, reflect it into the overall design.
> Don't stuff the magic into five line out-of-place code.
> 
> > If flush is queueable, I'm not sure if we can do the
> > optimization. For example, we dispatch 32 requests in the
> > meantime. and the last request is flush, can the hardware guarantee
> > the cache for the first 31 requests are flushed out?  On the other
> > hand, my optimization works even there are write requests in between
> > the back-to-back flush.
> 
> Eh, wasn't your optimization only applicable if flush is not
> queueable?  IIUC, what your optimization achieves is merging
> back-to-back flushes and you're achieving that in a _very_ non-obvious
> round-about way.  Do it in straight-forward way even if that costs
> more lines of code.
This isn't a problem of more code or less code. I thought my patch is
already quite simple.

The method your described only works for non-queueable flush too. And it
has limitation that the requests between two back-to-back flushes must
not be write. my patch works for non-queueable flush but has no such
limitation.

> Darrick, do you see flush performance regression between rc1 and rc2?
> You're testing on higher end, so maybe it's still okay for you?
please ignore the regression. the patch isn't related to the regression,
but that problem motivates me to do the patch.
Actually I still need the RFC patch in another thread to recover the
regression. I hope you and Jens can seriously look at that issue too.

Thanks,
Shaohua

