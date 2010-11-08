Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0KHPTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:19:30 -0500
Received: from flusers.ccur.com ([173.221.59.2]:38014 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006Ab0KHPT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:19:29 -0500
Date: Mon, 8 Nov 2010 10:18:29 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        Jim Houston <jim.houston@comcast.net>
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108151829.GB8996@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <20101106192812.GI15561@linux.vnet.ibm.com>
 <20101108150644.GB5466@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108150644.GB5466@nowhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:06:47AM -0500, Frederic Weisbecker wrote:
> On Sat, Nov 06, 2010 at 12:28:12PM -0700, Paul E. McKenney wrote:
>> OK, so your approach treats preempt_disable code sequences as RCU
>> read-side critical sections by relying on the fact that the per-CPU
>> ->krcud task cannot run until such code sequences complete, correct?
>> 
>> This seems to require that each CPU's ->krcud task be awakened at
>> least once per grace period, but I might well be missing something.
> 
> I understood it differently, but I might also be wrong as well. krcud
> executes the callbacks, but it is only woken up for CPUs that want to
> execute callbacks, not for those that only signal a quiescent state,
> which is only determined in two ways through rcu_poll_other_cpus():
> 
> - if the CPU is in an rcu_read_lock() critical section, it has the
>   IN_RCU_READ_LOCK flag. If so then we set up its DO_RCU_COMPLETION flag so
>   that it signals its quiescent state on rcu_read_unlock().
> 
> - otherwise it's in a quiescent state.
> 
> This works for rcu and rcu bh critical sections.
> But this works in rcu sched critical sections only if rcu_read_lock_sched() has
> been called explicitly, otherwise that doesn't work (in preempt_disable(),
> local_irq_save(), etc...). I think this is what is not complete when
> Joe said it's not yet a complete rcu implementation.
> 
> This is also the part that scaries me most :)

Mostly, I meant that the new RCU API interfaces that have come into
existance since 2004 were only hastily wrapped or NOPed by me to get
things going.

Jim's method only works with explicit rcu_read_lock..unlock sequences,
implicit sequences via preempt_disable..enable and the like are not
handled.  I had thought all such sequences were converted to rcu_read_lock
but maybe that is not yet correct.

Jim will have to comment on the full history.  He is incommunicado
at the moment; hopefully he will be able to participate sometime in
the next few days.

Regards,
Joe
