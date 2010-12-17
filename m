Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0LQUFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:05:02 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58012 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0LQUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:05:00 -0500
Date: Fri, 17 Dec 2010 14:04:47 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [RFC 5/5] user namespaces: Allow ptrace from non-init user
 namespaces
Message-ID: <20101217200447.GA3701@peq>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217152547.GB11162@mail.hallyn.com>
 <20101217152625.GC11162@mail.hallyn.com>
 <20101217152659.GD11162@mail.hallyn.com>
 <20101217152737.GE11162@mail.hallyn.com>
 <m1hbecqj2q.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbecqj2q.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing, Eric.

Quoting Eric W. Biederman (ebiederm@xmission.com):
> > +static inline int may_ptrace_ns(struct task_struct *t)
> 
> Can we name this ptrace_capable?  Since you are only
> wrapping the capability check?  With a name like may_ptrace_ns
> I imagine very different semantics.

Hm, the whole structure here could probably stand to be improved
anyway.  I just can't quite think how.  I'll rename it as you
suggest for starters, just not sure if it'll continue to exist.

> 
> > +{
> > +	struct user_namespace *ns;
> > +	int ret;
> > +
> > +	rcu_read_lock();
> > +	ns = task_cred_xxx(t, user)->user_ns;
> > +	ret = ns_capable(ns, CAP_SYS_PTRACE);
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> >  int __ptrace_may_access(struct task_struct *task, unsigned int mode)
> >  {
> >  	const struct cred *cred = current_cred(), *tcred;
> > @@ -134,21 +147,24 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
> >  		return 0;
> >  	rcu_read_lock();
> >  	tcred = __task_cred(task);
> > -	if ((cred->uid != tcred->euid ||
> > -	     cred->uid != tcred->suid ||
> > -	     cred->uid != tcred->uid  ||
> > -	     cred->gid != tcred->egid ||
> > -	     cred->gid != tcred->sgid ||
> > -	     cred->gid != tcred->gid) &&
> > -	    !capable(CAP_SYS_PTRACE)) {
> > -		rcu_read_unlock();
> > -		return -EPERM;
> > -	}
> > +	if (cred->user->user_ns == tcred->user->user_ns &&
> > +	    (cred->uid == tcred->euid ||
> > +	     cred->uid == tcred->suid ||
> > +	     cred->uid == tcred->uid  ||
> > +	     cred->gid == tcred->egid ||
> > +	     cred->gid == tcred->sgid ||
> > +	     cred->gid == tcred->gid))
> > +		goto ok;
> 
> This needs to be:
> > +	if (cred->user->user_ns == tcred->user->user_ns &&
> > +	    (cred->uid == tcred->euid &&
> > +	     cred->uid == tcred->suid &&
> > +	     cred->uid == tcred->uid  &&
> > +	     cred->gid == tcred->egid &&
> > +	     cred->gid == tcred->sgid &&
> > +	     cred->gid == tcred->gid))
> > +		goto ok;

Hm, I started to explain why it doesn't, but you're right.
If any of the uids are different, then you must have
CAP_SYS_PTRACE or be denied.

> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -136,12 +136,20 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
> >  int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
> >  {
> >  	int ret = 0;
> > +	struct cred *cred, *tcred;
> >  
> >  	rcu_read_lock();
> > -	if (!cap_issubset(__task_cred(child)->cap_permitted,
> > -			  current_cred()->cap_permitted) &&
> > +	cred = current_cred();
> > +	tcred = __task_cred(child);
> > +	if (cred->user->user_ns != tcred->user->user_ns) {
> 
> This probably deserves a comment about why cap_issubset isn't
> needed here.  Aka we implicitly have all caps in child user namespaces
> so if we have CAP_SYS_PTRACE we know we have them all.

(going strictly by the rules which fall out from the original intent
of ns_capable) :

There is a case where that isn't true - if I'm user B in userns 3, and
user A in userns 3 created the userns 4 in which this target task, owned
by user C, sits.  Then user B does not have all capabilities to userns 4,
but any calculated capabilities which B has, are also valid in userns 4.

I'd still claim that capabilities aren't really comparable (because
they are targeted at different user namespaces), and therefore the
CAP_SYS_PTRACE should be sufficient for this case.  But maybe that's
not as practical.  Maybe the cap_issubset check should be there after
all.

> > +		if (!ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
> > +			ret = -EPERM;
> > +		goto out;
> > +	}
> > +	if (!cap_issubset(tcred->cap_permitted, cred->cap_permitted) &&
> >  	    !capable(CAP_SYS_PTRACE))
> >  		ret = -EPERM;
> > +out:
> >  	rcu_read_unlock();
> >  	return ret;
> >  }
> > @@ -156,12 +164,20 @@ int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
> >  int cap_ptrace_traceme(struct task_struct *parent)
> >  {
> >  	int ret = 0;
> > +	struct cred *cred, *tcred;
> >  
> >  	rcu_read_lock();
> > -	if (!cap_issubset(current_cred()->cap_permitted,
> > -			  __task_cred(parent)->cap_permitted) &&
> > -	    !has_capability(parent, CAP_SYS_PTRACE))
> > +	cred = __task_cred(parent);
> > +	tcred = current_cred();
> > +	if (cred->user->user_ns != tcred->user->user_ns) {
> > +		if (!has_ns_capability(parent, tcred->user->user_ns, CAP_SYS_PTRACE))
> > +			ret = -EPERM;
> > +		goto out;
> > +	}
> > +	if (!cap_issubset(tcred->cap_permitted, cred->cap_permitted) &&
> > +	    !has_ns_capability(parent, tcred->user->user_ns, CAP_SYS_PTRACE))
> >  		ret = -EPERM;
> > +out:
> >  	rcu_read_unlock();
> >  	return ret;
> >  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
