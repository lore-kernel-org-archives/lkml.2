Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1HMAUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:20:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44541 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab1HMAUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:20:04 -0400
Date: Fri, 12 Aug 2011 17:19:59 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        bonbons@linux-vserver.org, oleg@tv-sign.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Notify container-init parent a 'reboot' occured
Message-ID: <20110813001959.GB5777@count0.beaverton.ibm.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
 <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:24:01PM +0200, Daniel Lezcano wrote:
> When the reboot syscall is called and the pid namespace where the calling
> process belongs to is not from the init pidns, we send a SIGCHLD with CLD_REBOOTED
> to the parent of this pid namespace.

Shouldn't we honor the exit_signal set via clone() here rather than
hardcode SIGCHLD? More below...

> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
> ---
>  include/asm-generic/siginfo.h |    3 ++-
>  include/linux/sched.h         |    1 +
>  kernel/signal.c               |   40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/sys.c                  |   20 ++++++++++++++++++--
>  4 files changed, 61 insertions(+), 3 deletions(-)
> 
> diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
> index 0dd4e87..9bff4a2 100644
> --- a/include/asm-generic/siginfo.h
> +++ b/include/asm-generic/siginfo.h
> @@ -218,7 +218,8 @@ typedef struct siginfo {
>  #define CLD_TRAPPED	(__SI_CHLD|4)	/* traced child has trapped */
>  #define CLD_STOPPED	(__SI_CHLD|5)	/* child has stopped */
>  #define CLD_CONTINUED	(__SI_CHLD|6)	/* stopped child has continued */
> -#define NSIGCHLD	6
> +#define CLD_REBOOTED    (__SI_CHLD|7)   /* process was killed by a reboot */
> +#define NSIGCHLD	7
> 
>  /*
>   * SIGPOLL si_codes
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 20b03bf..c62dc9e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2170,6 +2170,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
>  extern int kill_pid(struct pid *pid, int sig, int priv);
>  extern int kill_proc_info(int, struct siginfo *, pid_t);
>  extern __must_check bool do_notify_parent(struct task_struct *, int);
> +extern void do_notify_parent_cldreboot(struct task_struct *, int, char *);
>  extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
>  extern void force_sig(int, struct task_struct *);
>  extern int send_sig(int, struct task_struct *, int);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 291c970..7d3d44c 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1668,6 +1668,46 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>  	return autoreap;
>  }
> 
> +void do_notify_parent_cldreboot(struct task_struct *tsk, int why, char *buffer)
> +{
> +	struct siginfo info = { };
> +	struct task_struct *parent;
> +	struct sighand_struct *sighand;
> +	unsigned long flags;
> +
> +	if (tsk->ptrace)
> +		parent = tsk->parent;
> +	else {
> +		tsk = tsk->group_leader;
> +		parent = tsk->real_parent;
> +	}
> +
> +	info.si_signo = SIGCHLD;

should this be:

info.si_signo = tsk->exit_signal == -1 ? SIGCHLD : tsk->exit_signal;

?

> +	info.si_errno = 0;
> +	info.si_status = why;
> +
> +	rcu_read_lock();
> +	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
> +	info.si_uid = __task_cred(tsk)->uid;
> +	rcu_read_unlock();
> +
> +	info.si_utime = cputime_to_clock_t(tsk->utime);
> +	info.si_stime = cputime_to_clock_t(tsk->stime);
> +
> +	info.si_code = CLD_REBOOTED;
> +
> +	sighand = parent->sighand;
> +	spin_lock_irqsave(&sighand->siglock, flags);
> +	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
> +	    sighand->action[SIGCHLD-1].sa.sa_flags & SA_CLDREBOOT)
> +		__group_send_sig_info(SIGCHLD, &info, parent);

(with corresponding changes above...)

> +	/*
> +	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
> +	 */
