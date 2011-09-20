Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1ITMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1ITMZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:25:57 -0400
Date: Tue, 20 Sep 2011 14:22:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110920122202.GA26504@redhat.com>
References: <20110919214531.GA18085@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919214531.GA18085@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19, Serge E. Hallyn wrote:
>
> __send_signal: convert the uid being sent in SI_USER to the target task's
> user namespace.
>
> do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
>  user namespace
>
> ptrace_signal: map parent's uid into current's user namespace before
> including in signal to current.

And all of them follow the same pattern,

> @@ -1073,7 +1074,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			q->info.si_code = SI_USER;
>  			q->info.si_pid = task_tgid_nr_ns(current,
>  							task_active_pid_ns(t));
> -			q->info.si_uid = current_uid();
> +			q->info.si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> +					current_cred(), current_uid());

Up to you, but may be we can add a helper? Something like

	static inline uid_t good_name(struct task_struct *from, struct task_struct *to)
	{
		// the caller does rcu_read_lock() if needed
		const struct cred *from_cred = __task_cred(from);
		return user_ns_map_uid(task_cred_xxx(to, user_ns),
					from_cred, from_cred->uid);
	}

As for __send_signal() in particular, I guess we could do

		q->info.si_uid = from_ancestor_ns ? 0 : current_uid();

instead, but otoh perhaps it is better to use user_ns_map_uid() anyway
for consistency.

> @@ -2118,11 +2124,16 @@ static int ptrace_signal(int signr, siginfo_t *info,
>  	 * have updated *info via PTRACE_SETSIGINFO.
>  	 */
>  	if (signr != info->si_signo) {
> +		const struct cred *pcred;
>  		info->si_signo = signr;
>  		info->si_errno = 0;
>  		info->si_code = SI_USER;
>  		info->si_pid = task_pid_vnr(current->parent);
> -		info->si_uid = task_uid(current->parent);
> +		rcu_read_lock();

In this case please add rcu_read_lock() earlier, before task_pid_vnr().
It has the same (theoretical) reasons for rcu lock.

Oleg.

