Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0JSVrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:47:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0JSVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:47:08 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=DqA9x28ZrxracdHcmasA:9 a=mcxkclqp2OThatTrHVYA:7 a=S70PK0LCb_ixx_fxJx3Rxp0Zcf0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
In-Reply-To: <4CBE0AC6.3040402@caviumnetworks.com>
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
	 <20101019142820.GA14520@Krystal>
	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
	 <4CBE0AC6.3040402@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 17:47:05 -0400
Message-ID: <1287524825.16971.476.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 14:16 -0700, David Daney wrote:
> On 10/19/2010 12:49 PM, Thomas Gleixner wrote:
> [...]
> > So that saves _TWO_ bytes of text and replaces:
> >
> > -  1e:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 25<test+0x25>
> > -  25:	74 4d                	je     74<test+0x74>
> > +  1e:	e9 00 00 00 00       	jmpq   23<test+0x23>
> > +  23:	eb 4d                	jmp    72<test+0x72>
> >
> > So it trades a conditional vs. two jumps ? WTF ??
> >
> > I thought that jumplabel magic was supposed to get rid of the jump
> > over the tracing code ? In fact it adds another jump. Whatfor ?
> 
> The 'asm goto' construct in GCC-4.5 is deficient in this area.
> 
> GCC assumes that all exit paths from an 'asm goto' are equally likely, 
> so the tracing (or dynamic printk etc.) code is assumed to be hot and is 
> emitted inline.  Since they are inline like this, there are all these 
> jumps around them and they pollute the I-Cache.
> 

Interesting. I thought the driving force for asm goto was for
tracepoints, as the documentation seems to reference them. One would
think that the default would have been to make it the unlikely case, as
it may be the only user of that code so far.

> I was looking at fixing it, but I think a true general purpose fix would 
> require enhancing GCC's grammar to allow specifying of the 'likelyness' 
> of each exit path from 'asm goto'.

That would be nice.

Thanks,

-- Steve


