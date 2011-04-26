Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab1DZRNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:13:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757556Ab1DZRNi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110426183859.6ff6279b@neptune.home>
References: <20110425180450.1ede0845@neptune.home> <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
 <20110425190032.7904c95d@neptune.home> <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com>
 <20110425203606.4e78246c@neptune.home> <20110425191607.GL2468@linux.vnet.ibm.com>
 <20110425231016.34b4293e@neptune.home> <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
 <20110425214933.GO2468@linux.vnet.ibm.com> <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2011 10:12:39 -0700
Message-ID: <BANLkTin3UG=xF1VQOtdEDOnShoMQwQ7gFg@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulmck@linux.vnet.ibm.com, Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 9:38 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> Here it comes:
>
> rcu_kthread (when build processes are STOPped):
> [  836.050003] rcu_kthread     R running   7324     6      2 0x00000000
> [  836.050003]  dd473f28 00000046 5a000240 dd65207c dd407360 dd651d40 0000035c dd473ed8
> [  836.050003]  c10bf8a2 c14d63d8 dd65207c dd473f28 dd445040 dd445040 dd473eec c10be848
> [  836.050003]  dd651d40 dd407360 ddfdca00 dd473f14 c10bfde2 00000000 00000001 000007b6
> [  836.050003] Call Trace:
> [  836.050003]  [<c10bf8a2>] ? check_object+0x92/0x210
> [  836.050003]  [<c10be848>] ? init_object+0x38/0x70
> [  836.050003]  [<c10bfde2>] ? free_debug_processing+0x112/0x1f0
> [  836.050003]  [<c103d9fd>] ? lock_timer_base+0x2d/0x70
> [  836.050003]  [<c13c8ec7>] schedule_timeout+0x137/0x280

Hmm.

I'm adding Ingo and Peter to the cc, because this whole "rcu_kthread
is running, but never actually running" is starting to smell like a
scheduler issue.

Peter/Ingo: RCUTINY seems to be broken for Bruno. During any kind of
heavy workload, at some point it looks like rcu_kthread simply stops
making any progress. It's constantly in runnable state, but it doesn't
actually use any CPU time, and it's not processing the RCU callbacks,
so the RCU memory freeing isn't happening, and slabs just build up
until the machine dies.

And it really is RCUTINY, because the thing doesn't happen with the
regular tree-RCU.

This is without CONFIG_RCU_BOOST_PRIO, so we basically have

        struct sched_param sp;

        rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
        sp.sched_priority = RCU_BOOST_PRIO;
        sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);

where RCU_BOOST_PRIO is 1 for the non-boost case.

Is that so low that even the idle thread will take priority? It's a UP
config with PREEMPT_VOLUNTARY. So pretty much _all_ the stars are
aligned for odd scheduling behavior.

Other users of SCHED_FIFO tend to set the priority really high (eg
"MAX_RT_PRIO-1" is clearly the default one - softirq's, watchdog), but
"1" is not unheard of either (touchscreen/ucb1400_ts and
mmc/core/sdio_irq), and there are some other random choises out tere.

Any ideas?

                             Linus
