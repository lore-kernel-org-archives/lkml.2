Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1HNQEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1HNQEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:04:11 -0400
Date: Sun, 14 Aug 2011 18:01:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, bonbons@linux-vserver.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com
Subject: Re: [PATCH 2/2] Notify container-init parent a 'reboot' occured
Message-ID: <20110814160112.GA29798@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Daniel Lezcano wrote:
>
> When the reboot syscall is called and the pid namespace where the calling
> process belongs to is not from the init pidns, we send a SIGCHLD with CLD_REBOOTED
> to the parent of this pid namespace.

OK, but why you can't simply send the signal?

Why do you need the strange do_notify_parent_cldreboot() which tries
to mimic do_notify_parent() for (afaics) no reason ?

> +void do_notify_parent_cldreboot(struct task_struct *tsk, int why, char *buffer)

buffer is not used. Why?

> +	if (tsk->ptrace)
> +		parent = tsk->parent;
> +	else {
> +		tsk = tsk->group_leader;
> +		parent = tsk->real_parent;
> +	}

For what? I simply can't understand this...

> +     sighand = parent->sighand;
> +     spin_lock_irqsave(&sighand->siglock, flags);

this is unsafe, we can't trust ->sighand and parent.

> +	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.

but not in this case, afaics?

> +	__wake_up_parent(tsk, parent);

Why do you need __wake_up_parent()?

> +static void pid_namespace_reboot(struct pid_namespace *pid_ns,
> +				int cmd, char *buffer)
> +{
> +	struct task_struct *tsk = pid_ns->child_reaper;
> +	do_notify_parent_cldreboot(tsk, cmd, buffer);

nothing prevents ->child_reaper from exiting it it is multithreaded,
this can crash the kernel.

> @@ -426,10 +434,18 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  {
>  	char buffer[256];

again, it is not used.

>  	int ret = 0;
> +	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
> +
> +        /* We only trust the superuser with rebooting the system. */
> +	if (!capable(CAP_SYS_BOOT)) {
> +		/* If we are not in the initial pid namespace, we send a signal
> +		 * to the parent of this init pid namespace, notifying a shutdown
> +		 * occured */
> +		if (pid_ns != &init_pid_ns)
> +			pid_namespace_reboot(pid_ns, cmd, buffer);

Hmm. Looks like pid_ns should be checked after CAP_SYS_BOOT?

Oleg.

