Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2EaVhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:37:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2EaVhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:37:22 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6I2XFdsDAPIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Yt4uPxRe2q3sBeL-BKgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338500240.13348.453.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 17:37:20 -0400
In-Reply-To: <4FC7DDF1.5070606@zytor.com>
References: <20120531012829.160060586@goodmis.org>
	     <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>
	    <1338492300.13348.384.camel@gandalf.stny.rr.com>
	    <4FC7C62C.1020807@zytor.com>
	   <1338494431.13348.410.camel@gandalf.stny.rr.com>
	   <4FC7D1F7.8090405@zytor.com>
	  <1338496555.13348.429.camel@gandalf.stny.rr.com>
	  <4FC7D6EC.3000904@zytor.com>
	 <1338497811.13348.443.camel@gandalf.stny.rr.com>
	 <4FC7DDF1.5070606@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 14:09 -0700, H. Peter Anvin wrote:

> No, I'm asking what environments (alternate stacks) are permitted where.
>  That is the important information.

I believe that the IST stack switch is just a convenient way to allow
separate stacks for separate events instead of trying to handle all
events on a single stack, and risk stack overflow.

Thus, the debug/int3 and NMI events use a separate stack to not stress
the current stack that is not expected to switch. The external interrupt
stacks are switched on entry of the interrupt and stays on that stack
and until its finished. There's a check to see if it is already on the
stack before it does the switch so that it doesn't have the HW switch
issues that NMI and int3 has.

Thus, if we say we must stay on either the NMI stack or the DEBUG stack,
then this is what happens. Well, almost.

For NMIs, if it preempted something on the debug stack, it will always
stay on the NMI stack and never switch. A check is made for both debug
stacks at once:

int is_debug_stack(unsigned long addr)
{
	return __get_cpu_var(debug_stack_usage) ||
		(addr <= __get_cpu_var(debug_stack_addr) &&
		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
}

Where:

#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)


But if the NMI did not preempt the DEBUG stack, and it hits a breakpoint
it will switch to the debug stack. And it is possible to make another
switch if the debug code were to somehow.

Thus the transactions are something like this:

NORMAL_STACK (either kernel/user/irq) -> DEBUG1 -> DEBUG2

NORMAL_STACK -> DEBUG1 -> NMI

NORMAL_STACK -> DEBUG1 -> DEBUG2 -> NMI

NORMAL_STACK -> NMI -> DEBUG1 -> DEBUG2

-- Steve


