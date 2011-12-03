Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1LCQzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 11:55:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1LCQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 11:54:58 -0500
Date: Sat, 3 Dec 2011 17:49:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add reboot_pid_ns to handle the reboot syscall
Message-ID: <20111203164950.GA32004@redhat.com>
References: <1322905364-29538-1-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322905364-29538-1-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Daniel Lezcano wrote:
>
> This patch propose to store the reboot value in the 16 upper bits of the
> exit code from the processes belonging to a pid namespace which has
> rebooted. When the reboot syscall is called and we are not in the initial
> pid namespace, we kill the pid namespace.

OK, this is close to what we discussed before.

But why does this patch uglify wait_task_zombie() ?

> @@ -1192,6 +1192,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>  	pid_t pid = task_pid_vnr(p);
>  	uid_t uid = __task_cred(p)->uid;
>  	struct siginfo __user *infop;
> +	struct pid_namespace *pid_ns = task_active_pid_ns(p);
>
>  	if (!likely(wo->wo_flags & WEXITED))
>  		return 0;
> @@ -1291,8 +1292,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>  		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
>  	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
>  		? p->signal->group_exit_code : p->exit_code;
> -	if (!retval && wo->wo_stat)
> +	if (!retval && wo->wo_stat) {
> +		status |= (pid_ns->reboot & ~0xffff);
>  		retval = put_user(status, wo->wo_stat);
> +	}

This doesn't cover WNOWAIT.

But I think this change is not needed at all. Instead, can't you
add something like

	if (pid_ns->reboot)
		current->signal->group_exit_code = pid_ns->reboot;

into zap_pid_ns_processes() ? IIRC this was discussed too, I do
not understand why do you think we should hack do_wait()...


> +int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
> +{
> +	switch(cmd) {
> +	case LINUX_REBOOT_CMD_RESTART2:
> +	case LINUX_REBOOT_CMD_RESTART:
> +		pid_ns->reboot = SYSTEM_RESTART << 16;
> +		break;
> +
> +	case LINUX_REBOOT_CMD_HALT:
> +		pid_ns->reboot = SYSTEM_HALT << 16;
> +		break;
> +
> +	case LINUX_REBOOT_CMD_POWER_OFF:
> +		pid_ns->reboot = SYSTEM_POWER_OFF << 16;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	force_sig(SIGKILL, pid_ns->child_reaper);

In theory this is racy. Nothing protects ->child_reaper if it is
multi-threaded. read_lock(tasklist) should help.

> +
> +	return 0;
> +}

I am not sure "return 0" is really correct. Perhaps HALT/POWER_OFF
should do do_exit() like the the "normal" sys_reboot() does ?

>  static __init int pid_namespaces_init(void)
>  {
>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
> diff --git a/kernel/sys.c b/kernel/sys.c
> index ddf8155..02d9645 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -429,6 +429,7 @@ static DEFINE_MUTEX(reboot_mutex);
>  SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  		void __user *, arg)
>  {
> +	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
>  	char buffer[256];
>  	int ret = 0;
>
> @@ -450,6 +451,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
>  		cmd = LINUX_REBOOT_CMD_HALT;
>
> +	if (pid_ns != &init_pid_ns)
> +		return reboot_pid_ns(pid_ns, cmd);

Cosmetic nit,

	if (task_active_pid_ns(current) != &init_pid_ns)
		return reboot_pid_ns(cmd);

this way we do not need the new variable.

Also. I do not know if this is important, but perhaps it makes
sense to move this code up, before the !pm_power_off check which
can transform POWER_OFF into HALT?

Oleg.

