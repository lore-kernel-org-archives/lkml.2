Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1D3M7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:59:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58830 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1D3M7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:59:30 -0400
Date: Sat, 30 Apr 2011 05:59:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110430125928.GJ2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
 <20110429083618.GL2191@linux.vnet.ibm.com>
 <20110429083904.GA12987@linux.vnet.ibm.com>
 <20110429180239.GA32566@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429180239.GA32566@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 09:02:39PM +0300, Gleb Natapov wrote:
> On Fri, Apr 29, 2011 at 01:39:04AM -0700, Paul E. McKenney wrote:
> > On Fri, Apr 29, 2011 at 01:36:18AM -0700, Paul E. McKenney wrote:
> > > On Thu, Apr 28, 2011 at 12:52:02PM +0300, Gleb Natapov wrote:
> > > 
> > > Hmmm....  This is interesting.  KVM being a module, we either expand
> > > TINY_RCU's size a bit by making rcu_note_context_switch() be a real
> > > function in rcutiny.c and adding an export, or we expand it by adding
> > > two exports.
> > > 
> > > I would like to solve this without making TINY_RCU larger, and preferably
> > > by making it smaller.  Any ideas come to mind?  (Other than making
> > > KVM depend on CONFIG_SMP, which sounds too much like throwing out the
> > > baby with the bathwater.)
> > 
> > Nothing quite like hitting "send" to make an idea show up...
> > 
> > In a UP kernel, does it actually help anything to have KVM
> > tell RCU about executing in a guest?  If not, could we have a
> > rcu_note_context_switch_kvm() that is a static inline empty function in
> > TINY_RCU and maps to rcu_note_context_switch() for TREE_RCU?
> > 
> That will work, but does making rcu_note_context_switch() out of line
> actually increase kernel size? The function is called in two places
> currently, so by making it out of line we make two calling site smaller.
> Will measure it next week.

One thing to keep in mind...  Calling an out-of-line function from
KVM requires an export, each of which significantly increases TINY_RCU's
memory footprint.

							Thanx, Paul

> > > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > > > ---
> > > >  include/linux/rcutiny.h |    6 +-----
> > > >  kernel/rcutiny.c        |    7 +++++++
> > > >  kernel/rcutree.c        |    1 +
> > > >  3 files changed, 9 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> > > > index 30ebd7c..8e5f7cf 100644
> > > > --- a/include/linux/rcutiny.h
> > > > +++ b/include/linux/rcutiny.h
> > > > @@ -93,11 +93,7 @@ static inline int rcu_needs_cpu(int cpu)
> > > > 
> > > >  #endif /* #else #ifdef CONFIG_TINY_RCU */
> > > > 
> > > > -static inline void rcu_note_context_switch(int cpu)
> > > > -{
> > > > -	rcu_sched_qs(cpu);
> > > > -	rcu_preempt_note_context_switch();
> > > > -}
> > > > +extern void rcu_note_context_switch(int cpu);
> > > > 
> > > >  /*
> > > >   * Return the number of grace periods.
> > > > diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> > > > index 0c343b9..3d715a4 100644
> > > > --- a/kernel/rcutiny.c
> > > > +++ b/kernel/rcutiny.c
> > > > @@ -78,6 +78,13 @@ void rcu_exit_nohz(void)
> > > > 
> > > >  #endif /* #ifdef CONFIG_NO_HZ */
> > > > 
> > > > +void rcu_note_context_switch(int cpu)
> > > > +{
> > > > +	rcu_sched_qs(cpu);
> > > > +	rcu_preempt_note_context_switch();
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(rcu_note_context_switch);
> > > > +
> > > >  /*
> > > >   * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
> > > >   * Also disable irqs to avoid confusion due to interrupt handlers
> > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > index dd4aea8..0837d63 100644
> > > > --- a/kernel/rcutree.c
> > > > +++ b/kernel/rcutree.c
> > > > @@ -124,6 +124,7 @@ void rcu_note_context_switch(int cpu)
> > > >  	rcu_sched_qs(cpu);
> > > >  	rcu_preempt_note_context_switch(cpu);
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(rcu_note_context_switch);
> > > > 
> > > >  #ifdef CONFIG_NO_HZ
> > > >  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
> > > > -- 
> > > > 1.7.2.3
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> 			Gleb.
