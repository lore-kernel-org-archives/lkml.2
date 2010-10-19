Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab0JSWup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:50:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52460 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab0JSWuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:50:44 -0400
Message-ID: <4CBE206A.20702@zytor.com>
Date: Tue, 19 Oct 2010 15:49:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <1287521757.16971.397.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com> <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal>
In-Reply-To: <20101019224126.GD3519@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 03:41 PM, Mathieu Desnoyers wrote:
>>
>> OK, first of all, there are some serious WTFs here:
>>
>> # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
>>
>> A jump instruction is one of the worst possible NOPs.  Why are we doing
>> this?
> 
> This code is dynamically patched at boot time (and module load time) with a
> better nop, just like the function tracer does.
> 

That's just ridiculous... start out with something sane and you at least
have the chance of not having to patch it.

> Intel's manual "Intel 64 and IA-32 Architectures Optimization Reference Manual"
> 
> http://www.intel.com/Assets/PDF/manual/248966.pdf
> 
> Page C-33 (or 577 in the pdf)
> 
> "7. Selection of conditional jump instructions should be based on the
>     recommendation of section Section 3.4.1, “Branch Prediction Optimization,” to
>     improve the predictability of branches. When branches are predicted
>     successfully, the latency of jcc is effectively zero."
> 
> So it mentions "jcc", but not jmp. Is there any reason for jmp to have a higher
> latency than jcc ?
> 
> In this manual, the latency of predicted jcc is therefore 0 cycle, and its
> throughput is 0.5 cycle/insn.
> 
> NOP (page C-29) is stated to have a latency of 0.5 to 1 cycle/insn (depending on
> the exact HW), and throughput of 0.5 cycle/insn.
> 
> However, I have not found "jmp" explicitly in this listing.
> 
> So if we were executing tracepoints in a maze of jumps, we could argue that
> instruction throughput is the most important there. However, if we expect the
> common case to be surrounded by some non-ALU instructions, latency tends to
> become the most important criterion.
> 
> But I feel I might be missing something important that distinguish "jcc" from
> "jmp".

NOP has a latency of 0.5-1.0 cycle/insns, *but has no consumers*.

JMP/Jcc does have a consumer -- the IP -- and actually measuring shows
that it is much, much worse than NOP and other dummy instructions.

	-hpa
