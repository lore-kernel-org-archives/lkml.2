Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2JPKMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:12:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49953 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2JPKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:12:18 -0400
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        mhocko@suse.cz
Cc: linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while memcg oom happening
Date: Tue, 16 Oct 2012 18:12:08 +0800
Message-Id: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
task in out-of-memory situations, but it only works on overall system-wide oom.
But it's also a useful indication in memcg so we take it into consideration
while oom happening in memcg. Other sysctl such as panic_on_oom has already
been memcg-ware.


Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/memcontrol.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e4e9b18..c329940 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1486,6 +1486,15 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
+	if (sysctl_oom_kill_allocating_task && current->mm &&
+	    !oom_unkillable_task(current, memcg, NULL) &&
+	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
+		get_task_struct(current);
+		oom_kill_process(current, gfp_mask, order, 0, totalpages, memcg, NULL,
+				 "Memory cgroup out of memory (oom_kill_allocating_task)");
+		return;
+	}
+
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct cgroup *cgroup = iter->css.cgroup;
 		struct cgroup_iter it;
-- 
1.7.6.1

