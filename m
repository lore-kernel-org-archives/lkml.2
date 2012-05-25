Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab2EYP3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:29:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2EYP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:29:07 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=LjBlXQQp-u8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D_lWP2BdmwKiLwPvjKsA:9 a=PUjeQqilurYA:10 a=v8b_qJdt7Dls0uHt:21 a=afGoZCSUHPBgFJXr:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337959746.13348.264.camel@gandalf.stny.rr.com>
Subject: Re: BUG - function tracing with breakpoints (was: Re: tracing
 ring_buffer_resize oops.)
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Fri, 25 May 2012 11:29:06 -0400
In-Reply-To: <1337956262.13348.257.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
	 <1337909963.13348.232.camel@gandalf.stny.rr.com>
	 <1337910106.13348.234.camel@gandalf.stny.rr.com>
	 <1337956262.13348.257.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 10:31 -0400, Steven Rostedt wrote:

> Looks like we set RSP to code. Again pointing to a corrupted iretq.
> Maybe we are having nested debug stack usage, where we are hitting a
> breakpoint before setting the idt to not change the stack?

Another clue. If I do not trace the following functions:

func_ptr_is_kernel_text
kprobe_exceptions_notify
hw_breakpoint_exceptions_notify
notifier_call_chain*

it works fine.

# echo func_ptr_is_kernel_text kprobe_exceptions_notify \
 hw_breakpoint_exceptions_notify notifier_call_chain* > set_ftrace_notrace
# echo function > current_tracer

works!

These notifiers are being called by the breakpoint. So perhaps the
breakpoint is still being called by int3 when it shouldn't be. It
shouldn't because we have:


dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
{
#ifdef CONFIG_DYNAMIC_FTRACE
	/* ftrace must be first, everything else may cause a recursive crash */
	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
		return;
#endif

The fix I added (but hasn't fixed it completely) was:

 void arch_ftrace_update_code(int command)
 {
        modifying_ftrace_code++;
+       /*
+        * Make sure that all CPUs see this before we start
+        * adding breakpoints.
+        */
+       smp_mb();
 
        ftrace_modify_all_code(command);
 
+       /* Finish all breakpoints before clearing */
+       smp_mb();
+
        modifying_ftrace_code--;
 }


This would make sense for this bug, as if modifying_ftrace_code was not
seen by other CPUs, it wouldn't go into the ftrace_int3_handler() path.
That would cause this issue. But the bug remains after the smp_mb()'s
were put in place. Although it behaves a little differently not. Maybe
there's something else I missed?

-- Steve


