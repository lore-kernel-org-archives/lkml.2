Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2EVGVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:21:43 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44060 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2EVGVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:21:42 -0400
Date: Tue, 22 May 2012 14:21:27 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: Re: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with
 irq disabled
Message-ID: <20120522062126.GB12098@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
 <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
 <4FBA1B54.3@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBA1B54.3@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:09:16PM +0530, Srivatsa S. Bhat wrote:
> On 05/21/2012 11:30 AM, Yong Zhang wrote:
> 
> > From: Yong Zhang <yong.zhang@windriver.com>
> > 
> > To prevent a problem as commit 5fbd036b [sched: Cleanup cpu_active madness]
> > and commit 2baab4e9 [sched: Fix select_fallback_rq() vs cpu_active/cpu_online]
> > try to resolve, move set_cpu_online() to the brought up CPU and with irq
> > disabled.
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Acked-by: David Daney <david.daney@cavium.com>
> > ---
> >  arch/mips/kernel/smp.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> > index 73a268a..042145f 100644
> > --- a/arch/mips/kernel/smp.c
> > +++ b/arch/mips/kernel/smp.c
> > @@ -122,6 +122,8 @@ asmlinkage __cpuinit void start_secondary(void)
> > 
> >  	notify_cpu_starting(cpu);
> > 
> > +	set_cpu_online(cpu, true);
> > +
> 
> 
> You will also need to use ipi_call_lock/unlock() around this.
> See how x86 does it. (MIPS also selects USE_GENERIC_SMP_HELPERS).

Hmm... But look at the comments in arch/x86/kernel/smpboot.c::start_secondary()

start_secondary()
{
	...
        /*   
         * We need to hold call_lock, so there is no inconsistency
         * between the time smp_call_function() determines number of
         * IPI recipients, and the time when the determination is made
         * for which cpus receive the IPI. Holding this
         * lock helps us to not include this cpu in a currently in progress
         * smp_call_function().
         *
         * We need to hold vector_lock so there the set of online cpus
         * does not change while we are assigning vectors to cpus.  Holding
         * this lock ensures we don't half assign or remove an irq from a cpu.
         */
        ipi_call_lock();
        lock_vector_lock();
        set_cpu_online(smp_processor_id(), true);
        unlock_vector_lock();
        ipi_call_unlock();

	...
}

which ipi_call_lock()/ipi_call_unlock() is to pretect race with concurrent 
smp_call_function(), but it seems that is already broken, because

1) The comments is alread there before we switch to generic smp helper(commit
   3b16cf87), and at that time the comments is true because
   smp_call_function_interrupt() doesn't test if a cpu should handle the
   IPI interrupt.
   But in the gereric smp helper, we have checked if a cpu should handle the IPI
   in generic_smp_call_function_interrupt():
   	if (!cpumask_test_cpu(cpu, data->cpumask))
		continue;

2) call_function.lock used in smp_call_function_many() is just to protect
   call_function.queue and &data->refs, cpu_online_mask is outside of the
   lock. And I don't think it's necessary to protect cpu_online_mask,
   because data->cpumask is pre-calculate and even if a cpu is brougt up
   when calling arch_send_call_function_ipi_mask(), it's harmless because
   validation test in generic_smp_call_function_interrupt() will take care
   of it.

3) For cpu down issue, stop_machine() will guarantee that no concurrent
   smp_call_fuction() is processing.

So it seems ipi_call_lock()/ipi_call_unlock() is not needed and could be
removed IMHO.
Or am I missing something?

Thanks,
Yong

