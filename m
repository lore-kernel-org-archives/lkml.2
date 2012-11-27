Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab2K0JTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:19:04 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40575 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab2K0JTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:19:00 -0500
Message-ID: <50B4856F.3060903@in.ibm.com>
Date: Tue, 27 Nov 2012 14:48:39 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: oleg@redhat.com, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc: Move the single step enable code to a generic
 path
References: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com> <20121126110448.6545.90588.stgit@suzukikp.in.ibm.com> <50B3B092.90605@linutronix.de>
In-Reply-To: <50B3B092.90605@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112709-0260-0000-0000-000002385B45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 11:40 PM, Sebastian Andrzej Siewior wrote:
> On 11/26/2012 12:05 PM, Suzuki K. Poulose wrote:
>> diff --git a/arch/powerpc/include/asm/probes.h
>> b/arch/powerpc/include/asm/probes.h
>> index 5f1e15b..836e9b9 100644
>> --- a/arch/powerpc/include/asm/probes.h
>> +++ b/arch/powerpc/include/asm/probes.h
>> @@ -38,5 +38,34 @@ typedef u32 ppc_opcode_t;
>>   #define is_trap(instr)        (IS_TW(instr) || IS_TWI(instr))
>>   #endif /* CONFIG_PPC64 */
>>
>> +#ifdef CONFIG_PPC_ADV_DEBUG_REGS
>> +#define MSR_SINGLESTEP    (MSR_DE)
>> +#else
>> +#define MSR_SINGLESTEP    (MSR_SE)
>> +#endif
>> +
>> +/* Enable single stepping for the current task */
>> +static inline void enable_single_step(struct pt_regs *regs)
>> +{
>> +
>> +    /*
>> +     * We turn off async exceptions to ensure that the single step will
>> +     * be for the instruction we have the kprobe on, if we dont its
> it is
>
>> +     * possible we'd get the single step reported for an exception
>> handler
>> +     * like Decrementer or External Interrupt
>> +     */
>
> Hmmm. The TRM for E400 says
>
> |5.11.1 e500 Exception Priorities
> |The following is a prioritized listing of e500 exceptions:
> |   4. Critical input
> |   5. Debug interrupt
> |   6. External input
> |   22. Decrementer
>
> The list has been cut down a little. That means the debug interrupt
> comes before external interrupt and before the decrement fires.
>
> And if single step is what wakes you up then DBSR[ICMP] is set. Am I
> missing something or is this FSL only not not book-e
>

You are right. The same priority applies for Book3S as well. The above
code/comment was initially written for kprobe. So I didn't bother to
double check the same, when I moved it to the common place.

I will send a v2 with the required changes.

Thanks for the question !

Cheers
Suzuki

