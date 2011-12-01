Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1LAToh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:44:37 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:35347
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab1LATog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:44:36 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4ED7D8A8.3090106@am.sony.com>
Date: Thu, 1 Dec 2011 11:42:32 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 4/6] ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on
 ASID-capable CPUs
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com> <1322569352-23584-5-git-send-email-catalin.marinas@arm.com> <4ED6ED03.9080408@am.sony.com> <20111201092638.GA27394@arm.com>
In-Reply-To: <20111201092638.GA27394@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/11 01:26, Catalin Marinas wrote:
> On Thu, Dec 01, 2011 at 02:57:07AM +0000, Frank Rowand wrote:
>> On 11/29/11 04:22, Catalin Marinas wrote:
>>> Since the ASIDs must be unique to an mm across all the CPUs in a system,
>>> the __new_context() function needs to broadcast a context reset event to
>>> all the CPUs during ASID allocation if a roll-over occurred. Such IPIs
>>> cannot be issued with interrupts disabled and ARM had to define
>>> __ARCH_WANT_INTERRUPTS_ON_CTXSW.
>>>
>>> This patch changes the check_context() function to
>>> check_and_switch_context() called from switch_mm(). In case of
>>> ASID-capable CPUs (ARMv6 onwards), if a new ASID is needed, it defers
>>> the __new_context() and cpu_switch_mm() calls to the post-lock switch
>>> hook where the interrupts are enabled. Setting the reserved TTBR0 was
>>> also moved to check_and_switch_context() from cpu_v7_switch_mm().
>>>
>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> ---
>>>  arch/arm/include/asm/mmu_context.h |   81 ++++++++++++++++++++++++++++--------
>>>  arch/arm/include/asm/system.h      |    2 +
>>>  arch/arm/include/asm/thread_info.h |    1 +
>>>  arch/arm/mm/context.c              |    4 +-
>>>  arch/arm/mm/proc-v7.S              |    3 -
>>>  5 files changed, 69 insertions(+), 22 deletions(-)
>>>
>>
>> < snip >
>>
>>> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
>>> index 2faff3b..d5334d9 100644
>>> --- a/arch/arm/mm/proc-v7.S
>>> +++ b/arch/arm/mm/proc-v7.S
>>> @@ -116,9 +116,6 @@ ENTRY(cpu_v7_switch_mm)
>>>  #ifdef CONFIG_ARM_ERRATA_430973
>>>  	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
>>>  #endif
>>> -	mrc	p15, 0, r2, c2, c0, 1		@ load TTB 1
>>> -	mcr	p15, 0, r2, c2, c0, 0		@ into TTB 0
>>> -	isb
>>>  #ifdef CONFIG_ARM_ERRATA_754322
>>>  	dsb
>>>  #endif
>>
>> I do not have a tree that matches this version of cpu_v7_switch_mm().
>> Can you point me at a tree that I can see this in?
> 
> That's added by the second patch in the series (and removed in a later
> patch but it is a logical change in both situations and keeps the code
> bisectable).
> 

Ah, yes!  Thanks.

-Frank

