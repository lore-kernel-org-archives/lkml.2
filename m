Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1I0VpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:45:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42196 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1I0VpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:45:01 -0400
Date: Tue, 27 Sep 2011 23:44:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/7] rcu: Fix preempt-unsafe debug check of rcu extended
 quiescent state
Message-ID: <20110927214453.GO18553@somewhere>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
 <1317032352-25571-2-git-send-email-fweisbec@gmail.com>
 <CAG1a4rtKc0ZPZEeAsde-u7Xw9w36Oi05Zd--ueHT2XHbqRr6cg@mail.gmail.com>
 <20110927115002.GH18553@somewhere>
 <CAG1a4ruxzNo3TrRZTTLQWNfhVK7mB_0Mr4ff=tuK9k6CZbReDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG1a4ruxzNo3TrRZTTLQWNfhVK7mB_0Mr4ff=tuK9k6CZbReDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:16:02AM -0400, Pavel Ivanov wrote:
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

So, like Paul said rcu_read_lock() doesn't necessary imply to disable
preemption.

Hence by the time we call rcu_check_extended_qs() the current task
can be migrated anytime before, while in the function (except
a little part) or after.

The CPU I was referring to when I talked about "CPU we are currently
running on" is the CPU we are running between the call to get_cpu_var()
and put_cpu_var(). This one can not be changed because get_cpu_var()
disables preemption.

So consider this piece of code:

        struct rcu_dynticks *rdtp =
               &get_cpu_var(rcu_dynticks);
        bool ext_qs = true;
 
        if (atomic_read(&rdtp->dynticks) & 0x1)
                ext_qs = false;
 
        put_cpu_var(rcu_dynticks);	

What I expect from preemption disabled is that when I read the local
CPU variable rdtp->dyntick, I'm sure this is the CPU var of the local
CPU and the rdtp->dyntick from another CPU.

If I don't disable preemption, like it was without my patch:

0	struct rcu_dynticks *rdtp =
1               &__raw_get_cpu_var(rcu_dynticks);
2
3        if (atomic_read(&rdtp->dynticks) & 0x1)
4                ext_qs = false;
5
6        put_cpu_var(rcu_dynticks);	

I can fetch rdtp of CPU 1 in line 0. Then the task migrates on CPU 2.
So on line 3 I'm reading rdtp->dynticks of CPU 1 from CPU 2 and this is
racy because CPU 1 can change the value of rdtp->dynticks concurrently.

Now indeed it's weird because we can migrate anytime outside that preempt
disabled section.

So let's explore the two cases where this function can be called:

- From the idle task. For now this is the only place where we can
run sections of code in RCU extended quiescent state. If any use
of RCU is made on such section, it will hit our check.
Here there is no head-scratching about the role of disabling preemption
because the idle tasks can't be migrated. There is one per cpu so
the rcu_dynticks variable we look at is always the same inside a
given idle task.

- From a normal task. We assume it can be migrated anytime. But
normal tasks aren't supposed in RCU extended quiescent state.
Still the check can be useful there and spot for example cases where
we exit the idle task without calling rcu_exit_nohz().

Now from a normal task, when we call rcu_read_lock(), we assume
we can read the value dynticks from any CPU, wherever we migrate
to. So for example if we are running idle in CPU 1, then we exit
idle without calling rcu_exit_nohz(), the next task running on this
CPU is about to call rcu_read_lock(), but of on the last time before
we do our check it migrates to CPU 2. It won't detect the issue in CPU 1
then. But it doesn't matter much, soon or later there are fair
chances there will be a call to rcu_read_lock() on CPU 1 that
will report the issue.

That's also an anticipation for future development where we may
call rcu_enter_nohz() in more place than just idle. Like in
the Nohz cpusets for example.

Right?
