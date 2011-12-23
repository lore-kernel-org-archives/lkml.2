Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1LWCld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:41:33 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39136 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1LWCla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:41:30 -0500
Date: Fri, 23 Dec 2011 03:41:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/3] cgroup: remove tasklist_lock from cgroup_attach_proc
Message-ID: <20111223024122.GC28309@somewhere.redhat.com>
References: <1324601873-20773-1-git-send-email-msb@chromium.org>
 <20111223022742.GA28309@somewhere.redhat.com>
 <4EF3EA1C.4000806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF3EA1C.4000806@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:40:28AM +0800, Li Zefan wrote:
> >> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> >> index 1042b3c..032139d 100644
> >> --- a/kernel/cgroup.c
> >> +++ b/kernel/cgroup.c
> >> @@ -2102,21 +2102,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >>  	if (retval)
> >>  		goto out_free_group_list;
> >>  
> >> -	/* prevent changes to the threadgroup list while we take a snapshot. */
> >> -	read_lock(&tasklist_lock);
> >> -	if (!thread_group_leader(leader)) {
> >> -		/*
> >> -		 * a race with de_thread from another thread's exec() may strip
> >> -		 * us of our leadership, making while_each_thread unsafe to use
> >> -		 * on this task. if this happens, there is no choice but to
> >> -		 * throw this task away and try again (from cgroup_procs_write);
> >> -		 * this is "double-double-toil-and-trouble-check locking".
> >> -		 */
> >> -		read_unlock(&tasklist_lock);
> >> -		retval = -EAGAIN;
> >> -		goto out_free_group_list;
> >> -	}
> >> -
> >>  	tsk = leader;
> >>  	i = 0;
> >>  	do {
> >> @@ -2145,7 +2130,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >>  	group_size = i;
> >>  	tset.tc_array = group;
> >>  	tset.tc_array_len = group_size;
> >> -	read_unlock(&tasklist_lock);
> > 
> > You still need rcu_read_lock()/rcu_read_unlock() around
> > 	do {
> > 
> > 	} while_each_thread()
> > 
> > because threadgroup_lock() doesn't lock the part that remove a thread from
> > its group on exit.
> > 
> 
> and inside rcu critical section, you can't call kmalloc(GFP_KERNEL)!!

Good point. Well it's still worth replacing tasklist_lock by rcu though :)
