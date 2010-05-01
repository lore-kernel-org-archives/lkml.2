Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0EAO0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:26:16 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:62951 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0EAOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:25:59 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Cedric Le Goater <legoater@free.fr>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH v21 017/100] cgroup freezer: interface to freeze a cgroup from within the kernel
Date: Sat,  1 May 2010 10:14:59 -0400
Message-Id: <1272723382-19470-18-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add public interface to freeze a cgroup freezer given a task that
belongs to that cgroup:  cgroup_freezer_make_frozen(task)

Freezing the root cgroup is not permitted. Freezing the cgroup to
which current process belong is also not permitted.

This will be used for restart(2) to be able to leave the restarted
processes in a frozen state, instead of resuming execution.

This is useful for debugging, if the user would like to attach a
debugger to the restarted task(s).

It is also useful if the restart procedure would like to perform
additional setup once the tasks are restored but before they are
allowed to proceed execution.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
CC: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Cedric Le Goater <legoater@free.fr>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
---
 include/linux/freezer.h |    1 +
 kernel/cgroup_freezer.c |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 3d32641..0cb22cb 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -68,6 +68,7 @@ extern int cgroup_freezing_or_frozen(struct task_struct *task);
 extern int in_same_cgroup_freezer(struct task_struct *p, struct task_struct *q);
 extern int cgroup_freezer_begin_checkpoint(struct task_struct *task);
 extern void cgroup_freezer_end_checkpoint(struct task_struct *task);
+extern int cgroup_freezer_make_frozen(struct task_struct *task);
 #else /* !CONFIG_CGROUP_FREEZER */
 static inline int cgroup_freezing_or_frozen(struct task_struct *task)
 {
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 58ee049..8f923d8 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -480,4 +480,31 @@ void cgroup_freezer_end_checkpoint(struct task_struct *task)
 	 */
 	WARN_ON(freezer_checkpointing(task, CGROUP_FROZEN) != CGROUP_CHECKPOINTING);
 }
+
+int cgroup_freezer_make_frozen(struct task_struct *task)
+{
+	struct freezer *freezer;
+	struct cgroup_subsys_state *css;
+	int ret = -ENODEV;
+
+	task_lock(task);
+	css = task_subsys_state(task, freezer_subsys_id);
+	css_get(css); /* make sure freezer doesn't go away */
+	freezer = container_of(css, struct freezer, css);
+	task_unlock(task);
+
+	/* Never freeze the root cgroup */
+	if (!test_bit(CSS_ROOT, &css->flags) &&
+	    cgroup_lock_live_group(css->cgroup)) {
+		/* do not freeze outselves, ei ?! */
+		if (css != task_subsys_state(current, freezer_subsys_id))
+			ret = freezer_change_state(css->cgroup, CGROUP_FROZEN);
+		else
+			ret = -EPERM;
+		cgroup_unlock();
+	}
+
+	css_put(css);
+	return ret;
+}
 #endif /* CONFIG_CHECKPOINT */
-- 
1.6.3.3

