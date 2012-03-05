Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2CEQBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:01:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab2CEQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:41 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 19/19] fs: Refuse to freeze filesystem with open but unlinked files
Date: Mon,  5 Mar 2012 17:01:17 +0100
Message-Id: <1330963277-26336-20-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystem with frozen but unlinked files cannot be forced into
a fully consistent state. Also handling of closing such files on frozen
filesystem is problematic since fput() can be called with mmap_sem held
and protection against frozen filesystem ranks above it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 0830afb..e0f5992 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1415,16 +1415,22 @@ int freeze_super(struct super_block *sb)
 	/* All writers are done so after syncing there won't be dirty data */
 	sync_filesystem(sb);
 
+	/*
+	 * Check whether there are some open unlinked files (since all writers
+	 * are blocked, new ones cannot be created now so the check is
+	 * reliable). In that case filesystem cannot be forced into a
+	 * consistent state so we just bail out.
+	 */
+	if (atomic_long_read(&sb->s_remove_count)) {
+		ret = -EBUSY;
+		goto bail;
+	}
+
 	if (sb->s_op->freeze_fs) {
 		ret = sb->s_op->freeze_fs(sb);
 		if (ret) {
-			printk(KERN_ERR
-				"VFS:Filesystem freeze failed\n");
-			sb->s_writers.frozen = SB_UNFROZEN;
-			smp_wmb();
-			wake_up(&sb->s_writers.wait_unfrozen);
-			deactivate_locked_super(sb);
-			return ret;
+			printk(KERN_ERR "VFS: Filesystem freeze failed\n");
+			goto bail;
 		}
 	}
 	/*
@@ -1434,6 +1440,12 @@ int freeze_super(struct super_block *sb)
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
 	up_write(&sb->s_umount);
 	return 0;
+bail:
+	sb->s_writers.frozen = SB_UNFROZEN;
+	smp_wmb();
+	wake_up(&sb->s_writers.wait_unfrozen);
+	deactivate_locked_super(sb);
+	return ret;
 }
 EXPORT_SYMBOL(freeze_super);
 
-- 
1.7.1

