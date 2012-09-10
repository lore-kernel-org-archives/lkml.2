Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2IJEfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:35:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39513 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJEfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:35:19 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:35:18 +0800
Message-ID: <CAPgLHd8agN_sjuYzWBQJqMs3gkStW92UPeboGEN7si1D8S-TKg@mail.gmail.com>
Subject: [PATCH] ocfs2: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: yongjun_wei@trendmicro.com.cn, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ocfs2/move_extents.c | 3 ++-
 fs/ocfs2/journal.c      | 3 ++-
 fs/ocfs2/dlmglue.c      | 15 ++++++++++-----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6083432..c7631ee 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -975,11 +975,12 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct inode *inode = context->inode;
 	struct ocfs2_dinode *di;
 	struct buffer_head *di_bh = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 
 	if (!inode)
 		return -ENOENT;
 
+	osb = OCFS2_SB(inode->i_sb);
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 2dd36af..a0c2e8a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -340,11 +340,12 @@ finally:
 
 handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 {
-	journal_t *journal = osb->journal->j_journal;
+	journal_t *journal;
 	handle_t *handle;
 
 	BUG_ON(!osb || !osb->journal->j_journal);
 
+	journal = osb->journal->j_journal;
 	if (ocfs2_is_hard_readonly(osb))
 		return ERR_PTR(-EROFS);
 

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..65fc2f6 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1596,7 +1596,7 @@ static int ocfs2_create_new_lock(struct ocfs2_super *osb,
 int ocfs2_create_new_inode_locks(struct inode *inode)
 {
 	int ret;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 
 	BUG_ON(!inode);
 	BUG_ON(!ocfs2_inode_is_new(inode));
@@ -1611,6 +1611,7 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	 * on a resource which has an invalid one -- we'll set it
 	 * valid when we release the EX. */
 
+	osb = OCFS2_SB(inode->i_sb);
 	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_rw_lockres, 1, 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -1641,7 +1642,7 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 {
 	int status, level;
 	struct ocfs2_lock_res *lockres;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 
 	BUG_ON(!inode);
 
@@ -1649,6 +1650,7 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
 
+	osb = OCFS2_SB(inode->i_sb);
 	if (ocfs2_mount_local(osb))
 		return 0;
 
@@ -1685,13 +1687,14 @@ int ocfs2_open_lock(struct inode *inode)
 {
 	int status = 0;
 	struct ocfs2_lock_res *lockres;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 
 	BUG_ON(!inode);
 
 	mlog(0, "inode %llu take PRMODE open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
+	osb = OCFS2_SB(inode->i_sb);
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
 		goto out;
 
@@ -1710,7 +1713,7 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 {
 	int status = 0, level;
 	struct ocfs2_lock_res *lockres;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 
 	BUG_ON(!inode);
 
@@ -1718,6 +1721,7 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
 
+	osb = OCFS2_SB(inode->i_sb);
 	if (ocfs2_is_hard_readonly(osb)) {
 		if (write)
 			status = -EROFS;
@@ -2288,7 +2292,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	int status, level, acquired;
 	u32 dlm_flags;
 	struct ocfs2_lock_res *lockres = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 	struct buffer_head *local_bh = NULL;
 
 	BUG_ON(!inode);
@@ -2299,6 +2303,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 
 	status = 0;
 	acquired = 0;
+	osb = OCFS2_SB(inode->i_sb);
 	/* We'll allow faking a readonly metadata lock for
 	 * rodevices. */
 	if (ocfs2_is_hard_readonly(osb)) {


