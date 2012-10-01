Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab2JAXM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:12:56 -0400
Received: from 1wt.eu ([62.212.114.60]:35536 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab2JAXCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:20 -0400
Message-Id: <20121001225201.244836502@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 086/180] ext3: Fix error handling on inode bitmap corruption
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1415dd8705394399d59a3df1ab48d149e1e41e77 upstream.

When insert_inode_locked() fails in ext3_new_inode() it most likely
means inode bitmap got corrupted and we allocated again inode which
is already in use. Also doing unlock_new_inode() during error recovery
is wrong since inode does not have I_NEW set. Fix the problem by jumping
to fail: (instead of fail_drop:) which declares filesystem error and
does not call unlock_new_inode().

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext3/ialloc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index b399912..108f4fc 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -575,8 +575,12 @@ got:
 	if (IS_DIRSYNC(inode))
 		handle->h_sync = 1;
 	if (insert_inode_locked(inode) < 0) {
-		err = -EINVAL;
-		goto fail_drop;
+		/*
+		 * Likely a bitmap corruption causing inode to be allocated
+		 * twice.
+		 */
+		err = -EIO;
+		goto fail;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;
-- 
1.7.2.1.45.g54fbc



