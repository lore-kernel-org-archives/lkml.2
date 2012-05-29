Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2E2N1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:27:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2E2N07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:26:59 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Aua4qMZyJ18A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=WDI_K4LwUoHb7w7lQ7AA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338298017.13348.293.camel@gandalf.stny.rr.com>
Subject: Re: BUG - function tracing with breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Tue, 29 May 2012 09:26:57 -0400
In-Reply-To: <1338291441.13348.291.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
	 <1337909963.13348.232.camel@gandalf.stny.rr.com>
	 <1337910106.13348.234.camel@gandalf.stny.rr.com>
	 <1337956262.13348.257.camel@gandalf.stny.rr.com>
	 <1337959746.13348.264.camel@gandalf.stny.rr.com>
	 <4FBFC421.3020901@linux.intel.com>
	 <1337971575.13348.268.camel@gandalf.stny.rr.com>
	 <1337979086.13348.269.camel@gandalf.stny.rr.com>
	 <1338291441.13348.291.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 07:37 -0400, Steven Rostedt wrote:

> trace_hardirqs_on_caller {
> 	__trace_hardirqs_on_caller(ip) {
> 		mark_locks_held() {
> 			mark_lock() {
> 				save_trace() {
> 					save_stack_trace()...
> 
> 
> Unfortunately, the save_stack_trace() is traced by the function tracer.
> Which means that it will hit a breakpoint and jump into the breakpoint
> code. But here it will reset the stack and corrupt the current stack,
> causing strange hard-to-debug bugs.
> 

Bah, unfortunately this still isn't enough, as save_stack_trace() calls
a lot more that happens to be traced. I'm looking into seeing if I can
change lockdep not to blindly do records when enabling interrupts.

-- Steve

> There's no reason to function trace stack dumps, and this stops the bug
> from triggering when I apply it.
> 
> Dave, can you give this a try too?
> 
> Thanks!
> 
> -- Steve
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 532d2e0..0026999 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -14,6 +14,10 @@ CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
>  CFLAGS_REMOVE_pvclock.o = -pg
>  CFLAGS_REMOVE_kvmclock.o = -pg
>  CFLAGS_REMOVE_ftrace.o = -pg
> +CFLAGS_REMOVE_dumpstack.o = -pg
> +CFLAGS_REMOVE_dumpstack_32.o = -pg
> +CFLAGS_REMOVE_dumpstack_64.o = -pg
> +CFLAGS_REMOVE_stacktrace.o = -pg
>  CFLAGS_REMOVE_early_printk.o = -pg
>  endif
>  
> 


