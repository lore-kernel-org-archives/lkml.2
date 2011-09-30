Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab1I3MFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:05:44 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:53652 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758488Ab1I3MFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:05:37 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk@culm.net>
Subject: [PATCH 2/6] cgroup: make 'cgroup_is_descendant' function take cgroup as a 'descendant of' argument
Date: Fri, 30 Sep 2011 13:36:21 +0200
Message-Id: <1317382585-12172-3-git-send-email-wpk@culm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317382585-12172-1-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make currently unused (previously used by cgroup_ns) 'cgroup_is_descendant' function
take cgroup as a 'descendant of' argument instead of task.

Signed-off-by: Witold Krecicki <wpk@culm.net>
---
 include/linux/cgroup.h |    5 +++--
 kernel/cgroup.c        |   16 +++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ee51f79..6965591 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -440,8 +440,9 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
-/* Return true if cgrp is a descendant of the task's cgroup */
-int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
+/* Return true if cgrp is a descendant of the topcgrp */
+int cgroup_is_descendant(const struct cgroup *cgrp,
+			  const struct cgroup *topcgrp);
 
 /*
  * When the subsys has to access css and may add permanent refcnt to css,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a4d002c..0177472 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4684,30 +4684,28 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 }
 
 /**
- * cgroup_is_descendant - see if @cgrp is a descendant of @task's cgrp
+ * cgroup_is_descendant - see if @cgrp is a descendant of @topcgrp
  * @cgrp: the cgroup in question
- * @task: the task in question
+ * @topcgrp: the top cgroup
  *
- * See if @cgrp is a descendant of @task's cgroup in the appropriate
+ * See if @cgrp is a descendant of @topcgrp in the appropriate
  * hierarchy.
  *
  * If we are sending in dummytop, then presumably we are creating
  * the top cgroup in the subsystem.
  *
- * Called only by the ns (nsproxy) cgroup.
  */
-int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task)
+int cgroup_is_descendant(const struct cgroup *cgrp,
+			  const struct cgroup *topcgrp)
 {
 	int ret;
-	struct cgroup *target;
 
 	if (cgrp == dummytop)
 		return 1;
 
-	target = task_cgroup_from_root(task, cgrp->root);
-	while (cgrp != target && cgrp!= cgrp->top_cgroup)
+	while (cgrp != topcgrp && cgrp != cgrp->top_cgroup)
 		cgrp = cgrp->parent;
-	ret = (cgrp == target);
+	ret = (cgrp == topcgrp);
 	return ret;
 }
 
-- 
1.7.4.1

