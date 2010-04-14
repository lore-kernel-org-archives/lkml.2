Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0DNMir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:38:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:47345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0DNMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:38:43 -0400
From: Jan Blunck <jblunck@suse.de>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 3/7] ext2: Remove duplicate code from ext2_sync_fs()
Date: Wed, 14 Apr 2010 14:38:35 +0200
Message-Id: <1271248719-21488-4-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1271248719-21488-1-git-send-email-jblunck@suse.de>
References: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending in the state (valid or unchecked) of the filesystem either
ext2_sync_super() or ext2_commit_super() is called. If the filesystem is
currently valid (it is checked), we first mark it unchecked and afterwards
duplicate the work that ext2_sync_super() is doing later. Therefore this
patch removes the duplicate code and calls ext2_sync_super() directly after
marking the filesystem unchecked.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/super.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b205003..09a88bf 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1163,16 +1163,9 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
 	lock_kernel();
-	ext2_clear_super_error(sb);
-
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
-		es->s_free_blocks_count =
-			cpu_to_le32(ext2_count_free_blocks(sb));
-		es->s_free_inodes_count =
-			cpu_to_le32(ext2_count_free_inodes(sb));
-		es->s_wtime = cpu_to_le32(get_seconds());
 		ext2_sync_super(sb, es);
 	} else {
 		ext2_commit_super(sb, es);
-- 
1.6.4.2

