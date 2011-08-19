Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1HSPnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:43:46 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50642 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1HSPno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <1313763382-12341-15-git-send-email-tj@kernel.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-15-git-send-email-tj@kernel.org>
From: Paul Menage <menage@google.com>
Date: Fri, 19 Aug 2011 08:43:22 -0700
X-Google-Sender-Auth: qs2zxneqU8A-2fFdcnpjf3dPse8
Message-ID: <CALdu-PAJhKeaT4Lxmtg2aA_FoU6uuZN47T1-CyBGQo2SnZvD7Q@mail.gmail.com>
Subject: Re: [PATCH 14/16] freezer: make freezing() test freeze conditions in
 effect instead of TIF_FREEZE
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, arnd@arndb.de, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 7:16 AM, Tejun Heo <tj@kernel.org> wrote:
> Using TIF_FREEZE for freezing worked when there was only single
> freezing condition (the system-wide one); however, now there also is
> the cgroup_freezer and single bit flag is getting clumsy.
> thaw_processes() is already testing whether cgroup freezing in in
> effect to avoid thawing tasks which were frozen by both system and
> cgroup freezers.
>
> This is racy (nothing prevents race against cgroup freezing) and
> fragile.  A much simpler way is to test actual freeze conditions from
> freezing() - ie. directly test whether system or cgroup freezing is in
> effect.
>
> This patch adds variables to indicate whether and what type of system
> freezing is in effect and reimplements freezing() such that it
> directly tests whether any of the two freezing conditions is active
> and the task should freeze.  On fast path, freezing() is still very
> cheap, it only tests system_freezing_cnt.
>
> This makes the clumsy dancing aroung TIF_FREEZE unnecessary and
> freeze/thaw operations more usual - updating state variables for the
> new state and nudging target tasks so that they notice the new state
> and comply.  As long as the nudging happens after state update, it's
> race-free.
>
> * This allows use of freezing() in freeze_task().  Replace the open
>  coded tests with freezing().
>
> * p != current test is added to warning printing conditions in
>  try_to_freeze_tasks() failure path.  This is necessary as freezing()
>  is now true for the task which initiated freezing too.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Paul Menage <paul@paulmenage.org>  (for the cgroup portions)


> ---
>  include/linux/freezer.h |   33 +++++++++----------------
>  kernel/cgroup_freezer.c |    8 +++++-
>  kernel/fork.c           |    1 -
>  kernel/freezer.c        |   62 ++++++++++++++++++++++++++++++----------------
>  kernel/power/process.c  |   15 ++++++++---
>  5 files changed, 70 insertions(+), 49 deletions(-)
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index bcc0637..11b2bd9 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -5,8 +5,13 @@
>
>  #include <linux/sched.h>
>  #include <linux/wait.h>
> +#include <linux/atomic.h>
>
>  #ifdef CONFIG_FREEZER
> +extern atomic_t system_freezing_cnt;   /* nr of freezing conds in effect */
> +extern bool pm_freezing;               /* PM freezing in effect */
> +extern bool pm_nosig_freezing;         /* PM nosig freezing in effect */
> +
>  /*
>  * Check if a process has been frozen
>  */
> @@ -15,28 +20,16 @@ static inline int frozen(struct task_struct *p)
>        return p->flags & PF_FROZEN;
>  }
>
> -/*
> - * Check if there is a request to freeze a process
> - */
> -static inline int freezing(struct task_struct *p)
> -{
> -       return test_tsk_thread_flag(p, TIF_FREEZE);
> -}
> +extern bool freezing_slow_path(struct task_struct *p);
>
>  /*
> - * Request that a process be frozen
> - */
> -static inline void set_freeze_flag(struct task_struct *p)
> -{
> -       set_tsk_thread_flag(p, TIF_FREEZE);
> -}
> -
> -/*
> - * Sometimes we may need to cancel the previous 'freeze' request
> + * Check if there is a request to freeze a process
>  */
> -static inline void clear_freeze_flag(struct task_struct *p)
> +static inline bool freezing(struct task_struct *p)
>  {
> -       clear_tsk_thread_flag(p, TIF_FREEZE);
> +       if (likely(!atomic_read(&system_freezing_cnt)))
> +               return false;
> +       return freezing_slow_path(p);
>  }
>
>  static inline bool should_send_signal(struct task_struct *p)
> @@ -164,9 +157,7 @@ static inline bool set_freezable_with_signal(void)
>  })
>  #else /* !CONFIG_FREEZER */
>  static inline int frozen(struct task_struct *p) { return 0; }
> -static inline int freezing(struct task_struct *p) { return 0; }
> -static inline void set_freeze_flag(struct task_struct *p) {}
> -static inline void clear_freeze_flag(struct task_struct *p) {}
> +static inline bool freezing(struct task_struct *p) { return false; }
>
>  static inline bool __refrigerator(bool check_kthr_stop) { return false; }
>  static inline int freeze_processes(void) { BUG(); return 0; }
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 0478c35..4e82525 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -145,7 +145,11 @@ static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
>  static void freezer_destroy(struct cgroup_subsys *ss,
>                            struct cgroup *cgroup)
>  {
> -       kfree(cgroup_freezer(cgroup));
> +       struct freezer *freezer = cgroup_freezer(cgroup);
> +
> +       if (freezer->state != CGROUP_THAWED)
> +               atomic_dec(&system_freezing_cnt);
> +       kfree(freezer);
>  }
>
>  /*
> @@ -311,9 +315,11 @@ static int freezer_change_state(struct cgroup *cgroup,
>
>        switch (goal_state) {
>        case CGROUP_THAWED:
> +               atomic_dec(&system_freezing_cnt);
>                unfreeze_cgroup(cgroup, freezer);
>                break;
>        case CGROUP_FROZEN:
> +               atomic_inc(&system_freezing_cnt);
>                retval = try_to_freeze_cgroup(cgroup, freezer);
>                break;
>        default:
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8e6b6f4..fa7beb3 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1000,7 +1000,6 @@ static void copy_flags(unsigned long clone_flags, struct task_struct *p)
>        new_flags |= PF_FORKNOEXEC;
>        new_flags |= PF_STARTING;
>        p->flags = new_flags;
> -       clear_freeze_flag(p);
>  }
>
>  SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 7506ef3..995bddf 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -11,9 +11,41 @@
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
>
> +/* total number of freezing conditions in effect */
> +atomic_t system_freezing_cnt = ATOMIC_INIT(0);
> +EXPORT_SYMBOL(system_freezing_cnt);
> +
> +/* indicate whether PM freezing is in effect, protected by pm_mutex */
> +bool pm_freezing;
> +bool pm_nosig_freezing;
> +
>  /* protects freezing and frozen transitions */
>  static DEFINE_SPINLOCK(freezer_lock);
>
> +/**
> + * freezing_slow_path - slow path for testing whether a task needs to be frozen
> + * @p: task to be tested
> + *
> + * This function is called by freezing() if system_freezing_cnt isn't zero
> + * and tests whether @p needs to enter and stay in frozen state.  Can be
> + * called under any context.  The freezers are responsible for ensuring the
> + * target tasks see the updated state.
> + */
> +bool freezing_slow_path(struct task_struct *p)
> +{
> +       if (p->flags & PF_NOFREEZE)
> +               return false;
> +
> +       if (pm_nosig_freezing || cgroup_freezing(p))
> +               return true;
> +
> +       if (pm_freezing && !(p->flags & PF_FREEZER_NOSIG))
> +               return true;
> +
> +       return false;
> +}
> +EXPORT_SYMBOL(freezing_slow_path);
> +
>  /* Refrigerator is place where frozen processes are stored :-). */
>  bool __refrigerator(bool check_kthr_stop)
>  {
> @@ -23,16 +55,10 @@ bool __refrigerator(bool check_kthr_stop)
>        long save;
>
>        /*
> -        * Enter FROZEN.  If NOFREEZE, schedule immediate thawing by
> -        * clearing freezing.
> +        * No point in checking freezing() again - the caller already did.
> +        * Proceed to enter FROZEN.
>         */
>        spin_lock_irq(&freezer_lock);
> -       if (!freezing(current)) {
> -               spin_unlock_irq(&freezer_lock);
> -               return was_frozen;
> -       }
> -       if (current->flags & PF_NOFREEZE)
> -               clear_freeze_flag(current);
>        current->flags |= PF_FROZEN;
>        spin_unlock_irq(&freezer_lock);
>
> @@ -96,18 +122,12 @@ static void fake_signal_wake_up(struct task_struct *p)
>  bool freeze_task(struct task_struct *p, bool sig_only)
>  {
>        unsigned long flags;
> -       bool ret = false;
>
>        spin_lock_irqsave(&freezer_lock, flags);
> -
> -       if ((p->flags & PF_NOFREEZE) ||
> -           (sig_only && !should_send_signal(p)))
> -               goto out_unlock;
> -
> -       if (frozen(p))
> -               goto out_unlock;
> -
> -       set_freeze_flag(p);
> +       if (!freezing(p) || frozen(p)) {
> +               spin_unlock_irqrestore(&freezer_lock, flags);
> +               return false;
> +       }
>
>        if (should_send_signal(p)) {
>                fake_signal_wake_up(p);
> @@ -120,10 +140,9 @@ bool freeze_task(struct task_struct *p, bool sig_only)
>        } else {
>                wake_up_state(p, TASK_INTERRUPTIBLE);
>        }
> -       ret = true;
> -out_unlock:
> +
>        spin_unlock_irqrestore(&freezer_lock, flags);
> -       return ret;
> +       return true;
>  }
>
>  void __thaw_task(struct task_struct *p)
> @@ -140,7 +159,6 @@ void __thaw_task(struct task_struct *p)
>         * avoid leaving dangling TIF_SIGPENDING behind.
>         */
>        spin_lock_irqsave(&freezer_lock, flags);
> -       clear_freeze_flag(p);
>        if (frozen(p)) {
>                wake_up_process(p);
>        } else {
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 1bbc363..fe06ddf 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -101,7 +101,7 @@ static int try_to_freeze_tasks(bool sig_only)
>                read_lock(&tasklist_lock);
>                do_each_thread(g, p) {
>                        if (!wakeup && !freezer_should_skip(p) &&
> -                           freezing(p) && !frozen(p))
> +                           p != current && freezing(p) && !frozen(p))
>                                sched_show_task(p);
>                } while_each_thread(g, p);
>                read_unlock(&tasklist_lock);
> @@ -120,13 +120,18 @@ int freeze_processes(void)
>  {
>        int error;
>
> +       if (!pm_freezing)
> +               atomic_inc(&system_freezing_cnt);
> +
>        printk("Freezing user space processes ... ");
> +       pm_freezing = true;
>        error = try_to_freeze_tasks(true);
>        if (error)
>                goto Exit;
>        printk("done.\n");
>
>        printk("Freezing remaining freezable tasks ... ");
> +       pm_nosig_freezing = true;
>        error = try_to_freeze_tasks(false);
>        if (error)
>                goto Exit;
> @@ -146,6 +151,11 @@ void thaw_processes(void)
>  {
>        struct task_struct *g, *p;
>
> +       if (pm_freezing)
> +               atomic_dec(&system_freezing_cnt);
> +       pm_freezing = false;
> +       pm_nosig_freezing = false;
> +
>        oom_killer_enable();
>
>        printk("Restarting tasks ... ");
> @@ -154,9 +164,6 @@ void thaw_processes(void)
>
>        read_lock(&tasklist_lock);
>        do_each_thread(g, p) {
> -               if (cgroup_freezing(p))
> -                       continue;
> -
>                __thaw_task(p);
>        } while_each_thread(g, p);
>        read_unlock(&tasklist_lock);
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
