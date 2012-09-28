Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2I1H56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:57:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2I1H54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:57:56 -0400
Date: Fri, 28 Sep 2012 00:57:38 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-e9d5bc24d665271513842f569ebb402d082bc612@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/mpol: Make mempolicy home-node aware
Git-Commit-ID: e9d5bc24d665271513842f569ebb402d082bc612
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 00:57:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9d5bc24d665271513842f569ebb402d082bc612
Gitweb:     http://git.kernel.org/tip/e9d5bc24d665271513842f569ebb402d082bc612
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 17:05:54 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 14:46:03 +0200

mm/mpol: Make mempolicy home-node aware

Add another layer of fallback policy to make the home node concept
useful from a memory allocation PoV.

This changes the mpol order to:

 - vma->vm_ops->get_policy	[if applicable]
 - vma->vm_policy		[if applicable]
 - task->mempolicy
 - tsk_home_node() preferred	[NEW]
 - default_policy

Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
facilitate efficient on-demand memory migration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-ybn5oygsqXZa6jtwpwjywmdu@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mempolicy.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9f742b6..6c6490b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -117,6 +117,22 @@ static struct mempolicy default_policy = {
 	.flags = MPOL_F_LOCAL,
 };
 
+static struct mempolicy preferred_node_policy[MAX_NUMNODES];
+
+static struct mempolicy *get_task_policy(struct task_struct *p)
+{
+	struct mempolicy *pol = p->mempolicy;
+	int node;
+
+	if (!pol) {
+		node = tsk_home_node(p);
+		if (node != -1)
+			pol = &preferred_node_policy[node];
+	}
+
+	return pol;
+}
+
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
 	/*
@@ -1565,7 +1581,7 @@ asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = task->mempolicy;
+	struct mempolicy *pol = get_task_policy(task);
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1955,7 +1971,7 @@ retry_cpuset:
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = current->mempolicy;
+	struct mempolicy *pol = get_task_policy(current);
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
@@ -2407,6 +2423,15 @@ void __init numa_policy_init(void)
 				     sizeof(struct sp_node),
 				     0, SLAB_PANIC, NULL);
 
+	for_each_node(nid) {
+		preferred_node_policy[nid] = (struct mempolicy) {
+			.refcnt = ATOMIC_INIT(1),
+			.mode = MPOL_PREFERRED,
+			.flags = MPOL_F_MOF,
+			.v = { .preferred_node = nid, },
+		};
+	}
+
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
 	 * enabled across suitably sized nodes (default is >= 16MB), or
