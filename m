Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2HWOi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab2HWOix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:38:53 -0400
Date: Thu, 23 Aug 2012 16:38:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] fork: fix oops after fork failure
Message-ID: <20120823143850.GC19968@dhcp22.suse.cz>
References: <1345727326-18730-1-git-send-email-glommer@parallels.com>
 <20120823143312.GA23636@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823143312.GA23636@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-08-12 16:33:12, Michal Hocko wrote:
> On Thu 23-08-12 17:08:46, Glauber Costa wrote:
> > When we want to duplicate a new process, dup_task_struct() will undergo
> > a series of allocations. If alloc_thread_info_node() fails, we call
> > free_task_struct() and return.
> > 
> > This seems right, but it is not. free_task_struct() will not only free
> > the task struct from the kmem_cache, but will also call
> > arch_release_task_struct(). The problem is that this function is
> > supposed to undo whatever arch-specific work done by
> > arch_dup_task_struct(), that is not yet called at this point.  The
> > particular problem I ran accross was that in x86, we will arrive at
> > fpu_free() without having ever allocated it.
> > 
> > This code is very ancient, and according to git, it is there since the
> > pre-git era. But forks don't fail that often, so that made it well
> > hidden.
> > 
> > Signed-off-by: Glauber Costa <glommer@parallels.com>
> > Reported-by: Frederic Weisbecker <fweisbec@redhat.com>
> > ---
> >  kernel/fork.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 152d023..b397435 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -299,7 +299,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
> >  
> >  	ti = alloc_thread_info_node(tsk, node);
> >  	if (!ti) {
> > -		free_task_struct(tsk);
> > +		kmem_cache_free(task_struct_cachep, tsk);
> 
> What about ia64 (or !CONFIG_ARCH_THREAD_INFO_ALLOCATOR in general) which
> doesn't allocate thread_info at all?

Hit send button too fast. Should read (or CONFIG_ARCH_THREAD_INFO_ALLOCATOR)
ia64 will not fail obviously and there is no other arch which would
define own thread infor allocators but there might be some in future.
-- 
Michal Hocko
SUSE Labs
