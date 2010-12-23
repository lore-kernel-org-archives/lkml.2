Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0LWCI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:08:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60435 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab0LWCI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:08:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FkZhQZNjygsxF/R32DMU59UorDLkM3+8ov5aRfNUj2rYaRCWLH0lKV8K0LQA2eAMdu
         C7dFQa2/SZJ3sOR+m7Bbw36ATGWeBZ94ZluhosPlbZG9Ywq/HUItpQpeqIJclhdHt3wd
         gMvg4OtX1vZqCDhOcKDSjGYpK0QH0JYnw3S7A=
MIME-Version: 1.0
In-Reply-To: <1293050173.2170.389.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	<1277808215.1868.5.camel@laptop>
	<20101219020313.GJ31750@genesis.frugalware.org>
	<20101222002248.GP10557@genesis.frugalware.org>
	<1293006589.2170.41.camel@laptop>
	<1293007311.11370.172.camel@marge.simson.net>
	<1293008842.2170.70.camel@laptop>
	<20101222133154.GS10557@genesis.frugalware.org>
	<1293026422.2170.136.camel@laptop>
	<1293027112.2170.140.camel@laptop>
	<20101222151434.GW10557@genesis.frugalware.org>
	<1293037718.2170.155.camel@laptop>
	<1293050173.2170.389.camel@laptop>
Date: Thu, 23 Dec 2010 10:08:56 +0800
Message-ID: <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in kernel/sched_fair.c
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miklos Vajna <vmiklos@frugalware.org>, Mike Galbraith <efault@gmx.de>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 4:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-12-22 at 18:08 +0100, Peter Zijlstra wrote:
>> On Wed, 2010-12-22 at 16:14 +0100, Miklos Vajna wrote:
>> > kernel-build is a git build using the config I already sent and after a
>> > 'git checkout v2.6.36'. I can try to build master as well, so far what I
>> > saw is that the bug occurs there as well, but less frequently, so maybe
>> > that's a bit harder to debug.
>>
>> Right, so I've got v2.6.36 exploding, current -git and -tip won't
>> explode for me, tried both about 20 times. So I'll try and figure out
>> wth makes .36 explode and then see if further kernel still suffer that
>> problem.
>
> OK, so something goes wrong with load accounting,
>
> Full log at: http://programming.kicks-ass.net/sekrit/log4
>
> I print the entire runqueue before and after each op, the last good one
> is a post-print:
>
> kworker/-9       0d..2. 2013644us : pick_next_task_fair: picked: f6a8de5c, kworker/u:1/1251
> kworker/-9       0d..2. 2013644us : print_runqueue <-pick_next_task_fair
> kworker/-9       0d..2. 2013645us : __print_runqueue:  cfs_rq: c2407c34, nr: 3, load: 3072
> kworker/-9       0d..2. 2013645us : __print_runqueue:  curr: f6a8de5c, comm: kworker/u:1/1251, load: 1024
> kworker/-9       0d..2. 2013646us : __print_runqueue:  se: f69e6300, load: 1024,
> kworker/-9       0d..2. 2013646us : __print_runqueue:    cfs_rq: f69e6540, nr: 2, load: 2048
> kworker/-9       0d..2. 2013646us : __print_runqueue:    curr: (null)
> kworker/-9       0d..2. 2013647us : __print_runqueue:    se: f69e65a0, load: 1024,
> kworker/-9       0d..2. 2013647us : __print_runqueue:      cfs_rq: f69e6240, nr: 1, load: 1024
> kworker/-9       0d..2. 2013648us : __print_runqueue:      curr: (null)
> kworker/-9       0d..2. 2013648us : __print_runqueue:      se: f725916c, comm: loadkeys/1225, load: 1024
> kworker/-9       0d..2. 2013649us : __print_runqueue:    se: f69e6660, load: 1024,
> kworker/-9       0d..2. 2013649us : __print_runqueue:      cfs_rq: f69e6600, nr: 1, load: 1024
> kworker/-9       0d..2. 2013650us : __print_runqueue:      curr: (null)
> kworker/-9       0d..2. 2013650us : __print_runqueue:      se: f6a8da0c, comm: systemd-tmpfile/1246, load: 1024
> kworker/-9       0d..2. 2013651us : __print_runqueue:  se: f6a8cd1c, comm: kworker/u:1/1252, load: 1024
>
>
> And then the next pre-print looks like:
>
> systemd--1251    0d..5. 2015398us : enqueue_task_fair <-enqueue_task
> systemd--1251    0d..5. 2015398us : print_runqueue <-enqueue_task_fair
> systemd--1251    0d..5. 2015399us : __print_runqueue:  cfs_rq: c2407c34, nr: 3, load: 3072
> systemd--1251    0d..5. 2015400us : __print_runqueue:  curr: f6a8de5c, comm: systemd-cgroups/1251, load: 1024
> systemd--1251    0d..5. 2015401us : __print_runqueue:  se: f69e6300, load: 1024,
> systemd--1251    0d..5. 2015401us : __print_runqueue:    cfs_rq: f69e6540, nr: 2, load: 2048
> systemd--1251    0d..5. 2015402us : __print_runqueue:    curr: (null)
> systemd--1251    0d..5. 2015402us : __print_runqueue:    se: f69e65a0, load: 4137574976,

the load == f69e65a0 == address of se, odd

Thanks,
Yong

> systemd--1251    0d..5. 2015402us : __print_runqueue:      cfs_rq: f69e6240, nr: 1, load: 4137575360
> systemd--1251    0d..5. 2015403us : __print_runqueue:      curr: (null)
> systemd--1251    0d..5. 2015404us : __print_runqueue:      se: f725916c, comm: loadkeys/1225, load: 1024
> systemd--1251    0d..5. 2015404us : __print_runqueue:    se: f69e6660, load: 1024,
> systemd--1251    0d..5. 2015404us : __print_runqueue:      cfs_rq: f69e6600, nr: 1, load: 1024
> systemd--1251    0d..5. 2015405us : __print_runqueue:      curr: (null)
> systemd--1251    0d..5. 2015406us : __print_runqueue:      se: f6a8da0c, comm: systemd-tmpfile/1246, load: 1024
> systemd--1251    0d..5. 2015406us : __print_runqueue:  se: f6a8cd1c, comm: kworker/u:1/1252, load: 1024
>
>
> The load value being crazy like this leads to dequeue_task_fair() making
> weird decisions since it checks for load==0 to dequeue groups.
>
> Not doing that, then leads to 'dead' groups still being enqueued and
> eventually referencing freed memory etc..
>
> I've no clue why any of this happens, it could be random scribbles,
> except the se/cfs_rq combo are always off together (although not always
> by the same amount).
>
> Anyway, my brain needs sleep, I'll continue poking tomorrow.
>
> ---
>  kernel/sched_fair.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 71 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..8b8b038 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -333,6 +333,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>        s64 key = entity_key(cfs_rq, se);
>        int leftmost = 1;
>
> +       trace_printk("%p to %p, %ld tasks\n", se, cfs_rq, cfs_rq->nr_running);
> +
>        /*
>         * Find the right place in the rbtree:
>         */
> @@ -364,6 +366,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>
>  static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> +       trace_printk("%p from %p, %ld left\n", se, cfs_rq, cfs_rq->nr_running);
> +
>        if (cfs_rq->rb_leftmost == &se->run_node) {
>                struct rb_node *next_node;
>
> @@ -394,6 +398,53 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
>        return rb_entry(last, struct sched_entity, run_node);
>  }
>
> +#define INDENT(i) ((i)*2), "                                  "
> +
> +static void notrace __print_runqueue(struct cfs_rq *cfs_rq, int indent);
> +
> +static void __always_inline
> +__print_entity(struct sched_entity *se, char *name, int indent)
> +{
> +       if (!se) {
> +               trace_printk("%.*s %s: %p\n", INDENT(indent), name, se);
> +               return;
> +       }
> +
> +       if (entity_is_task(se)) {
> +               struct task_struct *p = task_of(se);
> +               trace_printk("%.*s %s: %p, comm: %s/%d, load: %ld\n",
> +                               INDENT(indent), name,
> +                               se, p->comm, p->pid, se->load.weight);
> +       } else {
> +               trace_printk("%.*s %s: %p, load: %ld, ",
> +                               INDENT(indent), name,
> +                               se, se->load.weight);
> +               __print_runqueue(group_cfs_rq(se), indent+1);
> +       }
> +}
> +
> +static void notrace __print_runqueue(struct cfs_rq *cfs_rq, int indent)
> +{
> +       struct rb_node *n;
> +
> +       trace_printk("%.*s cfs_rq: %p, nr: %ld, load: %ld\n",
> +                       INDENT(indent),
> +                       cfs_rq, cfs_rq->nr_running,
> +                       cfs_rq->load.weight);
> +
> +       __print_entity(cfs_rq->curr, "curr", indent);
> +
> +       for (n = cfs_rq->rb_leftmost; n; n = rb_next(n)) {
> +               struct sched_entity *se = rb_entry(n, struct sched_entity, run_node);
> +               __print_entity(se, "se", indent);
> +       }
> +}
> +
> +void print_runqueue(struct cfs_rq *cfs_rq)
> +{
> +       __print_runqueue(cfs_rq, 0);
> +}
> +
>  /**************************************************************
>  * Scheduling class statistics methods:
>  */
> @@ -1047,6 +1098,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>        struct cfs_rq *cfs_rq;
>        struct sched_entity *se = &p->se;
>
> +       print_runqueue(&rq->cfs);
>        for_each_sched_entity(se) {
>                if (se->on_rq)
>                        break;
> @@ -1055,6 +1107,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>                flags = ENQUEUE_WAKEUP;
>        }
>
> +       trace_printk("add task: %p, %s/%d\n", &p->se, p->comm, p->pid);
> +       print_runqueue(&rq->cfs);
> +
>        hrtick_update(rq);
>  }
>
> @@ -1068,6 +1123,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>        struct cfs_rq *cfs_rq;
>        struct sched_entity *se = &p->se;
>
> +       print_runqueue(&rq->cfs);
>        for_each_sched_entity(se) {
>                cfs_rq = cfs_rq_of(se);
>                dequeue_entity(cfs_rq, se, flags);
> @@ -1077,6 +1133,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>                flags |= DEQUEUE_SLEEP;
>        }
>
> +       trace_printk("del task: %p, %s/%d\n", &p->se, p->comm, p->pid);
> +       print_runqueue(&rq->cfs);
> +
>        hrtick_update(rq);
>  }
>
> @@ -1719,6 +1778,8 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
>        struct cfs_rq *cfs_rq = &rq->cfs;
>        struct sched_entity *se;
>
> +       print_runqueue(&rq->cfs);
> +
>        if (!cfs_rq->nr_running)
>                return NULL;
>
> @@ -1731,6 +1792,9 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
>        p = task_of(se);
>        hrtick_start_fair(rq, p);
>
> +       trace_printk("picked: %p, %s/%d\n", se, p->comm, p->pid);
> +       print_runqueue(&rq->cfs);
> +
>        return p;
>  }
>
> @@ -1742,10 +1806,15 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
>        struct sched_entity *se = &prev->se;
>        struct cfs_rq *cfs_rq;
>
> +       print_runqueue(&rq->cfs);
>        for_each_sched_entity(se) {
>                cfs_rq = cfs_rq_of(se);
>                put_prev_entity(cfs_rq, se);
>        }
> +
> +       trace_printk("put: %p, %s/%d\n", se, prev->comm, prev->pid);
> +       print_runqueue(&rq->cfs);
> +
>  }
>
>  #ifdef CONFIG_SMP
> @@ -3819,8 +3888,10 @@ static void set_curr_task_fair(struct rq *rq)
>  {
>        struct sched_entity *se = &rq->curr->se;
>
> +       print_runqueue(&rq->cfs);
>        for_each_sched_entity(se)
>                set_next_entity(cfs_rq_of(se), se);
> +       print_runqueue(&rq->cfs);
>  }
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself.
