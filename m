Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0I2NLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:11:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37103 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab0I2NLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uLlE2N4bgtYQ52LbWQ8QE33E4bXWZnF6OENzytjksFVw69T/NPmOowkPjBtOeGw6Zn
         QIApEzP2k8S/XaFb8YJPVNcetgU2DWNLX/4qAqziiAcAgkrgBzzbStMszkm+laaDSzQ8
         5vyjhl1o6oH52kSE95+RAK/jWFQVNL9LajcT4=
Date: Wed, 29 Sep 2010 15:11:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH -tip -v6] irq_work: generic hard-irq context callbacks
Message-ID: <20100929131052.GA5602@nowhere>
References: <1285663908.20791.286.camel@yhuang-dev> <20100928155609.GA5354@nowhere> <AANLkTinO6rOmKhQGP9jqN_qaA5bweeXy3bwdDwt9FToG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinO6rOmKhQGP9jqN_qaA5bweeXy3bwdDwt9FToG@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 04:29:52PM +0800, huang ying wrote:
> Hi, Frederic,
> 
> On Tue, Sep 28, 2010 at 11:56 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > On Tue, Sep 28, 2010 at 04:51:48PM +0800, Huang Ying wrote:
> >> +++ b/arch/x86/kernel/irq_work.c
> >> @@ -0,0 +1,30 @@
> >> +/*
> >> + * x86 specific code for irq_work
> >> + *
> >> + * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
> >> + */
> >> +
> >> +#include <linux/kernel.h>
> >> +#include <linux/irq_work.h>
> >> +#include <linux/hardirq.h>
> >> +#include <asm/apic.h>
> >> +
> >> +void smp_irq_work_interrupt(struct pt_regs *regs)
> >> +{
> >> +     irq_enter();
> >> +     ack_APIC_irq();
> >> +     inc_irq_stat(apic_irq_work_irqs);
> >> +     irq_work_run();
> >> +     irq_exit();
> >> +}
> >> +
> >> +void arch_irq_work_raise(void)
> >> +{
> >> +#ifdef CONFIG_X86_LOCAL_APIC
> >> +     if (!cpu_has_apic)
> >> +             return;
> >> +
> >> +     apic->send_IPI_self(IRQ_WORK_VECTOR);
> >> +     apic_wait_icr_idle();
> >> +#endif
> >> +}
> >
> >
> >
> > So basically, CONFIG_X86_LOCAL_APIC == !HAVE_IRQ_WORK ?
> >
> > But IIUC, this will fallback to the timer interrupt:
> 
> If !CONFIG_X86_LOCAL_APIC or !cpu_has_apic, this will fallback to the
> timer interrupt.


Ah right, there is cpu_has_apic, so we may need the dynamic and adaptive
fallback. May be cpu_has_apic only appears on very particular configs though,
so that we can narrow down this situation statically?


 
> >> @@ -1279,7 +1279,10 @@ void update_process_times(int user_tick)
> >>       run_local_timers();
> >>       rcu_check_callbacks(cpu, user_tick);
> >>       printk_tick();
> >> -     perf_event_do_pending();
> >> +#ifdef CONFIG_IRQ_WORK
> >> +     if (in_irq())
> >> +             irq_work_run();
> >> +#endif
> >>       scheduler_tick();
> >>       run_posix_cpu_timers(p);
> >>  }
> >
> > Then HAVE_IRQ_WORK just means that the arch supports self IPIs.
> 
> HAVE_IRQ_WORK means IRQ_WORK is supported on the architecture, it has
> nothing to do with self IPIs.


Ok, but IRQ_WORK is always supported on the architecture because of
the fallback. It seems that archs enable HAVE_IRQ_WORK when they find
an optimization (self IPIs in x86, other shortcuts in other archs), but
these optimizations never change the core code anyway, right?
It would have been nice to avoid building the fallback when the archs can
already manage the path by themselves.

