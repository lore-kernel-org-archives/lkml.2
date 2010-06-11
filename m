Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0FKPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:09:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:53705 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab0FKPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:09:25 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] AFFS: clean up dirty flag usage
Date: Fri, 11 Jun 2010 18:05:19 +0300
Message-Id: <1276268720-7398-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
References: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 11 Jun 2010 15:09:14.0233 (UTC) FILETIME=[0DCB1690:01CB0978]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

In 'affs_write_super()': remove ancient and wrong commented code,
remove unneeded 'clean' variable, so the function becomes a bit
cleaner and simpler.

In 'affs_remount(): remove unnecessary SB dirty flag changes.

Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/affs/super.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 16a3e47..8447451 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -61,20 +61,13 @@ affs_put_super(struct super_block *sb)
 static void
 affs_write_super(struct super_block *sb)
 {
-	int clean = 2;
-
 	lock_super(sb);
-	if (!(sb->s_flags & MS_RDONLY)) {
-		//	if (sbi->s_bitmap[i].bm_bh) {
-		//		if (buffer_dirty(sbi->s_bitmap[i].bm_bh)) {
-		//			clean = 0;
-		affs_commit_super(sb, clean);
-		sb->s_dirt = !clean;	/* redo until bitmap synced */
-	} else
-		sb->s_dirt = 0;
+	if (!(sb->s_flags & MS_RDONLY))
+		affs_commit_super(sb, 2);
+	sb->s_dirt = 0;
 	unlock_super(sb);
 
-	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
+	pr_debug("AFFS: write_super() at %lu, clean=2\n", get_seconds());
 }
 
 static int
@@ -554,9 +547,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
-		sb->s_dirt = 1;
-		while (sb->s_dirt)
-			affs_write_super(sb);
+		affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
 		res = affs_init_bitmap(sb, flags);
-- 
1.7.0.1

