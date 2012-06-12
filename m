Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2FLPnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:43:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59313 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2FLPjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:45 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 01/16] Revert "rw_semaphore: remove up/down_read_non_owner"
Date: Tue, 12 Jun 2012 08:39:07 -0700
Message-Id: <1339515562-14638-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 11b80f459adaf91a712f95e7734a17655a36bf30.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/rwsem.h |   10 ++++++++++
 kernel/rwsem.c        |   16 ++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 54bd7cd..ddfe46d 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -125,9 +125,19 @@ extern void downgrade_write(struct rw_semaphore *sem);
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
+/*
+ * Take/release a lock when not the owner will release it.
+ *
+ * [ This API should be avoided as much as possible - the
+ *   proper abstraction for this case is completions. ]
+ */
+extern void down_read_non_owner(struct rw_semaphore *sem);
+extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
+# define down_read_non_owner(sem)		down_read(sem)
+# define up_read_non_owner(sem)			up_read(sem)
 #endif
 
 #endif /* _LINUX_RWSEM_H */
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index 6850f53..78b7915 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -116,6 +116,15 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 
 EXPORT_SYMBOL(down_read_nested);
 
+void down_read_non_owner(struct rw_semaphore *sem)
+{
+	might_sleep();
+
+	__down_read(sem);
+}
+
+EXPORT_SYMBOL(down_read_non_owner);
+
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
@@ -126,6 +135,13 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 
 EXPORT_SYMBOL(down_write_nested);
 
+void up_read_non_owner(struct rw_semaphore *sem)
+{
+	__up_read(sem);
+}
+
+EXPORT_SYMBOL(up_read_non_owner);
+
 #endif
 
 
-- 
1.7.9.3.327.g2980b

