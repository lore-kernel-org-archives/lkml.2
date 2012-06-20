Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2FTKpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:45:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2FTKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:45:51 -0400
Date: Wed, 20 Jun 2012 03:45:35 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-b451c38428c5682348b6f661d767e358d1d70c41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20120524141635.3692.893.stgit@srivatsabhat.in.ibm.com>
References: <20120524141635.3692.893.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpusets, hotplug:
  Implement cpuset tree traversal in a helper function
Git-Commit-ID: b451c38428c5682348b6f661d767e358d1d70c41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:45:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b451c38428c5682348b6f661d767e358d1d70c41
Gitweb:     http://git.kernel.org/tip/b451c38428c5682348b6f661d767e358d1d70c41
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Thu, 24 May 2012 19:46:41 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 11:45:04 +0200

cpusets, hotplug: Implement cpuset tree traversal in a helper function

At present, the functions that deal with cpusets during CPU/Mem hotplug
are quite messy, since a lot of the functionality is mixed up without clear
separation. And this takes a toll on optimization as well. For example,
the function cpuset_update_active_cpus() is called on both CPU offline and CPU
online events; and it invokes scan_for_empty_cpusets(), which makes sense
only for CPU offline events. And hence, the current code ends up unnecessarily
traversing the cpuset tree during CPU online also.

As a first step towards cleaning up those functions, encapsulate the cpuset
tree traversal in a helper function, so as to facilitate upcoming changes.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120524141635.3692.893.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpuset.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 77abe1a..e0b29bb 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1990,6 +1990,32 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 }
 
 /*
+ * Helper function to traverse cpusets.
+ * It can be used to walk the cpuset tree from top to bottom, completing
+ * one layer before dropping down to the next (thus always processing a
+ * node before any of its children).
+ */
+static struct cpuset *cpuset_next(struct list_head *queue)
+{
+	struct cpuset *cp;
+	struct cpuset *child;	/* scans child cpusets of cp */
+	struct cgroup *cont;
+
+	if (list_empty(queue))
+		return NULL;
+
+	cp = list_first_entry(queue, struct cpuset, stack_list);
+	list_del(queue->next);
+	list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+		child = cgroup_cs(cont);
+		list_add_tail(&child->stack_list, queue);
+	}
+
+	return cp;
+}
+
+
+/*
  * Walk the specified cpuset subtree and look for empty cpusets.
  * The tasks of such cpuset must be moved to a parent cpuset.
  *
@@ -2008,19 +2034,11 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 {
 	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
-	struct cpuset *child;	/* scans child cpusets of cp */
-	struct cgroup *cont;
 	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
-	while (!list_empty(&queue)) {
-		cp = list_first_entry(&queue, struct cpuset, stack_list);
-		list_del(queue.next);
-		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
-			child = cgroup_cs(cont);
-			list_add_tail(&child->stack_list, &queue);
-		}
+	while ((cp = cpuset_next(&queue)) != NULL) {
 
 		/* Continue past cpusets with all cpus, mems online */
 		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&
