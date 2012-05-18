Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030836Ab2ERCzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:55:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40599 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030741Ab2ERCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:53 -0400
Message-Id: <20120518023259.275988327@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 36/53] ext4: avoid deadlock on sync-mounted FS w/o journal
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit c1bb05a657fb3d8c6179a4ef7980261fae4521d7 upstream.

Processes hang forever on a sync-mounted ext2 file system that
is mounted with the ext4 module (default in Fedora 16).

I can reproduce this reliably by mounting an ext2 partition with
"-o sync" and opening a new file an that partition with vim. vim
will hang in "D" state forever.  The same happens on ext4 without
a journal.

I am attaching a small patch here that solves this issue for me.
In the sync mounted case without a journal,
ext4_handle_dirty_metadata() may call sync_dirty_buffer(), which
can't be called with buffer lock held.

Also move mb_cache_entry_release inside lock to avoid race
fixed previously by 8a2bfdcb ext[34]: EA block reference count racing fix
Note too that ext2 fixed this same problem in 2006 with
b2f49033 [PATCH] fix deadlock in ext2

Signed-off-by: Martin.Wilck@ts.fujitsu.com
[sandeen@redhat.com: move mb_cache_entry_release before unlock, edit commit msg]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1bff752..3369157 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -484,18 +484,19 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
+		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		if (ce)
+			mb_cache_entry_release(ce);
+		unlock_buffer(bh);
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, 1);
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
-		if (ce)
-			mb_cache_entry_release(ce);
 	}
-	unlock_buffer(bh);
 out:
 	ext4_std_error(inode->i_sb, error);
 	return;
-- 
1.7.10



