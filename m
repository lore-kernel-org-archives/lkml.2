Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2IUUW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:22:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63206 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab2IUUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:22:24 -0400
Date: Fri, 21 Sep 2012 13:22:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 11/16] memcg: destroy memcg caches
Message-ID: <20120921202220.GO7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-12-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977530-29755-12-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:12:05PM +0400, Glauber Costa wrote:
> +static LIST_HEAD(destroyed_caches);
> +
> +static void kmem_cache_destroy_work_func(struct work_struct *w)
> +{
> +	struct kmem_cache *cachep;
> +	struct mem_cgroup_cache_params *p, *tmp;
> +	unsigned long flags;
> +	LIST_HEAD(del_unlocked);
> +
> +	spin_lock_irqsave(&cache_queue_lock, flags);
> +	list_for_each_entry_safe(p, tmp, &destroyed_caches, destroyed_list) {
> +		cachep = container_of(p, struct kmem_cache, memcg_params);
> +		list_move(&cachep->memcg_params.destroyed_list, &del_unlocked);
> +	}
> +	spin_unlock_irqrestore(&cache_queue_lock, flags);
> +
> +	list_for_each_entry_safe(p, tmp, &del_unlocked, destroyed_list) {
> +		cachep = container_of(p, struct kmem_cache, memcg_params);
> +		list_del(&cachep->memcg_params.destroyed_list);
> +		if (!atomic_read(&cachep->memcg_params.nr_pages)) {
> +			mem_cgroup_put(cachep->memcg_params.memcg);
> +			kmem_cache_destroy(cachep);
> +		}
> +	}
> +}
> +static DECLARE_WORK(kmem_cache_destroy_work, kmem_cache_destroy_work_func);

Again, please don't build your own worklist.  Just embed a work item
into mem_cgroup_cache_params and manipulate them.  No need to
duplicate what workqueue already implements.

Thanks.

-- 
tejun
