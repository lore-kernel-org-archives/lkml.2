Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1HSPlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:41:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61526 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1HSPlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:41:13 -0400
MIME-Version: 1.0
In-Reply-To: <1313763382-12341-14-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-14-git-send-email-tj@kernel.org>
From: Paul Menage <menage@google.com>
Date: Fri, 19 Aug 2011 08:40:52 -0700
X-Google-Sender-Auth: 2E2Yi225QB8C2BY_kPInIL8aYx8
Message-ID: <CALdu-PBvOFjYC-KUF=ehc-2fTYZArQ2YO0Hd0k9nq2Chcx9cpQ@mail.gmail.com>
Subject: Re: [PATCH 13/16] cgroup_freezer: prepare for removal of TIF_FREEZE
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, arnd@arndb.de, oleg@redhat.com,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 7:16 AM, Tejun Heo <tj@kernel.org> wrote:
> TIF_FREEZE will be removed soon and freezing() will directly test
> whether any freezing condition is in effect.  Make the following
> changes in preparation.
>
> * Rename cgroup_freezing_or_frozen() to cgroup_freezing() and make it
>  return bool.
>
> * Make cgroup_freezing() access task_freezer() under rcu read lock
>  instead of task_lock().  This makes the state dereferencing racy
>  against task moving to another cgroup; however, it was already racy
>  without this change as ->state dereference wasn't synchronized.
>  This will be later dealt with using attach hooks.
>
> * freezer->state is now set before trying to push tasks into the
>  target state.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul Menage <menage@google.com>

Acked-by: Paul Menage <paul@paulmenage.org>


> Cc: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/freezer.h |    6 +++---
>  kernel/cgroup_freezer.c |   36 ++++++++++++------------------------
>  kernel/power/process.c  |    2 +-
>  3 files changed, 16 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 13559a8..bcc0637 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -63,11 +63,11 @@ extern bool freeze_task(struct task_struct *p, bool sig_only);
>  extern bool __set_freezable(bool with_signal);
>
>  #ifdef CONFIG_CGROUP_FREEZER
> -extern int cgroup_freezing_or_frozen(struct task_struct *task);
> +extern bool cgroup_freezing(struct task_struct *task);
>  #else /* !CONFIG_CGROUP_FREEZER */
> -static inline int cgroup_freezing_or_frozen(struct task_struct *task)
> +static inline bool cgroup_freezing(struct task_struct *task)
>  {
> -       return 0;
> +       return false;
>  }
>  #endif /* !CONFIG_CGROUP_FREEZER */
>
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index e7fa0ec..0478c35 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -48,19 +48,17 @@ static inline struct freezer *task_freezer(struct task_struct *task)
>                            struct freezer, css);
>  }
>
> -static inline int __cgroup_freezing_or_frozen(struct task_struct *task)
> +bool cgroup_freezing(struct task_struct *task)
>  {
> -       enum freezer_state state = task_freezer(task)->state;
> -       return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
> -}
> +       enum freezer_state state;
> +       bool ret;
>
> -int cgroup_freezing_or_frozen(struct task_struct *task)
> -{
> -       int result;
> -       task_lock(task);
> -       result = __cgroup_freezing_or_frozen(task);
> -       task_unlock(task);
> -       return result;
> +       rcu_read_lock();
> +       state = task_freezer(task)->state;
> +       ret = state == CGROUP_FREEZING || state == CGROUP_FROZEN;
> +       rcu_read_unlock();
> +
> +       return ret;
>  }
>
>  /*
> @@ -102,9 +100,6 @@ struct cgroup_subsys freezer_subsys;
>  * freezer_can_attach():
>  * cgroup_mutex (held by caller of can_attach)
>  *
> - * cgroup_freezing_or_frozen():
> - * task->alloc_lock (to get task's cgroup)
> - *
>  * freezer_fork() (preserving fork() performance means can't take cgroup_mutex):
>  * freezer->lock
>  *  sighand->siglock (if the cgroup is freezing)
> @@ -177,13 +172,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
>
>  static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  {
> -       rcu_read_lock();
> -       if (__cgroup_freezing_or_frozen(tsk)) {
> -               rcu_read_unlock();
> -               return -EBUSY;
> -       }
> -       rcu_read_unlock();
> -       return 0;
> +       return cgroup_freezing(tsk) ? -EBUSY : 0;
>  }
>
>  static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
> @@ -279,7 +268,6 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
>        struct task_struct *task;
>        unsigned int num_cant_freeze_now = 0;
>
> -       freezer->state = CGROUP_FREEZING;
>        cgroup_iter_start(cgroup, &it);
>        while ((task = cgroup_iter_next(cgroup, &it))) {
>                if (!freeze_task(task, true))
> @@ -303,8 +291,6 @@ static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
>        while ((task = cgroup_iter_next(cgroup, &it)))
>                __thaw_task(task);
>        cgroup_iter_end(cgroup, &it);
> -
> -       freezer->state = CGROUP_THAWED;
>  }
>
>  static int freezer_change_state(struct cgroup *cgroup,
> @@ -321,6 +307,8 @@ static int freezer_change_state(struct cgroup *cgroup,
>        if (goal_state == freezer->state)
>                goto out;
>
> +       freezer->state = goal_state;
> +
>        switch (goal_state) {
>        case CGROUP_THAWED:
>                unfreeze_cgroup(cgroup, freezer);
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index f8012f2..1bbc363 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -154,7 +154,7 @@ void thaw_processes(void)
>
>        read_lock(&tasklist_lock);
>        do_each_thread(g, p) {
> -               if (cgroup_freezing_or_frozen(p))
> +               if (cgroup_freezing(p))
>                        continue;
>
>                __thaw_task(p);
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
