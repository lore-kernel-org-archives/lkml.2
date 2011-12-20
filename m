Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1LTXPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:15:54 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65169 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1LTXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:14:43 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: [PATCH 5/5] cgroup: separate out cgroup_attach_proc error handling code
Date: Tue, 20 Dec 2011 15:14:33 -0800
Message-Id: <1324422873-31001-6-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324422873-31001-1-git-send-email-msb@chromium.org>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it easier to read the non-error path.

While at it, move the retval=0 assignment inside the !group_size
check. This way the comment describe this check is directly
above it(we also avoid an extra assignment not needed in the
normal path). Also return 0 directly instead of using retval.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/cgroup.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2ac9eee..9ce0872 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2067,9 +2067,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	read_unlock(&tasklist_lock);
 
 	/* methods shouldn't be called if no task is actually migrating */
-	retval = 0;
-	if (!group_size)
+	if (!group_size) {
+		retval = 0;
 		goto out_free_group_list;
+	}
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
@@ -2126,20 +2127,20 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 */
 	synchronize_rcu();
 	cgroup_wakeup_rmdir_waiter(cgrp);
-	retval = 0;
+	flex_array_free(group);
+	return 0;
+
 out_list_teardown:
 	for (i = 0; i < css_set_refs; i++) {
 		tc = flex_array_get(group, i);
 		put_css_set(tc->cg);
 	}
 out_cancel_attach:
-	if (retval) {
-		for_each_subsys(root, ss) {
-			if (ss == failed_ss)
-				break;
-			if (ss->cancel_attach)
-				ss->cancel_attach(ss, cgrp, &tset);
-		}
+	for_each_subsys(root, ss) {
+		if (ss == failed_ss)
+			break;
+		if (ss->cancel_attach)
+			ss->cancel_attach(ss, cgrp, &tset);
 	}
 out_free_group_list:
 	flex_array_free(group);
-- 
1.7.3.1

