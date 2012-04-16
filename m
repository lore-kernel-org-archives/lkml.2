Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2DPQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:17:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2DPQOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:25 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 26/27] fs: Refuse to freeze filesystem with open but unlinked files
Date: Mon, 16 Apr 2012 18:14:04 +0200
Message-Id: <1334592845-22862-27-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystem with frozen but unlinked files cannot be forced into
a fully consistent state. Also handling of closing such files on frozen
filesystem is problematic since fput() can be called with mmap_sem held
and protection against frozen filesystem ranks above it.

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7b2c81c..2bd3632 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1485,16 +1485,22 @@ int freeze_super(struct super_block *sb)
 	smp_wmb();
 	sb_wait_write(sb, SB_FREEZE_FS);
 
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
@@ -1504,6 +1510,12 @@ int freeze_super(struct super_block *sb)
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

