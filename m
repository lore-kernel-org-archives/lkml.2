Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2DDCeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 22:34:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab2DDCen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 22:34:43 -0400
Message-ID: <1333506878.7433.2.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 04 Apr 2012 04:34:38 +0200
In-Reply-To: <20120403184901.GC27794@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <20120403184901.GC27794@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 11:49 -0700, Tejun Heo wrote: 
> On Tue, Apr 03, 2012 at 07:58:26PM +0200, Mike Galbraith wrote:
> > @@ -1894,6 +1895,14 @@ int cgroup_attach_task(struct cgroup *cg
> >  	if (tsk->flags & PF_EXITING)
> >  		return -ESRCH;
> >  
> > +	/*
> > +	 * Workqueue threads may acquire PF_THREAD_BOUND and become
> > +	 * trapped in a cpuset, or RT worker may be born in a cgroup
> > +	 * with no rt_runtime allocated.  Just say no.
> > +	 */
> > +	if (tsk == kthreadd_task)
> > +		return -EINVAL;
> > +
> >  	/* Nothing to do if the task is already in that cgroup */
> >  	oldcgrp = task_cgroup_from_root(tsk, root);
> >  	if (cgrp == oldcgrp)
> > @@ -2172,6 +2181,17 @@ static int attach_task_by_pid(struct cgr
> >  
> >  	if (threadgroup)
> >  		tsk = tsk->group_leader;
> > +
> > +	/*
> > +	 * Workqueue threads may acquire PF_THREAD_BOUND and become
> > +	 * trapped in a cpuset, or RT worker may be born in a cgroup
> > +	 * with no rt_runtime allocated.  Just say no.
> > +	 */
> > +	if (tsk == kthreadd_task) {
> > +		ret = -EINVAL;
> > +		goto out_unlock_cgroup;
> > +	}
> 
> If we have this test here, do we need the same check in
> cgroup_attach_task()/

It looked to me like yes, because cgroup_attach_task() can be called
directly.  For the problem at hand, user script doing bad things, no,
it's not needed.

-Mike

