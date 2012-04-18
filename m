Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2DRTGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:06:16 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:33819 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2DRTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:06:14 -0400
Date: Wed, 18 Apr 2012 19:07:11 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 32/43] userns: signal remove unnecessary map_cred_ns
Message-ID: <20120418190711.GJ5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-32-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-32-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> map_cred_ns is a light wrapper around from_kuid with the order of the arguments
> reversed.  Replace map_cred_ns with from_kuid and remove map_cred_ns.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/signal.c |   20 +++++---------------
>  1 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9797939..6aca310 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1019,15 +1019,6 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
>  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
>  }
>  
> -/*
> - * map the uid in struct cred into user namespace *ns
> - */
> -static inline uid_t map_cred_ns(const struct cred *cred,
> -				struct user_namespace *ns)
> -{
> -	return from_kuid_munged(ns, cred->uid);
> -}
> -
>  #ifdef CONFIG_USER_NS
>  static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
>  {
> @@ -1677,8 +1668,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>  	 */
>  	rcu_read_lock();
>  	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
> -	info.si_uid = map_cred_ns(__task_cred(tsk),
> -			task_cred_xxx(tsk->parent, user_ns));
> +	info.si_uid = from_kuid_munged(task_cred_xxx(tsk->parent, user_ns),
> +				       task_uid(tsk));
>  	rcu_read_unlock();
>  
>  	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
> @@ -1761,8 +1752,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
>  	 */
>  	rcu_read_lock();
>  	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
> -	info.si_uid = map_cred_ns(__task_cred(tsk),
> -			task_cred_xxx(parent, user_ns));
> +	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
>  	rcu_read_unlock();
>  
>  	info.si_utime = cputime_to_clock_t(tsk->utime);
> @@ -2180,8 +2170,8 @@ static int ptrace_signal(int signr, siginfo_t *info,
>  		info->si_code = SI_USER;
>  		rcu_read_lock();
>  		info->si_pid = task_pid_vnr(current->parent);
> -		info->si_uid = map_cred_ns(__task_cred(current->parent),
> -				current_user_ns());
> +		info->si_uid = from_kuid_munged(current_user_ns(),
> +						task_uid(current->parent));
>  		rcu_read_unlock();
>  	}
>  
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
