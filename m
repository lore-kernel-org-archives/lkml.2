Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750817Ab2F0EBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:01:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42719 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2F0EBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:01:35 -0400
Date: Tue, 26 Jun 2012 21:01:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
In-Reply-To: <4FE97E31.3010201@parallels.com>
Message-ID: <alpine.DEB.2.00.1206262100320.24245@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206260210200.16020@chino.kir.corp.google.com> <4FE97E31.3010201@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > @@ -416,6 +423,43 @@ static inline void sock_update_memcg(struct sock *sk)
> > >   static inline void sock_release_memcg(struct sock *sk)
> > >   {
> > >   }
> > > +
> > > +#define mem_cgroup_kmem_on 0
> > > +#define __mem_cgroup_new_kmem_page(a, b, c) false
> > > +#define __mem_cgroup_free_kmem_page(a,b )
> > > +#define __mem_cgroup_commit_kmem_page(a, b, c)
> > > +#define is_kmem_tracked_alloc (false)
> > >   #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> > > +
> > > +static __always_inline
> > > +bool mem_cgroup_new_kmem_page(gfp_t gfp, void *handle, int order)
> > > +{
> > > +	if (!mem_cgroup_kmem_on)
> > > +		return true;
> > > +	if (!is_kmem_tracked_alloc)
> > > +		return true;
> > > +	if (!current->mm)
> > > +		return true;
> > > +	if (in_interrupt())
> > > +		return true;
> > 
> > You can't test for current->mm in irq context, so you need to check for
> > in_interrupt() first.
> >
> Right, thanks.
> 
> > Also, what prevents __mem_cgroup_new_kmem_page()
> > from being called for a kthread that has called use_mm() before
> > unuse_mm()?
> 
> Nothing, but I also don't see how to prevent that.

You can test for current->flags & PF_KTHREAD following the check for 
in_interrupt() and return true, it's what you were trying to do with the 
check for !current->mm.
