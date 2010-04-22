Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0DVUOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:14:37 -0400
Received: from kroah.org ([198.145.64.141]:59887 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0DVUBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:09 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:14 2010
Message-Id: <20100422195414.427869456@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       maximilian attems <max@stro.at>
Subject: [092/139] ocfs2: set i_mode on disk during acl operations
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Fasheh <mfasheh@suse.com>

commit fcefd25ac89239cb57fa198f125a79ff85468c75 upstream.

ocfs2_set_acl() and ocfs2_init_acl() were setting i_mode on the in-memory
inode, but never setting it on the disk copy. Thus, acls were some times not
getting propagated between nodes. This patch fixes the issue by adding a
helper function ocfs2_acl_set_mode() which does this the right way.
ocfs2_set_acl() and ocfs2_init_acl() are then updated to call
ocfs2_acl_set_mode().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/acl.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -30,6 +30,8 @@
 #include "alloc.h"
 #include "dlmglue.h"
 #include "file.h"
+#include "inode.h"
+#include "journal.h"
 #include "ocfs2_fs.h"
 
 #include "xattr.h"
@@ -166,6 +168,60 @@ static struct posix_acl *ocfs2_get_acl(s
 }
 
 /*
+ * Helper function to set i_mode in memory and disk. Some call paths
+ * will not have di_bh or a journal handle to pass, in which case it
+ * will create it's own.
+ */
+static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
+			      handle_t *handle, umode_t new_mode)
+{
+	int ret, commit_handle = 0;
+	struct ocfs2_dinode *di;
+
+	if (di_bh == NULL) {
+		ret = ocfs2_read_inode_block(inode, &di_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	} else
+		get_bh(di_bh);
+
+	if (handle == NULL) {
+		handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb),
+					   OCFS2_INODE_UPDATE_CREDITS);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			mlog_errno(ret);
+			goto out_brelse;
+		}
+
+		commit_handle = 1;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	inode->i_mode = new_mode;
+	di->i_mode = cpu_to_le16(inode->i_mode);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+out_commit:
+	if (commit_handle)
+		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out_brelse:
+	brelse(di_bh);
+out:
+	return ret;
+}
+
+/*
  * Set the access or default ACL of an inode.
  */
 static int ocfs2_set_acl(handle_t *handle,
@@ -193,9 +249,14 @@ static int ocfs2_set_acl(handle_t *handl
 			if (ret < 0)
 				return ret;
 			else {
-				inode->i_mode = mode;
 				if (ret == 0)
 					acl = NULL;
+
+				ret = ocfs2_acl_set_mode(inode, di_bh,
+							 handle, mode);
+				if (ret)
+					return ret;
+
 			}
 		}
 		break;
@@ -283,6 +344,7 @@ int ocfs2_init_acl(handle_t *handle,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct posix_acl *acl = NULL;
 	int ret = 0;
+	mode_t mode;
 
 	if (!S_ISLNK(inode->i_mode)) {
 		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
@@ -291,12 +353,17 @@ int ocfs2_init_acl(handle_t *handle,
 			if (IS_ERR(acl))
 				return PTR_ERR(acl);
 		}
-		if (!acl)
-			inode->i_mode &= ~current_umask();
+		if (!acl) {
+			mode = inode->i_mode & ~current_umask();
+			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			if (ret) {
+				mlog_errno(ret);
+				goto cleanup;
+			}
+		}
 	}
 	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
 		struct posix_acl *clone;
-		mode_t mode;
 
 		if (S_ISDIR(inode->i_mode)) {
 			ret = ocfs2_set_acl(handle, inode, di_bh,
@@ -313,7 +380,7 @@ int ocfs2_init_acl(handle_t *handle,
 		mode = inode->i_mode;
 		ret = posix_acl_create_masq(clone, &mode);
 		if (ret >= 0) {
-			inode->i_mode = mode;
+			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
 			if (ret > 0) {
 				ret = ocfs2_set_acl(handle, inode,
 						    di_bh, ACL_TYPE_ACCESS,


