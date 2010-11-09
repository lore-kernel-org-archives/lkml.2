Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0KIJZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:25:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0KIJZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:25:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=W/kyC/0stm0LoYDfbDaexM1hlKFZrXp3tkKlx6FB6gDoCV6D2eboCCJ7r1la0upSC
	ydA8ha+Qc5zCwYdgY6nFQ==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 5/6] memcg: simplify mem_cgroup_dirty_info()
Date: Tue,  9 Nov 2010 01:24:30 -0800
Message-Id: <1289294671-6865-6-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289294671-6865-1-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because mem_cgroup_page_stat() no longer returns negative numbers
to indicate failure, mem_cgroup_dirty_info() does not need to check
for such failures.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f8df350..ccdbb7e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1258,8 +1258,6 @@ bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 	__mem_cgroup_dirty_param(&dirty_param, memcg);
 
 	value = mem_cgroup_page_stat(memcg, MEMCG_NR_DIRTYABLE_PAGES);
-	if (value < 0)
-		goto done;
 
 	available_mem = min((unsigned long)value, sys_available_mem);
 
@@ -1279,15 +1277,9 @@ bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			(dirty_param.dirty_background_ratio *
 			       available_mem) / 100;
 
-	value = mem_cgroup_page_stat(memcg, MEMCG_NR_RECLAIM_PAGES);
-	if (value < 0)
-		goto done;
-	info->nr_reclaimable = value;
-
-	value = mem_cgroup_page_stat(memcg, MEMCG_NR_WRITEBACK);
-	if (value < 0)
-		goto done;
-	info->nr_writeback = value;
+	info->nr_reclaimable =
+		mem_cgroup_page_stat(memcg, MEMCG_NR_RECLAIM_PAGES);
+	info->nr_writeback = mem_cgroup_page_stat(memcg, MEMCG_NR_WRITEBACK);
 
 	valid = true;
 
-- 
1.7.3.1

