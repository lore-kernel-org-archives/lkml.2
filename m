Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0DRVy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 17:54:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54722 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab0DRVy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 17:54:57 -0400
Date: Sun, 18 Apr 2010 14:54:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 02/16] rcu: make dead code really dead
Message-ID: <20100418215452.GK3096@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1271355219-20714-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100415235251.GA2491@feather>
 <20100416142348.GD2615@linux.vnet.ibm.com>
 <20100416211610.GA8357@feather>
 <20100416222927.GP2615@linux.vnet.ibm.com>
 <20100417045326.GA11604@feather>
 <20100418011213.GF2876@linux.vnet.ibm.com>
 <20100418035309.GA20129@feather>
 <20100418134217.GC3096@linux.vnet.ibm.com>
 <20100418211215.GA25720@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418211215.GA25720@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oN Sun, Apr 18, 2010 at 02:12:16PM -0700, Josh Triplett wrote:
> On Sun, Apr 18, 2010 at 06:42:17AM -0700, Paul E. McKenney wrote:
> > On Sat, Apr 17, 2010 at 08:53:09PM -0700, Josh Triplett wrote:
> > > On Sat, Apr 17, 2010 at 06:12:13PM -0700, Paul E. McKenney wrote:
> > > > On Fri, Apr 16, 2010 at 09:53:27PM -0700, Josh Triplett wrote:
> > > > > On Fri, Apr 16, 2010 at 03:29:27PM -0700, Paul E. McKenney wrote:
> > > > > > On Fri, Apr 16, 2010 at 02:16:10PM -0700, Josh Triplett wrote:
> > > > > > > On Fri, Apr 16, 2010 at 07:23:48AM -0700, Paul E. McKenney wrote:
> > > > > > > > On Thu, Apr 15, 2010 at 04:52:52PM -0700, Josh Triplett wrote:
> > > > > > > > > On Thu, Apr 15, 2010 at 11:13:25AM -0700, Paul E. McKenney wrote:
> > > > > > > > > > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > > > > > > > 
> > > > > > > > > > cleanup: make dead code really dead
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > > > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > > > > > ---
> > > > > > > > > >  kernel/rcutree.c |    4 ++--
> > > > > > > > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > > > > > > index e54c123..6042fb8 100644
> > > > > > > > > > --- a/kernel/rcutree.c
> > > > > > > > > > +++ b/kernel/rcutree.c
> > > > > > > > > > @@ -1236,11 +1236,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
> > > > > > > > > >  		break; /* grace period idle or initializing, ignore. */
> > > > > > > > > >  
> > > > > > > > > >  	case RCU_SAVE_DYNTICK:
> > > > > > > > > > -
> > > > > > > > > > -		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> > > > > > > > > >  		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
> > > > > > > > > >  			break; /* So gcc recognizes the dead code. */
> > > > > > > > > 
> > > > > > > > > GCC's new __builtin_unreachable would help here, though obviously we
> > > > > > > > > can't count on 4.5 or newer quite yet.  A wrapper in compiler.h would
> > > > > > > > > let us use it when available though.
> > > > > > > > 
> > > > > > > > So at some time when we can count on gcc 4.5 or newer, the code
> > > > > > > > would look something like the following?
> > > > > > > > 
> > > > > > > > 	if (RCU_SIGNAL_INIT == RCU_SAVE_DYNTICK)
> > > > > > > > 		this_is_unreachable();
> > > > > > > 
> > > > > > > Yes, exactly.
> > > > > > > 
> > > > > > > > I suppose that in the meantime one could supply the code to use
> > > > > > > > in the unreachable case:
> > > > > > > > 
> > > > > > > > 	if (RCU_SIGNAL_INIT == RCU_SAVE_DYNTICK)
> > > > > > > > 		this_is_unreachable(break);
> > > > > > > > 
> > > > > > > > But this is beginning to seem a bit strained to me.  ;-)
> > > > > > > 
> > > > > > > I'd suggest spelling that this way:
> > > > > > > 
> > > > > > > 	if (RCU_SIGNAL_INIT == RCU_SAVE_DYNTICK) {
> > > > > > > 		unreachable();
> > > > > > > 		break;
> > > > > > > 	}
> > > > > > > 
> > > > > > > But in any case, all of these do seem excessive just to avoid the need
> > > > > > > for an ifdef. :)
> > > > > > 
> > > > > > Actually, the "if" condition is a comparison of numerical constants,
> > > > > > so no #ifdef is required.
> > > > > 
> > > > > I just meant that those constants get #defined based on CONFIG_NO_HZ, so
> > > > > an #ifdef on that would remove the need for the special handling of dead
> > > > > code.
> > > > 
> > > > True, I could put a #ifdef CONFIG_NO_HZ around that leg of the switch
> > > > statement.  Or am I still missing your point?
> > > 
> > > No, you got it exactly.  Hence my suggesting that all the other
> > > alternatives (the if with a break, or with __builtin_unreachable) seemed
> > > excessive just to try to convince the compiler to infer what an ifdef
> > > would tell it explicitly. :)
> > 
> > Which is exactly the purpose of the "if" statement comparing the two
> > constants, right?  ;-)
> 
> Right, which also seems excessive compared to an ifdef, since it serves
> the same purpose but more confusingly. ;)

Well, I must confess that it confused me when I added the spin_unlock()...

							Thanx, Paul
