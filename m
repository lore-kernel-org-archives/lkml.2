Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1AEIN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:13:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63694 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1AEIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uFGGCrek3CksqumNzPrf4Kvu8NwkEA6qaqaWCwiYezjrX2TZN+PQrrTP+Fpr7JWs0m
         Kq/4Gk+aWKfgyVJmj0QaDWTk7+aUCwxUqrCpPP5qfxu9Zu4bm35sCPAw0MgRi7QuRUJD
         H686s1YWg3MqQ6QycXTuTmh5RBQ2vxKGhe4/Q=
MIME-Version: 1.0
In-Reply-To: <20110104150102.562967001@chello.nl>
References: <20110104145929.772813816@chello.nl>
	<20110104150102.562967001@chello.nl>
Date: Wed, 5 Jan 2011 16:13:54 +0800
Message-ID: <AANLkTinmKHSPbrR5Z3_wD52RQRXfZHPSH+b9n2CNPZ8K@mail.gmail.com>
Subject: Re: [RFC][PATCH 05/18] sched: Provide p->on_rq
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p058EMoO015878

On Tue, Jan 4, 2011 at 10:59 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Provide a generic p->on_rq because the p->se.on_rq semantics are
> unfavourable for lockless wakeups but needed for sched_fair.
>
> In particular, p->on_rq is only cleared when we actually dequeue the
> task in schedule() and not on any random dequeue as done by things
> like __migrate_task() and __sched_setscheduler().
>
> This also allows us to remove p->se usage from !sched_fair code.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h   |    1 +
>  kernel/sched.c          |   36 ++++++++++++++++++------------------
>  kernel/sched_debug.c    |    2 +-
>  kernel/sched_rt.c       |   10 +++++-----
>  kernel/sched_stoptask.c |    2 +-
>  5 files changed, 26 insertions(+), 25 deletions(-)
>
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -1132,7 +1132,7 @@ static void put_prev_task_rt(struct rq *
>         * The previous task needs to be made eligible for pushing
>         * if it is still active
>         */
> -       if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
> +       if (p->on_rq && p->rt.nr_cpus_allowed > 1)

How about on_rt_rq(&p->rt) here?

Quoted from my previous reply:
[Seems we need on_rt_rq(&p->rt) here, otherwise we enqueue the
task to pushable list when called from rt_mutex_setprio()/
__sched_setscheduler() etc. Thus add a little overhead.
Though we call dequeue_pushable_task() in set_curr_task_rt()
unconditionally.]

Thanks,
Yong

>                enqueue_pushable_task(rq, p);
>  }
>
> @@ -1283,7 +1283,7 @@ static struct rq *find_lock_lowest_rq(st
>                                     !cpumask_test_cpu(lowest_rq->cpu,
>                                                       &task->cpus_allowed) ||
>                                     task_running(rq, task) ||
> -                                    !task->se.on_rq)) {
> +                                    !task->on_rq)) {
>
>                                raw_spin_unlock(&lowest_rq->lock);
>                                lowest_rq = NULL;
> @@ -1317,7 +1317,7 @@ static struct task_struct *pick_next_pus
>        BUG_ON(task_current(rq, p));
>        BUG_ON(p->rt.nr_cpus_allowed <= 1);
>
> -       BUG_ON(!p->se.on_rq);
> +       BUG_ON(!p->on_rq);
>        BUG_ON(!rt_task(p));
>
>        return p;
> @@ -1463,7 +1463,7 @@ static int pull_rt_task(struct rq *this_
>                 */
>                if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
>                        WARN_ON(p == src_rq->curr);
> -                       WARN_ON(!p->se.on_rq);
> +                       WARN_ON(!p->on_rq);
>
>                        /*
>                         * There's a chance that p is higher in priority
> @@ -1534,7 +1534,7 @@ static void set_cpus_allowed_rt(struct t
>         * Update the migration status of the RQ if we have an RT task
>         * which is running AND changing its weight value.
>         */
> -       if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
> +       if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
>                struct rq *rq = task_rq(p);
>
>                if (!task_current(rq, p)) {
> Index: linux-2.6/kernel/sched_stoptask.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_stoptask.c
> +++ linux-2.6/kernel/sched_stoptask.c
> @@ -26,7 +26,7 @@ static struct task_struct *pick_next_tas
>  {
>        struct task_struct *stop = rq->stop;
>
> -       if (stop && stop->se.on_rq)
> +       if (stop && stop->on_rq)
>                return stop;
>
>        return NULL;
>
>
>



-- 
Only stand for myself
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
