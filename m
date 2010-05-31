Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0EaPlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:41:15 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:49428 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611Ab0EaPlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:41:12 -0400
Subject: Re: 2.6.34 nfs fsync() deadlock
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linux NFS Mailing List <nfs@lists.sourceforge.net>
In-Reply-To: <87r5ksjfql.fsf@spindle.srvr.nix>
References: <87r5ksjfql.fsf@spindle.srvr.nix>
Content-Type: multipart/mixed; boundary="=-PMyGiMX1AIv+1Zrib0Fj"
Date: Mon, 31 May 2010 11:41:07 -0400
Message-ID: <1275320467.5038.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 2 sum rcpts/h 5 sum msgs/h 2 total rcpts 405 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 64D3CC5F58C8A932EE4CE399A21184A6C0C2FD1F
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 192 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PMyGiMX1AIv+1Zrib0Fj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2010-05-31 at 15:41 +0100, Nix wrote:
> I just got a deadlock while doing a postgresql 'make check' on an NFSv3
> TCP mount (the server is Linux 2.6.34 as well; the underlying filesystem
> is ext4). This testsuite is notable for doing a lot of things in
> parallel, each of which is generally doing a lot of fsync()ing.
> 
> /proc/mounts for the filesystem of discourse:
> 
> package.srvr.nix:/usr/src /usr/src nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.14.15,mountvers=3,mountport=50892,mountproto=udp,addr=192.168.14.15 0 0
> 
> /etc/exports for it on the server:
> 
> /usr/src mutilate(rw,no_root_squash,no_subtree_check,async)
> 
> dmesg:

Can you see if the following 2 attached patches (already sent to
stable@kernel.org) suffice to fix the hang?

Cheers
  Trond

--=-PMyGiMX1AIv+1Zrib0Fj
Content-Type: text/x-patch; name="0001-NFS-Ensure-that-we-mark-the-inode-as-dirty-if-we-exi.patch"; charset="UTF-8"
Content-Description: 
Content-Disposition: inline; filename*0=0001-NFS-Ensure-that-we-mark-the-inode-as-dirty-if-we-exi.pat; filename*1=ch
Content-Transfer-Encoding: 7bit

>From 0b574497e05f62fd49cfe26f1b97e3669525446c Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 22 May 2010 11:49:19 -0400
Subject: [PATCH] NFS: Ensure that we mark the inode as dirty if we exit early from commit

commit c5efa5fc91f1f6d1d47e65f39e7ec6d1157c777d upstream

If we exit from nfs_commit_inode() without ensuring that the COMMIT rpc
call has been completed, we must re-mark the inode as dirty. Otherwise,
future calls to sync_inode() with the WB_SYNC_ALL flag set will fail to
ensure that the data is on the disk.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
Please apply for 2.6.34 stable series

 fs/nfs/write.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 3aea3ca..b8a6d7a 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1386,7 +1386,7 @@ static int nfs_commit_inode(struct inode *inode, int how)
 	int res = 0;
 
 	if (!nfs_commit_set_lock(NFS_I(inode), may_wait))
-		goto out;
+		goto out_mark_dirty;
 	spin_lock(&inode->i_lock);
 	res = nfs_scan_commit(inode, &head, 0, 0);
 	spin_unlock(&inode->i_lock);
@@ -1398,9 +1398,18 @@ static int nfs_commit_inode(struct inode *inode, int how)
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
 
-- 
1.7.0.1


--=-PMyGiMX1AIv+1Zrib0Fj
Content-Type: text/x-patch; name="0002-NFS-Fix-another-nfs_wb_page-deadlock.patch"; charset="UTF-8"
Content-Description: 
Content-Disposition: inline; filename="0002-NFS-Fix-another-nfs_wb_page-deadlock.patch"
Content-Transfer-Encoding: 7bit

>From ec9860a19aecb9ca691156d21af9e1865d9c0a28 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sun, 23 May 2010 14:37:02 -0400
Subject: [PATCH] NFS: Fix another nfs_wb_page() deadlock

commit 0522f6adedd2736cbca3c0e16ca51df668993eee upstream

J.R. Okajima reports that the call to sync_inode() in nfs_wb_page() can
deadlock with other writeback flush calls. It boils down to the fact
that we cannot ever call writeback_single_inode() while holding a page
lock (even if we do set nr_to_write to zero) since another process may
already be waiting in the call to do_writepages(), and so will deny us
the I_SYNC lock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
Please apply to 2.6.34 stable series

 fs/nfs/write.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index b8a6d7a..91679e2 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1518,14 +1518,17 @@ int nfs_wb_page(struct inode *inode, struct page *page)
 	};
 	int ret;
 
-	while(PagePrivate(page)) {
+	for (;;) {
 		wait_on_page_writeback(page);
 		if (clear_page_dirty_for_io(page)) {
 			ret = nfs_writepage_locked(page, &wbc);
 			if (ret < 0)
 				goto out_error;
+			continue;
 		}
-		ret = sync_inode(inode, &wbc);
+		if (!PagePrivate(page))
+			break;
+		ret = nfs_commit_inode(inode, FLUSH_SYNC);
 		if (ret < 0)
 			goto out_error;
 	}
-- 
1.7.0.1


--=-PMyGiMX1AIv+1Zrib0Fj--

