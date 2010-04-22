Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0DVTaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:30:08 -0400
Received: from kroah.org ([198.145.64.141]:41551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab0DVT3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:54 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.532359003@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       maximilian attems <max@stro.at>
Subject: [180/197] ext4: flush delalloc blocks when space is low
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit c8afb44682fcef6273e8b8eb19fab13ddd05b386 upstream.

Creating many small files in rapid succession on a small
filesystem can lead to spurious ENOSPC; on a 104MB filesystem:

for i in `seq 1 22500`; do
    echo -n > $SCRATCH_MNT/$i
    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
done

leads to ENOSPC even though after a sync, 40% of the fs is free
again.

This is because we reserve worst-case metadata for delalloc writes,
and when data is allocated that worst-case reservation is not
usually needed.

When freespace is low, kicking off an async writeback will start
converting that worst-case space usage into something more realistic,
almost always freeing up space to continue.

This resolves the testcase for me, and survives all 4 generic
ENOSPC tests in xfstests.

We'll still need a hard synchronous sync to squeeze out the last bit,
but this fixes things up to a large degree.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3031,11 +3031,18 @@ static int ext4_nonda_switch(struct supe
 	if (2 * free_blocks < 3 * dirty_blocks ||
 		free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
 		/*
-		 * free block count is less that 150% of dirty blocks
-		 * or free blocks is less that watermark
+		 * free block count is less than 150% of dirty blocks
+		 * or free blocks is less than watermark
 		 */
 		return 1;
 	}
+	/*
+	 * Even if we don't switch but are nearing capacity,
+	 * start pushing delalloc when 1/2 of free blocks are dirty.
+	 */
+	if (free_blocks < 2 * dirty_blocks)
+		writeback_inodes_sb_if_idle(sb);
+
 	return 0;
 }
 


