Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab2D2ENu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 00:13:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36585 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750744Ab2D2ENt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 00:13:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19j5+V1VjhjS44FCSEQwHa0iTkel6jN4NPpN/UMR+
	fzMwY0+/Dp5vgy
Message-ID: <1335672824.7366.56.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Sun, 29 Apr 2012 06:13:44 +0200
In-Reply-To: <20120428142605.GA20248@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 16:26 +0200, Oleg Nesterov wrote: 
> On 04/28, Mike Galbraith wrote:
> >
> > Greetings,
> 
> Hi,
> 
> Add CC's. I never understood the proc/namespace interaction in details,
> and it seems to me I forgot everything.
> 
> > SIGCHLD delivery during fork() may cause failure,
> 
> Or any other reason to fail after copy_namespaces()

Yeah.

> > resulting in the aborted
> > child being cloned with CLONE_NEWPID leaking namespaces due to proc being
> > mounted during pid namespace creation, but not unmounted on fork() failure.
> 
> Heh. Please look at http://marc.info/?l=linux-kernel&m=127687751003902
> and the whole thread, there are a lot more problems here.

Ew, I would have been better off not reading that ;-)

> But this particular one looks simple iirc.
> 
> > @@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
> >  	rcu_assign_pointer(p->nsproxy, new);
> >
> >  	if (ns && atomic_dec_and_test(&ns->count)) {
> > +		/* Handle fork() failure, unmount proc before proceeding */
> > +		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
> > +			struct pid_namespace *pid_ns = ns->pid_ns;
> > +
> > +			if (pid_ns && pid_ns != &init_pid_ns)
> > +				pid_ns_release_proc(pid_ns);
> > +		}
> > +
> >  		/*
> >  		 * wait for others to get what they want from this nsproxy.
> >  		 *
> 
> At first glance this looks correct. But the PF_EXITING check doesn't
> look very nice imho. It is needed to detect the case when the caller
> is copy_process()->bad_fork_cleanup_namespaces and p is not current.

Yeah, that does look a lot like a wart.

This being the first use of pid_ns_release_proc(), I was more concerned
that perhaps I should be doing something else entirely.

> Perhaps it would be more clean to add the explicit
> 
> 	 bad_fork_cleanup_namespaces:
> 	+	if (unlikely(clone_flags & CLONE_NEWPID))
> 	+		pid_ns_release_proc(...);
> 		exit_task_namespaces(p);
> 		
> 		
> code into this error path in copy_process?

Yeah, that's prettier.  Thanks.

-Mike

