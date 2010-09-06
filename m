Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0IFGxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:53:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0IFGxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:53:04 -0400
Date: Mon, 6 Sep 2010 08:52:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Daniel <wanders.thirst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, pjohn@mvista.com
Subject: Re: clock drift in set_task_cpu()
Message-ID: <20100906065229.GA14609@elte.hu>
References: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
 <1281002322.1923.1708.camel@laptop>
 <AANLkTi=Tyh2cBtffOthiYcu=+ZHWW8FfSeFwLUq84Q3y@mail.gmail.com>
 <1281365803.5390.2.camel@localhost.localdomain>
 <AANLkTimH45_46HiKWOudAS0zxTHjHyrsuxWoyFF1cdFv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimH45_46HiKWOudAS0zxTHjHyrsuxWoyFF1cdFv@mail.gmail.com>
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


* Jack Daniel <wanders.thirst@gmail.com> wrote:

> Hi Ingo,
>
> [...]
> 
> Any chance that you will be pulling in this fix ?

It's already upstream, as of v2.6.36-rc3. See the commit notification 
email below from Aug 19.

Thanks,

	Ingo

----- Forwarded message from tip-bot for Peter Zijlstra <peterz@infradead.org> -----

Date: Fri, 20 Aug 2010 14:16:14 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
	a.p.zijlstra@chello.nl, peterz@infradead.org, pjohn@mvista.com,
	wanders.thirst@gmail.com, tglx@linutronix.de, mingo@elte.hu
Subject: [tip:sched/urgent] sched: Fix rq->clock synchronization when migrating tasks

Commit-ID:  861d034ee814917a83bd5de4b26e3b8336ddeeb8
Gitweb:     http://git.kernel.org/tip/861d034ee814917a83bd5de4b26e3b8336ddeeb8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 19 Aug 2010 13:31:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Aug 2010 14:59:01 +0200

sched: Fix rq->clock synchronization when migrating tasks

sched_fork() -- we do task placement in ->task_fork_fair() ensure we
  update_rq_clock() so we work with current time. We leave the vruntime
  in relative state, so the time delay until wake_up_new_task() doesn't
  matter.

wake_up_new_task() -- Since task_fork_fair() left p->vruntime in
  relative state we can safely migrate, the activate_task() on the
  remote rq will call update_rq_clock() and causes the clock to be
  synced (enough).

Tested-by: Jack Daniel <wanders.thirst@gmail.com>
Tested-by: Philby John <pjohn@mvista.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1281002322.1923.1708.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 806d1b2..ab661eb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3752,6 +3752,8 @@ static void task_fork_fair(struct task_struct *p)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
+	update_rq_clock(rq);
+
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
 

----- End forwarded message -----
