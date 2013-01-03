Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3ACVov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:44:51 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41593 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3ACVoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:44:14 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cpuset: implement cgroup_rightmost_descendant()
Date: Thu,  3 Jan 2013 13:44:04 -0800
Message-Id: <1357249446-25075-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357249446-25075-1-git-send-email-tj@kernel.org>
References: <1357249446-25075-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement cgroup_rightmost_descendant() which returns the right most
descendant of the specified cgroup.  This can be used to skip the
cgroup's subtree while iterating with
cgroup_for_each_descendant_pre().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
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
index 4855892..6643f70 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3017,6 +3017,32 @@ struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
 }
 EXPORT_SYMBOL_GPL(cgroup_next_descendant_pre);
 
+/**
+ * cgroup_rightmost_descendant - return the rightmost descendant of a cgroup
+ * @pos: cgroup of interest
+ *
+ * Return the rightmost descendant of @pos.  If there's no descendant,
+ * @pos is returned.  This can be used during pre-order traversal to skip
+ * subtree of @pos.
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
1.8.0.2

