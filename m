Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1JJK0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:26:20 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48651 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab1JJK0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:26:16 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH v6 8/8] Disable task moving when using kernel memory accounting
Date: Mon, 10 Oct 2011 14:24:28 +0400
Message-Id: <1318242268-2234-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318242268-2234-1-git-send-email-glommer@parallels.com>
References: <1318242268-2234-1-git-send-email-glommer@parallels.com>
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
 mm/memcontrol.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ca08be2..8d1beeb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -408,23 +408,11 @@ void sock_update_memcg(struct sock *sk)
 
 	rcu_read_lock();
 	sk->sk_cgrp = mem_cgroup_from_task(current);
-
-	/*
-	 * We don't need to protect against anything task-related, because
-	 * we are basically stuck with the sock pointer that won't change,
-	 * even if the task that originated the socket changes cgroups.
-	 *
-	 * What we do have to guarantee, is that the chain leading us to
-	 * the top level won't change under our noses. Incrementing the
-	 * reference count via cgroup_exclude_rmdir guarantees that.
-	 */
-	cgroup_exclude_rmdir(mem_cgroup_css(sk->sk_cgrp));
 	rcu_read_unlock();
 }
 
 void sock_release_memcg(struct sock *sk)
 {
-	cgroup_release_and_wakeup_rmdir(mem_cgroup_css(sk->sk_cgrp));
 }
 
 void memcg_sockets_allocated_dec(struct mem_cgroup *memcg, struct proto *prot)
@@ -5636,10 +5624,17 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 {
 	int ret = 0;
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
+	struct mem_cgroup *from = mem_cgroup_from_task(p);
+
+	if (from != mem &&
+	    res_counter_read_u64(&mem->tcp.tcp_memory_allocated, RES_USAGE)) {
+		printk(KERN_WARNING "Can't move tasks between cgroups: "
+			"Kernel memory held. task: %s\n", p->comm);
+		return 1;
+	}
 
 	if (mem->move_charge_at_immigrate) {
 		struct mm_struct *mm;
-		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
 		VM_BUG_ON(from == mem);
 
@@ -5807,6 +5802,16 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
 				struct task_struct *p)
 {
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
+	struct mem_cgroup *from = mem_cgroup_from_task(p);
+
+	if (from != mem &&
+	    res_counter_read_u64(&mem->tcp.tcp_memory_allocated, RES_USAGE)) {
+		printk(KERN_WARNING "Can't move tasks between cgroups: "
+			"Kernel memory held. task: %s\n", p->comm);
+		return 1;
+	}
+
 	return 0;
 }
 static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
-- 
1.7.6.4

