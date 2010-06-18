Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059Ab0FRL4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:56:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761036Ab0FRL4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:56:07 -0400
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 13:55:30 +0200
Message-ID: <1276862130.1875.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-12 at 17:28 +0800, Huang Ying wrote:
> +#define NMI_DELAYED_CALL_ID_MAX                32
> +#define NMI_DELAYED_CALL_RESTART_MAX   5
> +
> +static nmi_delayed_call_func_t nmi_delayed_call_funcs[NMI_DELAYED_CALL_ID_MAX];
> +static DEFINE_SPINLOCK(nmi_delayed_call_lock);
> +
> +static DEFINE_PER_CPU(unsigned long, nmi_delayed_call_pending);
> +
> +static void nmi_delayed_call_run(void)
> +{
> +       int cpu, restart = NMI_DELAYED_CALL_RESTART_MAX;
> +       unsigned long pending, *ppending;
> +       nmi_delayed_call_func_t *pfunc, func;
> +
> +       cpu = smp_processor_id();
> +       ppending = per_cpu_ptr(&nmi_delayed_call_pending, cpu);
> +       while (*ppending && restart--) {
> +               pending = xchg(ppending, 0);
> +               pfunc = nmi_delayed_call_funcs;
> +               do {
> +                       if (pending & 1) {
> +                               func = *pfunc;
> +                               if (func)
> +                                       func();
> +                       }
> +                       pfunc++;
> +                       pending >>= 1;
> +               } while (pending);
> +       }
> +}

So aside from the should this be perf or not, the above is utter
gibberish. Whoever came up with this nonsense?

Why not make a work_struct like thing and enqueue it using cmpxchg on a
percpu list, then have the interrupt process them. Read
perf_pending_queue() and __perf_pending_run().

That way you don't need this whole register/id/limit crap.

> +#ifdef CONFIG_X86_LOCAL_APIC

What's the point of the rest of this code if we don't have a lapic?

> +asmlinkage void smp_nmi_delayed_call_interrupt(struct pt_regs *regs)
> +{
> +       ack_APIC_irq();
> +       irq_enter();

You're missing inc_irq_stat() there.

> +       nmi_delayed_call_run();
> +       irq_exit();
> +}
> +#endif 
