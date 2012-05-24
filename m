Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2EXOR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:17:29 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49278 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2EXOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:17:27 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v6 2/4] cpusets,
 hotplug: Implement cpuset tree traversal in a helper function
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 24 May 2012 19:46:41 +0530
Message-ID: <20120524141635.3692.893.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
References: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12052404-1618-0000-0000-000001ABB8B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 kernel/cpuset.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 746d1ee..ba96349 100644
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

