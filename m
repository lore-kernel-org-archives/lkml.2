Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab2DXUVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:21:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65440 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2DXUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:21:47 -0400
Date: Tue, 24 Apr 2012 13:21:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, devel@openvz.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
In-Reply-To: <20120424142232.GC8626@somewhere>
Message-ID: <alpine.DEB.2.00.1204241319360.753@chino.kir.corp.google.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Frederic Weisbecker wrote:

> > This seems horribly inconsistent with memcg charging of user memory since 
> > it charges to p->mm->owner and you're charging to p.  So a thread attached 
> > to a memcg can charge user memory to one memcg while charging slab to 
> > another memcg?
> 
> Charging to the thread rather than the process seem to me the right behaviour:
> you can have two threads of a same process attached to different cgroups.
> 
> Perhaps it is the user memory memcg that needs to be fixed?
> 

No, because memory is represented by mm_struct, not task_struct, so you 
must charge to p->mm->owner to allow for moving threads amongst memcgs 
later for memory.move_charge_at_immigrate.  You shouldn't be able to 
charge two different memcgs for memory represented by a single mm.

> > > +
> > > +	if (!mem_cgroup_kmem_enabled(memcg))
> > > +		goto out;
> > > +
> > > +	mem_cgroup_get(memcg);
> > > +	ret = memcg_charge_kmem(memcg, gfp, size) == 0;
> > > +	if (ret)
> > > +		mem_cgroup_put(memcg);
> > > +out:
> > > +	rcu_read_unlock();
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL(__mem_cgroup_charge_kmem);
> > > +
> > > +void __mem_cgroup_uncharge_kmem(size_t size)
> > > +{
> > > +	struct mem_cgroup *memcg;
> > > +
> > > +	rcu_read_lock();
> > > +	memcg = mem_cgroup_from_task(current);
> > > +
> > > +	if (!mem_cgroup_kmem_enabled(memcg))
> > > +		goto out;
> > > +
> > > +	mem_cgroup_put(memcg);
> > > +	memcg_uncharge_kmem(memcg, size);
> > > +out:
> > > +	rcu_read_unlock();
> > > +}
> > > +EXPORT_SYMBOL(__mem_cgroup_uncharge_kmem);
