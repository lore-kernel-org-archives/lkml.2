Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1BAWoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:44:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:9683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1BAWoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:44:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="702996921"
From: jacob.jun.pan@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul Menage <menage@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        container cgroup <containers@lists.linux-foundation.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] cgroups: respect cgroup timer slack value in prctl
Date: Tue,  1 Feb 2011 14:41:43 -0800
Message-Id: <1296600103-15726-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Per cgroup timer slack value is used to manage task groups
for more friendly power management behavior. Once a task is
attached to a cgroup, we should not allow user to change
(escape) the per cgroup restriction unless a more relaxed
timer slack value is given by user via prctl.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 include/linux/cgroup.h      |   13 +++++++++++++
 kernel/cgroup_timer_slack.c |    4 ----
 kernel/sys.c                |   21 ++++++++++++++++++++-
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed4ba11..4405666 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -627,6 +627,19 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
 
+#ifdef CONFIG_CGROUP_TIMER_SLACK
+struct timer_slack_cgroup {
+	struct cgroup_subsys_state css;
+	unsigned long timer_slack_ns;
+};
+
+static inline struct timer_slack_cgroup *task_timer_slack(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, timer_slack_subsys_id),
+			    struct timer_slack_cgroup, css);
+}
+#endif
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup_timer_slack.c b/kernel/cgroup_timer_slack.c
index daa452d..1de122a 100644
--- a/kernel/cgroup_timer_slack.c
+++ b/kernel/cgroup_timer_slack.c
@@ -4,10 +4,6 @@
 #include <linux/slab.h>
 
 struct cgroup_subsys timer_slack_subsys;
-struct timer_slack_cgroup {
-	struct cgroup_subsys_state css;
-	unsigned long timer_slack_ns;
-};
 
 static struct timer_slack_cgroup *cgroup_to_tslack_cgroup(struct cgroup *cgroup)
 {
diff --git a/kernel/sys.c b/kernel/sys.c
index 7f5a0cd..433fcdb 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -37,6 +37,8 @@
 #include <linux/ptrace.h>
 #include <linux/fs_struct.h>
 #include <linux/gfp.h>
+#include <linux/cgroup.h>
+#include <linux/init_task.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -1688,8 +1690,25 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			if (arg2 <= 0)
 				current->timer_slack_ns =
 					current->default_timer_slack_ns;
-			else
+			else {
+#ifdef CONFIG_CGROUP_TIMER_SLACK
+				/* only allow more relaxed slack value than
+				 * the attached timer slack cgroup allows.
+				 */
+				unsigned long cg_timer_slack;
+
+				rcu_read_lock();
+				cg_timer_slack = task_timer_slack(current)->timer_slack_ns;
+				rcu_read_unlock();
+				if (cg_timer_slack < arg2 || cg_timer_slack
+					== TIMER_SLACK_NS_DEFAULT)
+					current->timer_slack_ns = arg2;
+				else
+					return -EINVAL;
+#else
 				current->timer_slack_ns = arg2;
+#endif
+			}
 			error = 0;
 			break;
 		case PR_MCE_KILL:
-- 
1.7.0.4

