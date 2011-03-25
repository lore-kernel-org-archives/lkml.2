Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab1CZAE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:04:56 -0400
Received: from kroah.org ([198.145.64.141]:41888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab1CYXxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:13 2011
Message-Id: <20110325234512.995997034@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [49/63] fix deadlock in pivot_root()
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 27cb1572e3e6bb1f8cf6bb3d74c914a87b131792 upstream.

Don't hold vfsmount_lock over the loop traversing ->mnt_parent;
do check_mnt(new.mnt) under namespace_sem instead; combined with
namespace_sem held over all that code it'll guarantee the stability
of ->mnt_parent chain all the way to the root.

Doing check_mnt() outside of namespace_sem in case of pivot_root()
is wrong anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2469,9 +2469,6 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	error = user_path_dir(new_root, &new);
 	if (error)
 		goto out0;
-	error = -EINVAL;
-	if (!check_mnt(new.mnt))
-		goto out1;
 
 	error = user_path_dir(put_old, &old);
 	if (error)
@@ -2491,7 +2488,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		IS_MNT_SHARED(new.mnt->mnt_parent) ||
 		IS_MNT_SHARED(root.mnt->mnt_parent))
 		goto out2;
-	if (!check_mnt(root.mnt))
+	if (!check_mnt(root.mnt) || !check_mnt(new.mnt))
 		goto out2;
 	error = -ENOENT;
 	if (cant_mount(old.dentry))
@@ -2515,19 +2512,19 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		goto out2; /* not attached */
 	/* make sure we can reach put_old from new_root */
 	tmp = old.mnt;
-	br_write_lock(vfsmount_lock);
 	if (tmp != new.mnt) {
 		for (;;) {
 			if (tmp->mnt_parent == tmp)
-				goto out3; /* already mounted on put_old */
+				goto out2; /* already mounted on put_old */
 			if (tmp->mnt_parent == new.mnt)
 				break;
 			tmp = tmp->mnt_parent;
 		}
 		if (!is_subdir(tmp->mnt_mountpoint, new.dentry))
-			goto out3;
+			goto out2;
 	} else if (!is_subdir(old.dentry, new.dentry))
-		goto out3;
+		goto out2;
+	br_write_lock(vfsmount_lock);
 	detach_mnt(new.mnt, &parent_path);
 	detach_mnt(root.mnt, &root_parent);
 	/* mount old root on put_old */
@@ -2550,9 +2547,6 @@ out1:
 	path_put(&new);
 out0:
 	return error;
-out3:
-	br_write_unlock(vfsmount_lock);
-	goto out2;
 }
 
 static void __init init_mount_tree(void)


