Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab1I3JXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:23:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:49127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1I3JXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:23:41 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 11:23:02 +0200
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
	 <1317355529.4588.45.camel@gandalf.stny.rr.com>
	 <20110930041424.GH10425@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317374582.19415.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> static void flush_gcwq(struct global_cwq *gcwq)
> {
>         struct work_struct *work, *nw;
>         struct worker *worker, *n;
>         LIST_HEAD(non_affine_works);
> 
>         spin_lock_irq(&gcwq->lock);
>         list_for_each_entry_safe(work, nw, &gcwq->worklist, entry) {
>                 struct workqueue_struct *wq = get_work_cwq(work)->wq;
> 
>                 if (wq->flags & WQ_NON_AFFINE)
>                         list_move(&work->entry, &non_affine_works);
>         }
> 
>         while (!list_empty(&gcwq->worklist)) {
>                 int nr_works = 0;
> 
>                 list_for_each_entry(work, &gcwq->worklist, entry) {
>                         send_mayday(work);
>                         nr_works++;
>                 }
> 
>                 list_for_each_entry(worker, &gcwq->idle_list, entry) {
>                         if (!nr_works--)
>                                 break;
>                         wake_up_process(worker->task);
>                 }
> 
>                 spin_unlock_irq(&gcwq->lock);
> 
>                 if (need_to_create_worker(gcwq)) {
>                         worker = create_worker(gcwq, true);
>                         if (worker)
>                                 start_worker(worker);
>                 }
> 
>                 wait_event_timeout(gcwq->idle_wait,
>                                 gcwq->nr_idle == gcwq->nr_workers, HZ/10);
> 
>                 spin_lock_irq(&gcwq->lock);
>         }

We could probably replace that loop with one of the flush/barrier
thingies, but I got lost and wanted to post something. Using a proper
flush would also get rid of that icky waitqueue.

> 
>         WARN_ON(gcwq->nr_workers != gcwq->nr_idle);
> 
>         list_for_each_entry_safe(worker, n, &gcwq->idle_list, entry)
>                 destroy_worker(worker);
> 
>         WARN_ON(gcwq->nr_workers || gcwq->nr_idle);
> 
>         spin_unlock_irq(&gcwq->lock);
> 
>         gcwq = get_gcwq(get_cpu());
>         spin_lock_irq(&gcwq->lock);
>         list_for_each_entry_safe(work, nw, &non_affine_works, entry) {
>                 list_del_init(&work->entry);
>                 ___queue_work(get_work_cwq(work)->wq, gcwq, work);
>         }
>         spin_unlock_irq(&gcwq->lock);
>         put_cpu();
> }
