Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2IDWoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:44:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51206 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab2IDWox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:44:53 -0400
Date: Tue, 4 Sep 2012 15:44:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 08/15] rcu: Apply for_each_rcu_flavor() to
 increment_cpu_stall_ticks()
Message-ID: <20120904224442.GS2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831181516.GF4259@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831181516.GF4259@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090422-3534-0000-0000-00000C3DC5B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:15:16AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:56:21AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The increment_cpu_stall_ticks() function listed each RCU flavor
> > explicitly, with an ifdef to handle preemptible RCU.  This commit
> > therefore applies for_each_rcu_flavor() to save a line of code.
> 
> And also mysteriously changes __get_cpu_var to __this_cpu_var without
> documenting that (or the reason for it) in the commit message. :)

Good point!  The change is needed because of the need to switch from
using the given rcu_data per-CPU variable directly to accessing it via
each rcu_state structure's ->rda pointer.  Will update the commit log.

							Thanx, Paul

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_plugin.h |    9 ++++-----
> >  1 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 3ea60c9..139a803 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -2196,11 +2196,10 @@ static void zero_cpu_stall_ticks(struct rcu_data *rdp)
> >  /* Increment ->ticks_this_gp for all flavors of RCU. */
> >  static void increment_cpu_stall_ticks(void)
> >  {
> > -	__get_cpu_var(rcu_sched_data).ticks_this_gp++;
> > -	__get_cpu_var(rcu_bh_data).ticks_this_gp++;
> > -#ifdef CONFIG_TREE_PREEMPT_RCU
> > -	__get_cpu_var(rcu_preempt_data).ticks_this_gp++;
> > -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> > +	struct rcu_state *rsp;
> > +
> > +	for_each_rcu_flavor(rsp)
> > +		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
> >  }
> >  
> >  #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
> > -- 
> > 1.7.8
> > 
> 

