Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1FPMpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab1FPMpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:45:11 -0400
Date: Thu, 16 Jun 2011 14:42:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110616124019.GA19312@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615184625.GA15573@redhat.com> <1308222107.8230.49.camel@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308222107.8230.49.camel@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Greg Kurz wrote:
>
> On Wed, 2011-06-15 at 20:46 +0200, Oleg Nesterov wrote:
> > On 06/15, Greg Kurz wrote:
> > >
> > > @@ -176,6 +177,17 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
> > >  		if (tracer)
> > >  			tpid = task_pid_nr_ns(tracer, ns);
> > >  	}
> > > +	actpid = 0;
> > > +	sighand = rcu_dereference(p->sighand);
> > > +	if (sighand) {
> > > +		struct pid_namespace *pid_ns;
> > > +		unsigned long flags;
> > > +		spin_lock_irqsave(&sighand->siglock, flags);
> >
> > Well. This is not exactly right. We have lock_task_sighand() for this.
> >
>
> I see... ->sighand could change so we need the for(;;) loop in
> __lock_task_sighand() to be sure we have the right pointer, correct ?

Yes,

> By the way, if we use lock_task_sighand() we'll end up with nested
> rcu_read_lock(): it will work but I don't know how it may affect
> performance...

You are kidding ;)

> > But. Why do you need ->siglock? Why rcu_read_lock() is not enough?
> >
>
> Because there's a race with
> __exit_signal()->__unhash_process()->detach_pid() that can break
> task_active_pid_ns()

Yes,

> and rcu won't help here

Why? free_pid() uses call_rcu() to do put_pid()

> (unless *perhaps* by
> modifying __exit_signal() but I don't want to mess with such a critical
> path).

I don't think so...

> > Hmm. You don't even need pid_ns afaics, you could simply look at
> > pid->numbers[pid->level].
> >
>
> True but I will have the same problem: detach_pid() nullifies the pid.

Can't understand. Of course pid can be NULL. So what? Say, ->sighand
can be NULL as well, they both "disappear" at the same time. This is
fine, we raced with exit, we should report pid=0.

Oleg.

