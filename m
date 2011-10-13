Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1JMOoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:44:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58900 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab1JMOoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <1318452651.14236.9.camel@twins>
References: <CAEbykaX=HWMJmTB0VCFkfW2v2G9=FcnFZBFwrYk8bFTT_FrD-Q@mail.gmail.com>
	<1318452651.14236.9.camel@twins>
Date: Thu, 13 Oct 2011 17:44:36 +0300
Message-ID: <CAEbykaWbtBvHQMQjRt7NDngy1oz=dBAZ3ii79XOJKvF5-fPaew@mail.gmail.com>
Subject: Re: sig->cputimer.lock/rq->lock lockdep report
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch works. No more warnings in the log after boot. I have the
issue in two machines. Both of them freeze after a few hours of use,
but log files don't tell anything after a forced reboot. Tomorrow will
tell if this was it.

Ari

2011/10/12 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2011-10-12 at 23:13 +0300, Ari Savolainen wrote:
>> I've got the same problem that Dave reported earlier. I bisected it to
>> commit d670ec13178d "posix-cpu-timers: Cure SMP wobbles".
>
> https://lkml.org/lkml/2011/10/7/282
>
> Does the below work for you? (still not proud of it)
>
> ---
>  include/linux/sched.h     |    3 +++
>  kernel/posix-cpu-timers.c |    6 +++++-
>  kernel/sched_stats.h      |    4 ++--
>  3 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 41d0237..ad9eafc 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -503,6 +503,7 @@ struct task_cputime {
>  * @running:           non-zero when there are timers running and
>  *                     @cputime receives updates.
>  * @lock:              lock for fields in this struct.
> + * @runtime_lock:      lock for cputime.sum_exec_runtime
>  *
>  * This structure contains the version of task_cputime, above, that is
>  * used for thread group CPU timer calculations.
> @@ -511,6 +512,7 @@ struct thread_group_cputimer {
>        struct task_cputime cputime;
>        int running;
>        spinlock_t lock;
> +       spinlock_t runtime_lock;
>  };
>
>  #include <linux/rwsem.h>
> @@ -2566,6 +2568,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
>  static inline void thread_group_cputime_init(struct signal_struct *sig)
>  {
>        spin_lock_init(&sig->cputimer.lock);
> +       spin_lock_init(&sig->cputimer.runtime_lock);
>  }
>
>  /*
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index c8008dd..fa189a6 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -284,9 +284,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
>                 * it.
>                 */
>                thread_group_cputime(tsk, &sum);
> +               spin_lock(&cputimer->runtime_lock);
>                update_gt_cputime(&cputimer->cputime, &sum);
> -       }
> +       } else
> +               spin_lock(&cputimer->runtime_lock);
> +
>        *times = cputimer->cputime;
> +       spin_unlock(&cputimer->runtime_lock);
>        spin_unlock_irqrestore(&cputimer->lock, flags);
>  }
>
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 331e01b..a7e2c1a 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -330,7 +330,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
>        if (!cputimer->running)
>                return;
>
> -       spin_lock(&cputimer->lock);
> +       spin_lock(&cputimer->runtime_lock);
>        cputimer->cputime.sum_exec_runtime += ns;
> -       spin_unlock(&cputimer->lock);
> +       spin_unlock(&cputimer->runtime_lock);
>  }
>
>
