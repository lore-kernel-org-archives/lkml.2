Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1HPNn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:43:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1HPNnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <1311897706.16657.2.camel@mop>
References: <1311897706.16657.2.camel@mop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Aug 2011 15:43:03 +0200
Message-ID: <CAPXgP120L0JqgnfNVhR=ApK-wjPSg11Uh9dJPRs0LXAvqBOuQg@mail.gmail.com>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple
 process supervision
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lennart Poettering <lennart@poettering.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, mind picking this up?

Thanks,
Kay

On Fri, Jul 29, 2011 at 02:01, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Lennart Poettering <lennart@poettering.net>
> Subject: prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple process supervision
>
> Userspace service managers/supervisors need to track their started
> services. Many services daemonize by double-forking and get implicitely
> re-parented to PID 1. The process manager will no longer be able to
> receive the SIGCHLD signals for them.
>
> With this prctl, a service manager can mark itself as a sort of
> 'sub-init' process, able to stay as the parent process for all processes
> created by the started services. All SIGCHLD signals will be delivered
> to the service manager.
>
> As a side effect, the relevant parent PID information does not get lost
> by a double-fork, which results in a more elaborate process tree and 'ps'
> output.
>
> This is orthogonal to PID namespaces. PID namespaces are isolated
> from each other, while a service management process usually requires
> the serices to live in the same namespace, to be able to talk to each
> other.
>
> Users of this will be the systemd per-user instance, which provides
> init-like functionality for the user's login session and D-Bus, which
> activates bus services on on-demand. Both will need init-like capabilities
> to be able to properly keep track of the services they start.
>
> Signed-off-by: Lennart Poettering <lennart@poettering.net>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>
>  include/linux/prctl.h |    3 +++
>  include/linux/sched.h |    2 ++
>  kernel/exit.c         |    9 ++++++++-
>  kernel/fork.c         |    2 ++
>  kernel/sys.c          |    7 +++++++
>  5 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/prctl.h b/include/linux/prctl.h
> index a3baeb2..716b7d3 100644
> --- a/include/linux/prctl.h
> +++ b/include/linux/prctl.h
> @@ -102,4 +102,7 @@
>
>  #define PR_MCE_KILL_GET 34
>
> +#define PR_SET_CHILD_REAPER 35
> +#define PR_GET_CHILD_REAPER 36
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 20b03bf..2dba23b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1300,6 +1300,8 @@ struct task_struct {
>                                 * execve */
>        unsigned in_iowait:1;
>
> +       /* Reparent child processes to this process instead of pid 1. */
> +       unsigned child_reaper:1;
>
>        /* Revert to default priority/policy when forking */
>        unsigned sched_reset_on_fork:1;
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 2913b35..61a80a4 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -700,7 +700,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
>        __acquires(&tasklist_lock)
>  {
>        struct pid_namespace *pid_ns = task_active_pid_ns(father);
> -       struct task_struct *thread;
> +       struct task_struct *thread, *reaper;
>
>        thread = father;
>        while_each_thread(father, thread) {
> @@ -711,6 +711,13 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
>                return thread;
>        }
>
> +       /* find the first ancestor which is marked as child_reaper */
> +       for (reaper = father->parent;
> +            reaper != &init_task && reaper != pid_ns->child_reaper;
> +            reaper = reaper->parent)
> +               if (reaper->child_reaper)
> +                       return reaper;
> +
>        if (unlikely(pid_ns->child_reaper == father)) {
>                write_unlock_irq(&tasklist_lock);
>                if (unlikely(pid_ns == &init_pid_ns))
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e7ceaca..863c5c7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1326,6 +1326,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                p->parent_exec_id = current->self_exec_id;
>        }
>
> +       p->child_reaper = 0;
> +
>        spin_lock(&current->sighand->siglock);
>
>        /*
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a101ba3..9b41498 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1792,6 +1792,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>                        else
>                                error = PR_MCE_KILL_DEFAULT;
>                        break;
> +               case PR_SET_CHILD_REAPER:
> +                       me->child_reaper = !!arg2;
> +                       error = 0;
> +                       break;
> +               case PR_GET_CHILD_REAPER:
> +                       error = put_user(me->child_reaper, (int __user *) arg2);
> +                       break;
>                default:
>                        error = -EINVAL;
>                        break;
>
>
>
