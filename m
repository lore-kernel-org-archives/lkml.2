Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2BWNvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:51:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2BWNvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:51:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.156.219 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v3 02/21] memcg: make mm_match_cgroup() hirarchical
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 17:51:46 +0400
Message-ID: <20120223135146.12988.47611.stgit@zurg>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check mm-owner cgroup membership hierarchically.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/memcontrol.h |   11 ++---------
 mm/memcontrol.c            |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8c4d74f..4822d53 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -87,15 +87,8 @@ extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);
 extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
 
-static inline
-int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
-{
-	struct mem_cgroup *memcg;
-	rcu_read_lock();
-	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
-	rcu_read_unlock();
-	return cgroup == memcg;
-}
+extern int mm_match_cgroup(const struct mm_struct *mm,
+			   const struct mem_cgroup *cgroup);
 
 extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8039d2..77f5d48 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -821,6 +821,26 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 				struct mem_cgroup, css);
 }
 
+/**
+ * mm_match_cgroup - cgroup hierarchy mm membership test
+ * @mm		mm_struct to test
+ * @cgroup	target cgroup
+ *
+ * Returns true if mm belong this cgroup or any its child in hierarchy
+ */
+int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	while (memcg != cgroup && memcg && memcg->use_hierarchy)
+		memcg = parent_mem_cgroup(memcg);
+	rcu_read_unlock();
+
+	return cgroup == memcg;
+}
+
 struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;

