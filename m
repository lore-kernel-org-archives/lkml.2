Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab2EDTSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:18:31 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59075 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2EDTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:18:29 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 1/7] cpusets,
 hotplug: Implement cpuset tree traversal in a helper function
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:47:48 +0530
Message-ID: <20120504191731.4603.56791.stgit@srivatsabhat>
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050419-3864-0000-0000-00000290C3AE
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
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 14f7070..23e5da6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2000,6 +2000,23 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	move_member_tasks_to_cpuset(cs, parent);
 }
 
+static struct cpuset *traverse_cpusets(struct list_head *queue)
+{
+	struct cpuset *cp;
+	struct cpuset *child;	/* scans child cpusets of cp */
+	struct cgroup *cont;
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
 /*
  * Walk the specified cpuset subtree and look for empty cpusets.
  * The tasks of such cpuset must be moved to a parent cpuset.
@@ -2019,19 +2036,12 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 {
 	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
-	struct cpuset *child;	/* scans child cpusets of cp */
-	struct cgroup *cont;
 	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
 	while (!list_empty(&queue)) {
-		cp = list_first_entry(&queue, struct cpuset, stack_list);
-		list_del(queue.next);
-		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
-			child = cgroup_cs(cont);
-			list_add_tail(&child->stack_list, &queue);
-		}
+		cp = traverse_cpusets(&queue);
 
 		/* Continue past cpusets with all cpus, mems online */
 		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&

