Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1CCF2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:28:01 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45339 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1CCF17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:27:59 -0500
X-AuditID: b753bd60-a64bdba000004916-bb-4d6f26dc4c37
X-AuditID: b753bd60-a64bdba000004916-bb-4d6f26dc4c37
Message-ID: <4D6F26DA.5040403@hitachi.com>
Date: Thu, 03 Mar 2011 14:27:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] x86: stop machine text poke should issue sync core
References: <20110228152405.GA7064@Krystal>
In-Reply-To: <20110228152405.GA7064@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/01 0:24), Mathieu Desnoyers wrote:
> Intel Archiecture Software Developer's Manual section 7.1.3 specifies that a
> core serializing instruction such as "cpuid" should be executed on _each_ core
> before the new instruction is made visible.
> 
> Failure to do so can lead to unspecified behavior (Intel XMC erratas include
> General Protection Fault in the list), so we should avoid this at all cost.
> 
> This problem can affect modified code executed by interrupt handlers after
> interrupt are re-enabled at the end of stop_machine, because no core serializing
> instruction is executed between the code modification and the moment interrupts
> are reenabled.
> 
> Because stop_machine_text_poke performs the text modification from the first CPU
> decrementing stop_machine_first, modified code executed in thread context is
> also affected by this problem. To explain why, we have to split the CPUs in two
> categories: the CPU that initiates the text modification (calls text_poke_smp)
> and all the others. The scheduler, executed on all other CPUs after
> stop_machine, issues an "iret" core serializing instruction, and therefore
> handles core serialization for all these CPUs. However, the text modification
> initiator can continue its execution on the same thread and access the modified
> text without any scheduler call. Given that the CPU that initiates the code
> modification is not guaranteed to be the one actually performing the code
> modification, it falls into the XMC errata.

Thanks Mathieu!
It seems reasonable change. At least I'm OK :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Arjan van de Ven <arjan@infradead.org>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  arch/x86/kernel/alternative.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c
> +++ linux-2.6-lttng/arch/x86/kernel/alternative.c
> @@ -612,6 +612,12 @@ static int __kprobes stop_machine_text_p
>  
>  	flush_icache_range((unsigned long)tpp->addr,
>  			   (unsigned long)tpp->addr + tpp->len);
> +	/*
> +	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
> +	 * that a core serializing instruction such as "cpuid" should be
> +	 * executed on _each_ core before the new instruction is made visible.
> +	 */
> +	sync_core();
>  	return 0;
>  }
>  


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
