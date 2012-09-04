Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2IDR3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:29:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33728 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2IDR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:29:43 -0400
From: Benjamin Segall <bsegall@google.com>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [patch 06/16] sched: account for blocked load waking back up
References: <20120823141422.444396696@google.com>
	<20120823141506.726077467@google.com>
	<CAM4v1pO8SPCmqJTTBHpqwrwuO7noPdskg0RSooxyPsWoE395_A@mail.gmail.com>
Date: Tue, 04 Sep 2012 10:29:37 -0700
In-Reply-To: <CAM4v1pO8SPCmqJTTBHpqwrwuO7noPdskg0RSooxyPsWoE395_A@mail.gmail.com>
	(Preeti Murthy's message of "Sat, 1 Sep 2012 23:02:48 +0530")
Message-ID: <xm26fw6xd7cu.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q84HTqTA012614

Preeti Murthy <preeti.lkml@gmail.com> writes:

> Hi Paul,
>
>     @@ -1170,20 +1178,42 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>                                                       struct sched_entity *se,
>                                                       int wakeup)
>      {
>     -       /* we track migrations using entity decay_count == 0 */
>     -       if (unlikely(!se->avg.decay_count)) {
>     +       /*
>     +        * We track migrations using entity decay_count <= 0, on a wake-up
>     +        * migration we use a negative decay count to track the remote decays
>     +        * accumulated while sleeping.
>     +        */
>     +       if (unlikely(se->avg.decay_count <= 0)) {
>                     se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
>     +               if (se->avg.decay_count) {
>     +                       /*
>     +                        * In a wake-up migration we have to approximate the
>     +                        * time sleeping.  This is because we can't synchronize
>     +                        * clock_task between the two cpus, and it is not
>     +                        * guaranteed to be read-safe.  Instead, we can
>     +                        * approximate this using our carried decays, which are
>     +                        * explicitly atomically readable.
>     +                        */
>     +                       se->avg.last_runnable_update -= (-se->avg.decay_count)
>     +                                                       << 20;
>     +                       update_entity_load_avg(se, 0);
>     +                       /* Indicate that we're now synchronized and on-rq */
>     +                       se->avg.decay_count = 0;
>     +               }
>                     wakeup = 0;
>             } else {
>                     __synchronize_entity_decay(se);
>
>  
> Should not the last_runnable_update of se get updated in __synchronize_entity_decay()?
> Because it contains the value of the runnable update before going to sleep.If not updated,when
> update_entity_load_avg() is called below during a local wakeup,it will decay the runtime load
> for the duration including the time the sched entity has slept.

If you are asking if it should be updated in the else block (local
wakeup, no migration) here, no:

* __synchronize_entity_decay will decay load_avg_contrib to match the
  decay that the cfs_rq has done, keeping those in sync, and ensuring we
  don't subtract too much when we update our current load average.
* clock_task - last_runnable_update will be the amount of time that the
  task has been blocked. update_entity_load_avg (below) and
  __update_entity_runnable_avg will account this time as non-runnable
  time into runnable_avg_sum/period, and from there onto the cfs_rq via
  __update_entity_load_avg_contrib.

Both of these are necessary, and will happen. In the case of !wakeup,
the task is being moved between groups or is migrating between cpus, and
we pretend (to the best of our ability in the case of migrating between
cpus which may have different clock_tasks) that the task has been
runnable this entire time.

In the more general case, no, it is called from migrate_task_rq_fair,
which doesn't have the necessary locks to read clock_task.

>
> This also means that during dequeue_entity_load_avg(),update_entity_load_avg() needs to be
> called to keep the runnable_avg_sum of the sched entity updated till
> before sleep.

Yes, this happens first thing in dequeue_entity_load_avg.
>
>             }
>    
>     -       if (wakeup)
>     +       /* migrated tasks did not contribute to our blocked load */
>     +       if (wakeup) {
>                     subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
>     +               update_entity_load_avg(se, 0);
>     +       }
>    
>     -       update_entity_load_avg(se, 0);
>             cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
>     -       update_cfs_rq_blocked_load(cfs_rq);
>     +       /* we force update consideration on load-balancer moves */
>     +       update_cfs_rq_blocked_load(cfs_rq, !wakeup);
>      }
>    
>       --
>     To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at  http://www.tux.org/lkml/
>
> Regards
> Preeti
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
