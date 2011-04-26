Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1DZTRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:17:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47590 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1DZTR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=r7CE9uUeH+S7J8CRT8B96kf6PfhmiYEyaeTkpyJfuGr7MhapG9OFmRBcqXR409eykJ
         VGhVwQtpUhcnN+HhoO4Dkl2IimQwcjAt+JxJK0piqT09QywLFwIrj7ZYF2sgZueh9Xw3
         x3Sy9lz5BqQ9JfQ8qEJBfRlJ1oXtaeSjlfzIQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110426185036.GG2135@linux.vnet.ibm.com>
References: <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>
	<20110425203606.4e78246c@neptune.home>
	<20110425191607.GL2468@linux.vnet.ibm.com>
	<20110425231016.34b4293e@neptune.home>
	<BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
	<20110425214933.GO2468@linux.vnet.ibm.com>
	<20110426081904.0d2b1494@pluto.restena.lu>
	<20110426112756.GF4308@linux.vnet.ibm.com>
	<20110426183859.6ff6279b@neptune.home>
	<BANLkTin3UG=xF1VQOtdEDOnShoMQwQ7gFg@mail.gmail.com>
	<20110426185036.GG2135@linux.vnet.ibm.com>
Date: Tue, 26 Apr 2011 21:17:28 +0200
Message-ID: <BANLkTinqm7CTACEYuMZxKmXkjwHRyg+fHw@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 8:50 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Apr 26, 2011 at 10:12:39AM -0700, Linus Torvalds wrote:
>> On Tue, Apr 26, 2011 at 9:38 AM, Bruno Prémont
>> <bonbons@linux-vserver.org> wrote:
>> >
>> > Here it comes:
>> >
>> > rcu_kthread (when build processes are STOPped):
>> > [  836.050003] rcu_kthread     R running   7324     6      2 0x00000000
>> > [  836.050003]  dd473f28 00000046 5a000240 dd65207c dd407360 dd651d40 0000035c dd473ed8
>> > [  836.050003]  c10bf8a2 c14d63d8 dd65207c dd473f28 dd445040 dd445040 dd473eec c10be848
>> > [  836.050003]  dd651d40 dd407360 ddfdca00 dd473f14 c10bfde2 00000000 00000001 000007b6
>> > [  836.050003] Call Trace:
>> > [  836.050003]  [<c10bf8a2>] ? check_object+0x92/0x210
>> > [  836.050003]  [<c10be848>] ? init_object+0x38/0x70
>> > [  836.050003]  [<c10bfde2>] ? free_debug_processing+0x112/0x1f0
>> > [  836.050003]  [<c103d9fd>] ? lock_timer_base+0x2d/0x70
>> > [  836.050003]  [<c13c8ec7>] schedule_timeout+0x137/0x280
>>
>> Hmm.
>>
>> I'm adding Ingo and Peter to the cc, because this whole "rcu_kthread
>> is running, but never actually running" is starting to smell like a
>> scheduler issue.
>>
>> Peter/Ingo: RCUTINY seems to be broken for Bruno. During any kind of
>> heavy workload, at some point it looks like rcu_kthread simply stops
>> making any progress. It's constantly in runnable state, but it doesn't
>> actually use any CPU time, and it's not processing the RCU callbacks,
>> so the RCU memory freeing isn't happening, and slabs just build up
>> until the machine dies.
>>
>> And it really is RCUTINY, because the thing doesn't happen with the
>> regular tree-RCU.
>
> The difference between TINY_RCU and TREE_RCU is that TREE_RCU still uses
> softirq for the core RCU processing.  TINY_RCU switched to a kthread
> when I implemented RCU priority boosting.  There is a similar change in
> my -rcu tree that makes TREE_RCU use kthreads, and Sedat has been running
> into a very similar problem with that change in place.  Which is why I
> do not yet push it to the -next tree.
>
>> This is without CONFIG_RCU_BOOST_PRIO, so we basically have
>>
>>         struct sched_param sp;
>>
>>         rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
>>         sp.sched_priority = RCU_BOOST_PRIO;
>>         sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
>>
>> where RCU_BOOST_PRIO is 1 for the non-boost case.
>
> Good point!  Bruno, Sedat, could you please set CONFIG_RCU_BOOST_PRIO to
> (say) 50, and see if this still happens?  (I bet that you do, but...)
>

What's with CONFIG_RCU_BOOST_DELAY setting?

Are those values OK?

$ egrep 'M486|M686|X86_UP|CONFIG_SMP|NR_CPUS|PREEMPT|_RCU|_HIGHMEM|PAE' .config
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=50
CONFIG_RCU_BOOST_DELAY=500
CONFIG_SMP=y
# CONFIG_M486 is not set
CONFIG_M686=y
CONFIG_NR_CPUS=32
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_HIGHMEM=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_PREEMPT=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_PREEMPT_TRACER=y

- Sedat -

>> Is that so low that even the idle thread will take priority? It's a UP
>> config with PREEMPT_VOLUNTARY. So pretty much _all_ the stars are
>> aligned for odd scheduling behavior.
>>
>> Other users of SCHED_FIFO tend to set the priority really high (eg
>> "MAX_RT_PRIO-1" is clearly the default one - softirq's, watchdog), but
>> "1" is not unheard of either (touchscreen/ucb1400_ts and
>> mmc/core/sdio_irq), and there are some other random choises out tere.
>>
>> Any ideas?
>
> I have found one bug so far in my code, but it only affects TREE_RCU
> in my -rcu tree, and even then only if HOTPLUG_CPU is enabled.  I am
> testing a fix, but I expect Sedat's tests to still break.
>
> I gave Sedat a patch that make rcu_kthread() run at normal (non-realtime)
> priority, and he did not see the failure.  So running non-realtime at
> least greatly reduces the probability of failure.
>
>                                                        Thanx, Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
