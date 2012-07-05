Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2GEK4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:56:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51720 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2GEK4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:56:01 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: return -EBUSY when oom-kill-disable modified and memcg use_hierarchy, has children
Date: Thu,  5 Jul 2012 18:55:08 +0800
Message-Id: <1341485708-14221-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

When oom-kill-disable modified by the user and current memcg use_hierarchy,
the change can occur, provided the current memcg has no children. If it
has children, return -EBUSY is enough.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63e36e7..4b64fe0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4521,11 +4521,14 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
 
 	cgroup_lock();
 	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) ||
-	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
+	if (parent->use_hierarchy) {
 		cgroup_unlock();
 		return -EINVAL;
+	} else if (memcg->use_hierarchy && !list_empty(&cgrp->children)) {
+		cgroup_unlock();
+		return -EBUSY;
 	}
+
 	memcg->oom_kill_disable = val;
 	if (!val)
 		memcg_oom_recover(memcg);
-- 
1.7.5.4

