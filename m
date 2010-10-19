Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab0JSVRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:17:00 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6463 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0JSVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:16:59 -0400
Message-ID: <4CBE0AC6.3040402@caviumnetworks.com>
Date: Tue, 19 Oct 2010 14:16:54 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org> <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2010 21:17:15.0268 (UTC) FILETIME=[00D12440:01CB6FD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 12:49 PM, Thomas Gleixner wrote:
[...]
> So that saves _TWO_ bytes of text and replaces:
>
> -  1e:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 25<test+0x25>
> -  25:	74 4d                	je     74<test+0x74>
> +  1e:	e9 00 00 00 00       	jmpq   23<test+0x23>
> +  23:	eb 4d                	jmp    72<test+0x72>
>
> So it trades a conditional vs. two jumps ? WTF ??
>
> I thought that jumplabel magic was supposed to get rid of the jump
> over the tracing code ? In fact it adds another jump. Whatfor ?

The 'asm goto' construct in GCC-4.5 is deficient in this area.

GCC assumes that all exit paths from an 'asm goto' are equally likely, 
so the tracing (or dynamic printk etc.) code is assumed to be hot and is 
emitted inline.  Since they are inline like this, there are all these 
jumps around them and they pollute the I-Cache.

I was looking at fixing it, but I think a true general purpose fix would 
require enhancing GCC's grammar to allow specifying of the 'likelyness' 
of each exit path from 'asm goto'.

David Daney

>
> Now even worse, when you NOP out the jmpq then your tracepoint is
> still not enabled. Brilliant !
>
> Did you guys ever look at the assembly output of that insane shite you
> are advertising with lengthy explanations ?
>
> Obviously _NOT_
>
> Come back when you can show me a clean imlementation of all this crap
> which reproduces with my jumplabel enabled stock compiler. And please
> just send me a patch w/o the blurb.
>
> And sane looks like:
>
>      jmpq   2f<---- This gets noped out
> 1:
>      mov    %r12,%rdi
>      callq  *(%r12)
>      [whatever cleanup it takes ]
>      leaveq
>      retq
>
> 2f:
>      [tracing gunk]
>      jmp    1b
>
> And further I want to see the tracing gunk in a minimal size so the
> net/core/dev.c deinlining does not happen.
>
> Thanks,
>
> 	tglx
>
> P.S.: It might be helpful and polite if you'd take off your tracing
>        blinkers from time to time.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

