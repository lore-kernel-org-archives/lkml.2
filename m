Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2GWD1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 23:27:55 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42868 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2GWD1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 23:27:54 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWAHiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] memcg: fix mm/memcontrol.c build error against linux-next
Date: Mon, 23 Jul 2012 11:27:34 +0800
Message-Id: <1343014054-30929-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12072303-2000-0000-0000-0000085DE83D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Fengguang Wu reported, linux-next failed to build with 

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
head:   37e2ad4953983527f7bdb6831bf478eedcc84082
commit: 442d53f161093de78f0aafcd3ec2a6345de42890 [164/309] memcg: add mem_cgroup_from_css() helper

mem_cgroup_from_css() is defined inside CONFIG_MEMCG_KMEM and used
outside of it, move mem_cgroup_from_css() out of the #ifdef 
CONFIG_MEMCG_KMEM can address this issue.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

---
 mm/memcontrol.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 439190b..994e353 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -405,17 +405,17 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
-/* Writing them here to avoid exposing memcg's inner layout */
-#ifdef CONFIG_MEMCG_KMEM
-#include <net/sock.h>
-#include <net/ip.h>
-
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
 {
 	return container_of(s, struct mem_cgroup, css);
 }
 
+/* Writing them here to avoid exposing memcg's inner layout */
+#ifdef CONFIG_MEMCG_KMEM
+#include <net/sock.h>
+#include <net/ip.h>
+
 static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
 void sock_update_memcg(struct sock *sk)
 {
-- 
1.7.7.6

