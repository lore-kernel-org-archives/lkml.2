Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2E3NLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:11:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61443 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2E3NLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:11:08 -0400
Date: Wed, 30 May 2012 15:11:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Message-ID: <20120530131059.GE25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
 <20120530123406.GC25094@somewhere.redhat.com>
 <4FC614CF.5000906@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC614CF.5000906@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:38:39PM +0400, Glauber Costa wrote:
> On 05/30/2012 04:34 PM, Frederic Weisbecker wrote:
> >On Fri, May 25, 2012 at 05:03:36PM +0400, Glauber Costa wrote:
> >>+bool __mem_cgroup_new_kmem_page(struct page *page, gfp_t gfp)
> >>+{
> >>+	struct mem_cgroup *memcg;
> >>+	struct page_cgroup *pc;
> >>+	bool ret = true;
> >>+	size_t size;
> >>+	struct task_struct *p;
> >>+
> >>+	if (!current->mm || in_interrupt())
> >>+		return true;
> >>+
> >>+	rcu_read_lock();
> >>+	p = rcu_dereference(current->mm->owner);
> >>+	memcg = mem_cgroup_from_task(p);
> >
> >So this takes the memcg of the group owner rather than the
> >task? I understand why we want this for user memory, but for
> >kernel?
> 
> That was already discussed when this first came up in my last submission
> If I recall correctly, Kame pointed out that this would be needed
> for proper OOM-scoring and killing.

Can we have at least a comment in the code that explain the reasons of taking the
owner rather than the task? It's not going to be very obvious to future reviewers.

> Now of course we won't oom kernel threads or anything like that.

Seems we are not even accounting them anyway.

> But since this is also accounted towards memcg, it should at least be
> consistent with each memcg it accounts to.
> 
> We can't account kmem for the thread's memcg, and mem to the process'.

Don't know. This goes a bit against cgroups semantics which group at the task
level and not process. But I personally don't mind much, as long as it's
documented.
