Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab2FOW6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:58:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36443 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab2FOW6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:58:47 -0400
Date: Fri, 15 Jun 2012 15:57:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 14/14] rcu: Fix rcu_is_cpu_idle() #ifdef in
 TINY_RCU
Message-ID: <20120615225749.GQ2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615212827.GR31184@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615212827.GR31184@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061522-4242-0000-0000-000001FB5C4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:28:28PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 01:13:15PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The rcu_is_cpu_idle() function is used if CONFIG_DEBUG_LOCK_ALLOC,
> > but TINY_RCU defines it only when CONFIG_PROVE_RCU.  This causes
> > build failures when CONFIG_DEBUG_LOCK_ALLOC=y but CONFIG_PROVE_RCU=n.
> > This commit therefore adjusts the #ifdefs for rcu_is_cpu_idle() so
> > that it is defined when CONFIG_DEBUG_LOCK_ALLOC=y.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Given that an earlier patch in this series makes rcupdate.h
> unconditionally prototype rcu_is_cpu_idle, shouldn't rcutiny.c define it
> unconditionally?  (And do so before the earlier patch in this series
> makes it available unconditionally?)

Or update that earlier patch so that it keeps rcu_is_cpu_idle() under
#ifdef CONFIG_DEBUG_LOCK_ALLOC.  Either way, good catch!

Hmmm...  I want it under CONFIG_DEBUG_LOCK_ALLOC for TINY_RCU (memory
footprint and all that), but unconditional for TREE_RCU.  That can
be arranged...

						Thanx, Paul

> - Josh Triplett
> 
> >  kernel/rcutiny.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> > index 37a5444..547b1fe 100644
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -172,7 +172,7 @@ void rcu_irq_enter(void)
> >  	local_irq_restore(flags);
> >  }
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  
> >  /*
> >   * Test whether RCU thinks that the current CPU is idle.
> > @@ -183,7 +183,7 @@ int rcu_is_cpu_idle(void)
> >  }
> >  EXPORT_SYMBOL(rcu_is_cpu_idle);
> >  
> > -#endif /* #ifdef CONFIG_PROVE_RCU */
> > +#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> >  
> >  /*
> >   * Test whether the current CPU was interrupted from idle.  Nested
> > -- 
> > 1.7.8
> > 
> 

