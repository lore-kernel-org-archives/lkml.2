Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2K1Vel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:34:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47858 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab2K1Vei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:34:38 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/13] cpuset: introduce CS_ONLINE
Date: Wed, 28 Nov 2012 13:34:11 -0800
Message-Id: <1354138460-19286-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CS_ONLINE which is set from css_online() and cleared from
css_offline().  This will enable using generic cgroup iterator while
allowing decoupling cpuset from cgroup internal locking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 70197ba..22b521d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -138,6 +138,7 @@ static inline bool task_has_mempolicy(struct task_struct *task)
 
 /* bits in struct cpuset flags field */
 typedef enum {
+	CS_ONLINE,
 	CS_CPU_EXCLUSIVE,
 	CS_MEM_EXCLUSIVE,
 	CS_MEM_HARDWALL,
@@ -154,6 +155,11 @@ enum hotplug_event {
 };
 
 /* convenient tests for these bits */
+static inline bool is_cpuset_online(const struct cpuset *cs)
+{
+	return test_bit(CS_ONLINE, &cs->flags);
+}
+
 static inline int is_cpu_exclusive(const struct cpuset *cs)
 {
 	return test_bit(CS_CPU_EXCLUSIVE, &cs->flags);
@@ -190,7 +196,8 @@ static inline int is_spread_slab(const struct cpuset *cs)
 }
 
 static struct cpuset top_cpuset = {
-	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
+	.flags = ((1 << CS_ONLINE) | (1 << CS_CPU_EXCLUSIVE) |
+		  (1 << CS_MEM_EXCLUSIVE)),
 };
 
 /*
@@ -1822,6 +1829,7 @@ static int cpuset_css_online(struct cgroup *cgrp)
 	if (!parent)
 		return 0;
 
+	set_bit(CS_ONLINE, &cs->flags);
 	if (is_spread_page(parent))
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
 	if (is_spread_slab(parent))
@@ -1871,6 +1879,7 @@ static void cpuset_css_offline(struct cgroup *cgrp)
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	number_of_cpusets--;
+	clear_bit(CS_ONLINE, &cs->flags);
 
 	cgroup_unlock();
 }
-- 
1.7.11.7

