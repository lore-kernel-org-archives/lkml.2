Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab0HLAKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:10:09 -0400
Received: from kroah.org ([198.145.64.141]:48010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933318Ab0HLAJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:09:09 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:18 2010
Message-Id: <20100812000618.864595126@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [67/67] ext4: fix freeze deadlock under IO
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@sandeen.net>

commit 437f88cc031ffe7f37f3e705367f4fe1f4be8b0f upstream.

Commit 6b0310fbf087ad6 caused a regression resulting in deadlocks
when freezing a filesystem which had active IO; the vfs_check_frozen
level (SB_FREEZE_WRITE) did not let the freeze-related IO syncing
through.  Duh.

Changing the test to FREEZE_TRANS should let the normal freeze
syncing get through the fs, but still block any transactions from
starting once the fs is completely frozen.

I tested this by running fsstress in the background while periodically
snapshotting the fs and running fsck on the result.  I ran into
occasional deadlocks, but different ones.  I think this is a
fine fix for the problem at hand, and the other deadlocky things
will need more investigation.

Reported-by: Phillip Susi <psusi@cfl.rr.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,7 +241,7 @@ handle_t *ext4_journal_start_sb(struct s
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	vfs_check_frozen(sb, SB_FREEZE_TRANS);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3491,7 +3491,7 @@ int ext4_force_commit(struct super_block
 
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_WRITE);
+		vfs_check_frozen(sb, SB_FREEZE_TRANS);
 		ret = ext4_journal_force_commit(journal);
 	}
 


