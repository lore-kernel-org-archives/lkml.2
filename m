Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1LSHyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 02:54:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53571 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1LSHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 02:54:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 19 Dec 2011 16:51:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [PATCH] memcg: reset to root_mem_cgroup at bypassing
Message-Id: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d620ff605a3a592c2b1de3a046498ce5cd3d3c50 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 19 Dec 2011 16:55:10 +0900
Subject: [PATCH 2/2] memcg: reset lru to root_mem_cgroup in special cases.

This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patch

After the patch, all pages which will be onto LRU must have sane
pc->mem_cgroup. But, in special case, it's not set.

If task->mm is NULL or task is TIF_MEMDIE or fatal_signal_pending(),
try_charge() is bypassed and the new charge will not be charged. And
pc->mem_cgroup is unset even if the page will be used/mapped and added
to LRU. To avoid this,  this patch charges such pages to root_mem_cgroup,
then, pc->mem_cgroup will be handled correctly.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d6d21c..9268e8e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2324,7 +2324,7 @@ nomem:
 	*ptr = NULL;
 	return -ENOMEM;
 bypass:
-	*ptr = NULL;
+	*ptr = root_mem_cgroup;
 	return 0;
 }
 
-- 
1.7.4.1


