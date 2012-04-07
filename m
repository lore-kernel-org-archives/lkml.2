Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2DGTC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 15:02:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43746 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2DGTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 15:02:56 -0400
Date: Sat, 7 Apr 2012 22:02:52 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] proc: pass "fd" by value in /proc/*/{fd,fdinfo} code
Message-ID: <20120407190252.GB5946@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass "fd" directly, not via pointer -- one less memory read.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1836,7 +1836,7 @@ static const struct dentry_operations tid_fd_dentry_operations =
 static struct dentry *proc_fd_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(const unsigned *)ptr;
+	unsigned fd = (unsigned long)ptr;
 	struct file *file;
 	struct files_struct *files;
  	struct inode *inode;
@@ -1900,7 +1900,7 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 	if (fd == ~0U)
 		goto out;
 
-	result = instantiate(dir, dentry, task, &fd);
+	result = instantiate(dir, dentry, task, (void *)(unsigned long)fd);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -1952,7 +1952,7 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 				len = snprintf(name, sizeof(name), "%d", fd);
 				rv = proc_fill_cache(filp, dirent, filldir,
 						     name, len, instantiate, p,
-						     &fd);
+						     (void *)(unsigned long)fd);
 				if (rv < 0)
 					goto out_fd_loop;
 				rcu_read_lock();
@@ -2375,7 +2375,7 @@ static const struct inode_operations proc_fd_inode_operations = {
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(unsigned *)ptr;
+	unsigned fd = (unsigned long)ptr;
  	struct inode *inode;
  	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-ENOENT);
