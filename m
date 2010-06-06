Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab0FFOxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18233 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934010Ab0FFOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:35 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 11/16] ext2: fix race condition in marking SB dirty
Date: Sun,  6 Jun 2010 17:50:24 +0300
Message-Id: <1275835829-1478-12-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:30.0934 (UTC) FILETIME=[077A5560:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When synchronizing the superblock, ext2 first initiates the SB write
(a) and then marks the superblock as clean (b). However, meanwhile
(between (a) and (b)) someone else can modify the superblock and
mark it as dirty. This would be a race condition, and the result
would be that we'd end up with a modified superblock which would
nevertheless be marked as clean (because of (b)). This means that
'sync_supers()' would never call our '->write_super()', at least
not until yet another SB change happens.

This patch fixes this race condition by marking the superblock as
clean before initiating the write operation.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 39eb5df..611d4c4 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1145,6 +1145,7 @@ static void ext2_clear_super_error(struct super_block *sb)
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait)
 {
+	sb_mark_clean(sb);
 	ext2_clear_super_error(sb);
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
@@ -1155,7 +1156,6 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	if (wait)
 		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb_mark_clean(sb);
 }
 
 /*
-- 
1.7.0.1

