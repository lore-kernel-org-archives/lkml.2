Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0C3R2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:28:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37905 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab0C3R2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:28:16 -0400
Date: Tue, 30 Mar 2010 10:28:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, abogani@texware.it
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100330172808.GK2513@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329211525.GA17703@linux.vnet.ibm.com>
 <6599ad831003291543r71300bcfv2957004bf2e927bb@mail.gmail.com>
 <1269939034.5109.511.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269939034.5109.511.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 10:50:34AM +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 15:43 -0700, Paul Menage wrote:
> > On Mon, Mar 29, 2010 at 2:15 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > Add an rcu_read_lock() / rcu_read_unlock() pair to protect a fork-time
> > > cgroup access.  This seems likely to be a false positive.
> > >
> > > Located by: Alessio Igor Bogani <abogani@texware.it>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > >
> > >  sched.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > index 9ab3cd7..d4bb5e0 100644
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -2621,7 +2621,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
> > >        if (p->sched_class->task_fork)
> > >                p->sched_class->task_fork(p);
> > >
> > > +       rcu_read_lock();
> > >        set_task_cpu(p, cpu);
> > > +       rcu_read_unlock();
> > 
> > I think you're right that this is a false positive - it would only be
> > a problem if it were possible for the task to be moved to a different
> > cgroup, and I think that shouldn't be the case at this point in the
> > fork path since the new process isn't visible on the tasklist yet,
> > right?
> 
> Well the thing is, this fork time invocation of
> set_task_cpu()->set_task_rq() is in no way special, there's multiple
> places like that.

Certainly the lack of clarity about why this access is safe indicates
that recording some of the locking design in rcu_dereferenceI() would
be quite helpful.  ;-)

							Thanx, Paul
