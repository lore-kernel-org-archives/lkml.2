Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2FNCzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:55:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2FNCzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:55:08 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=DJ6KdbPuidDsZ8YjXZgA:9 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Wed, 13 Jun 2012 22:55:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: rcu-torture boot hang
Message-ID: <20120614025504.GE30024@home.goodmis.org>
References: <20120612012134.GA7706@localhost>
 <20120612121122.GA17891@localhost>
 <20120613124900.GA1741@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613124900.GA1741@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a note. Please use my goodmis email and not my Red Hat email. My
Red Hat email is not checked as often, and I don't usually tag emails
there as "reply to". I only author with that email to give credit to the
one that pays me to do the work (and I don't mean just for the LWN
stats).

On Wed, Jun 13, 2012 at 08:49:00PM +0800, Fengguang Wu wrote:
> Hi Steven,
> 
> On Tue, Jun 12, 2012 at 08:11:22PM +0800, Fengguang Wu wrote:
> > Hi Paul,
> > 
> > In kernel boot tests with the attached config, I find the 3.5-rc2+
> > kernels all hang here:
> > 
> > [    6.522546] rcu-torture:--- Start of test: nreaders=2
> > nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0
> > shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0
> > fqs_stutter=3 test_boost=1/0 test_boost_interval=7
> > test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> 
> It turns out that commit 5963e317b1e9d2a4511503916d8fd664bb8fa8fb
> ("ftrace/x86: Do not change stacks in DEBUG when calling lockdep") is
> the root cause of this boot hang. The commit is reported by git bisect
> and confirmed to fix the boot hang by reverting in on 3.5-rc2.

I get the hang with your config too. If I disable both LOCKDEP and
IRQSOFF_TRACER which turns off TRACE_IRQFLAGS then the lockup goes away.
This is consistent with your findings, as the patch you found is only
enabled when TRACE_IRQFLAGS is on.

> 
>         [ rcu torture tests ]
> 
> ...It would hang here before reverting the commit...
> 
>         [    1.611901] Testing tracer function: PASSED

I did a bit more investigation and found that the problem comes from the
load_idt() command that is used to avoid reseting the debug stack. When
the function tracer is enabled it adds breakpoints to all locations that
it is about to trace in order to convert the nops in the functions into
calls to the tracer. But if the breakpoint handler is traced, the
breakpoint in the handler will reset the stack and cause a crash.

Your above observation is correct. Actually I added a printk in my
testing and found that the 'Testing trace function:' does output before
the lockup. I think printk changed recently that prevents it to print
out right away if a '\n' is not supplied. The function tracer self test
prints:

  'Testing tracer function: '

Runs the test, and when it succeeds it prints 'PASSED\n'. Because the
first part wasn't printed, we never saw that the function tracer was
being tested when the lockup occurred.

This is a major flaw with the new printk(). It hides what is being
tested. I need to write a patch to create a fflush() for printk.

Anyway, load_idt() shouldn't be traced, but with PARAVIRT_GUEST it makes
functions that are even always_inlined not inlined, and allows things
like native_load_idt() to be traced, and that causes bad things as we
want to call load_idt to prevent recursion of the int3 handler.


If it works, can you give me your 'Tested-by'.

Thanks!

-- Steve

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index e5834aa..6a6d7ae 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -47,9 +47,9 @@
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-# define inline		inline		__attribute__((always_inline))
-# define __inline__	__inline__	__attribute__((always_inline))
-# define __inline	__inline	__attribute__((always_inline))
+# define inline		inline		__attribute__((always_inline)) notrace
+# define __inline__	__inline__	__attribute__((always_inline)) notrace
+# define __inline	__inline	__attribute__((always_inline)) notrace
 #else
 /* A lot of inline functions can cause havoc with function tracing */
 # define inline		inline		notrace
