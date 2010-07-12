Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0GLMMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 08:12:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0GLMMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 08:12:39 -0400
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
From: Mike Galbraith <mgalbraith@suse.de>
To: rostedt@goodmis.org
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        linux-rt-users@vger.kernel.org
In-Reply-To: <1278935120.1537.187.camel@gandalf.stny.rr.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
	 <1278790882.7352.101.camel@marge.simson.net>
	 <1278855208.15197.6.camel@marge.simson.net>
	 <1278935120.1537.187.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 12 Jul 2010 14:12:42 +0200
Message-Id: <1278936762.7419.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 07:45 -0400, Steven Rostedt wrote:
> On Sun, 2010-07-11 at 15:33 +0200, Mike Galbraith wrote:
> > On Sat, 2010-07-10 at 21:41 +0200, Mike Galbraith wrote:
> 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index a6cec32..ef489f3 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -2255,7 +2255,14 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
> >  	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
> >  	futex_wait_queue_me(hb, &q, to);
> >  
> > -	spin_lock(&hb->lock);
> > +	/*
> > +	 * Non-blocking synchronization point with futex_requeue().
> > +	 *
> > +	 * We dare not block here because this will alter PI state, possibly
> > +	 * before our waker finishes modifying same in wakeup_next_waiter().
> > +	 */
> > +	while(!spin_trylock(&hb->lock))
> > +		cpu_relax();
> 
> I agree that this would work. But I wonder if this should have an:
> 
> #ifdef PREEMPT_RT
> [...]
> #else
> 	spin_lock(&hb->lock);
> #endif
> 
> around it. Or encapsulate this lock in a macro that does the same thing
> (just to keep the actual code cleaner)

Yeah, it should.  I'll wait to see what Darren/others say about holding
the wakee's pi_lock across wakeup to plug it.  If he submits something
along that line, I can bin this.

	-Mike

