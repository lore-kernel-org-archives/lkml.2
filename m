Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1LTBtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:49:55 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:42117
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab1LTBtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:49:53 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zzbb2dI103dK1432N98dKzz1202hzz8275bhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EEFE9A0.9090206@am.sony.com>
Date: Mon, 19 Dec 2011 17:49:20 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
References: <4EEAB90D.3050504@am.sony.com> <20111216110100.GA6342@arm.com> <4EEBD2F2.5040203@am.sony.com> <20111219100217.GA29889@arm.com>
In-Reply-To: <20111219100217.GA29889@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/11 02:02, Catalin Marinas wrote:
> On Fri, Dec 16, 2011 at 11:23:30PM +0000, frank.rowand@am.sony.com wrote:
>> On 12/16/11 03:01, Catalin Marinas wrote:
>>> On Fri, Dec 16, 2011 at 03:20:45AM +0000, Frank Rowand wrote:
>>>> ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
>>>> (application specific ID). The number of ASIDs is limited to 256 and
>>>> the allocation algorithm requires IPIs when all the ASIDs have been
>>>> used.  The IPIs require interrupts enabled during context switch for
>>>> deadlock avoidance.
>>>>
>>>> The RT patch mm-protect-activate-switch-mm.patch disables irqs around
>>>> activate_mm() and switch_mm(), which are the portion of the ARMv6
>>>> context switch that require interrupts enabled.
>>>>
>>>> The solution for the ARMv6 processors could be to _not_ disable irqs.
>>>> A more conservative solution is to provide the same environment that
>>>> the scheduler provides, that is preempt_disable().  This is more
>>>> resilient for possible future changes to the ARM context switch code
>>>> that is not aware of the RT patches.
>>>>
>>>> This patch will conflict slightly with Catalin's patch set to remove
>>>> __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
>>>>
>>>>    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
>>>>
>>>> When Catalin's patch set is accepted, this RT patch will need to reverse
>>>> the change in patch 6 to arch/arm/include/asm/system.h:
>>>>
>>>>    -#ifndef CONFIG_CPU_HAS_ASID
>>>>    -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
>>>>    -#endif
>>>>
>>>> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
>>>
>>> The whole point of my patches was to no longer define
>>> __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM, so bringing it back in is not
>>> feasible.
>>
>> Looking over Catalin's patches again, it looks like my hacky RT patch
>> will no longer be needed after Catalin's patch set is in place.  The
>> problem my patch deals with is that with the RT patches applied, use_mm()
>> calls switch_mm() with IRQs disabled.  The current ARM switch_mm() can
>> not be called with IRQs disabled.  But with Catalin's patch 4
>> (http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01898.html)
>> applied, switch_mm() can be called with IRQs enabled, because
>> switch_mm() no longer calls check_context() which calls __new_context()
>> which calls smp_call_function() which requires IRQs to be enabled....
> 
> I don't think much has changed with my patches. The switch_mm() itself
> can be called with IRQs disabled but it wouldn't even do the pgd switch
> unless it is followed by a finish_arch_post_lock_switch() call (hook
> introduced by my patch, but only available in sched.c).
> 
> I think you need a solution for the RT series without considering my
> context switch changes. As I understand, the RT code currently calls
> switch_mm() with interrupts disabled which is not supported on ARM. So
> we have two solutions:
> 
> 1. Change the RT patches to call switch_mm() with interrupts enabled
>    (and I can modify the ARM code to cope with this scenario and do the
>    pgd switch in one go).
> 2. Call switch_mm() with interrupts disabled but invoke an arch hook
>    once the interrupts have been enabled to complete the pgd switch.

I think I'm in agreement with you.

Solution 1 works for the RT patch set with the current mainline (and my
short term modification to the RT patch set that calls switch_mm() with
interrupts enabled from use_mm()).  I don't think there is any need to
modify the ARM code for this to work.  I'm assuming that when you say
"do the pgd switch" that you are talking about the
"cpu_switch_mm(next->pgd, next)" that is currently in switch_mm().

Solution 2 will work after version 2 of your patches in "Remove the
__ARCH_WANT_INTERRUPTS_ON_CTXSW definition" is applied.  In this
case my short term modification to the RT patch set for solution 1
would be removed, and instead the RT patch set would call
finish_arch_post_lock_switch() after re-enabling IRQs in use_mm().

> 
> Option 1 is the only one that would work with the current ARM
> switch_mm() implementation and I think it's the simplest (but I don't
> know the background to the IRQs being disabled by the RT patches for the
> switch_mm() call).
> 

Thanks!

-Frank

