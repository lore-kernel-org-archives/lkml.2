Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332Ab2KBRG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:06:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:33090 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761120Ab2KBRGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:06:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nix <nix@esperi.org.uk>, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 01/11] ext4: fix unjournaled inode bitmap modification
Date: Fri,  2 Nov 2012 10:06:36 -0700
Message-Id: <20121102170314.310041730@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170314.204845540@linuxfoundation.org>
References: <20121102170314.204845540@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -697,6 +697,10 @@ repeat_in_this_group:
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
@@ -710,6 +714,11 @@ repeat_in_this_group:
 	goto out;
 
 got:
+	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
+	if (err)
+		goto fail;
+
 	/* We may have to initialize the block bitmap if it isn't already */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -742,11 +751,6 @@ got:
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
@@ -789,11 +793,6 @@ got:
 		ext4_unlock_group(sb, group);
 	}
 
-	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
-	if (err)
-		goto fail;
-
 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
 	if (err)


