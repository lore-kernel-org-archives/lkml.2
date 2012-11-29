Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab2K2Inb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2K2InF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:05 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299576"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 8/8] srcu: use ACCESS_ONCE() to access sp->completed in srcu_read_lock()
Date: Thu, 29 Nov 2012 16:46:09 +0800
Message-Id: <1354178770-6028-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:33,
	Serialize complete at 2012/11/29 16:42:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old srcu implement requires sp->completed is loaded in
RCU-sched(preempt_disable()) section.

The new srcu is now not RCU-sched based, it doesn't require the load of
sp->completed and the access to counter must be in the same RCU-sched
read site C.S., so we use ACCESS_ONCE() instead, and move it out of
the preempt_disable() section, preempt_disable() section is only used
for percpu data, not for RCU-sched.

The resulted code is almost as the same as before, but it helps people to
understand the code, and it avoids to add surprise to reviewer: "why we need
rcu_read_lock_sched_held() here?"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 38a762f..224400a 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -294,9 +294,8 @@ int __srcu_read_lock(struct srcu_struct *sp)
 {
 	int idx;
 
+	idx = ACCESS_ONCE(sp->completed) & 0x1;
 	preempt_disable();
-	idx = rcu_dereference_index_check(sp->completed,
-					  rcu_read_lock_sched_held()) & 0x1;
 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
 	smp_mb(); /* B */  /* Avoid leaking the critical section. */
 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
-- 
1.7.4.4

