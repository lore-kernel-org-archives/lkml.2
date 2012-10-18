Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2JRRCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:02:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2JRRCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:02:09 -0400
Date: Thu, 18 Oct 2012 10:01:47 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-dvswxo34oaiibm06zyvrv0q5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa: Simplify task_numa_fault()
Git-Commit-ID: f3bd8842a897685269b3fa48ad6f9d5590be67ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:01:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3bd8842a897685269b3fa48ad6f9d5590be67ab
Gitweb:     http://git.kernel.org/tip/f3bd8842a897685269b3fa48ad6f9d5590be67ab
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Oct 2012 14:13:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Oct 2012 12:30:16 +0200

sched/numa: Simplify task_numa_fault()

Also fix numa_scan_seq off by one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-dvswxo34oaiibm06zyvrv0q5@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |   11 +----------
 kernel/sched/core.c   |    2 +-
 kernel/sched/fair.c   |    9 ++++-----
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 99a70eb..c7f8656 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1608,16 +1608,7 @@ static inline int tsk_home_node(struct task_struct *p)
 }
 
 extern void task_numa_placement(void);
-extern void __task_numa_fault(int node);
-static inline void task_numa_fault(int node)
-{
-	struct task_struct *p = current;
-
-	if (likely(p->numa_faults))
-		p->numa_faults[node]++;
-	else
-		__task_numa_fault(node);
-}
+extern void task_numa_fault(int node);
 #else
 static inline int tsk_home_node(struct task_struct *p)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ff4a3bd..b370f2f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1543,7 +1543,7 @@ static void __sched_fork(struct task_struct *p)
 	p->node = -1;
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
-	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq : 0;
+	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_faults = NULL;
 #endif /* CONFIG_SCHED_NUMA */
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 592291b..1a32930 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -823,18 +823,17 @@ unsigned int sysctl_sched_numa_settle_count = 2;
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void __task_numa_fault(int node)
+void task_numa_fault(int node)
 {
 	struct task_struct *p = current;
 
-	if (!p->numa_faults) {
+	if (unlikely(!p->numa_faults)) {
 		p->numa_faults = kzalloc(sizeof(unsigned long) * nr_node_ids,
 					 GFP_KERNEL);
+		if (!p->numa_faults)
+			return;
 	}
 
-	if (!p->numa_faults)
-		return;
-
 	p->numa_faults[node]++;
 }
 
