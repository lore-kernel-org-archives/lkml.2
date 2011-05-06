Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1EFAlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:41:53 -0400
Received: from kroah.org ([198.145.64.141]:37240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432Ab1EFAZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.539134842@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oskar Schirmer <oskar@scara.com>, Andi Kleen <ak@linux.intel.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [115/143] cifs: fix another memleak, in cifs_root_iget
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Oskar Schirmer <oskar@scara.com>

commit a7851ce73b9fdef53f251420e6883cf4f3766534 upstream.

cifs_root_iget allocates full_path through
cifs_build_path_to_root, but fails to kfree it upon
cifs_get_inode_info* failure.

Make all failure exit paths traverse clean up
handling at the end of the function.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/cifs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -688,8 +688,10 @@ struct inode *cifs_root_iget(struct supe
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 						xid, NULL);
 
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (!inode) {
+		inode = ERR_PTR(rc);
+		goto out;
+	}
 
 	if (rc && cifs_sb->tcon->ipc) {
 		cFYI(1, ("ipc connection - fake read inode"));
@@ -700,13 +702,11 @@ struct inode *cifs_root_iget(struct supe
 		inode->i_uid = cifs_sb->mnt_uid;
 		inode->i_gid = cifs_sb->mnt_gid;
 	} else if (rc) {
-		kfree(full_path);
-		_FreeXid(xid);
 		iget_failed(inode);
-		return ERR_PTR(rc);
+		inode = ERR_PTR(rc);
 	}
 
-
+out:
 	kfree(full_path);
 	/* can not call macro FreeXid here since in a void func
 	 * TODO: This is no longer true


