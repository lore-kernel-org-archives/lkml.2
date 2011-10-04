Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab1JDRmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:42:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39774 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab1JDRmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:42:22 -0400
Date: Tue, 4 Oct 2011 12:42:13 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20111004174213.GA24179@sergelap>
References: <20110919214531.GA18085@sergelap>
 <20110920174849.GB22317@redhat.com>
 <20110920185354.GA19629@sergelap>
 <20110921175357.GA25590@redhat.com>
 <20110923163113.GA3820@sergelap>
 <20110923173656.GA5233@redhat.com>
 <20110923212025.GA21330@sergelap>
 <20110924163709.GA6776@redhat.com>
 <20110925201723.GA5288@sergelap>
 <20110926160619.GA13736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926160619.GA13736@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> --- x/kernel/signal.c
> +++ x/kernel/signal.c
> @@ -1019,6 +1019,27 @@ static inline int legacy_queue(struct si
>  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
>  }
>  
> +static inline fixup_uid(struct siginfo *info, struct task_struct *t)
> +{
> +#ifdef CONFIG_USER_NS
> +	if (current_user_ns() == task_cred_xxx(t, user_ns)))
> +#endif
> +		return;
> +
> +	if (SI_FROMKERNEL(info))
> +		switch (info->si_code & __SI_MASK) {
> +			default:
> +				return;
> +
> +			case __SI_CHLD:

If I'm reading this right, this will catch do_notify_parent, which is
sending signals not from current.  Not sure of the best way to avoid
this.  For pids that case is being ignored by not using the __SI_MASK,
so CLD_EXITED etc will cause from_ancestor_ns to be false.  Could we
do that here too, and then translate the pids in do_notify_parent?

> +			case __SI_MESGQ:
> +				break;
> +		}
> +
> +	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> +					current_cred(), info->si_uid);
> +}
> +
>  static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group, int from_ancestor_ns)
>  {
> @@ -1088,6 +1109,9 @@ static int __send_signal(int sig, struct
>  				q->info.si_pid = 0;
>  			break;
>  		}
> +
> +		fixup_uid(info, t);
> +
>  	} else if (!is_si_special(info)) {
>  		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
>  			/*
> 
