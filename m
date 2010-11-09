Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0KIJZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:25:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0KIJZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:25:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=MTohIZV60amfLBMLrryBmUJra7u7JZqPny78QgyqXJ4zWvHiTpU9GOWz2x9ND83UM
	e8KWqdNgzmo8DLTIR9pBQ==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 6/6] memcg: make mem_cgroup_page_stat() return value unsigned
Date: Tue,  9 Nov 2010 01:24:31 -0800
Message-Id: <1289294671-6865-7-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289294671-6865-1-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_page_stat() used to return a negative page count
value to indicate value.

mem_cgroup_page_stat() has changed so it never returns
error so convert the return value to the traditional page
count type (unsigned long).

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 include/linux/memcontrol.h |    6 +++---
 mm/memcontrol.c            |   12 ++++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a81dfda..3433784 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -158,8 +158,8 @@ bool mem_cgroup_has_dirty_limit(void);
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			   struct mem_cgroup *memcg,
 			   struct dirty_info *info);
-long mem_cgroup_page_stat(struct mem_cgroup *mem,
-			  enum mem_cgroup_nr_pages_item item);
+unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
+				   enum mem_cgroup_nr_pages_item item);
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
@@ -354,7 +354,7 @@ static inline bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 	return false;
 }
 
-static inline long mem_cgroup_page_stat(struct mem_cgroup *mem,
+static inline unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
 					enum mem_cgroup_nr_pages_item item)
 {
 	return -ENOSYS;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ccdbb7e..ed070d0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1361,8 +1361,8 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
  *
  * Return the accounted statistic value.
  */
-long mem_cgroup_page_stat(struct mem_cgroup *mem,
-			  enum mem_cgroup_nr_pages_item item)
+unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
+				   enum mem_cgroup_nr_pages_item item)
 {
 	struct mem_cgroup *iter;
 	long value;
@@ -1388,6 +1388,14 @@ long mem_cgroup_page_stat(struct mem_cgroup *mem,
 	for_each_mem_cgroup_tree(iter, mem)
 		value += mem_cgroup_local_page_stat(iter, item);
 
+	/*
+	 * The sum of unlocked per-cpu counters may yield a slightly negative
+	 * value.  This function returns an unsigned value, so round it up to
+	 * zero to avoid returning a very large value.
+	 */
+	if (value < 0)
+		value = 0;
+
 	put_online_cpus();
 
 	return value;
-- 
1.7.3.1

