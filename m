Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0JSVtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:49:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32828 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086Ab0JSVtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:49:50 -0400
Message-ID: <4CBE122B.9020807@zytor.com>
Date: Tue, 19 Oct 2010 14:48:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>	 <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>	 <20101019132236.GA19197@Krystal>	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>	 <1287496495.16971.372.camel@gandalf.stny.rr.com>	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>	 <20101019142820.GA14520@Krystal>	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>	 <1287521757.16971.397.camel@gandalf.stny.rr.com>	 <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com>
In-Reply-To: <1287523439.16971.433.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 02:23 PM, Steven Rostedt wrote:
> 
> But it seemed that gcc for you inlined the code in the wrong spot.
> Perhaps it's not a good idea to have the something like h - softirq_vec
> in the parameter of the tracepoint. Not saying that your change is not
> worth it. It is, because h - softirq_vec is used by others now too.
> 

OK, first of all, there are some serious WTFs here:

# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"

A jump instruction is one of the worst possible NOPs.  Why are we doing
this?

The second thing that I found when implementing static_cpu_has() was
that it is actually better to encapsulate the asm goto in a small inline
which returns bool (true/false) -- gcc will happily optimize out the
variable and only see it as a flow of control thing.  I would be very
curious if that wouldn't make gcc generate better code in cases like that.

gcc 4.5.0 has a bug in that there must be a flowthrough case in the asm
goto (you can't have it unconditionally branch one way or the other), so
that should be the likely case and accordingly it should be annotated
likely() so that gcc doesn't reorder.  I suspect in the end one ends up
with code like this:

static __always_inline __pure bool __switch_point(...)
{
	asm goto("1: " JUMP_LABEL_INITIAL_NOP
		 /* ... patching stuff */
		: : : : t_jump);
	return false;
t_jump:
	return true;
}

#define SWITCH_POINT(x) unlikely(__switch_point(x))

I *suspect* this will resolve the need for hot/cold labels just fine.

	-hpa

