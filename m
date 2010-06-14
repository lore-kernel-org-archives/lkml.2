Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0FNNiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:38:13 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:49624 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754034Ab0FNNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:38:09 -0400
Date: Mon, 14 Jun 2010 23:37:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
 statement warnings
Message-ID: <20100614133755.GE6590@dastard>
References: <20100610110.764742110@firstfloor.org>
 <20100610111052.3DDC5B1A2B@basil.firstfloor.org>
 <20100614042700.GC6590@dastard>
 <20100614074309.GA17092@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614074309.GA17092@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:43:09AM +0200, Andi Kleen wrote:
> On Mon, Jun 14, 2010 at 02:27:00PM +1000, Dave Chinner wrote:
> > > There were also some problems with variables used in ASSERT()
> > > I partly moved those into the ASSERT itself and partly
> > > used a new QASSERT that always evaluates.
> > 
> > That's a pretty ugly hack for a single occurrence of a warning.
> > Re-arrnaging the code is a much better idea than introducing a new
> > ASSERT type. e.g:
> 
> I originally planned to use it for more, but then ended up
> changing other code in other ways.
> 
> I still don't think it's a ugly hack, it's a relatively
> simple way to handle this. But I can change this single occurrence.
> 
> > FWIW, we've now got a situation where external static code checkers
> > will tell us that we are not handling an error case (which is where
> > this code and comment came from), and now the compiler will warn us
> > we are assigning but not using the return value. It's a bit of a
> > Catch-22 situation. Hence my question is this - how are we supposed
> > to "safely" ignore a return value seeing as the compiler is now
> > making the current method rather noisy?
> 
> Fix the problem?  

There is no problem. The end of the error reporting line is the
main loop of a background kernel thread - anything important is
already stashed for later reporting to a real context - so all that
is left to do is throw away the error once it propagated to the top
of the call chain....

> Otherwise you can use a (void) cast, but that's a bad way
> if there's a real problem.

Right, and that's exactly my point - we removed all the (void)
casts because the error checker flagged them as dangerous. Now the
compiler is complaining about not using the error that is
returned. So my question still stands....

> > >  			(uint)(msbp - msb), rsvd);
> > >  		ASSERT(error == 0);
> > > +		/* FIXME: need real error handling here, error can be ENOSPC */
> > 
> > That comment is wrong and hence is not needed.  By design, we should
> > never, ever get an error here because we've already reserved all the
> > space we need and this is just an accounting call.  That's what the
> > ASSERT(error == 0) is documenting. It's ben placed there to catch
> 
> Ok. But I must say ASSERT() is not really a good way to 
> document things like that. Whoever wrote this gets
> what he deserves now ...

We have historically documented code assumptions and bounds
with ASSERT() calls rather than in comments because it means
they are checked at runtime. It means we find out really quickly
when we've made some change that has had an unintended side effect,
rather than it going unnoticed until some user trips over it.

This one in specific has been there for at least 5 years - goes back
to before git was used and has proven to be useful for finding at
least one subtle race in new code introduced back in 2007
(45c34141126a89da07197d5b89c04c6847f1171a "[XFS] Apply transaction
delta counts atomically to incore counters").

FWIW, there's around 2000 asserts in the XFS code - that's about 2%
of the code - which means assumptions in the XFS code are pretty
well documented compared to other Linux filesystems...

> > function head comment during development.  Anyway, if we do get an
> > error here, we cannot handle it anyway - it's too late to do
> > anything short of a complete shutdown as we've already written the
> > transaction to the log.
> 
> Well I guess it should be unconditional BUG_ON then.

Don't be silly. A filesystem shutdown is all that is necessary,
especially as the XFS shutdown procedure has hooks to turn
corruption events into system panics if the admin wants to configure
it that way (generally useful for triggering crash dumps on
corruption events for offline triage).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
