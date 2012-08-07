Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2HGPR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:17:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2HGPR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:17:57 -0400
Date: Tue, 7 Aug 2012 17:13:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix
	set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120807151343.GA13476@redhat.com>
References: <20120803162954.GA19806@redhat.com> <501BFF95.8040202@linutronix.de> <20120803173830.GA22687@redhat.com> <501C183E.5000303@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C183E.5000303@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Today I noticed by accident that starting from Aug 4 (at least)
all my emails went to nowhere. I am resending some of them...


Peter, Ingo, could you help?

See the question about nmi at the end.

On 08/03, Sebastian Andrzej Siewior wrote:
>
> On 08/03/2012 07:38 PM, Oleg Nesterov wrote:
>>>>    	update_debugctlmsr(debugctl);
>>>> +	local_irq_enable();
>>>
>>> wouldn't preempt_disable() be enough?
>>
>> preempt_disable() can't help if interrupt handler changes
>> other bits in between?
>
> So perf() uses this register as well. Since perf() uses the raw
> primitives (raw_spin_lock())

Hmm. perf/whatever uses raw_spin_lock() if the lock is raw_spinlock_t.

But this doesn't matter? Whatever irq handler does has nothing to
do with the problem, either local_irq_disable() can prevent this
irq from happening, or not.

> shouldn't you do the same?

raw_local_irq_disable? I don't think so.

> If I recall
> correctly (but it is Friday and late) local_irq_enable() wouldn't
> disable irqs on RT

You mean it doesn't disable irqs in hardware? Yet local_irq_disable()
should protect against the interrupt handler.

OK, I know nothing about RT kernel (unfortunately), perhaps it has
other primitives, but

> and perf takes the raw lock

this certainly doesn't matter, afaics.

And note that __switch_to_xtra() runs under local_irq_disable() too.


However. It seems that perf (intel_pmu_handle_irq) can play with
MSR_IA32_DEBUGCTLMSR bits in nmi? In this case local_irq_disable()
can't help. Doesn't this mean __switch_to_xtra() has problems?

Oleg.

