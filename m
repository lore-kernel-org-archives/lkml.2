Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0G3RbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:31:11 -0400
Received: from kroah.org ([198.145.64.141]:52006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785Ab0G3RTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:10 2010
Message-Id: <20100730171510.200729949@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [117/165] ext4: stop issuing discards if not supported by device
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit a30eec2a8650a77f754e84b2e15f062fe652baa7 upstream (as of v2.6.34-git13)

Turn off issuance of discard requests if the device does
not support it - similar to the action we take for barriers.
This will save a little computation time if a non-discardable
device is mounted with -o discard, and also makes it obvious
that it's not doing what was asked at mount time ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2536,6 +2536,7 @@ static void release_blocks_on_commit(jou
 			 entry->count, entry->group, entry);
 
 		if (test_opt(sb, DISCARD)) {
+			int ret;
 			ext4_fsblk_t discard_block;
 
 			discard_block = entry->start_blk +
@@ -2543,7 +2544,12 @@ static void release_blocks_on_commit(jou
 			trace_ext4_discard_blocks(sb,
 					(unsigned long long)discard_block,
 					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
+			ret = sb_issue_discard(sb, discard_block, entry->count);
+			if (ret == EOPNOTSUPP) {
+				ext4_warning(sb, __func__,
+					"discard not supported, disabling");
+				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+			}
 		}
 
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);


