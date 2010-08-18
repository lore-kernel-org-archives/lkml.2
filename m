Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab0HRQPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:15:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48286 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0HRQPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:15:45 -0400
Date: Wed, 18 Aug 2010 18:15:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Deacon <will.deacon@arm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/0 v3] callchain fixes and cleanups
Message-ID: <20100818161520.GB31834@elte.hu>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
 <1282041159.22114.2.camel@e102144-lin.cambridge.arm.com>
 <20100818035507.GE24748@nowhere>
 <1282122527.14913.17.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282122527.14913.17.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> On Wed, 2010-08-18 at 04:55 +0100, Frederic Weisbecker wrote:
> > On Tue, Aug 17, 2010 at 11:32:39AM +0100, Will Deacon wrote:
> > > I've tested this on an ARM Cortex-A9 board and it all seems fine [plus
> > > the code is a lot cleaner!].
> > >
> > > Tested-by: Will Deacon <will.deacon@arm.com>
> > 
> > Thanks a lot!
> 
> > BTW, out of curiosity, do you have NMIs on ARM and do the hardware events
> > make use of them? Or may be you use FIQ to simulate NMIs?
> > 
> 
> We don't have NMIs on ARM [so obviously we can't use them!] but you're right 
> to point out the FIQ. I've actually been thinking about this during the past 
> week, but there are the following problems:
> 
> (1) The FIQ isn't always wired up in the hardware, so you can't
>     assume that it is available.

We dont always have NMIs on x86 either - we fall back to hrtimers in that 
case.

> (2) The FIQ can only have a single handler at a given time. This
>     is because it is a separate exception mode, with its own banked
>     registers. Consequently, we might not be able to use it if it's
>     being used for something else.

Technically the NMI is only a single exception source on x86 as well. We 
multiplex from there - if there are multiple users we call them using a 
notifier chain.

> (3) The Trustzone security extensions may reserve the FIQ for secure
>     use only or make it available only via the secure monitor [which
>     will increase latency].

As long as it can still be detected during PMU init and set up safely, it 
should be OK.

> Of course, the advantage is that we could then use sample-based profiling 
> techniques in sections of code where the interrupts are disabled.

Once you've tried NMI profiling you wont be going back - the difference is day 
and night ;-)

Here's the profile of a scheduling-intense workload using a timer based 
fallback path:

# Events: 586  cycles
#
# Overhead       Command      Shared Object                       Symbol
# ........  ............  .................  ...........................
#
    21.33%  pipe-test-1m  [kernel.kallsyms]  [k] finish_task_switch
    14.33%  pipe-test-1m  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     4.61%  pipe-test-1m  [kernel.kallsyms]  [k] avc_has_perm_noaudit
     3.75%  pipe-test-1m  [kernel.kallsyms]  [k] pipe_read
     3.58%  pipe-test-1m  libc-2.12.so       [.] __write_nocancel
     3.58%  pipe-test-1m  [kernel.kallsyms]  [k] copy_user_generic_string
     3.41%  pipe-test-1m  libc-2.12.so       [.] __GI___libc_read
     3.07%  pipe-test-1m  [kernel.kallsyms]  [k] system_call_after_swapgs
     3.07%  pipe-test-1m  [kernel.kallsyms]  [k] pipe_write
     3.07%  pipe-test-1m  [kernel.kallsyms]  [k] file_has_perm
     2.22%  pipe-test-1m  pipe-test-1m       [.] main
     2.22%  pipe-test-1m  [kernel.kallsyms]  [k] selinux_file_permission
     1.88%  pipe-test-1m  [kernel.kallsyms]  [k] rw_verify_area
     1.88%  pipe-test-1m  [kernel.kallsyms]  [k] fsnotify


# Events: 23K cycles
#
# Overhead       Command      Shared Object                               Symbol
# ........  ............  .................  ...................................
#
     7.14%  pipe-test-1m  [kernel.kallsyms]  [k] __default_send_IPI_dest_field
     4.34%  pipe-test-1m  [kernel.kallsyms]  [k] schedule
     4.27%  pipe-test-1m  [kernel.kallsyms]  [k] __switch_to
     3.88%  pipe-test-1m  [kernel.kallsyms]  [k] pipe_read
     3.57%  pipe-test-1m  [kernel.kallsyms]  [k] switch_mm
     3.45%  pipe-test-1m  [kernel.kallsyms]  [k] file_has_perm
     3.37%  pipe-test-1m  [kernel.kallsyms]  [k] copy_user_generic_string
     3.37%  pipe-test-1m  pipe-test-1m       [.] main
     3.20%  pipe-test-1m  [kernel.kallsyms]  [k] avc_has_perm_noaudit
     2.62%  pipe-test-1m  libc-2.12.so       [.] __GI___libc_read
     2.09%  pipe-test-1m  [kernel.kallsyms]  [k] fsnotify
     1.96%  pipe-test-1m  [kernel.kallsyms]  [k] system_call
     1.94%  pipe-test-1m  [kernel.kallsyms]  [k] pipe_write
     1.90%  pipe-test-1m  libc-2.12.so       [.] __write_nocancel
     1.88%  pipe-test-1m  [kernel.kallsyms]  [k] mutex_lock
     1.88%  pipe-test-1m  [kernel.kallsyms]  [k] selinux_file_permission
     1.78%  pipe-test-1m  [kernel.kallsyms]  [k] mutex_unlock
     1.66%  pipe-test-1m  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     1.50%  pipe-test-1m  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     1.23%  pipe-test-1m  [kernel.kallsyms]  [k] vfs_read
     1.19%  pipe-test-1m  [kernel.kallsyms]  [k] do_sync_read
     1.18%  pipe-test-1m  [kernel.kallsyms]  [k] update_curr

The NMI output is an order of magnitude richer in information.

> The only way I can think of adding this is as a Kconfig option, which, when 
> selected, tries to use the FIQ and then falls back to normal IRQs if it 
> fails.

Dynamic detection and a fallback path, should be perfectly OK. Kconfig options 
have the disadvantage of doubling the test space and halving the tester base 
(or worse).

Thanks,

	Ingo
