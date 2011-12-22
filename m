Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1LVJos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:44:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40078 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab1LVJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:44:45 -0500
Date: Thu, 22 Dec 2011 10:44:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 4/4] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20111222094437.GO17668@somewhere>
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
 <1324527518-24461-4-git-send-email-msb@chromium.org>
 <4EF2C536.7070408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF2C536.7070408@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 01:50:46PM +0800, Li Zefan wrote:
> > @@ -2091,6 +2010,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  	 * rcu or tasklist locked. instead, build an array of all threads in the
> >  	 * group - group_rwsem prevents new threads from appearing, and if
> >  	 * threads exit, this will just be an over-estimate.
> > +	 *
> > +	 * While creating the list, also make sure css_sets exist for all
> > +	 * threads to be migrated. we use find_css_set, which allocates a new
> > +	 * one if necessary.
> >  	 */
> >  	group_size = get_nr_threads(leader);
> >  	/* flex_array supports very large thread-groups better than kmalloc. */
> > @@ -2137,6 +2060,12 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  		/* nothing to do if this task is already in the cgroup */
> >  		if (ent.cgrp == cgrp)
> >  			continue;
> > +		ent.cg = find_css_set(tsk->cgroups, cgrp);
> 
> unfortunately This won't work, because we are holding tasklist_lock.

I believe we can remove tasklist_lock now (in a seperate patch).

It was there in order to protect while_each_thread() against exec but
now we have threadgroup_lock().

I think we only need to use rcu_read_lock() to protect against concurrent
removal in exit.
 
> > +		if (!ent.cg) {
> > +			retval = -ENOMEM;
> > +			group_size = i;
> > +			goto out_list_teardown;
> > +		}
> >  		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
> >  		BUG_ON(retval != 0);
> >  		i++;
