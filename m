Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2GPBbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:31:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:45175 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab2GPBaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:30:25 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/4] nilfs2: fix timing issue between rmcp and chcp ioctls
Date: Mon, 16 Jul 2012 10:05:25 +0900
Message-Id: <1342400726-30670-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Mon, 16 Jul 2012 10:30:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checkpoint deletion ioctl (rmcp ioctl) has potential for breaking
snapshot because it is not fully exclusive with checkpoint mode change
ioctl (chcp ioctl).

The rmcp ioctl first tests if the specified checkpoint is a snapshot
or not within nilfs_cpfile_delete_checkpoint function, and then calls
nilfs_cpfile_delete_checkpoints function to actually invalidate the
checkpoint only if it's not a snapshot.  However, the checkpoint can
be changed into a snapshot by the chcp ioctl between these two
operations.  In that case, calling nilfs_cpfile_delete_checkpoints()
wrongly invalidates the snapshot, which leads to snapshot list
corruption and snapshot count mismatch.

This fixes the issue by changing nilfs_cpfile_delete_checkpoints() so
that it reconfirms the target checkpoints are snapshot or not.

This second check is exclusive with the chcp operation since
it is protected by an existing semaphore.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index dab5c4c..deaa3d3 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -286,7 +286,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	__u64 cno;
 	void *kaddr;
 	unsigned long tnicps;
-	int ret, ncps, nicps, count, i;
+	int ret, ncps, nicps, nss, count, i;
 
 	if (unlikely(start == 0 || start > end)) {
 		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
@@ -301,6 +301,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	if (ret < 0)
 		goto out_sem;
 	tnicps = 0;
+	nss = 0;
 
 	for (cno = start; cno < end; cno += ncps) {
 		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, end);
@@ -318,8 +319,9 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 			cpfile, cno, cp_bh, kaddr);
 		nicps = 0;
 		for (i = 0; i < ncps; i++, cp = (void *)cp + cpsz) {
-			WARN_ON(nilfs_checkpoint_snapshot(cp));
-			if (!nilfs_checkpoint_invalid(cp)) {
+			if (nilfs_checkpoint_snapshot(cp)) {
+				nss++;
+			} else if (!nilfs_checkpoint_invalid(cp)) {
 				nilfs_checkpoint_set_invalid(cp);
 				nicps++;
 			}
@@ -364,6 +366,8 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	}
 
 	brelse(header_bh);
+	if (nss > 0)
+		ret = -EBUSY;
 
  out_sem:
 	up_write(&NILFS_MDT(cpfile)->mi_sem);
-- 
1.7.9.3

