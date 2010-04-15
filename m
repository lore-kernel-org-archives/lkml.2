Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0DORkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:40:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0DORkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:40:10 -0400
Date: Thu, 15 Apr 2010 19:39:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: PowerPC WARN_ON_ONCE() after merge of the final tree
 (tip related)
Message-ID: <20100415173955.GA10881@elte.hu>
References: <20100415161214.04637496.sfr@canb.auug.org.au>
 <20100415064940.GA9240@elte.hu>
 <20100415130032.GA6789@nowhere>
 <20100415140358.GA19981@elte.hu>
 <20100415172421.GB5069@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415172421.GB5069@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Apr 15, 2010 at 04:03:58PM +0200, Ingo Molnar wrote:
> > > 
> > > 
> > > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > > index 78325f8..65d4336 100644
> > > --- a/kernel/lockdep.c
> > > +++ b/kernel/lockdep.c
> > > @@ -2298,7 +2298,11 @@ void trace_hardirqs_on_caller(unsigned long ip)
> > >  		return;
> > >  
> > >  	if (unlikely(curr->hardirqs_enabled)) {
> > > +		unsigned long flags;
> > > +
> > > +		raw_local_irq_save(flags);
> > >  		debug_atomic_inc(redundant_hardirqs_on);
> > > +		raw_local_irq_restore(flags);
> > >  		return;
> > >  	}
> > >  	/* we'll do an OFF -> ON transition: */
> > 
> > that looks rather ugly. Why not do a raw:
> > 
> > 	this_cpu_inc(lockdep_stats.redundant_hardirqs_on);
> > 
> > which basically open-codes debug_atomic_inc(), but without the warning?
> 
> 
> There is also no guarantee we are in a non-preemptable section. We can then
> also race against another cpu.
> 
> I'm not sure what to do.

it's a statistics counter so worst-case we lose a count. It's not a real issue 
- but might be worth adding a comment.

	Ingo
