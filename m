Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1ABINX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:13:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:34063 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1ABHVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 011/260] ext4: stop issuing discards if not supported by device
Date: Sun,  2 Jan 2011 02:15:07 -0500
Message-Id: <1293952756-15010-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:18.0537 (UTC) FILETIME=[824B5590:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit a30eec2a8650a77f754e84b2e15f062fe652baa7 upstream.

Turn off issuance of discard requests if the device does
not support it - similar to the action we take for barriers.
This will save a little computation time if a non-discardable
device is mounted with -o discard, and also makes it obvious
that it's not doing what was asked at mount time ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/mballoc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8639d5a6..4f2d3a9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2534,6 +2534,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			 entry->count, entry->group, entry);
 
 		if (test_opt(sb, DISCARD)) {
+			int ret;
 			ext4_fsblk_t discard_block;
 
 			discard_block = entry->start_blk +
@@ -2541,7 +2542,12 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			trace_ext4_discard_blocks(sb,
 					(unsigned long long)discard_block,
 					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
+			ret = sb_issue_discard(sb, discard_block, entry->count);
+			if (ret == EOPNOTSUPP) {
+				ext4_warning(sb,
+					"discard not supported, disabling");
+				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+			}
 		}
 
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
-- 
1.7.3.3

