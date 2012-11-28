Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2K1W1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:27:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33613 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab2K1W1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:27:14 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cpuset: implement cgroup_rightmost_descendant()
Date: Wed, 28 Nov 2012 14:26:59 -0800
Message-Id: <1354141621-11906-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354141621-11906-1-git-send-email-tj@kernel.org>
References: <1354141621-11906-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement cgroup_rightmost_descendant() which returns the right most
descendant of the specified cgroup.  This can be used to skip the
cgroup's subtree while iterating with
cgroup_for_each_descendant_pre().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7d73905..860ca0f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -558,6 +558,7 @@ static inline struct cgroup* task_cgroup(struct task_struct *task,
 
 struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 					  struct cgroup *cgroup);
+struct cgroup *cgroup_rightmost_descendant(struct cgroup *pos);
 
 /**
  * cgroup_for_each_descendant_pre - pre-order walk of a cgroup's descendants
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c02b055..bbf7460 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3009,6 +3009,32 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 }
 EXPORT_SYMBOL_GPL(cgroup_next_descendant_pre);
 
+/**
+ * cgroup_rightmost_descendant - return the rightmost descendant of a cgroup
+ * @cgrp: cgroup of interest
+ *
+ * Return the rightmost descendant of @cgrp.  If there's no descendant,
+ * @cgrp is returned.  This can be used during pre-order traversal to skip
+ * subtree of @cgrp.
+ */
+struct cgroup *cgroup_rightmost_descendant(struct cgroup *pos)
+{
+	struct cgroup *last, *tmp;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	do {
+		last = pos;
+		/* ->prev isn't RCU safe, walk ->next till the end */
+		pos = NULL;
+		list_for_each_entry_rcu(tmp, &last->children, sibling)
+			pos = tmp;
+	} while (pos);
+
+	return last;
+}
+EXPORT_SYMBOL_GPL(cgroup_rightmost_descendant);
+
 static struct cgroup *cgroup_leftmost_descendant(struct cgroup *pos)
 {
 	struct cgroup *last;
-- 
1.7.11.7

