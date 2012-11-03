Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab2KCIkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:40:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33714 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2KCIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:39:31 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] cgroup_freezer: add ->post_create() and ->pre_destroy() and track online state
Date: Sat,  3 Nov 2012 01:38:34 -0700
Message-Id: <1351931915-1701-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351931915-1701-1-git-send-email-tj@kernel.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cgroup is online and visible to iteration between ->post_create()
and ->pre_destroy().  This patch introduces CGROUP_FREEZER_ONLINE and
toggles it from the newly added freezer_post_create() and
freezer_pre_destroy() while holding freezer->lock such that a
cgroup_freezer can be reilably distinguished to be online.  This will
be used by full hierarchy support.

ONLINE test is added to freezer_apply_state() but it currently doesn't
make any difference as freezer_write() can only be called for an
online cgroup.

Adjusting system_freezing_cnt on destruction is moved from
freezer_destroy() to the new freezer_pre_destroy() for consistency.

This patch doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup_freezer.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index b8ad93c..4f12d31 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -23,6 +23,7 @@
 #include <linux/seq_file.h>
 
 enum freezer_state_flags {
+	CGROUP_FREEZER_ONLINE	= (1 << 0), /* freezer is fully online */
 	CGROUP_FREEZING_SELF	= (1 << 1), /* this freezer is freezing */
 	CGROUP_FREEZING_PARENT	= (1 << 2), /* the parent freezer is freezing */
 	CGROUP_FROZEN		= (1 << 3), /* this and its descendants frozen */
@@ -98,13 +99,45 @@ static struct cgroup_subsys_state *freezer_create(struct cgroup *cgroup)
 	return &freezer->css;
 }
 
-static void freezer_destroy(struct cgroup *cgroup)
+/**
+ * freezer_post_create - commit creation of a freezer cgroup
+ * @cgroup: cgroup being created
+ *
+ * We're committing to creation of @cgroup.  Mark it online.
+ */
+static void freezer_post_create(struct cgroup *cgroup)
 {
 	struct freezer *freezer = cgroup_freezer(cgroup);
 
+	spin_lock_irq(&freezer->lock);
+	freezer->state |= CGROUP_FREEZER_ONLINE;
+	spin_unlock_irq(&freezer->lock);
+}
+
+/**
+ * freezer_pre_destroy - initiate destruction of @cgroup
+ * @cgroup: cgroup being destroyed
+ *
+ * @cgroup is going away.  Mark it dead and decrement system_freezing_count
+ * if it was holding one.
+ */
+static void freezer_pre_destroy(struct cgroup *cgroup)
+{
+	struct freezer *freezer = cgroup_freezer(cgroup);
+
+	spin_lock_irq(&freezer->lock);
+
 	if (freezer->state & CGROUP_FREEZING)
 		atomic_dec(&system_freezing_cnt);
-	kfree(freezer);
+
+	freezer->state = 0;
+
+	spin_unlock_irq(&freezer->lock);
+}
+
+static void freezer_destroy(struct cgroup *cgroup)
+{
+	kfree(cgroup_freezer(cgroup));
 }
 
 /*
@@ -260,6 +293,9 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
 	/* also synchronizes against task migration, see freezer_attach() */
 	lockdep_assert_held(&freezer->lock);
 
+	if (!(freezer->state & CGROUP_FREEZER_ONLINE))
+		return;
+
 	if (freeze) {
 		if (!(freezer->state & CGROUP_FREEZING))
 			atomic_inc(&system_freezing_cnt);
@@ -347,6 +383,8 @@ static struct cftype files[] = {
 struct cgroup_subsys freezer_subsys = {
 	.name		= "freezer",
 	.create		= freezer_create,
+	.post_create	= freezer_post_create,
+	.pre_destroy	= freezer_pre_destroy,
 	.destroy	= freezer_destroy,
 	.subsys_id	= freezer_subsys_id,
 	.attach		= freezer_attach,
-- 
1.7.11.7

