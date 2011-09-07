Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab1IGQTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:19:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56940 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab1IGQTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:19:01 -0400
Date: Wed, 7 Sep 2011 06:44:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, anton@samba.org,
        paulus@samba.org
Subject: Re: [PATCH tip/core/rcu 55/55] powerpc: Work around tracing from
 dyntick-idle mode
Message-ID: <20110907134400.GJ3610@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-55-git-send-email-paulmck@linux.vnet.ibm.com>
 <1315389622.26118.17.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315389622.26118.17.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 07:00:22AM -0300, Benjamin Herrenschmidt wrote:
> On Tue, 2011-09-06 at 11:00 -0700, Paul E. McKenney wrote:
> > PowerPC LPAR's __trace_hcall_exit() can invoke event tracing at a
> > point where RCU has been told that the CPU is in dyntick-idle mode.
> > Because event tracing uses RCU, this can result in failures.
> > 
> > A correct fix would arrange for RCU to be told about dyntick-idle
> > mode after tracing had completed, however, this will require some care
> > because it appears that __trace_hcall_exit() can also be called from
> > non-dyntick-idle mode.
> 
> This obviously needs to be fixed properly. hcall tracing is very useful
> and if I understand your patch properly, it just comments it out :-)

That is exactly what it does, and I completely agree that this patch
is nothing but a short-term work-around to allow my RCU tests to find
other bugs.

> I'm not sure what the best approach is, maybe have the hcall tracing
> test for the dyntick-idle mode and skip tracing in that case ?

Another approach would be to update Frederic Weisbecker's patch at:

	https://lkml.org/lkml/2011/8/20/83

so that powerpc does tick_nohz_enter_idle(false), and then uses
rcu_enter_nohz() explicitly just after doing the hcall tracing.
If pseries is the only powerpc architecture requiring this, then
the argument to tick_nohz_enter_idle() could depend on the powerpc
sub-architecture.

The same thing would be needed for tick_nohz_exit_idle() and
rcu_exit_nohz(): powerpc would need to invoke rcu_exit_nohz() after
gaining control from the hypervisor but before doing its first tracing,
and then it would need the idle loop to to tick_nohz_exit_idle(false).
Again, if pseries is the only powerpc architecture requiring this,
the argument to tick_nohz_exit_idle() could depend on the architecture.

Would this approach work?

							Thanx, Paul

> Cheers,
> Ben.
> 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: anton@samba.org
> > Cc: benh@kernel.crashing.org
> > Cc: paulus@samba.org
> > ---
> >  arch/powerpc/platforms/pseries/lpar.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
> > index 39e6e0a..668f300 100644
> > --- a/arch/powerpc/platforms/pseries/lpar.c
> > +++ b/arch/powerpc/platforms/pseries/lpar.c
> > @@ -715,12 +715,14 @@ EXPORT_SYMBOL(arch_free_page);
> >  /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
> >  extern long hcall_tracepoint_refcount;
> >  
> > +#if 0 /* work around buggy use of RCU from dyntick-idle mode */
> >  /* 
> >   * Since the tracing code might execute hcalls we need to guard against
> >   * recursion. One example of this are spinlocks calling H_YIELD on
> >   * shared processor partitions.
> >   */
> >  static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
> > +#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
> >  
> >  void hcall_tracepoint_regfunc(void)
> >  {
> > @@ -734,6 +736,7 @@ void hcall_tracepoint_unregfunc(void)
> >  
> >  void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
> >  {
> > +#if 0 /* work around buggy use of RCU from dyntick-idle mode */
> >  	unsigned long flags;
> >  	unsigned int *depth;
> >  
> > @@ -750,11 +753,13 @@ void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
> >  
> >  out:
> >  	local_irq_restore(flags);
> > +#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
> >  }
> >  
> >  void __trace_hcall_exit(long opcode, unsigned long retval,
> >  			unsigned long *retbuf)
> >  {
> > +#if 0 /* work around buggy use of RCU from dyntick-idle mode */
> >  	unsigned long flags;
> >  	unsigned int *depth;
> >  
> > @@ -771,6 +776,7 @@ void __trace_hcall_exit(long opcode, unsigned long retval,
> >  
> >  out:
> >  	local_irq_restore(flags);
> > +#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
> >  }
> >  #endif
> >  
> 
> 
