Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2BFKNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:13:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36368 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2BFKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:13:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Feb 2012 19:11:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC] [PATCH 6/6] memcg: fix performance of
 mem_cgroup_begin_update_page_stat()
Message-Id: <20120206191141.e854b311.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4094b65b9c0a368a34b8c3d42df1ce0ebfa1edf8 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 6 Feb 2012 12:14:47 +0900
Subject: [PATCH 6/6] memcg: fix performance of mem_cgroup_begin_update_page_stat()

mem_cgroup_begin_update_page_stat() should be very fast because
it's called very frequently. Now, it needs to look up page_cgroup
and its memcg....this is slow.

This patch adds a global variable to check "a memcg is moving or not".
By this, the caller doesn't need to visit page_cgroup and memcg.
This makes performance quicker.

Here is a test result. A test program makes page faults onto a file,
MAP_SHARED and makes each page's page_mapcount(page) > 1, and free
the range by madvise() and page fault again.  This program causes
26214400 times of page fault onto a file(size was 1G.) and shows
shows the cost of mem_cgroup_begin_update_page_stat().
(please see 'sys' time and think error range is 0.2 - 0.4sec.)

Before the series of patch (linux-next Feb/06)
[kamezawa@bluextal test]$ time ./mmap 1G

real    0m23.534s
user    0m5.949s
sys     0m17.563s

After the patch for mem_cgroup_begin_update_page_stat()
[kamezawa@bluextal test]$ time ./mmap 1G

real    0m24.268s
user    0m6.059s
sys     0m18.187s

After this patch
[kamezawa@bluextal test]$ time ./mmap 1G

real    0m23.094s
user    0m6.045s
sys     0m17.030s

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |    6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

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
index eedabee..322e381 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1273,16 +1273,20 @@ int mem_cgroup_swappiness(struct mem_cgroup *memcg)
  *         start move here.
  */
 
+atomic_t memcg_moving __read_mostly;
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
+	atomic_inc(&memcg_moving);
 	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
 
 static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 {
-	if (memcg)
+	if (memcg) {
 		atomic_dec(&memcg->moving_account);
+		atomic_dec(&memcg_moving);
+	}
 }
 /*
  * 2 routines for checking "mem" is under move_account() or not.
-- 
1.7.4.1


