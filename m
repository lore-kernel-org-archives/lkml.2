Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1EMHS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:18:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60085 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab1EMHSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:18:55 -0400
Date: Fri, 13 May 2011 00:18:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.39-rc6-mmotm0506 - lockdep splat in RCU code on page fault
Message-ID: <20110513071850.GU2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <6921.1304989476@localhost>
 <20110510082029.GF2258@linux.vnet.ibm.com>
 <34783.1305155494@localhost>
 <20110512094704.GL2258@linux.vnet.ibm.com>
 <5817.1305216324@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5817.1305216324@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:05:24PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 12 May 2011 02:47:05 PDT, "Paul E. McKenney" said:
> > On Wed, May 11, 2011 at 07:11:34PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > My source has this:
> > >
> > >         raw_spin_lock_irqsave(&rnp->lock, flags);
> > >         rnp->wakemask |= rdp->grpmask;
> > >         invoke_rcu_node_kthread(rnp);
> > >         raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > >
> > > the last 2 lines swapped from what you diffed against.  I can easily work around
> > > that, except it's unclear what the implications of the invoke_rcu moving outside
> > > of the irq save/restore pair (or if it being inside is the actual root cause)...
> >
> > Odd...
> >
> > This looks to me like a recent -next -- I do not believe that straight
> > mmotm has rcu_cpu_kthread_timer() in it.  The patch should apply to the
> > last few days' -next kernels.
> 
> Ah. Found it. Your tree and current linux-next include this commit:
> 
> commit	1217ed1ba5c67393293dfb0f03c353b118dadeb4
> tree	a765356c8418e134de85fd05d9fe6eda41de859c	tree | snapshot
> parent	29ce831000081dd757d3116bf774aafffc4b6b20	commit | diff
> rcu: permit rcu_read_unlock() to be called while holding runqueue locks
> 
> which includes this chunk:
> 
> @@ -1546,8 +1531,8 @@ static void rcu_cpu_kthread_timer(unsigned long arg)
> 
>         raw_spin_lock_irqsave(&rnp->lock, flags);
>         rnp->wakemask |= rdp->grpmask;
> -       invoke_rcu_node_kthread(rnp);
>         raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +       invoke_rcu_node_kthread(rnp);
>  }
> 
> 
> but that was committed 4 days ago, and Andrew pulled linux-next for the -mmotm
> 6 days ago, so it's not in there.  The *rest* of your recent commits appear to
> be in there though.  So that explains the patch failure to apply.

Whew!!!  ;-)

							Thanx, Paul
