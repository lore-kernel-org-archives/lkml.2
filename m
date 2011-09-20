Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1ITPjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:39:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1ITPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:39:52 -0400
Date: Tue, 20 Sep 2011 10:39:44 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110920153944.GA11531@peqn>
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920122202.GA26504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> As for __send_signal() in particular, I guess we could do
> 
> 		q->info.si_uid = from_ancestor_ns ? 0 : current_uid();

But wait - can't __send_signal end up being triggered through fcntl
F_SETSIG+F_SETOWN to another but none-ancestor namespace?  So we
do actually need to call the full user_ns_map_uid() there.  However,
the uid sent in ptrace_signal() can (if i'm thinking right) be set
using

	info->si_uid = (current_user_ns() == parent_user_ns()) ?
			0 : current_uid();

Not much of a win performance-wise, but perhaps better by making it
clear that those are the only possibilities (and overflowuid is not
possible).

thanks,
-serge
