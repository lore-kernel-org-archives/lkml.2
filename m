Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab1LPKrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:47:20 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15490 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1LPKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:47:05 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] fs: add ability to attach and to allocate fd for non current tasks
Date: Fri, 16 Dec 2011 13:46:22 +0300
Message-Id: <1324032383-791758-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324032383-791758-1-git-send-email-avagin@openvz.org>
References: <1324032383-791758-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 fs/file.c            |    9 +++++++--
 fs/open.c            |    9 +++++++--
 include/linux/file.h |    4 ++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4c6992d..fbf2879 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -428,9 +428,9 @@ struct files_struct init_files = {
 /*
  * allocate a file descriptor, mark it busy.
  */
-int alloc_fd(unsigned start, unsigned flags)
+int alloc_task_fd(struct task_struct *tsk, unsigned start, unsigned flags)
 {
-	struct files_struct *files = current->files;
+	struct files_struct *files = tsk->files;
 	unsigned int fd;
 	int error;
 	struct fdtable *fdt;
@@ -479,6 +479,11 @@ out:
 	return error;
 }
 
+int alloc_fd(unsigned start, unsigned flags)
+{
+	return alloc_task_fd(current, start, flags);
+}
+
 int get_unused_fd(void)
 {
 	return alloc_fd(0, 0);
diff --git a/fs/open.c b/fs/open.c
index 22c41b5..9d340cc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -864,9 +864,9 @@ EXPORT_SYMBOL(put_unused_fd);
  * will follow.
  */
 
-void fd_install(unsigned int fd, struct file *file)
+void fd_task_install(struct task_struct *tsk, unsigned int fd, struct file *file)
 {
-	struct files_struct *files = current->files;
+	struct files_struct *files = tsk->files;
 	struct fdtable *fdt;
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
@@ -875,6 +875,11 @@ void fd_install(unsigned int fd, struct file *file)
 	spin_unlock(&files->file_lock);
 }
 
+void fd_install(unsigned int fd, struct file *file)
+{
+	return fd_task_install(current, fd, file);
+}
+
 EXPORT_SYMBOL(fd_install);
 
 static inline int build_open_flags(int flags, int mode, struct open_flags *op)
diff --git a/include/linux/file.h b/include/linux/file.h
index 21a7995..0250cf4 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -34,10 +34,14 @@ extern struct file *fget_raw_light(unsigned int fd, int *fput_needed);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern void put_filp(struct file *);
 extern int alloc_fd(unsigned start, unsigned flags);
+struct task_struct;
+extern int alloc_task_fd(struct task_struct *tsk, unsigned start, unsigned flags);
 extern int get_unused_fd(void);
 #define get_unused_fd_flags(flags) alloc_fd(0, (flags))
 extern void put_unused_fd(unsigned int fd);
 
+extern void fd_task_install(struct task_struct *tsk,
+				unsigned int fd, struct file *file);
 extern void fd_install(unsigned int fd, struct file *file);
 
 #endif /* __LINUX_FILE_H */
-- 
1.7.1

