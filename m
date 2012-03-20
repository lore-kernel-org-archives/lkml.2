Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab2CTOlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:41:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:13019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759756Ab2CTOlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141907357"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ted Tso <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 2/9] ext4: write superblock only once on unmount
Date: Tue, 20 Mar 2012 16:41:22 +0200
Message-Id: <1332254489-2300-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

In some rather rare cases it is possible that ext4 may the superblock to the
media twice. This patch makes sure this does not happen. This should speed up
unmounting in those cases.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..c1f5111 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -808,9 +808,6 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
-	if (sb->s_dirt)
-		ext4_commit_super(sb, 1);
-
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -827,8 +824,10 @@ static void ext4_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		ext4_commit_super(sb, 1);
 	}
+	if (sb->s_dirt || !(sb->s_flags & MS_RDONLY))
+		ext4_commit_super(sb, 1);
+
 	if (sbi->s_proc) {
 		remove_proc_entry(sb->s_id, ext4_proc_root);
 	}
-- 
1.7.7.6

