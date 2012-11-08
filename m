Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2KHJDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:03:53 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33270 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2KHJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:03:46 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 15/18] btrfs: add hot tracking support
Date: Thu,  8 Nov 2012 17:01:22 +0800
Message-Id: <1352365285-32419-16-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-5518-0000-0000-0000091CA188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one new mount option '-o hot_track',
and add its parsing support.
  Its usage looks like:
   mount -o hot_track
   mount -o nouser,hot_track
   mount -o nouser,hot_track,loop
   mount -o hot_track,nouser

Reviewed-by:   David Sterba <dsterba@suse.cz>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/super.c |   22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c72ead8..4703178 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1756,6 +1756,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_HOT_TRACK		(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..0bcc62b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
+#include <linux/hot_tracking.h>
 #include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -299,6 +300,10 @@ static void btrfs_put_super(struct super_block *sb)
 	 * last process that kept it busy.  Or segfault in the aforementioned
 	 * process...  Whom would you report that to?
 	 */
+
+	/* Hot data tracking */
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
+		hot_track_exit(sb);
 }
 
 enum {
@@ -311,7 +316,7 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_hot_track,
 	Opt_err,
 };
 
@@ -352,6 +357,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
+	{Opt_hot_track, "hot_track"},
 	{Opt_err, NULL},
 };
 
@@ -614,6 +620,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+		case Opt_hot_track:
+			btrfs_set_opt(info->mount_opt, HOT_TRACK);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -841,11 +850,20 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
+	if (btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
+		err = hot_track_init(sb);
+		if (err)
+			goto fail_hot;
+	}
+
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
 	return 0;
 
+fail_hot:
+	dput(sb->s_root);
+	sb->s_root = NULL;
 fail_close:
 	close_ctree(fs_info->tree_root);
 	return err;
@@ -941,6 +959,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",skip_balance");
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
+	if (btrfs_test_opt(root, HOT_TRACK))
+		seq_puts(seq, ",hot_track");
 	return 0;
 }
 
-- 
1.7.6.5

