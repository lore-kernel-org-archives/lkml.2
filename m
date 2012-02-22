Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2BVBtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:49:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab2BVBsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:48:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.241.170 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/36] block: ioc_task_link() can't fail
Date: Tue, 21 Feb 2012 17:46:59 -0800
Message-Id: <1329875223-5102-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioc_task_link() is used to share %current's ioc on clone.  If
%current->io_context is set, %current is guaranteed to have refcount
on the ioc and, thus, ioc_task_link() can't fail.

Replace error checking in ioc_task_link() with WARN_ON_ONCE() and make
it just increment refcount and nr_tasks.

-v2: Description typo fix (Vivek).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/iocontext.h |   16 +++++-----------
 kernel/fork.c             |    5 ++---
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 1a30180..81a8870 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -120,18 +120,12 @@ struct io_context {
 	struct work_struct release_work;
 };
 
-static inline struct io_context *ioc_task_link(struct io_context *ioc)
+static inline void ioc_task_link(struct io_context *ioc)
 {
-	/*
-	 * if ref count is zero, don't allow sharing (ioc is going away, it's
-	 * a race).
-	 */
-	if (ioc && atomic_long_inc_not_zero(&ioc->refcount)) {
-		atomic_inc(&ioc->nr_tasks);
-		return ioc;
-	}
-
-	return NULL;
+	WARN_ON_ONCE(atomic_long_read(&ioc->refcount) <= 0);
+	WARN_ON_ONCE(atomic_read(&ioc->nr_tasks) <= 0);
+	atomic_long_inc(&ioc->refcount);
+	atomic_inc(&ioc->nr_tasks);
 }
 
 struct task_struct;
diff --git a/kernel/fork.c b/kernel/fork.c
index b77fd55..a1b6327 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -901,9 +901,8 @@ static int copy_io(unsigned long clone_flags, struct task_struct *tsk)
 	 * Share io context with parent, if CLONE_IO is set
 	 */
 	if (clone_flags & CLONE_IO) {
-		tsk->io_context = ioc_task_link(ioc);
-		if (unlikely(!tsk->io_context))
-			return -ENOMEM;
+		ioc_task_link(ioc);
+		tsk->io_context = ioc;
 	} else if (ioprio_valid(ioc->ioprio)) {
 		new_ioc = get_task_io_context(tsk, GFP_KERNEL, NUMA_NO_NODE);
 		if (unlikely(!new_ioc))
-- 
1.7.7.3

