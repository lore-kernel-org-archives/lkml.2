Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab2LMOnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:43:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2LMOIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 119/241] reiserfs: Protect reiserfs_quota_write() with write lock
Date: Thu, 13 Dec 2012 11:58:04 -0200
Message-Id: <1355407206-17100-120-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 361d94a338a3fd0cee6a4ea32bbc427ba228e628 upstream.

Calls into reiserfs journalling code and reiserfs_get_block() need to
be protected with write lock. We remove write lock around calls to high
level quota code in the next patch so these paths would suddently become
unprotected.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/reiserfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 9b1745f..295caeb8 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2328,7 +2328,9 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 		tocopy = sb->s_blocksize - offset < towrite ?
 		    sb->s_blocksize - offset : towrite;
 		tmp_bh.b_state = 0;
+		reiserfs_write_lock(sb);
 		err = reiserfs_get_block(inode, blk, &tmp_bh, GET_BLOCK_CREATE);
+		reiserfs_write_unlock(sb);
 		if (err)
 			goto out;
 		if (offset || tocopy != sb->s_blocksize)
@@ -2344,10 +2346,12 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 		flush_dcache_page(bh->b_page);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
+		reiserfs_write_lock(sb);
 		reiserfs_prepare_for_journal(sb, bh, 1);
 		journal_mark_dirty(current->journal_info, sb, bh);
 		if (!journal_quota)
 			reiserfs_add_ordered_list(inode, bh);
+		reiserfs_write_unlock(sb);
 		brelse(bh);
 		offset = 0;
 		towrite -= tocopy;
-- 
1.7.9.5

