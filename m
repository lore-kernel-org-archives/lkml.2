Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1HSPho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:37:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55647 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1HSPhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1313763382-12341-6-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-6-git-send-email-tj@kernel.org>
From: Paul Menage <menage@google.com>
Date: Fri, 19 Aug 2011 08:37:20 -0700
X-Google-Sender-Auth: aK38yfS1IHz-9UnUHSU29d7lCwI
Message-ID: <CALdu-PC1bVESvJ2p13hpb4QuABGFyjhoke60+UB79YCOBtTXGg@mail.gmail.com>
Subject: Re: [PATCH 05/16] freezer: rename thaw_process() to __thaw_task() and
 simplify the implementation
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, arnd@arndb.de, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 7:16 AM, Tejun Heo <tj@kernel.org> wrote:
> thaw_process() now has only internal users - system and cgroup
> freezers.  Remove the unnecessary return value, rename, unexport and
> collapse __thaw_process() into it.  This will help further updates to
> the freezer code.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul Menage <menage@google.com>

Probably better to have Matt Helsley look at this?

Paul

> ---
>  include/linux/freezer.h |    3 +--
>  kernel/cgroup_freezer.c |    7 +++----
>  kernel/freezer.c        |   30 +++++++++++-------------------
>  kernel/power/process.c  |    2 +-
>  4 files changed, 16 insertions(+), 26 deletions(-)
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 8ee31e5..80a455d 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -45,7 +45,7 @@ static inline bool should_send_signal(struct task_struct *p)
>  }
>
>  /* Takes and releases task alloc lock using task_lock() */
> -extern int thaw_process(struct task_struct *p);
> +extern void __thaw_task(struct task_struct *t);
>
>  extern bool __refrigerator(bool check_kthr_stop);
>  extern int freeze_processes(void);
> @@ -167,7 +167,6 @@ static inline int frozen(struct task_struct *p) { return 0; }
>  static inline int freezing(struct task_struct *p) { return 0; }
>  static inline void set_freeze_flag(struct task_struct *p) {}
>  static inline void clear_freeze_flag(struct task_struct *p) {}
> -static inline int thaw_process(struct task_struct *p) { return 1; }
>
>  static inline bool __refrigerator(bool check_kthr_stop) { return false; }
>  static inline int freeze_processes(void) { BUG(); return 0; }
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index e691818..e7fa0ec 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -130,7 +130,7 @@ struct cgroup_subsys freezer_subsys;
>  *   write_lock css_set_lock (cgroup iterator start)
>  *    task->alloc_lock
>  *   read_lock css_set_lock (cgroup iterator start)
> - *    task->alloc_lock (inside thaw_process(), prevents race with refrigerator())
> + *    task->alloc_lock (inside __thaw_task(), prevents race with refrigerator())
>  *     sighand->siglock
>  */
>  static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
> @@ -300,9 +300,8 @@ static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
>        struct task_struct *task;
>
>        cgroup_iter_start(cgroup, &it);
> -       while ((task = cgroup_iter_next(cgroup, &it))) {
> -               thaw_process(task);
> -       }
> +       while ((task = cgroup_iter_next(cgroup, &it)))
> +               __thaw_task(task);
>        cgroup_iter_end(cgroup, &it);
>
>        freezer->state = CGROUP_THAWED;
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 656492c..f5db7fd 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -145,18 +145,8 @@ void cancel_freezing(struct task_struct *p)
>        }
>  }
>
> -static int __thaw_process(struct task_struct *p)
> -{
> -       if (frozen(p)) {
> -               p->flags &= ~PF_FROZEN;
> -               return 1;
> -       }
> -       clear_freeze_flag(p);
> -       return 0;
> -}
> -
>  /*
> - * Wake up a frozen process
> + * Wake up a frozen task
>  *
>  * task_lock() is needed to prevent the race with refrigerator() which may
>  * occur if the freezing of tasks fails.  Namely, without the lock, if the
> @@ -164,15 +154,17 @@ static int __thaw_process(struct task_struct *p)
>  * refrigerator() could call frozen_process(), in which case the task would be
>  * frozen and no one would thaw it.
>  */
> -int thaw_process(struct task_struct *p)
> +void __thaw_task(struct task_struct *p)
>  {
> +       bool was_frozen;
> +
>        task_lock(p);
> -       if (__thaw_process(p) == 1) {
> -               task_unlock(p);
> -               wake_up_process(p);
> -               return 1;
> -       }
> +       if ((was_frozen = frozen(p)))
> +               p->flags &= ~PF_FROZEN;
> +       else
> +               clear_freeze_flag(p);
>        task_unlock(p);
> -       return 0;
> +
> +       if (was_frozen)
> +               wake_up_process(p);
>  }
> -EXPORT_SYMBOL(thaw_process);
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 0cf3a27..bec09c3 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -176,7 +176,7 @@ static void thaw_tasks(bool nosig_only)
>                if (cgroup_freezing_or_frozen(p))
>                        continue;
>
> -               thaw_process(p);
> +               __thaw_task(p);
>        } while_each_thread(g, p);
>        read_unlock(&tasklist_lock);
>  }
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
