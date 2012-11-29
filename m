Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2K2O04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:26:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35233 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2K2O0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:26:54 -0500
Date: Thu, 29 Nov 2012 06:26:46 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, paul@paulmenage.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121129142646.GD24683@htj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <50B743A1.4040405@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B743A1.4040405@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Nov 29, 2012 at 03:14:41PM +0400, Glauber Costa wrote:
> On 11/29/2012 01:34 AM, Tejun Heo wrote:
> > This patchset decouples cpuset locking from cgroup_mutex.  After the
> > patchset, cpuset uses cpuset-specific cpuset_mutex instead of
> > cgroup_mutex.  This also removes the lockdep warning triggered during
> > cpu offlining (see 0009).
> > 
> > Note that this leaves memcg as the only external user of cgroup_mutex.
> > Michal, Kame, can you guys please convert memcg to use its own locking
> > too?
> 
> Not totally. There is still one mention to the cgroup_lock():
> 
> static void cpuset_do_move_task(struct task_struct *tsk,
>                                 struct cgroup_scanner *scan)
> {
>         struct cgroup *new_cgroup = scan->data;
> 
>         cgroup_lock();
>         cgroup_attach_task(new_cgroup, tsk);
>         cgroup_unlock();
> }

Which is outside all other locks and scheduled to be moved inside
cgroup_attach_task().

> And similar problem to this, is the one we have in memcg: We need to
> somehow guarantee that no tasks will join the cgroup for some time -
> this is why we hold the lock in memcg.
> 
> Just calling a function that internally calls the cgroup lock won't do
> much, since it won't solve any dependencies - where it is called matters
> little.

The dependency is already solved in cpuset.

> What I'll try to do, is to come with another specialized lock in cgroup
> just for this case. So after taking the cgroup lock, we would also take
> an extra lock if we are adding another entry - be it task or children -
> to the cgroup.

No, please don't do that.  Just don't invoke cgroup operation inside
any subsystem lock.

Thanks.

-- 
tejun
