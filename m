Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2KFKyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:54:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58359 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KFKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:54:29 -0500
Date: Tue, 6 Nov 2012 11:54:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 11/29] memcg: allow a memcg with kmem charges to be
 destructed.
Message-ID: <20121106105426.GE21167@dhcp22.suse.cz>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
 <1351771665-11076-12-git-send-email-glommer@parallels.com>
 <20121101170539.2e09dc8e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101170539.2e09dc8e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-11-12 17:05:39, Andrew Morton wrote:
> On Thu,  1 Nov 2012 16:07:27 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
> > Because the ultimate goal of the kmem tracking in memcg is to track slab
> > pages as well, we can't guarantee that we'll always be able to point a
> > page to a particular process, and migrate the charges along with it -
> > since in the common case, a page will contain data belonging to multiple
> > processes.
> > 
> > Because of that, when we destroy a memcg, we only make sure the
> > destruction will succeed by discounting the kmem charges from the user
> > charges when we try to empty the cgroup.
> 
> There was a significant conflict with the sched/numa changes in
> linux-next,

Just for record. The conflict was introduced by 2ef37d3f (memcg: Simplify
mem_cgroup_force_empty_list error handling) which came in via Tejun's
tree.
Your resolution looks good to me. Sorry about the trouble.

> which I resolved as below.  Please check it.
> 
> static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
> {
> 	struct cgroup *cgrp = memcg->css.cgroup;
> 	int node, zid;
> 	u64 usage;
> 
> 	do {
> 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
> 			return -EBUSY;
> 		/* This is for making all *used* pages to be on LRU. */
> 		lru_add_drain_all();
> 		drain_all_stock_sync(memcg);
> 		mem_cgroup_start_move(memcg);
> 		for_each_node_state(node, N_HIGH_MEMORY) {
> 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
> 				enum lru_list lru;
> 				for_each_lru(lru) {
> 					mem_cgroup_force_empty_list(memcg,
> 							node, zid, lru);
> 				}
> 			}
> 		}
> 		mem_cgroup_end_move(memcg);
> 		memcg_oom_recover(memcg);
> 		cond_resched();
> 
> 		/*
> 		 * Kernel memory may not necessarily be trackable to a specific
> 		 * process. So they are not migrated, and therefore we can't
> 		 * expect their value to drop to 0 here.
> 		 * Having res filled up with kmem only is enough.
> 		 *
> 		 * This is a safety check because mem_cgroup_force_empty_list
> 		 * could have raced with mem_cgroup_replace_page_cache callers
> 		 * so the lru seemed empty but the page could have been added
> 		 * right after the check. RES_USAGE should be safe as we always
> 		 * charge before adding to the LRU.
> 		 */
> 		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
> 			res_counter_read_u64(&memcg->kmem, RES_USAGE);
> 	} while (usage > 0);
> 
> 	return 0;
> }
> 

-- 
Michal Hocko
SUSE Labs
