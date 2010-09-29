Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0I2IaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:30:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47061 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0I2IaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XTbrqFCv/pZQk/skqSa30xG6dZ5zDZ5aTeIvE9Bj9uidOO1WTAANTi+SpuCBicKTQ3
         vQ4Nl6rwBqGSMx1+mlKvrxzi+ADuLIAlT0RPGIho9bT/H+/cDAndxdtBO00YOJ1HrA4r
         nySyeaBDrUaDKyv83N5g2eJehwXr7p1j/rGgw=
MIME-Version: 1.0
In-Reply-To: <20100928155609.GA5354@nowhere>
References: <1285663908.20791.286.camel@yhuang-dev>
	<20100928155609.GA5354@nowhere>
Date: Wed, 29 Sep 2010 16:29:52 +0800
Message-ID: <AANLkTinO6rOmKhQGP9jqN_qaA5bweeXy3bwdDwt9FToG@mail.gmail.com>
Subject: Re: [PATCH -tip -v6] irq_work: generic hard-irq context callbacks
From: huang ying <huang.ying.caritas@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Frederic,

On Tue, Sep 28, 2010 at 11:56 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Tue, Sep 28, 2010 at 04:51:48PM +0800, Huang Ying wrote:
>> +++ b/arch/x86/kernel/irq_work.c
>> @@ -0,0 +1,30 @@
>> +/*
>> + * x86 specific code for irq_work
>> + *
>> + * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/irq_work.h>
>> +#include <linux/hardirq.h>
>> +#include <asm/apic.h>
>> +
>> +void smp_irq_work_interrupt(struct pt_regs *regs)
>> +{
>> +     irq_enter();
>> +     ack_APIC_irq();
>> +     inc_irq_stat(apic_irq_work_irqs);
>> +     irq_work_run();
>> +     irq_exit();
>> +}
>> +
>> +void arch_irq_work_raise(void)
>> +{
>> +#ifdef CONFIG_X86_LOCAL_APIC
>> +     if (!cpu_has_apic)
>> +             return;
>> +
>> +     apic->send_IPI_self(IRQ_WORK_VECTOR);
>> +     apic_wait_icr_idle();
>> +#endif
>> +}
>
>
>
> So basically, CONFIG_X86_LOCAL_APIC == !HAVE_IRQ_WORK ?
>
> But IIUC, this will fallback to the timer interrupt:

If !CONFIG_X86_LOCAL_APIC or !cpu_has_apic, this will fallback to the
timer interrupt.

>> @@ -1279,7 +1279,10 @@ void update_process_times(int user_tick)
>>       run_local_timers();
>>       rcu_check_callbacks(cpu, user_tick);
>>       printk_tick();
>> -     perf_event_do_pending();
>> +#ifdef CONFIG_IRQ_WORK
>> +     if (in_irq())
>> +             irq_work_run();
>> +#endif
>>       scheduler_tick();
>>       run_posix_cpu_timers(p);
>>  }
>
> Then HAVE_IRQ_WORK just means that the arch supports self IPIs.

HAVE_IRQ_WORK means IRQ_WORK is supported on the architecture, it has
nothing to do with self IPIs.

Best Regards,
Huang Ying
