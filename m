Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab1FUJzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:55:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59268 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1FUJzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:55:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E006A70.2070205@jp.fujitsu.com>
Date: Tue, 21 Jun 2011 18:54:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] cpuset: Fix cpuset_cpus_allowed_fallback(),
 don't update tsk->rt.nr_cpus_allowed
References: <4DD4B3FA.5060901@jp.fujitsu.com>	 <tip-1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d@git.kernel.org> <1308565258.26237.2.camel@twins>
In-Reply-To: <1308565258.26237.2.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/20 19:20), Peter Zijlstra wrote:
> On Sat, 2011-05-28 at 16:35 +0000, tip-bot for KOSAKI Motohiro wrote:
>> +++ b/kernel/kthread.c
>> @@ -202,8 +202,8 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
>>                 return;
>>         }
>>  
>> -       p->cpus_allowed = cpumask_of_cpu(cpu);
>> -       p->rt.nr_cpus_allowed = 1;
>> +       /* It's safe because the task is inactive. */
>> +       do_set_cpus_allowed(p, cpumask_of(cpu));
>>         p->flags |= PF_THREAD_BOUND;
>>  }
> 
> 
> I just happened  to be staring at this stuff again, and I'm wondering
> how and why this is correct. After kthread_create() the thread exists
> and is exposed in the pid-hash, therefore userspace can come and do
> sys_sched_setaffinity() on it, and since we're not holding any locks and
> set PF_THREAD_BOUND _after_ setting cpus_allowed, things can end up
> funny.
> 
> Hmm?

Can't we take just either rq lock or pi_lock? Layer violation?



>From 1c0874b9157f47e22d0f6499612f0f78b830f018 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 21 Jun 2011 18:15:19 +0900
Subject: [PATCH] kthread: fix kthread_bind() race

Peter Zijlstra reported kthread_bind() has a race. It doesn't hold
any locks and set PF_THREAD_BOUND _after_ setting cpus_allowed. So,
following race can be happen.

  CPU0                           CPU1
  ----------------------------------------------------
  do_set_cpus_allowed()
				sys_sched_setaffinity()
  p->flags |= PF_THREAD_BOUND;

The solution is to take either rq lock or pi_lock. They prevent
a race because set_cpus_allowed_ptr() take both locks. This patch
choose to use latter way.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/kthread.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4ba7ccc..92e3083 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -196,15 +196,20 @@ EXPORT_SYMBOL(kthread_create_on_node);
  */
 void kthread_bind(struct task_struct *p, unsigned int cpu)
 {
+	unsigned long flags;
+
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
 		WARN_ON(1);
 		return;
 	}

+	/* protect from a race against set_cpus_allowed_ptr() */
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
 	p->flags |= PF_THREAD_BOUND;
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 EXPORT_SYMBOL(kthread_bind);

-- 
1.7.3.1




