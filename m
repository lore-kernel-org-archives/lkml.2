Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab2FGEe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:34:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200Ab2FGEWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:22:14 -0400
Message-Id: <20120607040347.783818534@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:53 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 77/82] vfs: Fix /proc/<tid>/fdinfo/<fd> file handling
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0640113be25d283e0ff77a9f041e1242182387f0 upstream.

Cyrill Gorcunov reports that I broke the fdinfo files with commit
30a08bf2d31d ("proc: move fd symlink i_mode calculations into
tid_fd_revalidate()"), and he's quite right.

The tid_fd_revalidate() function is not just used for the <tid>/fd
symlinks, it's also used for the <tid>/fdinfo/<fd> files, and the
permission model for those are different.

So do the dynamic symlink permission handling just for symlinks, making
the fdinfo files once more appear as the proper regular files they are.

Of course, Al Viro argued (probably correctly) that we shouldn't do the
symlink permission games at all, and make the symlinks always just be
the normal 'lrwxrwxrwx'.  That would have avoided this issue too, but
since somebody noticed that the permissions had changed (which was the
reason for that original commit 30a08bf2d31d in the first place), people
do apparently use this feature.

[ Basically, you can use the symlink permission data as a cheap "fdinfo"
  replacement, since you see whether the file is open for reading and/or
  writing by just looking at st_mode of the symlink.  So the feature
  does make sense, even if the pain it has caused means we probably
  shouldn't have done it to begin with. ]

Reported-and-tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1803,7 +1803,7 @@ static int tid_fd_revalidate(struct dent
 			rcu_read_lock();
 			file = fcheck_files(files, fd);
 			if (file) {
-				unsigned i_mode, f_mode = file->f_mode;
+				unsigned f_mode = file->f_mode;
 
 				rcu_read_unlock();
 				put_files_struct(files);
@@ -1819,12 +1819,14 @@ static int tid_fd_revalidate(struct dent
 					inode->i_gid = 0;
 				}
 
-				i_mode = S_IFLNK;
-				if (f_mode & FMODE_READ)
-					i_mode |= S_IRUSR | S_IXUSR;
-				if (f_mode & FMODE_WRITE)
-					i_mode |= S_IWUSR | S_IXUSR;
-				inode->i_mode = i_mode;
+				if (S_ISLNK(inode->i_mode)) {
+					unsigned i_mode = S_IFLNK;
+					if (f_mode & FMODE_READ)
+						i_mode |= S_IRUSR | S_IXUSR;
+					if (f_mode & FMODE_WRITE)
+						i_mode |= S_IWUSR | S_IXUSR;
+					inode->i_mode = i_mode;
+				}
 
 				security_task_to_inode(task, inode);
 				put_task_struct(task);
@@ -1859,6 +1861,7 @@ static struct dentry *proc_fd_instantiat
 	ei = PROC_I(inode);
 	ei->fd = fd;
 
+	inode->i_mode = S_IFLNK;
 	inode->i_op = &proc_pid_link_inode_operations;
 	inode->i_size = 64;
 	ei->op.proc_get_link = proc_fd_link;


