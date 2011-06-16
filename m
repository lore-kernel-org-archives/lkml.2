Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1FPLCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:02:16 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:52287 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1FPLCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:02:14 -0400
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
 Vpid:)
From: Greg Kurz <gkurz@fr.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, xemul@openvz.org
In-Reply-To: <20110615184625.GA15573@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local>
	 <20110615184625.GA15573@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 13:01:47 +0200
Message-ID: <1308222107.8230.49.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 20:46 +0200, Oleg Nesterov wrote:
> On 06/15, Greg Kurz wrote:
> >
> > @@ -176,6 +177,17 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
> >  		if (tracer)
> >  			tpid = task_pid_nr_ns(tracer, ns);
> >  	}
> > +	actpid = 0;
> > +	sighand = rcu_dereference(p->sighand);
> > +	if (sighand) {
> > +		struct pid_namespace *pid_ns;
> > +		unsigned long flags;
> > +		spin_lock_irqsave(&sighand->siglock, flags);
> 
> Well. This is not exactly right. We have lock_task_sighand() for this.
> 

I see... ->sighand could change so we need the for(;;) loop in
__lock_task_sighand() to be sure we have the right pointer, correct ?
By the way, if we use lock_task_sighand() we'll end up with nested
rcu_read_lock(): it will work but I don't know how it may affect
performance...

> But. Why do you need ->siglock? Why rcu_read_lock() is not enough?
> 

Because there's a race with
__exit_signal()->__unhash_process()->detach_pid() that can break
task_active_pid_ns() and rcu won't help here (unless *perhaps* by
modifying __exit_signal() but I don't want to mess with such a critical
path).

> Hmm. You don't even need pid_ns afaics, you could simply look at
> pid->numbers[pid->level].
> 

True but I will have the same problem: detach_pid() nullifies the pid.

Thanks for your comments.

--
Greg

