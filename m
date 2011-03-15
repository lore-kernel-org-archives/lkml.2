Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab1COQjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:39:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47741 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab1COQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:39:30 -0400
X-AuditID: b753bd60-a42c8ba0000066fd-af-4d7f963fbc2b
X-AuditID: b753bd60-a42c8ba0000066fd-af-4d7f963fbc2b
Message-ID: <4D7F963D.6050602@hitachi.com>
Date: Wed, 16 Mar 2011 01:39:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH] x86: stop machine text poke should issue sync core (v2)
References: <20110303160137.GB1590@Krystal> <20110315141817.GA27124@Krystal>
In-Reply-To: <20110315141817.GA27124@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/15 23:18), Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
>> Intel Archiecture Software Developer's Manual section 7.1.3 specifies that a
>> core serializing instruction such as "cpuid" should be executed on _each_ core
>> before the new instruction is made visible.
> 
> Hi,
> 
> Is anyone willing to merge this fix into the x86 tree ?

Hi Ingo,
Please merge this fix for safe self modifying!

Thanks

> 
> Thanks,
> 
> Mathieu
> 
>>
>> Failure to do so can lead to unspecified behavior (Intel XMC erratas include
>> General Protection Fault in the list), so we should avoid this at all cost.
>>
>> This problem can affect modified code executed by interrupt handlers after
>> interrupt are re-enabled at the end of stop_machine, because no core serializing
>> instruction is executed between the code modification and the moment interrupts
>> are reenabled.
>>
>> Because stop_machine_text_poke performs the text modification from the first CPU
>> decrementing stop_machine_first, modified code executed in thread context is
>> also affected by this problem. To explain why, we have to split the CPUs in two
>> categories: the CPU that initiates the text modification (calls text_poke_smp)
>> and all the others. The scheduler, executed on all other CPUs after
>> stop_machine, issues an "iret" core serializing instruction, and therefore
>> handles core serialization for all these CPUs. However, the text modification
>> initiator can continue its execution on the same thread and access the modified
>> text without any scheduler call. Given that the CPU that initiates the code
>> modification is not guaranteed to be the one actually performing the code
>> modification, it falls into the XMC errata.
>>
>> Q: Isn't this executed from an IPI handler, which will return with IRET (a
>>    serializing instruction) anyway?
>> A: No, now stop_machine uses per-cpu workqueue, so that handler will be
>>    executed from worker threads. There is no iret anymore.
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@elte.hu>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Arjan van de Ven <arjan@infradead.org>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Andi Kleen <andi@firstfloor.org>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  arch/x86/kernel/alternative.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> Index: linux-tip/arch/x86/kernel/alternative.c
>> ===================================================================
>> --- linux-tip.orig/arch/x86/kernel/alternative.c
>> +++ linux-tip/arch/x86/kernel/alternative.c
>> @@ -620,7 +620,12 @@ static int __kprobes stop_machine_text_p
>>  		flush_icache_range((unsigned long)p->addr,
>>  				   (unsigned long)p->addr + p->len);
>>  	}
>> -
>> +	/*
>> +	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
>> +	 * that a core serializing instruction such as "cpuid" should be
>> +	 * executed on _each_ core before the new instruction is made visible.
>> +	 */
>> +	sync_core();
>>  	return 0;
>>  }
>>  
>>
>> -- 
>> Mathieu Desnoyers
>> Operating System Efficiency R&D Consultant
>> EfficiOS Inc.
>> http://www.efficios.com
> 


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
