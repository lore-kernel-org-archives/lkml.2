Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2GTOhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:37:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43489 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2GTOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:37:16 -0400
Date: Fri, 20 Jul 2012 07:36:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/rcutree.c:1550
 __rcu_process_callbacks+0x46f/0x4b0()
Message-ID: <20120720143657.GC2721@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5007F8FA.7000203@linux.vnet.ibm.com>
 <20120719171550.GL2507@linux.vnet.ibm.com>
 <500935BC.4040405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500935BC.4040405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072014-6148-0000-0000-000007D3CC0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 04:11:00PM +0530, Srivatsa S. Bhat wrote:
> On 07/19/2012 10:45 PM, Paul E. McKenney wrote:
> > On Thu, Jul 19, 2012 at 05:39:30PM +0530, Srivatsa S. Bhat wrote:
> >> Hi Paul,
> >>
> >> While running a CPU hotplug stress test on v3.5-rc7+
> >> (mainline commit 8a7298b7805ab) I hit this warning.
> >> I haven't tried to debug this yet...
> >>
> >> Line number 1550 maps to:
> >>
> >> WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
> >>
> >> inside rcu_do_batch().
> > 
> > Hello, Srivatsa,
> > 
> > I believe that you need commit a16b7a69 (Prevent __call_rcu() from
> > invoking RCU core on offline CPUs), which is currently in -tip, queued
> > for 3.6.  Please see below for the patch.
> > 
> > Does this help?
> 
> Yes, that fixed it, thanks! :-)
> Sorry for the noise...

May I add your Tested-by?

							Thanx, Paul

> Regards,
> Srivatsa S. Bhat
> 
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Prevent __call_rcu() from invoking RCU core on offline CPUs
> > 
> > The __call_rcu() function will invoke the RCU core, for example, if
> > it detects that the current CPU has too many callbacks.  However, this
> > can happen on an offline CPU that is on its way to the idle loop, in
> > which case it is an error to invoke the RCU core, and the excess callbacks
> > will be adopted in any case.  This commit therefore adds checks to
> > __call_rcu() for running on an offline CPU, refraining from invoking
> > the RCU core in this case.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index a4a9c91..ceaa959 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1904,11 +1904,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
> >  	 * If called from an extended quiescent state, invoke the RCU
> >  	 * core in order to force a re-evaluation of RCU's idleness.
> >  	 */
> > -	if (rcu_is_cpu_idle())
> > +	if (rcu_is_cpu_idle() && cpu_online(smp_processor_id()))
> >  		invoke_rcu_core();
> > 
> > -	/* If interrupts were disabled, don't dive into RCU core. */
> > -	if (irqs_disabled_flags(flags)) {
> > +	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
> > +	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id())) {
> >  		local_irq_restore(flags);
> >  		return;
> >  	}
> > 

