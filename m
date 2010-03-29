Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0C2XFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:05:35 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60262 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0C2XFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:05:34 -0400
Date: Mon, 29 Mar 2010 16:05:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, abogani@texware.it
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100329230530.GS2569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329211525.GA17703@linux.vnet.ibm.com>
 <6599ad831003291543r71300bcfv2957004bf2e927bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad831003291543r71300bcfv2957004bf2e927bb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 03:43:43PM -0700, Paul Menage wrote:
> On Mon, Mar 29, 2010 at 2:15 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > Add an rcu_read_lock() / rcu_read_unlock() pair to protect a fork-time
> > cgroup access.  This seems likely to be a false positive.
> >
> > Located by: Alessio Igor Bogani <abogani@texware.it>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >
> >  sched.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 9ab3cd7..d4bb5e0 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2621,7 +2621,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
> >        if (p->sched_class->task_fork)
> >                p->sched_class->task_fork(p);
> >
> > +       rcu_read_lock();
> >        set_task_cpu(p, cpu);
> > +       rcu_read_unlock();
> 
> I think you're right that this is a false positive - it would only be
> a problem if it were possible for the task to be moved to a different
> cgroup, and I think that shouldn't be the case at this point in the
> fork path since the new process isn't visible on the tasklist yet,
> right?

You are correct, it is not yet on the tasklist.

So I have to ask...  What happens if the underlying cgroup is removed
between the time sched_fork() calls set_task_cpu() and the time that
copy_process() puts the new task on the tasklist?  Or is the initial
cgroup guaranteed to be immortal?

							Thanx, Paul
