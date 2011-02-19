Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab1BSFMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 00:12:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1BSFMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 00:12:23 -0500
Message-ID: <4D5F50B4.8020306@zytor.com>
Date: Fri, 18 Feb 2011 21:10:12 -0800
From: hpas@zytor.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andi Kleen <andi@firstfloor.org>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
References: <4D5D1672.6070206@hitachi.com>	 <1297948703.23343.907.camel@gandalf.stny.rr.com>	 <4D5D4013.4070602@hitachi.com>	 <1297957591.23343.921.camel@gandalf.stny.rr.com>	 <4D5D47C0.9020206@hitachi.com>	 <1297973501.23343.953.camel@gandalf.stny.rr.com>	 <4D5E5BCF.1040509@hitachi.com>	 <1298041659.23343.956.camel@gandalf.stny.rr.com>	 <20110218151954.GA27834@Krystal>	 <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>	 <20110218223902.GR5818@one.firstfloor.org>  <4D5EF67F.20007@zytor.com> <1298070174.23343.987.camel@gandalf.stny.rr.com>
In-Reply-To: <1298070174.23343.987.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 03:02 PM, Steven Rostedt wrote:
> 
> Is there any synchronization that needs to be done when doing this? Or
> can it just be:
> 
> 	insert_breakpoint();
> 	update_instruction();
> 	remove_breakpoint();
> 
> Because we need to do this for 22,000 calls in a row.
> 

The sequence needs to be:

1. Set up the breakpoint handler so that it can dismiss a breakpoint
interrupt from one of the patching addresses (it can just subtract one
from the return address and IRET).
2. Replace the first byte with a breakpoint instruction.
3. IPI all processors.
4. Write all but the first byte of the new instruction.
5. Write the first byte of the new instruction.
6. IPI all processors.
7. Tear down the breakpoint hander.

Note that "IPI all processors" does not require a rendezvous like
stop_machine(): it just means the issuing processor has to wait until
each processor has been IPI'd (e.g. via smp_call_function()), but those
processors can simply IRET and continue executing.

If the breakpoint handler can be left indefinitely, steps 6-7 can be
omitted (the IRET from the breakpoint handler will provide the necessary
serialization.)

	-hpa
