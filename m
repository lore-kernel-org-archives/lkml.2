Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936800Ab0CPHtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:49:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43031 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab0CPHtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:49:40 -0400
Date: Tue, 16 Mar 2010 08:49:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
Message-ID: <20100316074932.GD18448@elte.hu>
References: <4B990496.4020002@kernel.org>
 <4B9F08AC.9030904@kernel.org>
 <20100316061718.GA22651@elte.hu>
 <4B9F2B0A.70507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F2B0A.70507@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> > Also, why should we make this opt-in and expose a wide range of configs to 
> > build breakages? A more gradual approach would be to write a simple script 
> > that adds a slab.h include to all .c's that include percpu.h, directly or 
> > indirectly.
> >
> > You can map the pattern experimentally: the insertion pattern could be 
> > built from the x86 allmodconfig build you did [i.e. extend the pattern 
> > until you make it build on allmodconfig] - that would cover most cases in 
> > practice (not just allmodconfig) - and would cover most architectures as 
> > well.
> 
> I don't really get the 'experimental' part but if I count all the files 
> which ends up including percpu.h directly or indirectly on allmodconfig it 
> ends up including much more .c files than necessasry - 11203 to be exact, 
> ~20 times more than necessary.  Inclusions from .c files definitely are much 
> less troublesome so the situation would be better than now but we'll still 
> end up with a LOT of bogus inclusions without any good way to eventually 
> remove them.

That raises another problem we have: based on the sanitization of #include 
lines in a couple of files in the past, about 70-80% [+-10%] of all include 
lines are superfluous and duplicative.

So besides include file dependency incest, we have a random #include mess at 
the top of virtually every .c file in the kernel that has been around for more 
than a couple of years.

That too slows down the kernel build.

> Maybe a better way is to grab for slab API usages in .c files which don't 
> have slab.h inclusion.  If breaking the dependency is the way to go, I can 
> definitely write up some scripts and do test builds on some archs.  There 
> sure will be some fallouts but I think it won't be too bad.

Yeah, actual API usages would be quite good as an insertion pattern. I've done 
a good deal of such large-scale conversions in the past, and what worked (for 
me) best was along the lines of:

 - step 1: shoot for an all-tree scripted conversion (which tries to overshoot 
           the target, not under-shoot it)

 - step 2: some good build testing as there's always a few exceptions not 
           worth scripting

The solution you went for is good for an initial prototype, but i'd expect it 
to cause quite some build breakage that will be a shock to the system.

The shock can be avoided i think, with some more work (on your side :-/ ).

Thanks,

	Ingo
