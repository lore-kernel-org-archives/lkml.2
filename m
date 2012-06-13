Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2FMAGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:06:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2FMAF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:05:59 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 1/3] eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files
Date: Tue, 12 Jun 2012 17:05:38 -0700
Message-Id: <1339545940-11736-2-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
References: <1338061161.4284.16.camel@lappy>
 <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File operations on /dev/ecryptfs would BUG() when the operations were
performed by processes other than the process that originally opened the
file. This could happen with open files inherited after fork() or file
descriptors passed through IPC mechanisms. Rather than calling BUG(), an
error code can be safely returned in most situations.

In ecryptfs_miscdev_release(), eCryptfs still needs to handle the
release even if the last file reference is being held by a process that
didn't originally open the file. ecryptfs_find_daemon_by_euid() will not
be successful, so a pointer to the daemon is stored in the file's
private_data. The private_data pointer is initialized when the miscdev
file is opened and only used when the file is released.

https://launchpad.net/bugs/994247

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
---
 fs/ecryptfs/miscdev.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 3a06f40..2cd9c3f 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -49,7 +49,10 @@ ecryptfs_miscdev_poll(struct file *file, poll_table *pt)
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
 	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	BUG_ON(rc || !daemon);
+	if (rc || !daemon) {
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
+		return -EINVAL;
+	}
 	mutex_lock(&daemon->mux);
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
@@ -122,6 +125,7 @@ ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 		goto out_unlock_daemon;
 	}
 	daemon->flags |= ECRYPTFS_DAEMON_MISCDEV_OPEN;
+	file->private_data = daemon;
 	atomic_inc(&ecryptfs_num_miscdev_opens);
 out_unlock_daemon:
 	mutex_unlock(&daemon->mux);
@@ -152,9 +156,9 @@ ecryptfs_miscdev_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	BUG_ON(rc || !daemon);
+	if (rc || !daemon)
+		daemon = file->private_data;
 	mutex_lock(&daemon->mux);
-	BUG_ON(daemon->pid != task_pid(current));
 	BUG_ON(!(daemon->flags & ECRYPTFS_DAEMON_MISCDEV_OPEN));
 	daemon->flags &= ~ECRYPTFS_DAEMON_MISCDEV_OPEN;
 	atomic_dec(&ecryptfs_num_miscdev_opens);
@@ -269,8 +273,16 @@ ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 	mutex_lock(&ecryptfs_daemon_hash_mux);
 	/* TODO: Just use file->private_data? */
 	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	BUG_ON(rc || !daemon);
+	if (rc || !daemon) {
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
+		return -EINVAL;
+	}
 	mutex_lock(&daemon->mux);
+	if (task_pid(current) != daemon->pid) {
+		mutex_unlock(&daemon->mux);
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
+		return -EPERM;
+	}
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		rc = 0;
 		mutex_unlock(&ecryptfs_daemon_hash_mux);
@@ -307,9 +319,6 @@ check_list:
 		 * message from the queue; try again */
 		goto check_list;
 	}
-	BUG_ON(euid != daemon->euid);
-	BUG_ON(current_user_ns() != daemon->user_ns);
-	BUG_ON(task_pid(current) != daemon->pid);
 	msg_ctx = list_first_entry(&daemon->msg_ctx_out_queue,
 				   struct ecryptfs_msg_ctx, daemon_out_list);
 	BUG_ON(!msg_ctx);
-- 
1.7.9.5

