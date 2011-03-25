Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab1CYXxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:53:24 -0400
Received: from kroah.org ([198.145.64.141]:41990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab1CYXxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:14 2011
Message-Id: <20110325234514.031685470@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [59/63] NFS: Fix a hang/infinite loop in nfs_wb_page()
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b8413f98f997bb3ed7327e6d7117e7e91ce010c3 upstream.

When one of the two waits in nfs_commit_inode() is interrupted, it
returns a non-negative value, which causes nfs_wb_page() to think
that the operation was successful causing it to busy-loop rather
than exiting.
It also causes nfs_file_fsync() to incorrectly report the file as
being successfully committed to disk.

This patch fixes both problems by ensuring that we return an error
if the attempts to wait fail.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1214,13 +1214,17 @@ int nfs_writeback_done(struct rpc_task *
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
 static int nfs_commit_set_lock(struct nfs_inode *nfsi, int may_wait)
 {
+	int ret;
+
 	if (!test_and_set_bit(NFS_INO_COMMIT, &nfsi->flags))
 		return 1;
-	if (may_wait && !out_of_line_wait_on_bit_lock(&nfsi->flags,
-				NFS_INO_COMMIT, nfs_wait_bit_killable,
-				TASK_KILLABLE))
-		return 1;
-	return 0;
+	if (!may_wait)
+		return 0;
+	ret = out_of_line_wait_on_bit_lock(&nfsi->flags,
+				NFS_INO_COMMIT,
+				nfs_wait_bit_killable,
+				TASK_KILLABLE);
+	return (ret < 0) ? ret : 1;
 }
 
 static void nfs_commit_clear_lock(struct nfs_inode *nfsi)
@@ -1396,9 +1400,10 @@ int nfs_commit_inode(struct inode *inode
 {
 	LIST_HEAD(head);
 	int may_wait = how & FLUSH_SYNC;
-	int res = 0;
+	int res;
 
-	if (!nfs_commit_set_lock(NFS_I(inode), may_wait))
+	res = nfs_commit_set_lock(NFS_I(inode), may_wait);
+	if (res <= 0)
 		goto out_mark_dirty;
 	spin_lock(&inode->i_lock);
 	res = nfs_scan_commit(inode, &head, 0, 0);
@@ -1407,12 +1412,14 @@ int nfs_commit_inode(struct inode *inode
 		int error = nfs_commit_list(inode, &head, how);
 		if (error < 0)
 			return error;
-		if (may_wait)
-			wait_on_bit(&NFS_I(inode)->flags, NFS_INO_COMMIT,
-					nfs_wait_bit_killable,
-					TASK_KILLABLE);
-		else
+		if (!may_wait)
 			goto out_mark_dirty;
+		error = wait_on_bit(&NFS_I(inode)->flags,
+				NFS_INO_COMMIT,
+				nfs_wait_bit_killable,
+				TASK_KILLABLE);
+		if (error < 0)
+			return error;
 	} else
 		nfs_commit_clear_lock(NFS_I(inode));
 	return res;


