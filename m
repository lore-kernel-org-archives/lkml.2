Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab1LPXYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:24:01 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:25351
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab1LPXXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:23:53 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EEBD2F2.5040203@am.sony.com>
Date: Fri, 16 Dec 2011 15:23:30 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
References: <4EEAB90D.3050504@am.sony.com> <20111216110100.GA6342@arm.com>
In-Reply-To: <20111216110100.GA6342@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/11 03:01, Catalin Marinas wrote:
> Hi Frank,
> 
> On Fri, Dec 16, 2011 at 03:20:45AM +0000, Frank Rowand wrote:
>> ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
>> (application specific ID). The number of ASIDs is limited to 256 and
>> the allocation algorithm requires IPIs when all the ASIDs have been
>> used.  The IPIs require interrupts enabled during context switch for
>> deadlock avoidance.
>>
>> The RT patch mm-protect-activate-switch-mm.patch disables irqs around
>> activate_mm() and switch_mm(), which are the portion of the ARMv6
>> context switch that require interrupts enabled.
>>
>> The solution for the ARMv6 processors could be to _not_ disable irqs.
>> A more conservative solution is to provide the same environment that
>> the scheduler provides, that is preempt_disable().  This is more
>> resilient for possible future changes to the ARM context switch code
>> that is not aware of the RT patches.
>>
>> This patch will conflict slightly with Catalin's patch set to remove
>> __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
>>
>>    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
>>
>> When Catalin's patch set is accepted, this RT patch will need to reverse
>> the change in patch 6 to arch/arm/include/asm/system.h:
>>
>>    -#ifndef CONFIG_CPU_HAS_ASID
>>    -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
>>    -#endif
>>
>> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> 
> The whole point of my patches was to no longer define
> __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM, so bringing it back in is not
> feasible.

Looking over Catalin's patches again, it looks like my hacky RT patch
will no longer be needed after Catalin's patch set is in place.  The
problem my patch deals with is that with the RT patches applied, use_mm()
calls switch_mm() with IRQs disabled.  The current ARM switch_mm() can
not be called with IRQs disabled.  But with Catalin's patch 4
(http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01898.html)
applied, switch_mm() can be called with IRQs enabled, because
switch_mm() no longer calls check_context() which calls __new_context()
which calls smp_call_function() which requires IRQs to be enabled....

> 
> But by reading your patch I realised that there are two more switch_mm()
> calls outside the scheduler switch and the post-switch hook would not be
> called:
> 
> 1. idle_task_exit() - this function switches to the init_mm. With my new
> patches, even if the switch does not explicitly happen because it
> requires a new ASID, the ARMv6+ code sets the init_mm.pgd anyway. On
> ARMv5 such hook would not happen but we don't have CONFIG_HOTPLUG_CPU
> either. But even if it happens to work, it's not correct behaviour in
> either case.
> 
> 2. use_mm() - this also assumes an immediate switch_mm() which may not
> happen.
> 
> My question - can we not use activate_mm() directly in both cases? This
> function would ensure that the new mm is actually active on ARM and it
> does not disable the interrupts for the critical code. You may still
> need some RT patch if the RT series disables the interrupts for the
> switch_mm() calls.

Yes, activate_mm() should work for those two cases for ARM (I don't know
about other architectures).  To make this easier to follow for those reading
along, Catalin's patch 4 changes activate_mm() to call
finish_arch_post_lock_switch(), which will actually make the new mm active.

Here is the relevant code from Catalin's patch 4:

+static inline void finish_arch_post_lock_switch(void)
+{
+	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
+		struct mm_struct *mm = current->mm;
+		unsigned long flags;
+
+		__new_context(mm);
+
+		local_irq_save(flags);
+		cpu_switch_mm(mm->pgd, mm);
+		local_irq_restore(flags);
+	}
+}

+static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+#ifdef CONFIG_MMU
+	unsigned long flags;
+
+	local_irq_save(flags);
+	switch_mm(prev, next, current);
+	local_irq_restore(flags);
+
+	finish_arch_post_lock_switch();
+#endif
+}

But as Catalin points out, this means in use_mm() the RT patch will need to
call the ARM activate_mm() with interrupts enabled because
finish_arch_post_lock_switch() calls __new_context() which calls
smp_call_function() which requires IRQs to be enabled.

And, once again, I don't have a nice clean way to differentiate the
RT case that requires IRQs to be enabled.

This also brings up another question: should the RT patch
mm-protect-activate-switch-mm.patch also disable interrupts
around the call to switch_mm() in idle_task_exit()?

> 
> If that sounds reasonable, I'll repost my series with activate_mm() fix.
> 
> Thanks.
> 

-Frank

