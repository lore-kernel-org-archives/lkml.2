Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2LCOsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:48:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43761 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932224Ab2LCOgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:22 -0500
Message-Id: <20121203143156.335038811@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 63/89] reiserfs: Protect reiserfs_quota_write() with write lock
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 361d94a338a3fd0cee6a4ea32bbc427ba228e628 upstream.

Calls into reiserfs journalling code and reiserfs_get_block() need to
be protected with write lock. We remove write lock around calls to high
level quota code in the next patch so these paths would suddently become
unprotected.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index e59d6dd..c101704 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2338,7 +2338,9 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 		tocopy = sb->s_blocksize - offset < towrite ?
 		    sb->s_blocksize - offset : towrite;
 		tmp_bh.b_state = 0;
+		reiserfs_write_lock(sb);
 		err = reiserfs_get_block(inode, blk, &tmp_bh, GET_BLOCK_CREATE);
+		reiserfs_write_unlock(sb);
 		if (err)
 			goto out;
 		if (offset || tocopy != sb->s_blocksize)
@@ -2354,10 +2356,12 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
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


