Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1KDPV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:21:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64465 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1KDPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:21:57 -0400
Date: Fri, 4 Nov 2011 08:21:50 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com
Subject: Re: [PATCH 04/10] cgroup: always lock threadgroup during migration
Message-ID: <20111104152150.GX4417@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-5-git-send-email-tj@kernel.org>
 <20111104175413.30afaf8e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104175413.30afaf8e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 04, 2011 at 05:54:13PM +0900, KAMEZAWA Hiroyuki wrote:
> > -	/* if PF_EXITING is set, the tsk->cgroups pointer is no longer safe. */
> > +	/* @tsk can't exit as its threadgroup is locked */
> >  	task_lock(tsk);
> > -	if (tsk->flags & PF_EXITING) {
> > -		task_unlock(tsk);
> > -		put_css_set(newcg);
> > -		return -ESRCH;
> > -	}
> > +	WARN_ON_ONCE(tsk->flags & PF_EXITING);
> >  	rcu_assign_pointer(tsk->cgroups, newcg);
> >  	task_unlock(tsk);
> 
> Is this task_lock/unlock is required ?

For put, I don't think it's necessary.

> > @@ -2116,11 +2120,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  			continue;
> >  		/* get old css_set pointer */
> >  		task_lock(tsk);
> > -		if (tsk->flags & PF_EXITING) {
> > -			/* ignore this task if it's going away */
> > -			task_unlock(tsk);
> > -			continue;
> > -		}
> >  		oldcg = tsk->cgroups;
> >  		get_css_set(oldcg);
> >  		task_unlock(tsk);

For get, I think it is; otherwise, nothing prevents someone else from
changing tsk->cgroups between load and get, and destroying it.

Thanks.

-- 
tejun
