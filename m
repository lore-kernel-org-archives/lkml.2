Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2BNDR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:17:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38418 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2BNDRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:17:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 12:16:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 6/6 v4] memcg: fix performance of
 mem_cgroup_begin_update_page_stat()
Message-Id: <20120214121631.782352f2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3377fd7b6e23a5d2a368c078eae27e2b49c4f4aa Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 6 Feb 2012 12:14:47 +0900
Subject: [PATCH 6/6] memcg: fix performance of mem_cgroup_begin_update_page_stat()

mem_cgroup_begin_update_page_stat() should be very fast because
it's called very frequently. Now, it needs to look up page_cgroup
and its memcg....this is slow.

This patch adds a global variable to check "a memcg is moving or not".
By this, the caller doesn't need to visit page_cgroup and memcg.

Here is a test result. A test program makes page faults onto a file,
MAP_SHARED and makes each page's page_mapcount(page) > 1, and free
the range by madvise() and page fault again.  This program causes
26214400 times of page fault onto a file(size was 1G.) and shows
shows the cost of mem_cgroup_begin_update_page_stat().

Before this patch for mem_cgroup_begin_update_page_stat()
[kamezawa@bluextal test]$ time ./mmap 1G

real    0m21.765s
user    0m5.999s
sys     0m15.434s

    27.46%     mmap  mmap               [.] reader
    21.15%     mmap  [kernel.kallsyms]  [k] page_fault
     9.17%     mmap  [kernel.kallsyms]  [k] filemap_fault
     2.96%     mmap  [kernel.kallsyms]  [k] __do_fault
     2.83%     mmap  [kernel.kallsyms]  [k] __mem_cgroup_begin_update_page_stat

After this patch
[root@bluextal test]# time ./mmap 1G

real    0m21.373s
user    0m6.113s
sys     0m15.016s

In usual path, calls to __mem_cgroup_begin_update_page_stat() goes away.

Note: we may be able to remove this optimization in future if
      we can get pointer to memcg directly from struct page.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |    7 ++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3f3ef33..3df9979 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -143,7 +143,7 @@ static inline bool mem_cgroup_disabled(void)
 
 void __mem_cgroup_begin_update_page_stat(struct page *page,
 					bool *lock, unsigned long *flags);
-
+extern atomic_t memcg_moving;
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 					bool *lock, unsigned long *flags)
 {
@@ -151,7 +151,8 @@ static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 		return;
 	rcu_read_lock();
 	*lock = false;
-	return __mem_cgroup_begin_update_page_stat(page, lock, flags);
+	if (atomic_read(&memcg_moving))
+		return __mem_cgroup_begin_update_page_stat(page, lock, flags);
 }
 
 void __mem_cgroup_end_update_page_stat(struct page *page, bool *lock,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec55880..fd02fab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1273,8 +1273,11 @@ int mem_cgroup_swappiness(struct mem_cgroup *memcg)
  *         start move here.
  */
 
+/* for quick checking without looking up memcg */
+atomic_t memcg_moving __read_mostly;
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
+	atomic_inc(&memcg_moving);
 	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
@@ -1285,8 +1288,10 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
 	 * We check NULL in callee rather than caller.
 	 */
-	if (memcg)
+	if (memcg) {
+		atomic_dec(&memcg_moving);
 		atomic_dec(&memcg->moving_account);
+	}
 }
 
 /*
-- 
1.7.4.1


