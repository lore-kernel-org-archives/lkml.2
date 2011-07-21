Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab1GUFJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 01:09:50 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33741 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1GUFJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 01:09:49 -0400
Date: Wed, 20 Jul 2011 22:09:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, greearb@candelatech.com,
        edt@aei.ca
Subject: Re: [PATCH tip/core/urgent 3/7] rcu: Streamline code produced by
 __rcu_read_unlock()
Message-ID: <20110721050927.GV2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720182512.GA22946@linux.vnet.ibm.com>
 <1311186383-24819-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <CA+55aFzWAWV4Vr5mhy6+EELNY4_jCr4ozjgHmPk1CMp3mTOegw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWAWV4Vr5mhy6+EELNY4_jCr4ozjgHmPk1CMp3mTOegw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 03:44:55PM -0700, Linus Torvalds wrote:
> On Wed, Jul 20, 2011 at 11:26 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > Given some common flag combinations, particularly -Os, gcc will inline
> > rcu_read_unlock_special() despite its being in an unlikely() clause.
> > Use noinline to prohibit this misoptimization.
> 
> Btw, I suspect that we should at least look at what it would mean if
> we make the rcu_read_lock_nesting and the preempt counters both be
> per-cpu variables instead of making them per-thread/process counters.
> 
> Then, when we switch threads, we'd just save/restore them from the
> process register save area.
> 
> There's a lot of critical code sequences (spin-lock/unlock, rcu
> read-lock/unlock) that currently fetches the thread/process pointer
> only to then offset it and increment the count. I get the strong
> feeling that code generation could be improved and we could avoid one
> level of indirection by just making it a per-thread counter.
> 
> For example, instead of __rcu_read_lock: looking like this (and being
> an external function, partly because of header file dependencies on
> the data structures involved):
> 
>   push   %rbp
>   mov    %rsp,%rbp
>   mov    %gs:0xb580,%rax
>   incl   0x100(%rax)
>   leaveq
>   retq
> 
> it should inline to just something like
> 
>   incl %gs:0x100
> 
> instead. Same for the preempt counter.
> 
> Of course, it would need to involve making sure that we pick a good
> cacheline etc that is already always dirty. But other than that, is
> there any real downside?

We would need a form of per-CPU variable access that generated
efficient code, but that didn't complain about being used when
preemption was enabled.  __this_cpu_add_4() might do the trick,
but I haven't dug fully through it yet.

						Thanx, Paul
