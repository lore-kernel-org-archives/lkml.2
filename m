Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2DWWgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:36:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56497 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2DWWgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <1325951797.860.10.camel@mop>
References: <1325951797.860.10.camel@mop>
Date: Tue, 24 Apr 2012 10:36:05 +1200
X-Google-Sender-Auth: jX0BGqhJOhYRlFRatpIOM4XHDQY
Message-ID: <CAHO5Pa3G6VOirXf9pDjids8D3XGESCUVeipOiBBWY-Mn6xYpRg@mail.gmail.com>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple
 process supervision
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart,

On Sun, Jan 8, 2012 at 4:56 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> Resending this, it got lost last year's September.
>
> We still need it to properly implement init-like service managers.
>
> Andrew, care to pick this up again? The issues raised the last year are
> all expected to be fixed.
>
> Thanks,
> Kay
>
>
> From: Lennart Poettering <lennart@poettering.net>
> Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision

You have often enthusiastically pointed out to me pieces that are
missing from the man pages. When will you be sending me a man-pages
patch to document these new prctl() options that you've added?

Thanks,

Michael



> Userspace service managers/supervisors need to track their started
> services. Many services daemonize by double-forking and get implicitly
> re-parented to PID 1. The service manager will no longer be able to
> receive the SIGCHLD signals for them, and is no longer in charge of
> reaping the children with wait(). All information about the children
> is lost at the moment PID 1 cleans up the re-parented processes.
>
> With this prctl, a service manager process can mark itself as a sort of
> 'sub-init', able to stay as the parent for all orphaned processes
> created by the started services. All SIGCHLD signals will be delivered
> to the service manager.
>
> Receiving SIGCHLD and doing wait() is in cases of a service-manager
> much preferred over any possible asynchronous notification about
> specific PIDs, because the service manager has full access to the
> child process data in /proc and the PID can not be re-used until
> the wait(), the service-manager itself is in charge of, has happened.
>
> As a side effect, the relevant parent PID information does not get lost
> by a double-fork, which results in a more elaborate process tree and 'ps'
> output:
>
> before:
>  # ps afx
>  253 ?        Ss     0:00 /bin/dbus-daemon --system --nofork
>  294 ?        Sl     0:00 /usr/libexec/polkit-1/polkitd
>  328 ?        S      0:00 /usr/sbin/modem-manager
>  608 ?        Sl     0:00 /usr/libexec/colord
>  658 ?        Sl     0:00 /usr/libexec/upowerd
>  819 ?        Sl     0:00 /usr/libexec/imsettings-daemon
>  916 ?        Sl     0:00 /usr/libexec/udisks-daemon
>  917 ?        S      0:00  \_ udisks-daemon: not polling any devices
>
> after:
>  # ps afx
>  294 ?        Ss     0:00 /bin/dbus-daemon --system --nofork
>  426 ?        Sl     0:00  \_ /usr/libexec/polkit-1/polkitd
>  449 ?        S      0:00  \_ /usr/sbin/modem-manager
>  635 ?        Sl     0:00  \_ /usr/libexec/colord
>  705 ?        Sl     0:00  \_ /usr/libexec/upowerd
>  959 ?        Sl     0:00  \_ /usr/libexec/udisks-daemon
>  960 ?        S      0:00  |   \_ udisks-daemon: not polling any devices
>  977 ?        Sl     0:00  \_ /usr/libexec/packagekitd
>
> This prctl is orthogonal to PID namespaces. PID namespaces are isolated
> from each other, while a service management process usually requires
> the services to live in the same namespace, to be able to talk to each
> other.
>
> Users of this will be the systemd per-user instance, which provides
> init-like functionality for the user's login session and D-Bus, which
> activates bus services on-demand. Both need init-like capabilities
> to be able to properly keep track of the services they start.
>
> Many thanks to Oleg for several rounds of review and insights.
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Lennart Poettering <lennart@poettering.net>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>
>  include/linux/prctl.h |    3 +++
>  include/linux/sched.h |   12 ++++++++++++
>  kernel/exit.c         |   28 +++++++++++++++++++++++-----
>  kernel/fork.c         |    3 +++
>  kernel/sys.c          |    8 ++++++++
>  5 files changed, 49 insertions(+), 5 deletions(-)
>
> --- a/include/linux/prctl.h
> +++ b/include/linux/prctl.h
> @@ -102,4 +102,7 @@
>
>  #define PR_MCE_KILL_GET 34
>
> +#define PR_SET_CHILD_SUBREAPER 35
> +#define PR_GET_CHILD_SUBREAPER 36
> +
>  #endif /* _LINUX_PRCTL_H */
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -552,6 +552,18 @@ struct signal_struct {
>        int                     group_stop_count;
>        unsigned int            flags; /* see SIGNAL_* flags below */
>
> +       /*
> +        * PR_SET_CHILD_SUBREAPER marks a process, like a service
> +        * manager, to re-parent orphan (double-forking) child processes
> +        * to this process instead of 'init'. The service manager is
> +        * able to receive SIGCHLD signals and is able to investigate
> +        * the process until it calls wait(). All children of this
> +        * process will inherit a flag if they should look for a
> +        * child_subreaper process at exit.
> +        */
> +       unsigned int            is_child_subreaper:1;
> +       unsigned int            has_child_subreaper:1;
> +
>        /* POSIX.1b Interval Timers */
>        struct list_head posix_timers;
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -687,11 +687,12 @@ static void exit_mm(struct task_struct *
>  }
>
>  /*
> - * When we die, we re-parent all our children.
> - * Try to give them to another thread in our thread
> - * group, and if no such member exists, give it to
> - * the child reaper process (ie "init") in our pid
> - * space.
> + * When we die, we re-parent all our children, and try to:
> + * 1. give them to another thread in our thread group, if such a
> + *    member exists
> + * 2. give it to the first anchestor process which prctl'd itself
> + *    as a child_subreaper for its children (like a service manager)
> + * 3. give it to the init process (PID 1) in our pid namespace
>  */
>  static struct task_struct *find_new_reaper(struct task_struct *father)
>        __releases(&tasklist_lock)
> @@ -722,6 +723,23 @@ static struct task_struct *find_new_reap
>                 * forget_original_parent() must move them somewhere.
>                 */
>                pid_ns->child_reaper = init_pid_ns.child_reaper;
> +       } else if (father->signal->has_child_subreaper) {
> +               struct task_struct *reaper;
> +
> +               /* find the first ancestor marked as child_subreaper */
> +               for (reaper = father->real_parent;
> +                    reaper != &init_task;
> +                    reaper = reaper->real_parent) {
> +                       if (same_thread_group(reaper, pid_ns->child_reaper))
> +                               break;
> +                       if (!reaper->signal->is_child_subreaper)
> +                               continue;
> +                       thread = reaper;
> +                       do {
> +                               if (!(thread->flags & PF_EXITING))
> +                                       return reaper;
> +                       } while_each_thread(reaper, thread);
> +               }
>        }
>
>        return pid_ns->child_reaper;
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -979,6 +979,9 @@ static int copy_signal(unsigned long clo
>        sig->oom_score_adj = current->signal->oom_score_adj;
>        sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>
> +       sig->has_child_subreaper = current->signal->has_child_subreaper ||
> +                                  current->signal->is_child_subreaper;
> +
>        mutex_init(&sig->cred_guard_mutex);
>
>        return 0;
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1841,6 +1841,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
>                        else
>                                error = PR_MCE_KILL_DEFAULT;
>                        break;
> +               case PR_SET_CHILD_SUBREAPER:
> +                       me->signal->is_child_subreaper = !!arg2;
> +                       error = 0;
> +                       break;
> +               case PR_GET_CHILD_SUBREAPER:
> +                       error = put_user(me->signal->is_child_subreaper,
> +                                        (int __user *) arg2);
> +                       break;
>                default:
>                        error = -EINVAL;
>                        break;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
