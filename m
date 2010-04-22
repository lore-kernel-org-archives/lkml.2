Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0DVT1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:54 -0400
Received: from kroah.org ([198.145.64.141]:37303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab0DVT1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:10 2010
Message-Id: <20100422190910.152709753@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [031/197] Freezer: Fix buggy resume test for tasks frozen with cgroup freezer
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Helsley <matthltc@us.ibm.com>

commit 5a7aadfe2fcb0f69e2acc1fbefe22a096e792fc9 upstream.

When the cgroup freezer is used to freeze tasks we do not want to thaw
those tasks during resume. Currently we test the cgroup freezer
state of the resuming tasks to see if the cgroup is FROZEN.  If so
then we don't thaw the task. However, the FREEZING state also indicates
that the task should remain frozen.

This also avoids a problem pointed out by Oren Ladaan: the freezer state
transition from FREEZING to FROZEN is updated lazily when userspace reads
or writes the freezer.state file in the cgroup filesystem. This means that
resume will thaw tasks in cgroups which should be in the FROZEN state if
there is no read/write of the freezer.state file to trigger this
transition before suspend.

NOTE: Another "simple" solution would be to always update the cgroup
freezer state during resume. However it's a bad choice for several reasons:
Updating the cgroup freezer state is somewhat expensive because it requires
walking all the tasks in the cgroup and checking if they are each frozen.
Worse, this could easily make resume run in N^2 time where N is the number
of tasks in the cgroup. Finally, updating the freezer state from this code
path requires trickier locking because of the way locks must be ordered.

Instead of updating the freezer state we rely on the fact that lazy
updates only manage the transition from FREEZING to FROZEN. We know that
a cgroup with the FREEZING state may actually be FROZEN so test for that
state too. This makes sense in the resume path even for partially-frozen
cgroups -- those that really are FREEZING but not FROZEN.

Reported-by: Oren Ladaan <orenl@cs.columbia.edu>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/freezer.h |    7 +++++--
 kernel/cgroup_freezer.c |    9 ++++++---
 kernel/power/process.c  |    2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -64,9 +64,12 @@ extern bool freeze_task(struct task_stru
 extern void cancel_freezing(struct task_struct *p);
 
 #ifdef CONFIG_CGROUP_FREEZER
-extern int cgroup_frozen(struct task_struct *task);
+extern int cgroup_freezing_or_frozen(struct task_struct *task);
 #else /* !CONFIG_CGROUP_FREEZER */
-static inline int cgroup_frozen(struct task_struct *task) { return 0; }
+static inline int cgroup_freezing_or_frozen(struct task_struct *task)
+{
+	return 0;
+}
 #endif /* !CONFIG_CGROUP_FREEZER */
 
 /*
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -47,17 +47,20 @@ static inline struct freezer *task_freez
 			    struct freezer, css);
 }
 
-int cgroup_frozen(struct task_struct *task)
+int cgroup_freezing_or_frozen(struct task_struct *task)
 {
 	struct freezer *freezer;
 	enum freezer_state state;
 
 	task_lock(task);
 	freezer = task_freezer(task);
-	state = freezer->state;
+	if (!freezer->css.cgroup->parent)
+		state = CGROUP_THAWED; /* root cgroup can't be frozen */
+	else
+		state = freezer->state;
 	task_unlock(task);
 
-	return state == CGROUP_FROZEN;
+	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
 }
 
 /*
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -139,7 +139,7 @@ static void thaw_tasks(bool nosig_only)
 		if (nosig_only && should_send_signal(p))
 			continue;
 
-		if (cgroup_frozen(p))
+		if (cgroup_freezing_or_frozen(p))
 			continue;
 
 		thaw_process(p);


