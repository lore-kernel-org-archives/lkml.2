Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1FTKVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:21:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36808 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab1FTKVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:21:44 -0400
Subject: Re: [tip:sched/urgent] cpuset: Fix cpuset_cpus_allowed_fallback(),
 don't update tsk->rt.nr_cpus_allowed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d@git.kernel.org>
References: <4DD4B3FA.5060901@jp.fujitsu.com>
	 <tip-1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Jun 2011 12:20:58 +0200
Message-ID: <1308565258.26237.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 16:35 +0000, tip-bot for KOSAKI Motohiro wrote:
> +++ b/kernel/kthread.c
> @@ -202,8 +202,8 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
>                 return;
>         }
>  
> -       p->cpus_allowed = cpumask_of_cpu(cpu);
> -       p->rt.nr_cpus_allowed = 1;
> +       /* It's safe because the task is inactive. */
> +       do_set_cpus_allowed(p, cpumask_of(cpu));
>         p->flags |= PF_THREAD_BOUND;
>  }


I just happened  to be staring at this stuff again, and I'm wondering
how and why this is correct. After kthread_create() the thread exists
and is exposed in the pid-hash, therefore userspace can come and do
sys_sched_setaffinity() on it, and since we're not holding any locks and
set PF_THREAD_BOUND _after_ setting cpus_allowed, things can end up
funny.

Hmm?
