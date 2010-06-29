Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0F2Mao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab0F2Mam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:30:42 -0400
Date: Tue, 29 Jun 2010 08:30:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100629123032.GC7094@redhat.com>
References: <20100621110436.GA4056@lst.de>
 <4C1FB5F7.3070908@kernel.dk>
 <20100621191410.GA24213@lst.de>
 <20100621213618.GC6474@redhat.com>
 <20100623100138.GA9575@lst.de>
 <20100624014420.GB3297@redhat.com>
 <20100625110319.GA12855@lst.de>
 <20100626033509.GA2435@redhat.com>
 <x49wrtk32g1.fsf@segfault.boston.devel.redhat.com>
 <AANLkTiktd7GxqDkezq7LJ3vN8D0wFgzKePdQBAY3bz17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiktd7GxqDkezq7LJ3vN8D0wFgzKePdQBAY3bz17@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:06:19AM +0200, Corrado Zoccolo wrote:

[..]
> > I'm now testing OCFS2, and I'm seeing performance that is not great
> > (even with the blk_yield patches applied).  What happens is that we
> > successfully yield the queue to the journal thread, but then idle on the
> > journal thread (even though RQ_NOIDLE was set).
> >
> > So, can we just get rid of idling when RQ_NOIDLE is set?
> Hi Jeff,
> I think I spotted a problem with the initial implementation of the
> tree-wide idle when RQ_NOIDLE is set: I assumed that a queue would
> either send possibly-idling requests or no-idle requests, but it seems
> that RQ_NOIDLE is being used to mark the end of a stream of
> possibly-idling requests (in my initial implementation, this will then
> cause an unintended idle). The attached patch should fix it, and I
> think the logic is simpler than Vivek's. Can you give it a spin?
> Otherwise, I think that reverting the "noidle_tree_requires_idle"
> behaviour completely may be better than adding complexity, since it is
> really trying to solve corner cases (that maybe happen only on
> synthetic workloads), but affecting negatively more common cases.
> 

Hi Corrado,

I think you forgot to attach the patch? Can't find it.


> About what it is trying to solve, since I think it was not clear:
> - we have a workload of 2 queues, both issuing requests that are being
> put in the no-idle tree (e.g. they are random) + 1 queue issuing
> idling requests (e.g. sequential).
> - if one of the 2 "random" queues marks its requests as RQ_NOIDLE,
> then the timeslice for the no-idle tree is not preserved, causing
> unfairness, as soon as an RQ_NOIDLE request is serviced and the tree
> is empty.

I think Jeff's primary regressions were coming from the fact that we
will continue to idle on SYNC_WORKLOAD even if RQ_NOIDLE() was set.

Regarding giving up idling on sync-noidle workload, I think it still
makes some sense to keep track if some other random queue is doing IO on
that tree or not and if yes, then continue to idle. That's a different
thing that current logic if more coarse and could be fine grained a bit.

Because I don't have a practical workload example at this point of time, I
also don't mind reverting your old patch and restoring the policy of not
idling if RQ_NOIDLE() was set.

But it still does not answer the question that why O_DIRECT and O_SYNC
paths be different when it comes to RQ_NOIDLE.

Thanks
Vivek
