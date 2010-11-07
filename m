Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0KGWPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:15:41 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:45349 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0KGWPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:15:10 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/4] memcg: catch negative per-cpu sums in dirty info
Date: Sun,  7 Nov 2010 23:14:37 +0100
Message-Id: <20101107220353.414283590@cmpxchg.org>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101107215030.007259800@cmpxchg.org>
References: <20101107215030.007259800@cmpxchg.org>
User-Agent: quilt/0.48-1
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com> <20101106010357.GD23393@cmpxchg.org> <AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com> <20101107215030.007259800@cmpxchg.org>
Content-Disposition: inline; filename=memcg-catch-negative-per-cpu-sums-in-dirty-info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folding the per-cpu counters can yield a negative value in case of
accounting races between CPUs.

When collecting the dirty info, the code would read those sums into an
unsigned variable and then check for it being negative, which can not
work.

Instead, fold the counters into a signed local variable, make the
check, and only then assign it.

This way, the function signals correctly when there are insane values
instead of leaking them out to the caller.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1261,14 +1261,15 @@ bool mem_cgroup_dirty_info(unsigned long
 			(dirty_param.dirty_background_ratio *
 			       available_mem) / 100;
 
-	info->nr_reclaimable =
-		mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
-	if (info->nr_reclaimable < 0)
+	value = mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
+	if (value < 0)
 		return false;
+	info->nr_reclaimable = value;
 
-	info->nr_writeback = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
-	if (info->nr_writeback < 0)
+	value = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
+	if (value < 0)
 		return false;
+	info->nr_writeback = value;
 
 	return true;
 }


