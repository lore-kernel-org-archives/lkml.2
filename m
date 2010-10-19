Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0JSXFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:05:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab0JSXFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:05:18 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XYnli7Bj3DPLzSqfXIkA:9 a=dpng3TcHU6CwPnzCpNwA:7 a=XJaAdC2c18CbI6rbyPO099q1rowA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <4CBE206A.20702@zytor.com>
References: <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
	 <20101019142820.GA14520@Krystal>
	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
	 <1287521757.16971.397.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>
	 <1287523439.16971.433.camel@gandalf.stny.rr.com>
	 <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal>
	 <4CBE206A.20702@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 19:05:15 -0400
Message-ID: <1287529515.16971.538.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:49 -0700, H. Peter Anvin wrote:
> On 10/19/2010 03:41 PM, Mathieu Desnoyers wrote:
> >>
> >> OK, first of all, there are some serious WTFs here:
> >>
> >> # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
> >>
> >> A jump instruction is one of the worst possible NOPs.  Why are we doing
> >> this?
> > 
> > This code is dynamically patched at boot time (and module load time) with a
> > better nop, just like the function tracer does.
> > 
> 
> That's just ridiculous... start out with something sane and you at least
> have the chance of not having to patch it.

Yep we can fix this. Jason?



> > So if we were executing tracepoints in a maze of jumps, we could argue that
> > instruction throughput is the most important there. However, if we expect the
> > common case to be surrounded by some non-ALU instructions, latency tends to
> > become the most important criterion.
> > 
> > But I feel I might be missing something important that distinguish "jcc" from
> > "jmp".
> 
> NOP has a latency of 0.5-1.0 cycle/insns, *but has no consumers*.
> 
> JMP/Jcc does have a consumer -- the IP -- and actually measuring shows
> that it is much, much worse than NOP and other dummy instructions.

But how does JMP vs Jcc compare?

-- Steve


