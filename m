Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0JYWcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:32:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38979 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab0JYWcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:32:00 -0400
Message-ID: <4CC60529.7030102@zytor.com>
Date: Mon, 25 Oct 2010 15:31:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
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
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>  <1287395077.29097.1543.camel@twins>  <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>  <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>  <20101019132236.GA19197@Krystal>  <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>  <1287496495.16971.372.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>  <20101019142820.GA14520@Krystal>  <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>  <1287521757.16971.397.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>  <1287523439.16971.433.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010192359480.6815@localhost6.localdomain6>  <1287527634.16971.536.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010211817540.2418@localhost6.localdomain6> <1287680725.16971.586.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010212149480.3467@localhost6.localdoma!
 in6>
In-Reply-To: <alpine.LFD.2.00.1010212149480.3467@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 12:56 PM, Thomas Gleixner wrote:
> On Thu, 21 Oct 2010, Steven Rostedt wrote:
> 
>> On Thu, 2010-10-21 at 18:18 +0200, Thomas Gleixner wrote:
>>>
>>> On Tue, 19 Oct 2010, Steven Rostedt wrote:
>>>
>>>> On Wed, 2010-10-20 at 00:04 +0200, Thomas Gleixner wrote:
>>>>
>>>>> hpa just posted code which does the _RIGHT_ _THING_ independent of any
>>>>> compiler madness and you tracer folks just missed it.
>>>>
>>>> Thomas,
>>>>
>>>> Can you try this patch and see if it makes the object code better?
>>>
>>> Nope, same result.
>>
>> Yeah, I figured. Do you have CC_OPTIMIZE_FOR_SIZE set? And if you do,
>> what happens if you disable it?
> 
> Hmm. Indeed. That gets rid of the double jump.
> 

-Os unfortunately drops a bunch of optimizations.

With gcc 4.5.1 there is actually a way to guarantee to get rid of double
jumps, which is that you tell gcc that it is branching to one of two
targets:

                asm goto("1: .byte 0xe9 ; .long %l[t_no]-2f\n"
			 "2:\n"
		         /* patching infrastructure goes here */
                         : : "i" (bit) : : t_no, t_yes);
	        __builtin_unreachable();
t_no:
                return false;
t_yes:
                return true;

[The open-coding of the jump is necessary to force the 5-byte form
instead of the 2-byte form.]

The patching machinery can recognize the case where the jump offset is
zero and patch in a NOP instead.

There does, however, seem to be a couple of problems:

a) gcc 4.5.1 is required due to a bug in previous versions of gcc when
an asm goto doesn't have a fallthrough case.

b) it seems to encourage gcc to actively jump around as it reorders
blocks, since gcc no longer sees a fallthrough case at all.

Not sure I have a good solution for this, at least not with current gcc.

	-hpa
