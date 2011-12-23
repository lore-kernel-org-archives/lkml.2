Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1LWCjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:39:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35879 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1LWCjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:39:22 -0500
Date: Fri, 23 Dec 2011 03:39:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/3] cgroup: remove tasklist_lock from cgroup_attach_proc
Message-ID: <20111223023917.GB28309@somewhere.redhat.com>
References: <1324601873-20773-1-git-send-email-msb@chromium.org>
 <20111223022742.GA28309@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223022742.GA28309@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 03:27:45AM +0100, Frederic Weisbecker wrote:
> On Thu, Dec 22, 2011 at 04:57:51PM -0800, Mandeep Singh Baines wrote:
> > Since cgroup_attach_proc is protected by a threadgroup_lock, we
> > no longer need a tasklist_lock to protect while_each_thread.
> > To keep the complexity of the double-check locking in one place,
> > I also moved the thread_group_leader check up into
> > attach_task_by_pid.
> > 
> > While at it, also converted a couple of returns to gotos.
> > 
> > The suggestion was made here:
> > 
> > https://lkml.org/lkml/2011/12/22/86
> > 
> > Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: containers@lists.linux-foundation.org
> > Cc: cgroups@vger.kernel.org
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Paul Menage <paul@paulmenage.org>
> > ---
> >  kernel/cgroup.c |   52 +++++++++++++++++++++-------------------------------
> >  1 files changed, 21 insertions(+), 31 deletions(-)
> > 
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 1042b3c..032139d 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2102,21 +2102,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  	if (retval)
> >  		goto out_free_group_list;
> >  
> > -	/* prevent changes to the threadgroup list while we take a snapshot. */
> > -	read_lock(&tasklist_lock);
> > -	if (!thread_group_leader(leader)) {
> > -		/*
> > -		 * a race with de_thread from another thread's exec() may strip
> > -		 * us of our leadership, making while_each_thread unsafe to use
> > -		 * on this task. if this happens, there is no choice but to
> > -		 * throw this task away and try again (from cgroup_procs_write);
> > -		 * this is "double-double-toil-and-trouble-check locking".
> > -		 */
> > -		read_unlock(&tasklist_lock);
> > -		retval = -EAGAIN;
> > -		goto out_free_group_list;
> > -	}
> > -
> >  	tsk = leader;
> >  	i = 0;
> >  	do {
> > @@ -2145,7 +2130,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  	group_size = i;
> >  	tset.tc_array = group;
> >  	tset.tc_array_len = group_size;
> > -	read_unlock(&tasklist_lock);
> 
> You still need rcu_read_lock()/rcu_read_unlock() around
> 	do {
> 
> 	} while_each_thread()
> 
> because threadgroup_lock() doesn't lock the part that remove a thread from
> its group on exit.

Actually while_each_thread() takes care of the thread group list safe
walking. But we need RCU to ensure the task is not released in parallel.
threadgroup_lock() doesn't synchronize against that if the task has
already passed the setting of PF_EXITING.
