Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2LUPtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:49:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2LUPte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:49:34 -0500
Date: Fri, 21 Dec 2012 16:49:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/11] pidns: Support unsharing the pid namespace.
Message-ID: <20121221154931.GA18730@redhat.com>
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-11-git-send-email-ebiederm@xmission.com> <20121219181400.GA22991@redhat.com> <871uektc2f.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uektc2f.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > So alloc_pid() becomes the only user nsproxy->pid_ns and it is not
> > necessarily equal to task_active_pid_ns(). It seems to me that this
> > adds a lot of new corner cases.
>
> I have tried to simply outlaw the most of the new corner cases as they
> simply are not interesting so there is no point implementing them,
> or thinking about them once they are outlawed.

Eric. I understand that it is too late to discuss this. And yes, I simply
do not understand the problem space, I never used containers.

But, stupid question. Let's ignore the pid_ns-specific oddities.

1. Ignoring setns(), why do we need /proc/pid/ns/ ?

2. Why setns() requires /proc/pid/ns/ ? IOW, why it can't be

	sys_setns(pid_t pid, int clone_flags)
	{
		truct task_struct *tsk = find_task_by_vpid(pid);
		struct nsproxy *target = get_nsproxy(tsk->nsproxy);

		new_nsproxy = create_new_namespaces(...);

		if (clone_flags & CLONE_NEWNS)
			mntns_install(...);
		if (clone_flags & CLONE_NEWIPC)
			ipcns_install(...);
		...
	}

I feel I missed something trivial, but what?

> @@ -1166,6 +1166,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                                 current->signal->flags & SIGNAL_UNKILLABLE)
>                 return ERR_PTR(-EINVAL);
>
> +       /*
> +        * If the children will be in a different pid namespace don't allow
> +        * the creation of threads.
> +        */
> +       if ((clone_flags & (CLONE_THREAD|CLONE_SIGHAND|CLONE_VM|CLONE_PARENT)) &&
> +           task_active_pid_ns(current) != current->nsproxy->pid_ns)
> +               return ERR_PTR(-EINVAL);

Agreed, and this also removes other oddities with pthread_create().

Oleg.

