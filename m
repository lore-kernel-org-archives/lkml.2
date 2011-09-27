Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1I0QD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:03:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42051 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1I0QD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:03:27 -0400
Date: Tue, 27 Sep 2011 09:01:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/7] rcu: Fix preempt-unsafe debug check of rcu
 extended quiescent state
Message-ID: <20110927160100.GC2335@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
 <1317032352-25571-2-git-send-email-fweisbec@gmail.com>
 <CAG1a4rtKc0ZPZEeAsde-u7Xw9w36Oi05Zd--ueHT2XHbqRr6cg@mail.gmail.com>
 <20110927115002.GH18553@somewhere>
 <CAG1a4ruxzNo3TrRZTTLQWNfhVK7mB_0Mr4ff=tuK9k6CZbReDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG1a4ruxzNo3TrRZTTLQWNfhVK7mB_0Mr4ff=tuK9k6CZbReDg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:16:02AM -0400, Pavel Ivanov wrote:
> On Tue, Sep 27, 2011 at 7:50 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Mon, Sep 26, 2011 at 06:04:06PM -0400, Pavel Ivanov wrote:
> >> On Mon, Sep 26, 2011 at 6:19 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > In the rcu_check_extended_qs() function that is used to check
> >> > illegal uses of RCU under extended quiescent states, we look
> >> > at the local value of dynticks that is even if an extended
> >> > quiescent state or odd otherwise.
> >> >
> >> > We are looking at it without disabling the preemption though
> >> > and this opens a race window where we may read the state of
> >> > a remote CPU instead, like in the following scenario:
> >> >
> >> > CPU 1                                                        CPU 2
> >> >
> >> > bool rcu_check_extended_qs(void)
> >> > {
> >> >        struct rcu_dynticks *rdtp;
> >> >
> >> >        rdtp = &per_cpu(rcu_dynticks,
> >> >                        raw_smp_processor_id());
> >> >
> >> >        < ---- Task is migrated here ---- >
> >> >
> >> >        // CPU 1 goes idle and increase rdtp->dynticks
> >> >                                                        /* Here we are reading the value for
> >> >                                                        the remote CPU 1 instead of the local CPU */
> >> >                                                        if (atomic_read(&rdtp->dynticks) & 0x1)
> >> >                                                                return false;
> >> >
> >> >                                                        return true;
> >> >                                                        }
> >> >
> >> > The possible result of this is false positive return value of that
> >> > function, suggesting we are in an extended quiescent state in random
> >> > places.
> >>
> >> How is this different from what your patch allows?
> >>
> >> CPU 1                                               CPU 2
> >>
> >> bool rcu_check_extended_qs(void)
> >> {
> >>        struct rcu_dynticks *rdtp =
> >>                &get_cpu_var(rcu_dynticks);
> >>        bool ext_qs = true;
> >>
> >>        if (atomic_read(&rdtp->dynticks) & 0x1)
> >>                ext_qs = false;
> >>
> >>        put_cpu_var(rcu_dynticks);
> >>
> >>        < ---- Task is migrated here ---- >
> >>
> >>                                                   /* Here we return true/false
> >>                                                      based on the value for the
> >>                                                      remote CPU 1 instead of the
> >>                                                      local CPU */
> >>
> >>                                                   return ext_qs;
> >>                                                   }
> >>
> >>
> >> Looks like it can result in the same false positive result.
> >
> > Why?
> >
> > While calling rcu_read_lock(), the task can still be migrated
> > for example from CPU 0 to CPU 1, until we do our check
> > in rcu_check_extended_qs() with preemption disabled. But that's
> > not a problem, we are going to do our check either in CPU 0 or
> > CPU 1, that's doesn't matter much.
> 
> I don't have sources at hand now to check all call sites of
> rcu_check_extended_qs(). But are you saying that
> rcu_check_extended_qs() is always called after rcu_read_lock() ? If
> that's the case then preemption is already disabled, right? Otherwise
> I don't understand your reasoning here.

For kernels built with CONFIG_TREE_PREEMPT_RCU or CONFIG_TINY_PREEMPT_RCU,
rcu_read_lock() does not imply preempt_disable().  So you really can be
in an RCU read-side critical section without having preemption disabled.

> > What matters is that we do that check by ensuring we are really
> > checking the value of the cpu var in the CPU we are currently
> > running and not some other random one that can change its dynticks
> > value at the same time.
> 
> Define the "CPU we are currently running on" in this context. Is it
> CPU executing call to rcu_check_extended_qs() or is it CPU executing
> return from rcu_check_extended_qs() ? These CPUs can be different both
> before your patch and after that. And function can return extended_qs
> state from either of these CPUs again both before and after the patch.
> If the calling code wants these CPUs to be the same it has to disable
> preemption before making the call. And if it does so then additional
> preemption disabling inside the function is pointless.
> 
> All your patch does is changing possible scenarios of preemption...
> Wait a minute... Is that the whole point of the patch? If CPU where
> rcu_check_extended_qs() was called is in an extended qs then function
> cannot be preempted and so it will correctly return true from current
> CPU. If CPU where rcu_check_extended_qs() was called is not in
> extended qs then function can be preempted and migrated. But CPU where
> it migrates to won't be in extended qs either and thus function will
> correctly return false no matter which per_cpu variable is read. Is my
> understanding correct now? If so it's better to be explained in the
> commit log.
> 
> BTW, isn't it possible for CPU to wake up from extended qs after some
> interrupt coming in the middle of the function?

Indeed this can happen.  The calls to rcu_irq_enter() and
rcu_irq_exit() handle this transition from dyntick-idle extended
quiescent state to RCU being usable in the interrrupt handler.

							Thanx, Paul
