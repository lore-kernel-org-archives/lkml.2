Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0ESAE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:04:57 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:63552 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0ESAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=oVYxzIT1JFHe2trD5w4Fp4acEdYxjcMAPoGn3dbE5C2gqYceAQDPbUQ8C9bGuDnirP
         18iOiKSi1rLoAy5dIT4mPNGc21BOr3fzYuWmhMRdx69p1UshAP6a3xBasvLoBI0faVsz
         0hNHJN5IBSSzX087S5qj5z6gEN/fPfJnlMUm0=
Subject: [PATCH 1/3] cgroups: Add an API to attach a task to current task's
 cgroup
From: Sridhar Samudrala <samudrala.sridhar@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, netdev <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 May 2010 17:04:48 -0700
Message-Id: <1274227488.2370.107.camel@w-sridhar.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new kernel API to attach a task to current task's cgroup
in all the active hierarchies.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -570,6 +570,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
+int cgroup_attach_task_current_cg(struct task_struct *);
 
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6d870f2..6cfeb06 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1788,6 +1788,29 @@ out:
 	return retval;
 }
 
+/**
+ * cgroup_attach_task_current_cg - attach task 'tsk' to current task's cgroup
+ * @tsk: the task to be attached
+ */
+int cgroup_attach_task_current_cg(struct task_struct *tsk)
+{
+	struct cgroupfs_root *root;
+	struct cgroup *cur_cg;
+	int retval = 0;
+
+	cgroup_lock();
+	for_each_active_root(root) {
+		cur_cg = task_cgroup_from_root(current, root);
+		retval = cgroup_attach_task(cur_cg, tsk);
+		if (retval)
+			break;
+	}
+	cgroup_unlock();
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(cgroup_attach_task_current_cg);
+
 /*
  * Attach task with pid 'pid' to cgroup 'cgrp'. Call with cgroup_mutex
  * held. May take task_lock of task


