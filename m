Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab2AKQOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:14:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60079 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab2AKQOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:14:47 -0500
Date: Wed, 11 Jan 2012 17:14:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [BUG] kernel freezes with latest tree
Message-ID: <20120111161431.GA1233@elte.hu>
References: <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
 <1326234230.2614.15.camel@edumazet-laptop>
 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
 <4F0D2D9B.8030501@gmail.com>
 <1326272685.2442.120.camel@twins>
 <1326284711.2442.138.camel@twins>
 <20120111155658.GB26659@elte.hu>
 <1326297936.2442.157.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326297936.2442.157.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-01-11 at 16:56 +0100, Ingo Molnar wrote:
> 
> > Well, what happens if every CPU runs load_balance() and we keep 
> > triggering:
> > 
> >                 if (loops++ > sysctl_sched_nr_migrate) {
> >                         *lb_flags |= LBF_NEED_BREAK;
> >                         break;
> >                 }
> > 
> > in this case load_balance() will do the retry:
> > 
> >                 if (lb_flags & LBF_NEED_BREAK) {
> >                         lb_flags &= ~LBF_NEED_BREAK;
> >                         goto redo;
> >                 }
> > 
> > but the retry starts the loop again:
> > 
> >         list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
> > 
> > so nobody is able to make progress: livelock/lockup.
> 
> Ah, right! Silly me. One possibility is to rotate that list, except that
> won't work for the cgroup case where we have another iteration.
> 
> OK, here's an updated patch.. 
> 
> ---
> Subject: sched: Limit load-balance retries on lock-break
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jan 11 13:11:12 CET 2012
> 
> Eric and David reported dead machines and traced it to commit a195f004 ("sched:
> Fix load-balance lock-breaking"), it turns out there's still a
> scenario where we can end up re-trying forever.
> 
> Since there is no strict forward progress guarantee in the
> load-balance iteration we can get stuck re-retrying the same task-set
> over and over.
> 
> Creating a forward progress guarantee with the existing structure is
> somewhat non-trivial, for now simply terminate the retry loop after a
> few tries.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> [eric: logic cleanup]
> Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Link: http://lkml.kernel.org/n/tip-ya9m8grb9wfc26uqnviq2wjq@git.kernel.org
> ---
>  kernel/sched/fair.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Thanks Peter, i'll get this fix to Linus ASAP.

Thanks,

	Ingo
