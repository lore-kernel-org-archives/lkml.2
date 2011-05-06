Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1EFBtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:49:24 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63558 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519Ab1EFBtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:49:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8DAD9Sw015LBzagWdsb2JhbACmPhUBARYmJYhyvQYOhXkEnis
Date: Fri, 6 May 2011 11:49:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Bruno Pr?mont <bonbons@linux-vserver.org>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110506014906.GF26837@dastard>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110504005736.GA2958@cucamonga.audible.transient.net>
 <20110505002126.GA26797@dastard>
 <20110505022613.GA26837@dastard>
 <20110505122117.GB26837@dastard>
 <20110505123959.GA21098@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505123959.GA21098@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 08:39:59AM -0400, Christoph Hellwig wrote:
> > The third problem is that updating the push target is not safe on 32
> > bit machines. We cannot copy a 64 bit LSN without the possibility of
> > corrupting the result when racing with another updating thread. We
> > have function to do this update safely without needing to care about
> > 32/64 bit issues - xfs_trans_ail_copy_lsn() - so use that when
> > updating the AIL push target.
> 
> But reading xa_target without xa_lock isn't safe on 32-bit either, is it?

Not sure - I think it depends on the platform. I don't think we
protect LSN reads in any specific way on 32 bit platforms.

In this case, I don't think it matters so much on read, because if
we get a race with a write that mixes upper/lower words of the
target we will eventually hit the stop condition and we won't get a
match. That will trigger the requeue code and we'll start the push
again.

The problem with getting such a race on the target write is that we
could get a cycle/block pair that is beyond the current head of the
log and we'd never be able to push the AIL again as all push
thresholds are truncated to the current head LSN on disk...

> For the first read it can trivially be moved into the critical
> section a few lines below, and the second one should probably use
> XFS_LSN_CMP.
> 
> > @@ -482,19 +481,24 @@ xfs_ail_worker(
> >  	/* assume we have more work to do in a short while */
> >  	tout = 10;
> >  	if (!count) {
> > +out_done:
> 
> Jumping into conditionals is really ugly.  By initializing count a bit
> earlier you can just jump in front of the if/else clauses.  And while
> you're there maybe moving the tout = 10; into an else clause would
> also make the code more readable.
> an uninitialied used of tout.

Ok, I'll rework that.

> > +		if (ailp->xa_target == target ||
> > +		    (test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags)))
> 
> no need for braces around the test_and_set_bit call.

*nod*. Left over from developing the fix...

I'll split all these and post them to the xfs-list for review...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
