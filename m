Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2KVVQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:16:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:49630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab2KVSkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 78/83] reiserfs: Protect reiserfs_quota_write() with write lock
Date: Wed, 21 Nov 2012 16:42:40 -0800
Message-Id: <20121122004221.003099337@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 361d94a338a3fd0cee6a4ea32bbc427ba228e628 upstream.

Calls into reiserfs journalling code and reiserfs_get_block() need to
be protected with write lock. We remove write lock around calls to high
level quota code in the next patch so these paths would suddently become
unprotected.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2343,7 +2343,9 @@ static ssize_t reiserfs_quota_write(stru
 		tocopy = sb->s_blocksize - offset < towrite ?
 		    sb->s_blocksize - offset : towrite;
 		tmp_bh.b_state = 0;
+		reiserfs_write_lock(sb);
 		err = reiserfs_get_block(inode, blk, &tmp_bh, GET_BLOCK_CREATE);
+		reiserfs_write_unlock(sb);
 		if (err)
 			goto out;
 		if (offset || tocopy != sb->s_blocksize)
@@ -2359,10 +2361,12 @@ static ssize_t reiserfs_quota_write(stru
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


