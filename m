Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab0GAVbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:31:45 -0400
Received: from kroah.org ([198.145.64.141]:33199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111Ab0GAVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:13 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.317074046@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [175/200] NFS: Ensure that we mark the inode as dirty if we exit early from commit
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c5efa5fc91f1f6d1d47e65f39e7ec6d1157c777d upstream.

If we exit from nfs_commit_inode() without ensuring that the COMMIT rpc
call has been completed, we must re-mark the inode as dirty. Otherwise,
future calls to sync_inode() with the WB_SYNC_ALL flag set will fail to
ensure that the data is on the disk.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1386,7 +1386,7 @@ static int nfs_commit_inode(struct inode
 	int res = 0;
 
 	if (!nfs_commit_set_lock(NFS_I(inode), may_wait))
-		goto out;
+		goto out_mark_dirty;
 	spin_lock(&inode->i_lock);
 	res = nfs_scan_commit(inode, &head, 0, 0);
 	spin_unlock(&inode->i_lock);
@@ -1398,9 +1398,18 @@ static int nfs_commit_inode(struct inode
 			wait_on_bit(&NFS_I(inode)->flags, NFS_INO_COMMIT,
 					nfs_wait_bit_killable,
 					TASK_KILLABLE);
+		else
+			goto out_mark_dirty;
 	} else
 		nfs_commit_clear_lock(NFS_I(inode));
-out:
+	return res;
+	/* Note: If we exit without ensuring that the commit is complete,
+	 * we must mark the inode as dirty. Otherwise, future calls to
+	 * sync_inode() with the WB_SYNC_ALL flag set will fail to ensure
+	 * that the data is on the disk.
+	 */
+out_mark_dirty:
+	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 	return res;
 }
 


