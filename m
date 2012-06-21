Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2FUX3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:29:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39174 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886Ab2FUX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:29:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE3ADDD.9060908@jp.fujitsu.com>
Date: Fri, 22 Jun 2012 08:27:25 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
References: <4FACDED0.3020400@jp.fujitsu.com> <20120621202043.GD4642@google.com>
In-Reply-To: <20120621202043.GD4642@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




(2012/06/22 5:20), Tejun Heo wrote:
> On Fri, May 11, 2012 at 06:41:36PM +0900, KAMEZAWA Hiroyuki wrote:
>> Hi, here is v3 based on memcg-devel tree.
>> git://github.com/mstsxfx/memcg-devel.git
>>
>> This patch series is for avoiding -ENOMEM at calling pre_destroy()
>> which is called at rmdir(). After this patch, charges will be moved
>> to root (if use_hierarchy==0) or parent (if use_hierarchy==1), and
>> we'll not see -ENOMEM in rmdir() of cgroup.
>>
>> v2 included some other patches than ones for handling -ENOMEM problem,
>> but I divided it. I'd like to post others in different series, later.
>> No logical changes in general, maybe v3 is cleaner than v2.
>>
>> 0001 ....fix error code in memcg-hugetlb
>> 0002 ....add res_counter_uncharge_until
>> 0003 ....use res_counter_uncharge_until in memcg
>> 0004 ....move charges to root is use_hierarchy==0
>> 0005 ....cleanup for mem_cgroup_move_account()
>> 0006 ....remove warning of res_counter_uncharge_nofail (from Costa's slub accounting series).
>
> KAME, how is this progressing?  Is it stuck on anything?
>

I think I finished 80% of works and patches are in -mm stack now.
They'll be visible in -next, soon.

Remaining 20% of work is based on a modification to cgroup layer

How do you think this patch ? (This patch is not tested yet...so
may have troubles...) I think callers of pre_destory() is not so many...

==
 From a28db946f91f3509d25779e8c5db249506cc4b07 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 22 Jun 2012 08:38:38 +0900
Subject: [PATCH] cgroup: keep cgroup_mutex() while calling ->pre_destroy()

In past, memcg's pre_destroy() was verrry slow because of the possibility
of page reclaiming in it. So, cgroup_mutex() was released before calling
pre_destroy() callbacks. Now, it's enough fast. memcg just scans the list
and move pages to other cgroup, no memory reclaim happens.
Then, we can keep cgroup_mutex() there.

By holding looks, we can avoid following cases
    1. new task is attached while rmdir().
    2. new child cgroup is created while rmdir()
    3. new task is attached to cgroup and removed from cgroup before
       checking css's count. So, ->destroy() will be called even if
       some trashes by the task remains

(3. is terrible case...even if I think it will not happen in real world..)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
  kernel/cgroup.c |    3 +--
  1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index caff6a1..a5b6df1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4171,7 +4171,6 @@ again:
  		mutex_unlock(&cgroup_mutex);
  		return -EBUSY;
  	}
-	mutex_unlock(&cgroup_mutex);
  
  	/*
  	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4190,11 +4189,11 @@ again:
  	 */
  	ret = cgroup_call_pre_destroy(cgrp);
  	if (ret) {
+		mutex_unlock(&cgroup_mutex);
  		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
  		return ret;
  	}
  
-	mutex_lock(&cgroup_mutex);
  	parent = cgrp->parent;
  	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
  		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
-- 
1.7.4.1













