Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951Ab1BSFHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 00:07:34 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45904 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1BSFHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 00:07:30 -0500
X-AuditID: b753bd60-a50bbba000004916-d7-4d5f500f0d4c
X-AuditID: b753bd60-a50bbba000004916-d7-4d5f500f0d4c
Message-ID: <4D5F500C.40509@hitachi.com>
Date: Sat, 19 Feb 2011 14:07:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/19 8:02), Steven Rostedt wrote:
> On Fri, 2011-02-18 at 14:45 -0800, H. Peter Anvin wrote:
> 
>> We should also be able to use the breakpoint hack to avoid holding all
>> the CPUs.  They still need to be interrupted, but that skips the
>> rendezvous operation.

That's what I've done with text_poke_fixup()
http://lkml.org/lkml/2009/12/18/312

And I think it still not be checked officially from silicon side.

> As this is about the ftrace code, I'm in the process of analyzing and
> updating how the function tracer works. I can look to see if I can
> design it so we don't have to always use stop_machine() if a breakpoint
> method is in place.
> 
> Basically what is needed is to convert a "nop" into a "call" or maybe
> the other way around, safely.
> 
> Now is it safe to insert a breakpoint (usually a byte I believe), modify
> the rest of the instruction and then replace the breakpoint to the new
> code? Since the instruction that is being replaced or the instruction
> being added is always a nop, the breakpoint handler needs to do nothing
> but return to the location after the nop/call.

Yes, at least with text_poke_fixup(), you can call it as below

text_poke_fixup(addr, call_insn, CALL_INSN_SIZE, addr + CALL_INSN_SIZE);

Then, if a processor hits the addr, the breakpoint handler changes its
regs->ip to addr + CALL_INSN_SIZE so that it skips the modifying
instruction.

> Is there any synchronization that needs to be done when doing this? Or
> can it just be:
> 
> 	insert_breakpoint();
> 	update_instruction();
> 	remove_breakpoint();
> 
> Because we need to do this for 22,000 calls in a row.

In the case of text_poke_fixup(), it sends IPI twice for synchronization,
which doesn't stop all cores but current core. Of course, theoretically
this can be reduced by doing it in a batch.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
