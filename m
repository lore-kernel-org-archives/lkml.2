Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1LLOJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:09:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab1LLOJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:09:37 -0500
Date: Mon, 12 Dec 2011 15:09:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] memcg: clean up soft_limit_tree properly new
Message-ID: <20111212140935.GF14720@tiehlicka.suse.cz>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
 <alpine.LSU.2.00.1112111520510.2297@eggly>
 <20111212131118.GA15249@tiehlicka.suse.cz>
 <CAJd=RBAZT0zVnMm7i7P4J9Qg+LvTYh25RwFP7JZnN9dxwWp55g@mail.gmail.com>
 <20111212140750.GE14720@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212140750.GE14720@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a follow up patch for the proper clean up:
---
>From 4b9f5a1e88496af9f336d1ef37cfdf3754a3ba48 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 12 Dec 2011 15:04:18 +0100
Subject: [PATCH] memcg: clean up soft_limit_tree properly

If we are not able to allocate tree nodes for all NUMA nodes then we
should better clean up those that were allocated otherwise we will leak
a memory.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..838d812 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4874,7 +4874,7 @@ static int mem_cgroup_soft_limit_tree_init(void)
 			tmp = -1;
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
 		if (!rtpn)
-			return 1;
+			goto err_cleanup;
 
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 
@@ -4885,6 +4885,16 @@ static int mem_cgroup_soft_limit_tree_init(void)
 		}
 	}
 	return 0;
+
+err_cleanup:
+	for_each_node_state(node, N_POSSIBLE) {
+		if (!soft_limit_tree.rb_tree_per_node[node])
+			break;
+		kfree(soft_limit_tree.rb_tree_per_node[node]);
+		soft_limit_tree.rb_tree_per_node[node] = NULL;
+	}
+	return 1;
+
 }
 
 static struct cgroup_subsys_state * __ref
-- 
1.7.7.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
