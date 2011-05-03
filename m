Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1EGGc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:32:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1508 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1EGGcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=crNA4KW4OjvSWvKdcdb8pIpMOwSFl0FXf4utAXzAlO+MHjGUZxxZ5f31ZeuNIn56t
	nZWH+kbeGZ/Sg+5yoKuOQ==
Message-Id: <20110503092905.340562757@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:56 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 10/15] sched: allow for positional tg_tree walks
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-refactor-walk_tg_tree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend walk_tg_tree to accept a positional argument

static int walk_tg_tree_from(struct task_group *from,
			     tg_visitor down, tg_visitor up, void *data)

Existing semantics are preserved, caller must hold rcu_lock() or sufficient
analogue.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -1430,21 +1430,19 @@ static inline void dec_cpu_load(struct r
 #if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_RT_GROUP_SCHED)
 typedef int (*tg_visitor)(struct task_group *, void *);
 
-/*
- * Iterate the full tree, calling @down when first entering a node and @up when
- * leaving it for the final time.
- */
-static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+/* Iterate task_group tree rooted at *from */
+static int walk_tg_tree_from(struct task_group *from,
+			     tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
 	int ret;
 
-	rcu_read_lock();
-	parent = &root_task_group;
+	parent = from;
+
 down:
 	ret = (*down)(parent, data);
 	if (ret)
-		goto out_unlock;
+		goto out;
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1453,14 +1451,28 @@ up:
 		continue;
 	}
 	ret = (*up)(parent, data);
-	if (ret)
-		goto out_unlock;
+	if (ret || parent == from)
+		goto out;
 
 	child = parent;
 	parent = parent->parent;
 	if (parent)
 		goto up;
-out_unlock:
+out:
+	return ret;
+}
+
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ */
+
+static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = walk_tg_tree_from(&root_task_group, down, up, data);
 	rcu_read_unlock();
 
 	return ret;


