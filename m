Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1EBIdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:33:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50550 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1EBIdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:33:08 -0400
Date: Mon, 2 May 2011 01:33:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 17/86] rcu: fix boost-tracing bug and
 update tracing documentation
Message-ID: <20110502083301.GY2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501154310.GD14829@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501154310.GD14829@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:43:10AM -0700, Josh Triplett wrote:
> The bugfix here should really go in a separate commit from the updated
> documentation.  Also:
> 
> On Sun, May 01, 2011 at 06:20:57AM -0700, Paul E. McKenney wrote:
> > --- a/Documentation/RCU/trace.txt
> > +++ b/Documentation/RCU/trace.txt
> > @@ -10,34 +10,37 @@ for rcutree and next for rcutiny.
> >  
> >  CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
> >  
> > -These implementations of RCU provides five debugfs files under the
> > +These implementations of RCU provides seven debugfs files under the
> 
> s/seven/several/, so this doesn't continue to need updates as you add
> more tracing?  It doesn't seem entirely accurate even now, given that
> the set of files available now depends on CONFIG_RCU_BOOST.

Good point, will fix.

> >  top-level directory RCU: rcu/rcudata (which displays fields in struct
> 
> RCU or rcu?

Indeed, "rcu".  Will fix.

> >  rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
> >  rcu/rcudata), rcu/rcugp (which displays grace-period counters),
> > -rcu/rcuhier (which displays the struct rcu_node hierarchy), and
> > +rcu/rcuhier (which displays the struct rcu_node hierarchy),
> >  rcu/rcu_pending (which displays counts of the reasons that the
> > -rcu_pending() function decided that there was core RCU work to do).
> > +rcu_pending() function decided that there was core RCU work to do),
> > +rcu/rcutorture (which displays rcutorture test progress), and, if the
> > +kernel is built with CONFIG_RCU_BOOST, rcu/rcuboost (which displays RCU
> > +boosting statistics).
> 
> I think this would work better as a list:
> 
> rcu/rcudata:
>     Displays fields in struct rcu_data.
> rcu/rcudata.csv:
>     Comma-separated values spreadsheet version of rcudata.
> rcu/rcugp:
>     Displays grace-period counters.
> rcu/rcuhier
>     Displays the struct rcu_node hierarchy.
> rcu/rcu_pending:
>     Displays counts of the reasons rcu_pending() decided that RCU had
>     work to do.
> rcu/rcutorture:
>     Displays rcutorture test progress.
> rcu/rcuboost
>     Displays RCU boosting statistics. Only present if
>     CONFIG_RCU_BOOST=y.
> 
> Feel free to put the descriptions on the same lines as the filenames if
> you prefer; however, I thought this style worked better for the
> descriptions longer than one line.

Makes sense, will do a list.

> Also, does rcu/rcutorture appear with rcutorture not loaded?  Hopefully
> not, since rcutorture shouldn't take up any additional resources when
> not loaded.

Not much choice, unfortunately.  If I put the info into rcutorture, then
I lose it when rcutorture is unloaded.  This is problematic in automated
tests that repeatedly load and unload rcutorture.

But the amount of data is small, and I set things up so that TINY_RCU
can omit this.  TREE_RCU is big enough that it doesn't really matter.

> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -1086,7 +1086,7 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
> >  	else if (rnp->gp_tasks != NULL && rnp->qsmask != 0)
> >  		rnp->n_balk_notblocked++;
> >  	else if (rnp->gp_tasks != NULL &&
> > -		 ULONG_CMP_GE(jiffies, rnp->boost_time))
> > +		 ULONG_CMP_LT(jiffies, rnp->boost_time))
> >  		rnp->n_balk_notyet++;
> >  	else
> >  		rnp->n_balk_nos++;
> 
> This bugfix should go in a separate commit.

Excellent point, will fix.

							Thanx, Paul
