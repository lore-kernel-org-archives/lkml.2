Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1KYRlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:41:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3618 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1KYRlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:41:16 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v6 10/10] Disable task moving when using kernel memory accounting
Date: Fri, 25 Nov 2011 15:38:16 -0200
Message-Id: <1322242696-27682-11-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322242696-27682-1-git-send-email-glommer@parallels.com>
References: <1322242696-27682-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this code is still experimental, we are leaving the exact
details of how to move tasks between cgroups when kernel memory
accounting is used as future work.

For now, we simply disallow movement if there are any pending
accounted memory.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2df5d3c..ab7e57b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5451,10 +5451,19 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 {
 	int ret = 0;
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
+	struct mem_cgroup *from = mem_cgroup_from_task(p);
+
+#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_INET)
+	if (from != mem && !mem_cgroup_is_root(from) &&
+	    res_counter_read_u64(&from->tcp_mem.tcp_memory_allocated, RES_USAGE)) {
+		printk(KERN_WARNING "Can't move tasks between cgroups: "
+			"Kernel memory held. task: %s\n", p->comm);
+		return 1;
+	}
+#endif
 
 	if (mem->move_charge_at_immigrate) {
 		struct mm_struct *mm;
-		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
 		VM_BUG_ON(from == mem);
 
@@ -5622,6 +5631,18 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
 				struct task_struct *p)
 {
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
+	struct mem_cgroup *from = mem_cgroup_from_task(p);
+
+#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_INET)
+	if (from != mem && !mem_cgroup_is_root(from) &&
+	    res_counter_read_u64(&from->tcp_mem.tcp_memory_allocated, RES_USAGE)) {
+		printk(KERN_WARNING "Can't move tasks between cgroups: "
+			"Kernel memory held. task: %s\n", p->comm);
+		return 1;
+	}
+#endif
+
 	return 0;
 }
 static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
-- 
1.7.6.4

