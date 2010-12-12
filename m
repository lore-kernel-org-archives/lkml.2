Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0LLX6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:58:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0LLXr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:59 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: oskar@scara.com, ak@linux.intel.com, jj@chaosbits.net, sfrench@us.ibm.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [173/223] cifs: fix another memleak, in cifs_root_iget
Message-Id: <20101212234757.E7C5BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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

Index: linux/fs/cifs/inode.c
===================================================================
--- linux.orig/fs/cifs/inode.c
+++ linux/fs/cifs/inode.c
@@ -804,8 +804,10 @@ struct inode *cifs_root_iget(struct supe
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 						xid, NULL);
 
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (!inode) {
+		inode = ERR_PTR(rc);
+		goto out;
+	}
 
 	if (rc && cifs_sb->tcon->ipc) {
 		cFYI(1, "ipc connection - fake read inode");
@@ -816,13 +818,11 @@ struct inode *cifs_root_iget(struct supe
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
