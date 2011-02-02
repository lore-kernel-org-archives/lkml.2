Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1BBL2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:28:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:40800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BBL2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:28:24 -0500
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1295534345.28776.175.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1295534345.28776.175.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 12:29:20 +0100
Message-ID: <1296646160.26581.315.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 15:39 +0100, Peter Zijlstra wrote:
> On Thu, 2011-01-20 at 15:30 +0200, Stephane Eranian wrote:
> > @@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
> >  
> >         /* Reassign the task to the init_css_set. */
> >         task_lock(tsk);
> > +       /*
> > +        * we mask interrupts to prevent:
> > +        * - timer tick to cause event rotation which
> > +        *   could schedule back in cgroup events after
> > +        *   they were switched out by perf_cgroup_sched_out()
> > +        *
> > +        * - preemption which could schedule back in cgroup events
> > +        */
> > +       local_irq_save(flags);
> > +       perf_cgroup_sched_out(tsk);
> >         cg = tsk->cgroups;
> >         tsk->cgroups = &init_css_set;
> > +       perf_cgroup_sched_in(tsk);
> > +       local_irq_restore(flags);
> >         task_unlock(tsk);
> >         if (cg)
> >                 put_css_set_taskexit(cg); 
> 
> So you too need a callback on cgroup change there.. Li, Paul, any chance
> we can fix this cgroup_subsys::exit callback? The scheduler code needs
> to do funny thing because its in the wrong place as well.

cgroup guys? Shall I just fix this exit thing since the only user seems
to be the scheduler and now perf for both of which its unfortunate at
best?

Balbir, memcontrol.c uses pre_destroy(), I pose that using this method
is broken per definition since it makes the cgroup empty notification
void.



