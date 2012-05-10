Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2EJDNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:13:09 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36796 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab2EJDIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:08:54 -0400
Date: Wed, 9 May 2012 23:08:49 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 03/16] Revert "rw_semaphore: remove
 up/down_read_non_owner"
Message-ID: <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 11b80f459adaf91a712f95e7734a17655a36bf30.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/rwsem.h |   10 ++++++++++
 kernel/rwsem.c        |   16 ++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 63d4065..5f0dc75 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -126,9 +126,19 @@ extern void downgrade_write(struct rw_semaphore *sem);
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
index b152f74..66de558 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -117,6 +117,15 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 
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
@@ -127,6 +136,13 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 
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
1.7.9.rc2

