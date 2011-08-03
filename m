Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1HCKsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:48:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1HCKsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:48:08 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
        hch@infradead.org, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 4/4] vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON
Date: Wed,  3 Aug 2011 12:48:41 +0200
Message-Id: <1312368521-7911-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
References: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Now a successful sb_prepare_remount_readonly() should ensure that no
writable files remain for this superblock.  So turn this check into a
WARN_ON.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/file_table.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index c322794..dc9f437 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -486,8 +486,11 @@ int fs_may_remount_ro(struct super_block *sb)
 		if (inode->i_nlink == 0)
 			goto too_bad;
 
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
+		/*
+		 * Writable file?
+		 * Should be caught by sb_prepare_remount_readonly().
+		 */
+		if (WARN_ON(S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE)))
 			goto too_bad;
 	} while_file_list_for_each_entry;
 	lg_global_unlock(files_lglock);
-- 
1.7.3.4

