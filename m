Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2FRROF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:14:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35690 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2FRROC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:14:02 -0400
Date: Mon, 18 Jun 2012 10:05:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 09/10] POWERPC: smp: remove call to
 ipi_call_lock()/ipi_call_unlock()
Message-ID: <20120618170554.GE2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
 <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
 <20120616163219.GI2420@linux.vnet.ibm.com>
 <20120618025159.GA24420@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618025159.GA24420@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061817-7182-0000-0000-000001C48DAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 10:51:59AM +0800, Yong Zhang wrote:
> On Sat, Jun 16, 2012 at 09:32:19AM -0700, Paul E. McKenney wrote:
> > On Tue, May 29, 2012 at 03:16:04PM +0800, Yong Zhang wrote:
> > > From: Yong Zhang <yong.zhang@windriver.com>
> > > 
> > > 1) call_function.lock used in smp_call_function_many() is just to protect
> > >    call_function.queue and &data->refs, cpu_online_mask is outside of the
> > >    lock. And it's not necessary to protect cpu_online_mask,
> > >    because data->cpumask is pre-calculate and even if a cpu is brougt up
> > >    when calling arch_send_call_function_ipi_mask(), it's harmless because
> > >    validation test in generic_smp_call_function_interrupt() will take care
> > >    of it.
> > > 
> > > 2) For cpu down issue, stop_machine() will guarantee that no concurrent
> > >    smp_call_fuction() is processing.
> > 
> > However, there is an effort to get rid of stop_machine() from the
> > CPU-down path...  So something else will be needed.
> 
> Yeah. So Thomas changed the commit log like below:
> [
>     ipi_call_lock/unlock() lock resp. unlock call_function.lock. This lock
>     protects only the call_function data structure itself, but it's
>     completely unrelated to cpu_online_mask. The mask to which the IPIs
>     are sent is calculated before call_function.lock is taken in
>     smp_call_function_many(), so the locking around set_cpu_online() is
>     pointless and can be removed.
>     
>     [ tglx: Massaged changelog ]
> ]
> 
> in tip/smp/hotplug.

Got it, thank you!

							Thanx, Paul

> Thanks,
> Yong
> 
> > 
> > 							Thanx, Paul
> > 
> > > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: linuxppc-dev@lists.ozlabs.org
> > > ---
> > >  arch/powerpc/kernel/smp.c |    2 --
> > >  1 files changed, 0 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> > > index e4cb343..e1417c4 100644
> > > --- a/arch/powerpc/kernel/smp.c
> > > +++ b/arch/powerpc/kernel/smp.c
> > > @@ -571,7 +571,6 @@ void __devinit start_secondary(void *unused)
> > >  	if (system_state == SYSTEM_RUNNING)
> > >  		vdso_data->processorCount++;
> > >  #endif
> > > -	ipi_call_lock();
> > >  	notify_cpu_starting(cpu);
> > >  	set_cpu_online(cpu, true);
> > >  	/* Update sibling maps */
> > > @@ -601,7 +600,6 @@ void __devinit start_secondary(void *unused)
> > >  		of_node_put(np);
> > >  	}
> > >  	of_node_put(l2_cache);
> > > -	ipi_call_unlock();
> > > 
> > >  	local_irq_enable();
> > > 
> > > -- 
> > > 1.7.5.4
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Only stand for myself
> 

