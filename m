Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1EZSbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:31:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58494 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab1EZSba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=cxbD0AfU/qZ1u91ukVl6kER4rS4iV3H4lsDZQSaHh7cgoIfssAfX0/DU1lGYwqOpVC
         QQdSPDI/0R7gu6VPhEZjUovbp4tTsVwI6FnTEttTP/N6/O+sKXHE99Tuy5e8KeP8SqwC
         DlZFu8uOWkmra7g4Ht8yRazoAEZD6aF53ZqXA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110526173128.GE2386@linux.vnet.ibm.com>
References: <BANLkTink15DRi6WJT2g07zd6-=MtW2hODw@mail.gmail.com>
	<20110526173128.GE2386@linux.vnet.ibm.com>
Date: Thu, 26 May 2011 20:31:28 +0200
Message-ID: <BANLkTi=Y-JxoURbT7SanqeDO19RLpSUpBg@mail.gmail.com>
Subject: Re: linux-next: Tree for May 26 (RCU stalls)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 7:31 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, May 26, 2011 at 05:48:32PM +0200, Sedat Dilek wrote:
>> On Thu, May 26, 2011 at 8:39 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi all,
>> >
>> > [The kernel.org mirroring is being slow today]
>> >
>> > Changes since 20110525:
>> >
>> > Linus' tree gained a build failure for which I applied a patch.
>> >
>> > The m68knommu tree lost its conflicts.
>> >
>> > The hwmon-staging lost its conflict.
>> >
>> > The wireless lost its conflict.
>> >
>> > The mmc lost its conflict.
>> >
>> > The dwmw2-iommu tree lost its conflict.
>> >
>> > The kvm tree still had its build failure so I used the version from
>> > next-20110524.
>> >
>> > The namespace lost its conflicts.
>> >
>> > ----------------------------------------------------------------------------
>> >
>>
>> Hi,
>>
>> I see these call-traces on x86 UP machine:
>>
>> [  240.268061] INFO: task rcun0:8 blocked for more than 120 seconds.
>> [  240.268069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [  240.268072] rcun0           D 00000000     0     8      2 0x00000000
>> [  240.268079]  f6473fb8 00000046 013131b6 00000000 c1461ac0 00000000
>> 00000000 c1461ac0
>> [  240.268089]  00000000 00000000 f645dc70 f645bf60 00000003 f6473f78
>> c102a570 f6473f9c
>> [  240.268097]  c1021476 00000000 f645bf6c 00000001 00000000 00000286
>> f6473f9c c129b35a
>> [  240.268106] Call Trace:
>> [  240.268121]  [<c102a570>] ? default_wake_function+0xb/0xd
>> [  240.268127]  [<c1021476>] ? __wake_up_common+0x33/0x5b
>> [  240.268134]  [<c129b35a>] ? _raw_spin_unlock_irqrestore+0xe/0x10
>> [  240.268140]  [<c10234ed>] ? complete+0x34/0x3e
>> [  240.268147]  [<c1074d23>] ? cpumask_weight+0xc/0xc
>> [  240.268157]  [<c1044c97>] kthread+0x53/0x67
>> [  240.268162]  [<c1044c44>] ? kthread_worker_fn+0x111/0x111
>> [  240.268169]  [<c12a123e>] kernel_thread_helper+0x6/0xd
>>
>> dmesg and kernel-config are attached.
>
> Hello, Sedat,
>
> Does the following patch clear things up?
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state
>
> Upon creation, kthreads are in TASK_UNINTERRUPTIBLE state, which can
> result in softlockup warnings.  Because some of RCU's kthreads can
> legitimately be idle indefinitely, start them in TASK_INTERRUPTIBLE
> state in order to avoid those warnings.
>
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Yinghai Lu <yinghai@kernel.org>
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index a1a8bb6..40aab8d 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1647,6 +1647,7 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
>        if (IS_ERR(t))
>                return PTR_ERR(t);
>        kthread_bind(t, cpu);
> +       set_task_state(t, TASK_INTERRUPTIBLE);
>        per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
>        WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
>        per_cpu(rcu_cpu_kthread_task, cpu) = t;
> @@ -1754,6 +1755,7 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
>                if (IS_ERR(t))
>                        return PTR_ERR(t);
>                raw_spin_lock_irqsave(&rnp->lock, flags);
> +               set_task_state(t, TASK_INTERRUPTIBLE);
>                rnp->node_kthread_task = t;
>                raw_spin_unlock_irqrestore(&rnp->lock, flags);
>                sp.sched_priority = 99;
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 049f278..a767b7d 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1295,6 +1295,7 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
>        if (IS_ERR(t))
>                return PTR_ERR(t);
>        raw_spin_lock_irqsave(&rnp->lock, flags);
> +       set_task_state(t, TASK_INTERRUPTIBLE);
>        rnp->boost_kthread_task = t;
>        raw_spin_unlock_irqrestore(&rnp->lock, flags);
>        sp.sched_priority = RCU_KTHREAD_PRIO;
>

Thanks for the quick reply and patch!

On 1st look at dmesg the RCU stalls are gone.
I tested against linux-next (next-20110526).

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
