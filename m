Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1K3CPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:15:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40807 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:15:28 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/28] super: Use current logging styles
Date: Tue, 29 Nov 2011 18:14:03 -0800
Message-Id: <da0ec73777428a77a91abf92a2baf15fc4815d7c.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>
Add printk level KERN_CRIT to "busy inodes after dismount" message.
Coalesce long format.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/super.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index b83d1c1..23ff118 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -20,6 +20,8 @@
  *  Heavily rewritten for 'one fs - one tree' dcache architecture. AV, Mar 2000
  */
 
+#define pr_fmt(fmt) "VFS: " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/acct.h>
@@ -393,9 +395,8 @@ void generic_shutdown_super(struct super_block *sb)
 			sop->put_super(sb);
 
 		if (!list_empty(&sb->s_inodes)) {
-			printk("VFS: Busy inodes after unmount of %s. "
-			   "Self-destruct in 5 seconds.  Have a nice day...\n",
-			   sb->s_id);
+			pr_crit("Busy inodes after unmount of %s. Self-destruct in 5 seconds.  Have a nice day...\n",
+				sb->s_id);
 		}
 	}
 	spin_lock(&sb_lock);
@@ -777,7 +778,7 @@ static void do_emergency_remount(struct work_struct *work)
 		__put_super(p);
 	spin_unlock(&sb_lock);
 	kfree(work);
-	printk("Emergency Remount complete\n");
+	pr_info("Emergency Remount complete\n");
 }
 
 void emergency_remount(void)
@@ -1110,8 +1111,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	 * this warning for a little while to try and catch filesystems that
 	 * violate this rule.
 	 */
-	WARN((sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
-		"negative value (%lld)\n", type->name, sb->s_maxbytes);
+	WARN((sb->s_maxbytes < 0),
+	     "%s set sb->s_maxbytes to negative value (%lld)\n",
+	     type->name, sb->s_maxbytes);
 
 	up_write(&sb->s_umount);
 	free_secdata(secdata);
@@ -1163,8 +1165,7 @@ int freeze_super(struct super_block *sb)
 	if (sb->s_op->freeze_fs) {
 		ret = sb->s_op->freeze_fs(sb);
 		if (ret) {
-			printk(KERN_ERR
-				"VFS:Filesystem freeze failed\n");
+			pr_err("Filesystem freeze failed\n");
 			sb->s_frozen = SB_UNFROZEN;
 			deactivate_locked_super(sb);
 			return ret;
@@ -1197,8 +1198,7 @@ int thaw_super(struct super_block *sb)
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
 		if (error) {
-			printk(KERN_ERR
-				"VFS:Filesystem thaw failed\n");
+			pr_err("Filesystem thaw failed\n");
 			sb->s_frozen = SB_FREEZE_TRANS;
 			up_write(&sb->s_umount);
 			return error;
-- 
1.7.6.405.gc1be0

