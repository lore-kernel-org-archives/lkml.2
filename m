Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1ITMm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:42:59 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:34597 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752011Ab1ITMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:42:58 -0400
Date: Tue, 20 Sep 2011 12:44:20 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110920124419.GA10759@hallyn.com>
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920122202.GA26504@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/19, Serge E. Hallyn wrote:
> >
> > __send_signal: convert the uid being sent in SI_USER to the target task's
> > user namespace.
> >
> > do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
> >  user namespace
> >
> > ptrace_signal: map parent's uid into current's user namespace before
> > including in signal to current.
> 
> And all of them follow the same pattern,
> 
> > @@ -1073,7 +1074,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >  			q->info.si_code = SI_USER;
> >  			q->info.si_pid = task_tgid_nr_ns(current,
> >  							task_active_pid_ns(t));
> > -			q->info.si_uid = current_uid();
> > +			q->info.si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> > +					current_cred(), current_uid());
> 
> Up to you, but may be we can add a helper? Something like
> 
> 	static inline uid_t good_name(struct task_struct *from, struct task_struct *to)
> 	{
> 		// the caller does rcu_read_lock() if needed
> 		const struct cred *from_cred = __task_cred(from);
> 		return user_ns_map_uid(task_cred_xxx(to, user_ns),
> 					from_cred, from_cred->uid);
> 	}

That looks great, thanks.  I couldn't think it up myself, but now that
I see it in your email, I see this would be very valuable in helping
make this code more readable  :)

> As for __send_signal() in particular, I guess we could do
> 
> 		q->info.si_uid = from_ancestor_ns ? 0 : current_uid();
> 
> instead, but otoh perhaps it is better to use user_ns_map_uid() anyway
> for consistency.

Yeah I'm torn on this, but actually I think the above with a comment
explaining it might be better.

> > @@ -2118,11 +2124,16 @@ static int ptrace_signal(int signr, siginfo_t *info,
> >  	 * have updated *info via PTRACE_SETSIGINFO.
> >  	 */
> >  	if (signr != info->si_signo) {
> > +		const struct cred *pcred;
> >  		info->si_signo = signr;
> >  		info->si_errno = 0;
> >  		info->si_code = SI_USER;
> >  		info->si_pid = task_pid_vnr(current->parent);
> > -		info->si_uid = task_uid(current->parent);
> > +		rcu_read_lock();
> 
> In this case please add rcu_read_lock() earlier, before task_pid_vnr().
> It has the same (theoretical) reasons for rcu lock.

Ah.  I stared at that for some time trying to figure out if I was
wrong about my needing it since it didn't have that :)  Will do.

Thanks for the feedback, Oleg!

-serge
