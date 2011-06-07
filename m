Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab1FGX4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:56:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57956 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1FGX4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:56:17 -0400
Date: Tue, 7 Jun 2011 16:56:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org
Subject: Re: [PATCH v4 04/13] seccomp_filter: add process state reporting
Message-ID: <20110607235613.GA21645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
 <1307133252-23259-4-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307133252-23259-4-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 03:34:03PM -0500, Will Drewry wrote:
> Adds seccomp and seccomp_filter status reporting to proc.
> /proc/<pid>/seccomp_filter provides the current seccomp mode
> and the list of allowed or dynamically filtered system calls.
> 
> v4: move from rcu guard to mutex guard

Just in case the mutex guard turns into a bottleneck...  Replacing
your earlier racy rcu_assign_pointer() with xchg() would allow
the "winner" to free up the "loser"'s structure.

Of course, if the mutex guard works well for you, why bother?

							Thanx, Paul

> v3: changed to using filters directly.
> v2: removed status entry, added seccomp file.
>     (requested by kosaki.motohiro@jp.fujitsu.com)
>     allowed S_IRUGO reading of entries
>     (requested by viro@zeniv.linux.org.uk)
>     added flags
>     got rid of the seccomp_t type
>     dropped seccomp file
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  fs/proc/base.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index dfa5327..6dc4df8 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -73,6 +73,7 @@
>  #include <linux/security.h>
>  #include <linux/ptrace.h>
>  #include <linux/tracehook.h>
> +#include <linux/seccomp.h>
>  #include <linux/cgroup.h>
>  #include <linux/cpuset.h>
>  #include <linux/audit.h>
> @@ -579,6 +580,28 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
>  }
>  #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
> 
> +/*
> + * Print out the current seccomp filter set for the task.
> + */
> +#ifdef CONFIG_SECCOMP_FILTER
> +int proc_pid_seccomp_filter_show(struct seq_file *m, struct pid_namespace *ns,
> +				 struct pid *pid, struct task_struct *task)
> +{
> +	struct seccomp_filters *filters;
> +	/* Avoid allowing other processes to incur too much added contention by
> +	 * only acquiring a reference under the task-wide mutex.
> +	 */
> +	if (mutex_lock_killable(&task->seccomp.filters_guard))
> +		return -1;
> +	filters = get_seccomp_filter(task->seccomp.filters);
> +	mutex_unlock(&task->seccomp.filters_guard);
> +
> +	seccomp_show_filters(filters, m);
> +	put_seccomp_filter(filters);
> +	return 0;
> +}
> +#endif /* CONFIG_SECCOMP_FILTER */
> +
>  /************************************************************************/
>  /*                       Here the fs part begins                        */
>  /************************************************************************/
> @@ -2838,6 +2861,9 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
>  	INF("syscall",    S_IRUGO, proc_pid_syscall),
>  #endif
> +#ifdef CONFIG_SECCOMP_FILTER
> +	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
> +#endif
>  	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
>  	ONE("stat",       S_IRUGO, proc_tgid_stat),
>  	ONE("statm",      S_IRUGO, proc_pid_statm),
> @@ -3180,6 +3206,9 @@ static const struct pid_entry tid_base_stuff[] = {
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
>  	INF("syscall",   S_IRUGO, proc_pid_syscall),
>  #endif
> +#ifdef CONFIG_SECCOMP_FILTER
> +	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
> +#endif
>  	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
>  	ONE("stat",      S_IRUGO, proc_tid_stat),
>  	ONE("statm",     S_IRUGO, proc_pid_statm),
> -- 
> 1.7.0.4
> 
