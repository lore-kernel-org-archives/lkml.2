Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2JGTDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 15:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2JGTDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 15:03:35 -0400
Date: Sun, 7 Oct 2012 21:01:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] [RFC] pidns: don't zap processes several times
Message-ID: <20121007190118.GA16068@redhat.com>
References: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Andrew Vagin wrote:
>
> I wrote a test program. It does clone(CLONE_NEWPID | CLONE_VM) and
> sleep(), a new task repeates the same actions. This program creates
> 4000 tasks. When I tried to kill all this processes, a system was
> inaccessible for some minutes.

So this creates 4000 nested namespaces? Not sure this really needs the
fix... The size of pid would be more than 4000 * sizeof(struct upid).

Perhaps we should MAX_PID_NS_LEVEL instead?

As for the patch, it looks correct at first glance. But,

> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -34,6 +34,7 @@ struct pid_namespace {
>  	kgid_t pid_gid;
>  	int hide_pid;
>  	int reboot;	/* group exit code if this pidns was rebooted */
> +	atomic_t zapped; /* non zero if all process were killed */
>  };

atomic_t buys nothing. In this case atomic_set/read doesn't differ
from plain STORE/LOAD.

> @@ -177,21 +177,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	 * 	  maintain a tasklist for each pid namespace.
>  	 *
>  	 */
> +
> +	if (atomic_read(&pid_ns->zapped))
> +		goto wait; /* All processes were already killed */
> +

OK, but if we try to speedup, then probably the main loop should
check ->zapped too and stop. Multiple reapers can start
zap_pid_ns_processes() at the same time.

So, probably,

>  	read_lock(&tasklist_lock);
>  	nr = next_pidmap(pid_ns, 1);
>  	while (nr > 0) {

should be "while (nr > 0 && !zapped)", and

>  		rcu_read_lock();
>
>  		task = pid_task(find_vpid(nr), PIDTYPE_PID);
> -		if (task && !__fatal_signal_pending(task))
> +		if (task && !__fatal_signal_pending(task)) {
> +			struct pid_namespace *ns;
> +
>  			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
> +			ns = task_active_pid_ns(task);
> +			if (unlikely(ns->child_reaper == task))
> +				atomic_set(&ns->zapped, 1);

This should be unconditional. Even if the task is not child_reaper,
we are going to kill the whole namespace. So I think

	if (task_active_pid_ns(task) != task_active_pid_ns(current))
		ns->zapped = 1;

except it should be optimized.



I am wondering if we can do for_each_pid_in_this_ns(pid) which skips
the pids from the sub-namespaces. Note that zap_pid_ns_processes()
doesn't really need to kill the tasks from sub-namespace, its init
will take care anyway. In this case we do not nee ns->zapped.
Probably not...

Oleg.

