Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0JSW0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:26:12 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47310 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0JSW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:26:09 -0400
Message-ID: <364b3c9b09b8b02f6804634a2fc927b4.squirrel@programming.kicks-ass.net>
In-Reply-To: <1287527005.16971.527.camel@gandalf.stny.rr.com>
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
    <1287521757.16971.397.camel@gandalf.stny.rr.com>
    <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>
    <1287523439.16971.433.camel@gandalf.stny.rr.com>
    <4CBE122B.9020807@zytor.com>
    <1287527005.16971.527.camel@gandalf.stny.rr.com>
Date: Wed, 20 Oct 2010 00:27:25 +0200
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
        "Koki Sanagi" <sanagi.koki@jp.fujitsu.com>,
        "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
        "Frederic Weisbecker" <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "LKML" <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, "David Miller" <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 20, 2010 12:23 am, Steven Rostedt wrote:

>> static __always_inline __pure bool __switch_point(...)
>> {
>> 	asm goto("1: " JUMP_LABEL_INITIAL_NOP
>> 		 /* ... patching stuff */
>> 		: : : : t_jump);
>> 	return false;
>> t_jump:
>> 	return true;
>> }
>>
>> #define SWITCH_POINT(x) unlikely(__switch_point(x))
>>
>> I *suspect* this will resolve the need for hot/cold labels just fine.
>
> Interesting, we could try this.

Due to not actually having a sane key type the above is not easy to
implement, but I tried:

#define _SWITCH_POINT(x)\
({                                                              \
        __label__ jl_enabled;                                   \
        bool ret = true;                                        \
        JUMP_LABEL(x, jl_enabled);                              \
        ret = false;                                            \
jl_enabled:                                                     \
        ret;            })

#define SWITCH_POINT(x) unlikely(_SWITCH_POINT(x))

#define COND_STMT(key, stmt)                                    \
do {                                                            \
        if (SWITCH_POINT(key)) {                                \
                stmt;                                           \
        }                                                       \
} while (0)


and that's still generating these double jumps.

