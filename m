Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2KILJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:09:44 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:38797 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2KILJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:09:41 -0500
Message-ID: <509CE472.9040504@monom.org>
Date: Fri, 09 Nov 2012 12:09:38 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org> <20121108190715.GD9672@htj.dyndns.org>
In-Reply-To: <20121108190715.GD9672@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08.11.2012 20:07, Tejun Heo wrote:> Subject: cgroup: add 
cgroup_subsys->post_create()
 >
 > Currently, there's no way for a controller to find out whether a new
 > cgroup finished all ->create() allocatinos successfully and is
 > considered "live" by cgroup.

I'd like add hierarchy support to net_prio and the first thing to
do is to get rid of get_prioidx(). It looks like it would be nice to be 
able to use use_id and post_create() for this but as I read the code 
this might not work because the netdev might access resources allocated 
between create() and post_create(). So my question is would it make 
sense to move

cgroup_create():

		if (ss->use_id) {
			err = alloc_css_id(ss, parent, cgrp);
			if (err)
				goto err_destroy;
		}

part before create() or add some protection between create() and 
post_create() callback in net_prio. I have a patch but I see
I could drop it completely if post_create() is there.

cheers,
daniel


 From 84fbbdf0dc5d3460389e39a00a3ee553ee55b563 Mon Sep 17 00:00:00 2001
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Date: Thu, 8 Nov 2012 17:17:21 +0100
Subject: [PATCH] cgroups: net_prio: Use IDR library to assign netprio index

get_prioidx() allocated a new id whenever it was called. put_prioidx()
gave an id back. get_pioidx() could can reallocate the id later on.
So that is exactly what IDR offers and so let's use it.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
  net/core/netprio_cgroup.c | 51 
+++++++++--------------------------------------
  1 file changed, 9 insertions(+), 42 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 847c02b..3c1b612 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -27,10 +27,7 @@

  #include <linux/fdtable.h>

-#define PRIOIDX_SZ 128
-
-static unsigned long prioidx_map[PRIOIDX_SZ];
-static DEFINE_SPINLOCK(prioidx_map_lock);
+static DEFINE_IDA(netprio_ida);
  static atomic_t max_prioidx = ATOMIC_INIT(0);

  static inline struct cgroup_netprio_state *cgrp_netprio_state(struct 
cgroup *cgrp)
@@ -39,34 +36,6 @@ static inline struct cgroup_netprio_state 
*cgrp_netprio_state(struct cgroup *cgr
  			    struct cgroup_netprio_state, css);
  }

-static int get_prioidx(u32 *prio)
-{
-	unsigned long flags;
-	u32 prioidx;
-
-	spin_lock_irqsave(&prioidx_map_lock, flags);
-	prioidx = find_first_zero_bit(prioidx_map, sizeof(unsigned long) * 
PRIOIDX_SZ);
-	if (prioidx == sizeof(unsigned long) * PRIOIDX_SZ) {
-		spin_unlock_irqrestore(&prioidx_map_lock, flags);
-		return -ENOSPC;
-	}
-	set_bit(prioidx, prioidx_map);
-	if (atomic_read(&max_prioidx) < prioidx)
-		atomic_set(&max_prioidx, prioidx);
-	spin_unlock_irqrestore(&prioidx_map_lock, flags);
-	*prio = prioidx;
-	return 0;
-}
-
-static void put_prioidx(u32 idx)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&prioidx_map_lock, flags);
-	clear_bit(idx, prioidx_map);
-	spin_unlock_irqrestore(&prioidx_map_lock, flags);
-}
-
  static int extend_netdev_table(struct net_device *dev, u32 new_len)
  {
  	size_t new_size = sizeof(struct netprio_map) +
@@ -120,9 +89,9 @@ static struct cgroup_subsys_state *cgrp_create(struct 
cgroup *cgrp)
  	if (cgrp->parent && cgrp_netprio_state(cgrp->parent)->prioidx)
  		goto out;

-	ret = get_prioidx(&cs->prioidx);
-	if (ret < 0) {
-		pr_warn("No space in priority index array\n");
+	cs->prioidx = ida_simple_get(&netprio_ida, 0, 0, GFP_KERNEL);
+	if (cs->prioidx < 0) {
+		ret = cs->prioidx;
  		goto out;
  	}

@@ -146,7 +115,7 @@ static void cgrp_destroy(struct cgroup *cgrp)
  			map->priomap[cs->prioidx] = 0;
  	}
  	rtnl_unlock();
-	put_prioidx(cs->prioidx);
+	ida_simple_remove(&netprio_ida, cs->prioidx);
  	kfree(cs);
  }

@@ -284,12 +253,10 @@ struct cgroup_subsys net_prio_subsys = {
  	.module		= THIS_MODULE,

  	/*
-	 * net_prio has artificial limit on the number of cgroups and
-	 * disallows nesting making it impossible to co-mount it with other
-	 * hierarchical subsystems.  Remove the artificially low PRIOIDX_SZ
-	 * limit and properly nest configuration such that children follow
-	 * their parents' configurations by default and are allowed to
-	 * override and remove the following.
+	 * net_prio has artificial limit on properly nest
+	 * configuration such that children follow their parents'
+	 * configurations by default and are allowed to override and
+	 * remove the following.
  	 */
  	.broken_hierarchy = true,
  };
-- 
1.7.11.7


