Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2FNFfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 01:35:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:39320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2FNFfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 01:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165453256"
Date: Thu, 14 Jun 2012 13:35:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: rcu-torture boot hang
Message-ID: <20120614053547.GA10745@localhost>
References: <20120612012134.GA7706@localhost>
 <20120612121122.GA17891@localhost>
 <20120613124900.GA1741@localhost>
 <20120614025504.GE30024@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614025504.GE30024@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Jun 13, 2012 at 10:55:04PM -0400, Steven Rostedt wrote:
> Just a note. Please use my goodmis email and not my Red Hat email. My
> Red Hat email is not checked as often, and I don't usually tag emails
> there as "reply to". I only author with that email to give credit to the
> one that pays me to do the work (and I don't mean just for the LWN
> stats).

OK, got it!

> On Wed, Jun 13, 2012 at 08:49:00PM +0800, Fengguang Wu wrote:
> > Hi Steven,
> > 
> > On Tue, Jun 12, 2012 at 08:11:22PM +0800, Fengguang Wu wrote:
> > > Hi Paul,
> > > 
> > > In kernel boot tests with the attached config, I find the 3.5-rc2+
> > > kernels all hang here:
> > > 
> > > [    6.522546] rcu-torture:--- Start of test: nreaders=2
> > > nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0
> > > shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0
> > > fqs_stutter=3 test_boost=1/0 test_boost_interval=7
> > > test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> > 
> > It turns out that commit 5963e317b1e9d2a4511503916d8fd664bb8fa8fb
> > ("ftrace/x86: Do not change stacks in DEBUG when calling lockdep") is
> > the root cause of this boot hang. The commit is reported by git bisect
> > and confirmed to fix the boot hang by reverting in on 3.5-rc2.
> 
> I get the hang with your config too. If I disable both LOCKDEP and
> IRQSOFF_TRACER which turns off TRACE_IRQFLAGS then the lockup goes away.
> This is consistent with your findings, as the patch you found is only
> enabled when TRACE_IRQFLAGS is on.
> 
> > 
> >         [ rcu torture tests ]
> > 
> > ...It would hang here before reverting the commit...
> > 
> >         [    1.611901] Testing tracer function: PASSED
> 
> I did a bit more investigation and found that the problem comes from the
> load_idt() command that is used to avoid reseting the debug stack. When
> the function tracer is enabled it adds breakpoints to all locations that
> it is about to trace in order to convert the nops in the functions into
> calls to the tracer. But if the breakpoint handler is traced, the
> breakpoint in the handler will reset the stack and cause a crash.
> 
> Your above observation is correct. Actually I added a printk in my
> testing and found that the 'Testing trace function:' does output before
> the lockup. I think printk changed recently that prevents it to print
> out right away if a '\n' is not supplied. The function tracer self test
> prints:
> 
>   'Testing tracer function: '
> 
> Runs the test, and when it succeeds it prints 'PASSED\n'. Because the
> first part wasn't printed, we never saw that the function tracer was
> being tested when the lockup occurred.
> 
> This is a major flaw with the new printk(). It hides what is being
> tested. I need to write a patch to create a fflush() for printk.

Yes, it would definitely help if the printk message was flushed!

> Anyway, load_idt() shouldn't be traced, but with PARAVIRT_GUEST it makes
> functions that are even always_inlined not inlined, and allows things
> like native_load_idt() to be traced, and that causes bad things as we
> want to call load_idt to prevent recursion of the int3 handler.
> 
> 
> If it works, can you give me your 'Tested-by'.

It worked, thank you very much!

I apply the patch on linus master (which is confirmed to hang) and
it boots successfully for 3 times:

[    1.450495] Kprobe smoke test started
[    1.459965] Kprobe smoke test passed successfully
[    1.461578] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    1.689860] Testing tracer function: PASSED
[    2.047064] Testing dynamic ftrace: PASSED
[    2.378968] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 3) (2 2 4 1 21) PASSED

Tested-by: Fengguang Wu <wfg@linux.intel.com>

Thanks,
Fengguang

> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index e5834aa..6a6d7ae 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -47,9 +47,9 @@
>   */
>  #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
>      !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
> -# define inline		inline		__attribute__((always_inline))
> -# define __inline__	__inline__	__attribute__((always_inline))
> -# define __inline	__inline	__attribute__((always_inline))
> +# define inline		inline		__attribute__((always_inline)) notrace
> +# define __inline__	__inline__	__attribute__((always_inline)) notrace
> +# define __inline	__inline	__attribute__((always_inline)) notrace
>  #else
>  /* A lot of inline functions can cause havoc with function tracing */
>  # define inline		inline		notrace
