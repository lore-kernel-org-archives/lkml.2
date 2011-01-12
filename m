Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1ALQGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:06:45 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49716 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1ALQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:06:43 -0500
Message-Id: <20110112160625.193147752@szeredi.hu>
References: <20110112160551.722413413@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 12 Jan 2011 17:05:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON
Content-Disposition: inline; filename=vfs-remove-unnecessary-remount-check.patch
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
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2011-01-12 15:47:09.000000000 +0100
+++ linux-2.6/fs/file_table.c	2011-01-12 15:47:15.000000000 +0100
@@ -436,8 +436,11 @@ int fs_may_remount_ro(struct super_block
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
