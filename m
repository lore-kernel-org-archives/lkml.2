Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab2GLW7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:59:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162041Ab2GLWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [ 136/187] eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files
Date: Thu, 12 Jul 2012 15:34:52 -0700
Message-Id: <20120712191534.995309638@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 8dc6780587c99286c0d3de747a2946a76989414a upstream.

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
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/miscdev.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -49,7 +49,10 @@ ecryptfs_miscdev_poll(struct file *file,
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
@@ -122,6 +125,7 @@ ecryptfs_miscdev_open(struct inode *inod
 		goto out_unlock_daemon;
 	}
 	daemon->flags |= ECRYPTFS_DAEMON_MISCDEV_OPEN;
+	file->private_data = daemon;
 	atomic_inc(&ecryptfs_num_miscdev_opens);
 out_unlock_daemon:
 	mutex_unlock(&daemon->mux);
@@ -152,9 +156,9 @@ ecryptfs_miscdev_release(struct inode *i
 
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
@@ -269,8 +273,16 @@ ecryptfs_miscdev_read(struct file *file,
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


