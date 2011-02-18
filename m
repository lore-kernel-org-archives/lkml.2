Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1BRXDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 18:03:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44181 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1BRXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 18:02:58 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=JGpTz_e83PYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=eAjd9rQQabvo_yJTZfIA:9 a=uPV0y0LCg7IuzHhBEe8wCPoxQt0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <4D5EF67F.20007@zytor.com>
References: <4D5D1672.6070206@hitachi.com>
	 <1297948703.23343.907.camel@gandalf.stny.rr.com>
	 <4D5D4013.4070602@hitachi.com>
	 <1297957591.23343.921.camel@gandalf.stny.rr.com>
	 <4D5D47C0.9020206@hitachi.com>
	 <1297973501.23343.953.camel@gandalf.stny.rr.com>
	 <4D5E5BCF.1040509@hitachi.com>
	 <1298041659.23343.956.camel@gandalf.stny.rr.com>
	 <20110218151954.GA27834@Krystal>
	 <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
	 <20110218223902.GR5818@one.firstfloor.org>  <4D5EF67F.20007@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Feb 2011 18:02:54 -0500
Message-ID: <1298070174.23343.987.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 14:45 -0800, H. Peter Anvin wrote:

> We should also be able to use the breakpoint hack to avoid holding all
> the CPUs.  They still need to be interrupted, but that skips the
> rendezvous operation.

As this is about the ftrace code, I'm in the process of analyzing and
updating how the function tracer works. I can look to see if I can
design it so we don't have to always use stop_machine() if a breakpoint
method is in place.

Basically what is needed is to convert a "nop" into a "call" or maybe
the other way around, safely.

Now is it safe to insert a breakpoint (usually a byte I believe), modify
the rest of the instruction and then replace the breakpoint to the new
code? Since the instruction that is being replaced or the instruction
being added is always a nop, the breakpoint handler needs to do nothing
but return to the location after the nop/call.

Is there any synchronization that needs to be done when doing this? Or
can it just be:

	insert_breakpoint();
	update_instruction();
	remove_breakpoint();

Because we need to do this for 22,000 calls in a row.

-- Steve


