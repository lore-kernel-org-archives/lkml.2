Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1KOFyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 00:54:06 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33355 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1KOFyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 00:54:04 -0500
X-AuditID: b753bd60-a2688ba000000655-a6-4ec1fe793cd9
X-AuditID: b753bd60-a2688ba000000655-a6-4ec1fe793cd9
Message-ID: <4EC1FE76.3020002@hitachi.com>
Date: Tue, 15 Nov 2011 14:53:58 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 4/5] x86: panic on detection of stack overflow
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp> <20111107055308.7928.54878.stgit@ltc219.sdl.hitachi.co.jp> <20111110195910.GC22646@phenom.dumpdata.com>
In-Reply-To: <20111110195910.GC22646@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/11 4:59), Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 07, 2011 at 02:53:08PM +0900, Mitsuo Hayasaka wrote:
>> Currently, messages are just output on the detection of stack overflow,
>> which is not sufficient for enterprise systems since it may corrupt data.
>> To enhance reliability, it is required to stop the systems.
> 
> Why not just make the stack_overflow_check() return a value that it should
> not handle the IRQ and perhaps silence (disable_chip) the IRQ line?
> 
> That will still let the system run, albeit .. without certain parts
> not working right.. So perhaps re-enable the chip later on?
> 
> Or is there really no way to recover from this?

I understood that you mentioned the overflow handling of IRQ stack, right?

I think it is interesting but in this patch I'd like to focus on
causing a panic for the overflows of kernel, IRQ and exception stacks.
Of course, I will consider it as the future works.

This option is enabled only if the sysctl parameter is changed
in the same manner as other panic_on_XXX parameters.

Also, I have concerned about the additional corruption caused by
reading of the corrupted data due to the overflows of kernel, IRQ
and exception stacks. This may happen unless systems stop, and
is unacceptable for systems that need a high reliability.


>>
>> This patch causes a panic according to a sysctl parameter
>> panic_on_stackoverflow when detecting it. It is disabled by default.
>>
>> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> ---
>>
>>  arch/x86/kernel/irq_32.c |    2 ++
>>  arch/x86/kernel/irq_64.c |   16 +++++++++++-----
>>  2 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
>> index 7209070..e16e99eb 100644
>> --- a/arch/x86/kernel/irq_32.c
>> +++ b/arch/x86/kernel/irq_32.c
>> @@ -43,6 +43,8 @@ static void print_stack_overflow(void)
>>  {
>>  	printk(KERN_WARNING "low stack detected by irq handler\n");
>>  	dump_stack();
>> +	if (sysctl_panic_on_stackoverflow)
>> +		panic("low stack detected by irq handler - check messages\n");
>>  }
>>  
>>  #else
>> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
>> index d720813..f7baedd 100644
>> --- a/arch/x86/kernel/irq_64.c
>> +++ b/arch/x86/kernel/irq_64.c
>> @@ -69,14 +69,20 @@ static inline void stack_overflow_check(struct pt_regs *regs)
>>  		current->comm, curbase, regs->sp,
>>  		irq_stack_top, irq_stack_bottom,
>>  		estack_top, estack_bottom);
>> +	if (sysctl_panic_on_stackoverflow)
>> +		panic("low stack detected by irq handler - check messages\n");
>>  #else
>> -	WARN_ONCE(regs->sp >= curbase &&
>> -		  regs->sp <= curbase + THREAD_SIZE &&
>> -		  regs->sp <  curbase + sizeof(struct thread_info) +
>> -					sizeof(struct pt_regs) + 128,
>> -
>> +	if (regs->sp >= curbase &&
>> +		regs->sp <= curbase + THREAD_SIZE &&
>> +		regs->sp <  curbase + sizeof(struct thread_info) +
>> +					sizeof(struct pt_regs) + 128) {
>> +		WARN_ONCE(1,
>>  		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
>>  			current->comm, curbase, regs->sp);
>> +		if (sysctl_panic_on_stackoverflow)
>> +			panic("low stack detected by irq handler - check messages\n");
>> +	}
>> +
>>  #endif /* CONFIG_DEBUG_STACKOVERFLOW_DETAIL */
>>  #endif
>>  }
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

