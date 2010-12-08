Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0LHBQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:16:52 -0500
Received: from kroah.org ([198.145.64.141]:33685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab0LHBDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:23 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:44 2010
Message-Id: <20101208005744.344156135@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oskar Schirmer <oskar@scara.com>, Steve French <sfrench@us.ibm.com>
Subject: [229/289] cifs: fix another memleak, in cifs_root_iget
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oskar Schirmer <oskar@scara.com>

commit a7851ce73b9fdef53f251420e6883cf4f3766534 upstream.

cifs_root_iget allocates full_path through
cifs_build_path_to_root, but fails to kfree it upon
cifs_get_inode_info* failure.

Make all failure exit paths traverse clean up
handling at the end of the function.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -835,8 +835,10 @@ struct inode *cifs_root_iget(struct supe
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 						xid, NULL);
 
-	if (!inode)
-		return ERR_PTR(rc);
+	if (!inode) {
+		inode = ERR_PTR(rc);
+		goto out;
+	}
 
 #ifdef CONFIG_CIFS_FSCACHE
 	/* populate tcon->resource_id */
@@ -852,13 +854,11 @@ struct inode *cifs_root_iget(struct supe
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


