Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1AFOdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:33:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35545 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1AFOdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:33:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AFNggveinSw2V038CFTmuctd+5dPxuAYBSC+Ip8YfYiR8xRHCiog3ljPo2dmNUAVD6
         RTiEeG6AG5Ck7DCO3OLw3ule0w5f2TGwy66HptDXX3DqWe+LvyZs4iVxfk9S0TXIVQ5M
         9GcqSFJQ0zEXqt0V2Fkbs2FzZOIfQkd80H1kk=
MIME-Version: 1.0
In-Reply-To: <1294246647.8369.52.camel@marge.simson.net>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	<20110103162918.577a9620@annuminas.surriel.com>
	<1294164289.2016.186.camel@laptop>
	<1294246647.8369.52.camel@marge.simson.net>
Date: Thu, 6 Jan 2011 22:33:38 +0800
Message-ID: <AANLkTimqoMCJDfKCS=WK9oEbzZNgN6fm8vNtrWSO8ski@mail.gmail.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 12:57 AM, Mike Galbraith <efault@gmx.de> wrote:
> sched: Add yield_to(task, preempt) functionality.
>
> Currently only implemented for fair class tasks.
>
> Add a yield_to_task method() to the fair scheduling class. allowing the
> caller of yield_to() to accelerate another thread in it's thread group,
> task group, and sched class toward either it's cpu, or potentially the
> caller's own cpu if the 'preempt' argument is also passed.
>
> Implemented via a scheduler hint, using cfs_rq->next to encourage the
> target being selected.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
>
> ---
>  include/linux/sched.h |    1
>  kernel/sched.c        |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched_fair.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 109 insertions(+)
>
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -1056,6 +1056,7 @@ struct sched_class {
>        void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
>        void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
>        void (*yield_task) (struct rq *rq);
> +       int (*yield_to_task) (struct task_struct *p, int preempt);
>
>        void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -5327,6 +5327,62 @@ void __sched yield(void)
>  }
>  EXPORT_SYMBOL(yield);
>
> +/**
> + * yield_to - yield the current processor to another thread in
> + * your thread group, or accelerate that thread toward the
> + * processor it's on.
> + *
> + * It's the caller's job to ensure that the target task struct
> + * can't go away on us before we can do any checks.
> + */
> +void __sched yield_to(struct task_struct *p, int preempt)
> +{
> +       struct task_struct *curr = current;
> +       struct rq *rq, *p_rq;
> +       unsigned long flags;
> +       int yield = 0;
> +
> +       local_irq_save(flags);
> +       rq = this_rq();
> +
> +again:
> +       p_rq = task_rq(p);
> +       double_rq_lock(rq, p_rq);
> +       while (task_rq(p) != p_rq) {
> +               double_rq_unlock(rq, p_rq);
> +               goto again;
> +       }
> +
> +       if (!curr->sched_class->yield_to_task)
> +               goto out;
> +
> +       if (curr->sched_class != p->sched_class)
> +               goto out;
> +

to be clearer?
            if (task_running(p_rq, p) || p->state != TASK_RUNNING)

> +               goto out;
> +
> +       if (!same_thread_group(p, curr))
> +               goto out;
