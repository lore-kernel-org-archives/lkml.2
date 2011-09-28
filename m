Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1I1Eeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:34:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44393 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1I1Eef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:34:35 -0400
Date: Wed, 28 Sep 2011 10:04:27 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110928043427.GI4357@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Venki Pallipadi <venki@google.com> [2011-09-27 12:53:21]:

> Some comments:
> 
> Another potential change here is to
> - either reverse the order of rebalance_domains() and
> nohz_idle_balance() in run_rebalance_domains()

I thought of that, but then realized that it won't influence our
"idle_at_tick" check in nohz_idle_balance(). Did you have any other benefit in
mind behind that change?

> - or to kick another idle CPU in case of need_resched() in nohz_idle_balance.
> This should help with idle balance of tickless CPUs when ilb CPU gets
> a new task through load balance and hence aborts ilb.

Yes good point. I will add that in next version.

> > - The patch introduces a 'nohz.next_balance_lock' spinlock which is used
> >  to update nohz.next_balance, so that it stays as min(rq->next_balance).
> >  This fixes issue #2. I don't like a global spinlock so much, but don't
> >  see easy way out. Besides, this lock is taken in context of idle cpu.
> >
> 
> The problem I see with this is that there is no way to reset
> next_balance when a previously idle CPU goes busy. This probably will
> result in frequent ilb than needed and potential power and
> performance(due to SMT or freq timer interrupts) impact.

That already seems to be an issue with existing code. One possibility is
to rescan idle cpus looking for the next min rq->next_balance (unless we
want to go for more sophisticated like a sorted list of rq->next_balance
in a rb-tree).

> > - It allows any busy cpu to kick ilb_cpu if it has greater than 2
> >  runnable tasks. This addresses issue #3
> 
> 
> This again may have power impact with frequent kicking.

I don't know how much additional kicks it would add - I mean the system
is busy and ilb_cpu deserves a kick. With this, we are forcing it to
happen sooner rather than wait for first/second_pick_cpu to do
"justice"?

> Especially with higher number of logical CPUs. Likely cleaner way is to clear
> first_pick, second_pick on idle instead of clearing on tickless.

I think I tried that (cleared first/second_pick_cpu in
nohz_kick_needed() upon idle) but didn't get the best results. Let me
try that again and post idle time numbers.

> Would be interesting to see some tests power impact (or number of
> interrupts, resched IPIs etc) of this change. Both with netbook kind
> of systems and on servers with partially idle configuration.

Ok - will get some numbers in that regard as well.

- vatsa
