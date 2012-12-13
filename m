Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2LMPJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:09:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44023 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2LMOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 016/241] ext4: fix unjournaled inode bitmap modification
Date: Thu, 13 Dec 2012 11:56:21 -0200
Message-Id: <1355407206-17100-17-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit ffb5387e85d528fb6d0d924abfa3fbf0fc484071 upstream.

commit 119c0d4460b001e44b41dcf73dc6ee794b98bd31 changed
ext4_new_inode() such that the inode bitmap was being modified
outside a transaction, which could lead to corruption, and was
discovered when journal_checksum found a bad checksum in the
journal during log replay.

Nix ran into this when using the journal_async_commit mount
option, which enables journal checksumming.  The ensuing
journal replay failures due to the bad checksums led to
filesystem corruption reported as the now infamous
"Apparent serious progressive ext4 data corruption bug"

[ Changed by tytso to only call ext4_journal_get_write_access() only
  when we're fairly certain that we're going to allocate the inode. ]

I've tested this by mounting with journal_checksum and
running fsstress then dropping power; I've also tested by
hacking DM to create snapshots w/o first quiescing, which
allows me to test journal replay repeatedly w/o actually
power-cycling the box.  Without the patch I hit a journal
checksum error every time.  With this fix it survives
many iterations.

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/ialloc.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 76dcdcf..4418852 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -717,6 +717,10 @@ repeat_in_this_group:
 				   "inode=%lu", ino + 1);
 			continue;
 		}
+		BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
+		if (err)
+			goto fail;
 		ext4_lock_group(sb, group);
 		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
 		ext4_unlock_group(sb, group);
@@ -730,6 +734,11 @@ repeat_in_this_group:
 	goto out;
 
 got:
+	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
+	if (err)
+		goto fail;
+
 	/* We may have to initialize the block bitmap if it isn't already */
 	if (ext4_has_group_desc_csum(sb) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -763,11 +772,6 @@ got:
 			goto fail;
 	}
 
-	BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
-	if (err)
-		goto fail;
-
 	BUFFER_TRACE(group_desc_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, group_desc_bh);
 	if (err)
@@ -815,11 +819,6 @@ got:
 	}
 	ext4_unlock_group(sb, group);
 
-	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
-	if (err)
-		goto fail;
-
 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
 	if (err)
-- 
1.7.9.5

