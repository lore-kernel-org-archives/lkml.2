Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0DVUO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:14:59 -0400
Received: from kroah.org ([198.145.64.141]:59879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0DVUBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:06 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:14 2010
Message-Id: <20100422195414.163345482@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [090/139] fix NFS4 handling of mountpoint stat
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 462d60577a997aa87c935ae4521bd303733a9f2b upstream.

RFC says we need to follow the chain of mounts if there's more
than one stacked on that point.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2121,9 +2121,15 @@ out_acl:
 		 * and this is the root of a cross-mounted filesystem.
 		 */
 		if (ignore_crossmnt == 0 &&
-		    exp->ex_path.mnt->mnt_root->d_inode == dentry->d_inode) {
-			err = vfs_getattr(exp->ex_path.mnt->mnt_parent,
-				exp->ex_path.mnt->mnt_mountpoint, &stat);
+		    dentry == exp->ex_path.mnt->mnt_root) {
+			struct path path = exp->ex_path;
+			path_get(&path);
+			while (follow_up(&path)) {
+				if (path.dentry != path.mnt->mnt_root)
+					break;
+			}
+			err = vfs_getattr(path.mnt, path.dentry, &stat);
+			path_put(&path);
 			if (err)
 				goto out_nfserr;
 		}


