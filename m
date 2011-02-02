Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1BBMpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:45:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1BBMph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:45:37 -0500
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, lizf@cn.fujitsu.com, Paul Menage <menage@google.com>
In-Reply-To: <20110202115012.GA16409@balbir.in.ibm.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
	 <20110202115012.GA16409@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 13:46:32 +0100
Message-ID: <1296650792.26581.319.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 17:20 +0530, Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-02-02 12:29:20]:
> 
> > On Thu, 2011-01-20 at 15:39 +0100, Peter Zijlstra wrote:
> > > On Thu, 2011-01-20 at 15:30 +0200, Stephane Eranian wrote:
> > > > @@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
> > > >  
> > > >         /* Reassign the task to the init_css_set. */
> > > >         task_lock(tsk);
> > > > +       /*
> > > > +        * we mask interrupts to prevent:
> > > > +        * - timer tick to cause event rotation which
> > > > +        *   could schedule back in cgroup events after
> > > > +        *   they were switched out by perf_cgroup_sched_out()
> > > > +        *
> > > > +        * - preemption which could schedule back in cgroup events
> > > > +        */
> > > > +       local_irq_save(flags);
> > > > +       perf_cgroup_sched_out(tsk);
> > > >         cg = tsk->cgroups;
> > > >         tsk->cgroups = &init_css_set;
> > > > +       perf_cgroup_sched_in(tsk);
> > > > +       local_irq_restore(flags);
> > > >         task_unlock(tsk);
> > > >         if (cg)
> > > >                 put_css_set_taskexit(cg); 
> > > 
> > > So you too need a callback on cgroup change there.. Li, Paul, any chance
> > > we can fix this cgroup_subsys::exit callback? The scheduler code needs
> > > to do funny thing because its in the wrong place as well.
> > 
> > cgroup guys? Shall I just fix this exit thing since the only user seems
> > to be the scheduler and now perf for both of which its unfortunate at
> > best?
> 
> Are you suggesting that the cgroup_exit on task_exit notification should be
> pulled out?


No, just fixed. The callback as it exists isn't useful and leads to
hacks like the above.


> > Balbir, memcontrol.c uses pre_destroy(), I pose that using this method
> > is broken per definition since it makes the cgroup empty notification
> > void.
> >
> 
> We use pre_destroy() to reclaim, so that delete/rmdir() will be able
> to clean up the node/group. I am not sure what you mean by it makes
> the empty notification void and why pre_destroy() is broken?

A quick look at the code looked like it could return -EBUSY (and other
errors), in that case the rmdir of the empty cgroup will fail.

Therefore it can happen that after the last task is removed, and we get
the notification that the cgroup is empty, and we attempt the rmdir we
will fail.

This again means that all such notification handlers must poll state,
which is ridiculous.



