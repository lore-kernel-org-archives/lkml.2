Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030606Ab2LGODI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:03:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030510Ab2LGODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:03:06 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=3wj6tTq13JYz_zGn5rYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354888985.17101.41.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 09:03:05 -0500
In-Reply-To: <1354872138.3176.15.camel@computer5.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 09:22 +0000, Jon Medhurst (Tixy) wrote:
> On Thu, 2012-12-06 at 14:19 -0500, Steven Rostedt wrote:
> > Hmm, your use of "may or may not" seems as you may not know this answer.
> > I wonder if you can use the break point method as x86 does now, and
> > remove the stop machine completely. Basically this is how it works:
> > 
> > add sw breakpoints to all locations to modify (the bp handler just does
> > a nop over the instruction).
> > 
> > send an IPI to all CPUs to flush their icache.
> > 
> > Modify the non breakpoint part of the instruction with the new
> > instruction.
> > 
> > send an IPI to all CPUs to flush their icache
> > 
> > Replace the breakpoint with the finished instruction.
> 
> If I understand correctly then this method can't work on ARM because a
> 'software breakpoint' is 'replace an instruction with a known undefined
> instruction _of the same size_'. It haa to be the same size because code
> like this:
> 
> 	it eq       /* If condition code 'eq' true */
>         insA        /* then execute this instruction */
>         insB        /* Always execute this */
> 
> if we replace insA with a breakpoint which is shorter, then we have
> 
> 	it eq       /* If condition code 'eq' true */
>         bkpt        /* then execute the breakpoint */
>         insA-part2  /* Always execute this garbage */

Why always execute the garbage? Do what we do in x86, where the
breakpoint is only 1 byte and the instruction being replaced is 5 bytes.
The breakpoint handler returns to the instruction after the
"garbage" (insB).

>         insB        /* Always execute this */
> 
> and to complicate matters more, the 'it' instruction can make up to the
> next four instructions conditional, so you can't reverse decode the
> instruction stream reliably to even detect such code.
> 
> And further, it's implementation defined (up to who every creates the
> silicon) whether an undefined instructions actually causes an abort when
> it occurs in such an 'it' block, it may just execute as a nop.
> 
> Welcome to the work of ARM :-)
> 

But also realize that function tracing is special :-) We have no cases
like this. The instruction being replaced is a call to mcount. In fact,
we replace it at boot with a nop. And this method only replaces that nop
into a call to function tracer, or replaces the call to function tracer
back to a nop. Always at the start of the function, and never involved
with conditionals. This limitation that function tracing imposes on what
we replace makes things a bit more sane in how we replace it.

-- Steve


