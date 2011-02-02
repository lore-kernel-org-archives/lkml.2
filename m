Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1BBLuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:50:24 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40459 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBLuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:50:23 -0500
Date: Wed, 2 Feb 2011 17:20:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, lizf@cn.fujitsu.com, Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
Message-ID: <20110202115012.GA16409@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop>
 <1296646160.26581.315.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296646160.26581.315.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-02-02 12:29:20]:

> On Thu, 2011-01-20 at 15:39 +0100, Peter Zijlstra wrote:
> > On Thu, 2011-01-20 at 15:30 +0200, Stephane Eranian wrote:
> > > @@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
> > >  
> > >         /* Reassign the task to the init_css_set. */
> > >         task_lock(tsk);
> > > +       /*
> > > +        * we mask interrupts to prevent:
> > > +        * - timer tick to cause event rotation which
> > > +        *   could schedule back in cgroup events after
> > > +        *   they were switched out by perf_cgroup_sched_out()
> > > +        *
> > > +        * - preemption which could schedule back in cgroup events
> > > +        */
> > > +       local_irq_save(flags);
> > > +       perf_cgroup_sched_out(tsk);
> > >         cg = tsk->cgroups;
> > >         tsk->cgroups = &init_css_set;
> > > +       perf_cgroup_sched_in(tsk);
> > > +       local_irq_restore(flags);
> > >         task_unlock(tsk);
> > >         if (cg)
> > >                 put_css_set_taskexit(cg); 
> > 
> > So you too need a callback on cgroup change there.. Li, Paul, any chance
> > we can fix this cgroup_subsys::exit callback? The scheduler code needs
> > to do funny thing because its in the wrong place as well.
> 
> cgroup guys? Shall I just fix this exit thing since the only user seems
> to be the scheduler and now perf for both of which its unfortunate at
> best?a

Are you suggesting that the cgroup_exit on task_exit notification should be
pulled out?

> 
> Balbir, memcontrol.c uses pre_destroy(), I pose that using this method
> is broken per definition since it makes the cgroup empty notification
> void.
>

We use pre_destroy() to reclaim, so that delete/rmdir() will be able
to clean up the node/group. I am not sure what you mean by it makes
the empty notification void and why pre_destroy() is broken?

-- 
	Three Cheers,
	Balbir
