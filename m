Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0DQFDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 01:03:31 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57733 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0DQFDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 01:03:30 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2010 01:03:29 EDT
X-Originating-IP: 217.70.178.42
X-Originating-IP: 173.50.255.69
Date: Fri, 16 Apr 2010 21:53:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 02/16] rcu: make dead code really dead
Message-ID: <20100417045326.GA11604@feather>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
 <1271355219-20714-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100415235251.GA2491@feather>
 <20100416142348.GD2615@linux.vnet.ibm.com>
 <20100416211610.GA8357@feather>
 <20100416222927.GP2615@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416222927.GP2615@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:29:27PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 16, 2010 at 02:16:10PM -0700, Josh Triplett wrote:
> > On Fri, Apr 16, 2010 at 07:23:48AM -0700, Paul E. McKenney wrote:
> > > On Thu, Apr 15, 2010 at 04:52:52PM -0700, Josh Triplett wrote:
> > > > On Thu, Apr 15, 2010 at 11:13:25AM -0700, Paul E. McKenney wrote:
> > > > > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > > 
> > > > > cleanup: make dead code really dead
> > > > > 
> > > > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > ---
> > > > >  kernel/rcutree.c |    4 ++--
> > > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > index e54c123..6042fb8 100644
> > > > > --- a/kernel/rcutree.c
> > > > > +++ b/kernel/rcutree.c
> > > > > @@ -1236,11 +1236,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
> > > > >  		break; /* grace period idle or initializing, ignore. */
> > > > >  
> > > > >  	case RCU_SAVE_DYNTICK:
> > > > > -
> > > > > -		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> > > > >  		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
> > > > >  			break; /* So gcc recognizes the dead code. */
> > > > 
> > > > GCC's new __builtin_unreachable would help here, though obviously we
> > > > can't count on 4.5 or newer quite yet.  A wrapper in compiler.h would
> > > > let us use it when available though.
> > > 
> > > So at some time when we can count on gcc 4.5 or newer, the code
> > > would look something like the following?
> > > 
> > > 	if (RCU_SIGNAL_INIT == RCU_SAVE_DYNTICK)
> > > 		this_is_unreachable();
> > 
> > Yes, exactly.
> > 
> > > I suppose that in the meantime one could supply the code to use
> > > in the unreachable case:
> > > 
> > > 	if (RCU_SIGNAL_INIT == RCU_SAVE_DYNTICK)
> > > 		this_is_unreachable(break);
> > > 
> > > But this is beginning to seem a bit strained to me.  ;-)
> > 
> > I'd suggest spelling that this way:
> > 
> > 	if (RCU_SIGNAL_INIT == RCU_SAVE_DYNTICK) {
> > 		unreachable();
> > 		break;
> > 	}
> > 
> > But in any case, all of these do seem excessive just to avoid the need
> > for an ifdef. :)
> 
> Actually, the "if" condition is a comparison of numerical constants,
> so no #ifdef is required.

I just meant that those constants get #defined based on CONFIG_NO_HZ, so
an #ifdef on that would remove the need for the special handling of dead
code.

- Josh Triplett
