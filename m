Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1JHUCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:02:11 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:56990 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972Ab1JHUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:02:07 -0400
Date: Sat, 8 Oct 2011 20:02:11 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20111008200211.GA28115@hallyn.com>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/25, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 09/23, Serge E. Hallyn wrote:
> > > >
> > > > Quoting Oleg Nesterov (oleg@redhat.com):
> > > > > On 09/23, Serge E. Hallyn wrote:
> > > > > >
> > > > > > It looks like I can fix all the
> > > > > > cases
> > > > >
> > > > > except ptrace_signal(). Although we can simply ignore this case, imho.
> > > >
> > > > ptrace_signal() calls send_signal() though.
> > >
> > > Confused... I meant the "if (signr != info->si_signo)" case. This is
> > > simple, and I only meant that this case is not that important.
> >
> > Yes, that's the case I was talking about.  That then proceeds through
> > send_signal().
> 
> It doesn't? I am even more confuused. Anyway, your patch adds map_cred_ns()
> into ptrace_signal().
> 
> > The whole new patch (so far only compile-tested) is below.
> 
> Perhaps I missed something, but it looks overcomplicated. I was thinking
> about the (uncompiled/untested) simple patch below (it ignores ptrace_signal
> for clarity).
> 
> And note that this way we do not need to modify do_notify_parent*()
> or ipc/mqueue.c:__do_notify() (your patch doesn't cover the latter).
> Unless I missed something of course.
> 
> And we do not need to handle the SEND_SIG_NOINFO case separately.
> 
> 
> However, we still have the problems with sigqueueinfo, 
> 
> > > > > > by checking whether si_fromuser(info)
> > > > >
> > > > > I am not sure... sys_rt_queueinfo() is nasty. Plus we have to handle
> > > > > the "fromkernel" case too. May be we can ignore this too.
> > > >
> > > > sys_rt_tgsigqueueinfo() still seems to go through send_signal().
> > >
> > > Yes. But how can you fix si_uid? We do not even know if it exists.
> > > Please look at siginfo/_uid, there is a union. We can't know what
> > > the caller of sys_rt_sigqueueinfo() puts in this location.
> >
> > But it's a union alongside the pid.
> 
> Again, I do not understand... Yes, we have the same problem with
> 
> 	if (from_ancestor_ns)
> 		q->info.si_pid = 0;
> 
> This was discussed, we do not know what we can do. My point was, this
> change is not sigqueueinfo-friendly too.
> 
> Oleg.
> 
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

After looking a bit more, I really think the __SI_CHLD case just needs to
always be converted at the callers (i.e. do_notify_parent).

> +			case __SI_MESGQ:

This can be done like this, but if this is going to be the only case of
a SI_FROMKERNEL not being converted at the caller, and there is aiui only
one caller (__do_notivy in ipc/mmqueue.c), it seems better to just have
fixup_uid() always return for SI_FROMKERNEL(info).

Does that sound ok?

If so, I'll whip up the patch and send it out after some testing.  (If
not, I'll try to better understand :)


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

thanks,
-serge
