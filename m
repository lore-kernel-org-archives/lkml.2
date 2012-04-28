Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2D1O1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 10:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab2D1O1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 10:27:01 -0400
Date: Sat, 28 Apr 2012 16:26:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
Message-ID: <20120428142605.GA20248@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335604790.5995.22.camel@marge.simpson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Mike Galbraith wrote:
>
> Greetings,

Hi,

Add CC's. I never understood the proc/namespace interaction in details,
and it seems to me I forgot everything.

> SIGCHLD delivery during fork() may cause failure,

Or any other reason to fail after copy_namespaces()

> resulting in the aborted
> child being cloned with CLONE_NEWPID leaking namespaces due to proc being
> mounted during pid namespace creation, but not unmounted on fork() failure.

Heh. Please look at http://marc.info/?l=linux-kernel&m=127687751003902
and the whole thread, there are a lot more problems here.

But this particular one looks simple iirc.

> @@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
>  	rcu_assign_pointer(p->nsproxy, new);
>
>  	if (ns && atomic_dec_and_test(&ns->count)) {
> +		/* Handle fork() failure, unmount proc before proceeding */
> +		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
> +			struct pid_namespace *pid_ns = ns->pid_ns;
> +
> +			if (pid_ns && pid_ns != &init_pid_ns)
> +				pid_ns_release_proc(pid_ns);
> +		}
> +
>  		/*
>  		 * wait for others to get what they want from this nsproxy.
>  		 *

At first glance this looks correct. But the PF_EXITING check doesn't
look very nice imho. It is needed to detect the case when the caller
is copy_process()->bad_fork_cleanup_namespaces and p is not current.

Perhaps it would be more clean to add the explicit

	 bad_fork_cleanup_namespaces:
	+	if (unlikely(clone_flags & CLONE_NEWPID))
	+		pid_ns_release_proc(...);
		exit_task_namespaces(p);
		
		
code into this error path in copy_process?

Oleg.

