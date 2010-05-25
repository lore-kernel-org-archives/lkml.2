Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0EYNyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:54:23 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35370 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab0EYNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:51:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Subject: [PATCHv4 03/17] BFS: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:48:58 +0300
Message-Id: <1274795352-3551-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:38.0579 (UTC) FILETIME=[4205A430:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Tigran A. Aivazian <tigran@aivazian.fsnet.co.uk>
---
 fs/bfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index f22a7d3..080115e 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -223,7 +223,7 @@ static int bfs_sync_fs(struct super_block *sb, int wait)
 
 	mutex_lock(&info->bfs_lock);
 	mark_buffer_dirty(info->si_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	mutex_unlock(&info->bfs_lock);
 
 	return 0;
@@ -234,7 +234,7 @@ static void bfs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		bfs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void bfs_put_super(struct super_block *s)
@@ -246,7 +246,7 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (is_sb_dirty(s))
 		bfs_write_super(s);
 
 	brelse(info->si_sbh);
@@ -474,7 +474,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	brelse(bh);
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
-		s->s_dirt = 1;
+		mark_sb_dirty(s);
 	} 
 	dump_imap("read_super", s);
 	return 0;
-- 
1.6.6.1

