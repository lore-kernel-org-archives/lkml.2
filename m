Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab0FFOzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:55:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18237 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab0FFOxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:43 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCHv5 05/16] AFFS: clean up dirty flag usage
Date: Sun,  6 Jun 2010 17:50:18 +0300
Message-Id: <1275835829-1478-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:18.0778 (UTC) FILETIME=[003B79A0:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

In 'affs_write_super()': remove ancient and wrong commented code,
remove unneeded 'clean' variable, so the function becomes a bit
cleaner and simpler.

In 'affs_remount(): remove unnecessary SB dirty flag changes.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/affs/super.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index e391eed..ea00518 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -61,24 +61,13 @@ affs_put_super(struct super_block *sb)
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
-		/* redo until bitmap synced */
-		if (clean)
-			sb_mark_clean(sb);
-		else
-			sb_mark_dirty(sb);
-	} else
-		sb_mark_clean(sb);
+	if (!(sb->s_flags & MS_RDONLY))
+		affs_commit_super(sb, 2);
+	sb_mark_clean(sb);
 	unlock_super(sb);
 
-	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
+	pr_debug("AFFS: write_super() at %lu, clean=2\n", get_seconds());
 }
 
 static int
@@ -558,9 +547,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
-		sb_mark_dirty(sb);
-		while (sb_is_dirty(sb))
-			affs_write_super(sb);
+		affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
 		res = affs_init_bitmap(sb, flags);
-- 
1.7.0.1

