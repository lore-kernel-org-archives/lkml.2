Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0JROho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab0JROhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/22] GFS2: Use new workqueue scheme
Date: Mon, 18 Oct 2010 15:15:33 +0100
Message-Id: <1287411346-17855-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recovery workqueue can be freezable since
we want it to finish what it is doing if the system is to
be frozen (although why you'd want to freeze a cluster node
is beyond me since it will result in it being ejected from
the cluster). It does still make sense for single node
GFS2 filesystems though.

The glock workqueue will benefit from being able to run more
work items concurrently. A test running postmark shows
improved performance and multi-threaded workloads are likely
to benefit even more. It needs to be high priority because
the latency directly affects the latency of filesystem glock
operations.

The delete workqueue is similar to the recovery workqueue in
that it must not get blocked by memory allocations, and may
run for a long time.

Potentially other GFS2 threads might also be converted to
workqueues, but I'll leave that for a later patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8e478e2..c3f2a5c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1783,10 +1783,12 @@ int __init gfs2_glock_init(void)
 	}
 #endif
 
-	glock_workqueue = create_workqueue("glock_workqueue");
+	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_RESCUER |
+					  WQ_HIGHPRI | WQ_FREEZEABLE, 0);
 	if (IS_ERR(glock_workqueue))
 		return PTR_ERR(glock_workqueue);
-	gfs2_delete_workqueue = create_workqueue("delete_workqueue");
+	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue", WQ_RESCUER |
+						WQ_FREEZEABLE, 0);
 	if (IS_ERR(gfs2_delete_workqueue)) {
 		destroy_workqueue(glock_workqueue);
 		return PTR_ERR(gfs2_delete_workqueue);
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index b1e9630..1c8bbf2 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -140,7 +140,7 @@ static int __init init_gfs2_fs(void)
 
 	error = -ENOMEM;
 	gfs_recovery_wq = alloc_workqueue("gfs_recovery",
-					  WQ_NON_REENTRANT | WQ_RESCUER, 0);
+					  WQ_RESCUER | WQ_FREEZEABLE, 0);
 	if (!gfs_recovery_wq)
 		goto fail_wq;
 
-- 
1.7.1.1

