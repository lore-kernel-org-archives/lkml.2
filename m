Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2HCRfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:35:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63414 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2HCRfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:35:01 -0400
From: Sachidananda Urs <sacchi@gmail.com>
To: Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sachidananda Urs <sacchi@gmail.com>
Subject: [PATCH] Documentation/filesystems/porting: Update documentation.
Date: Fri,  3 Aug 2012 23:04:25 +0530
Message-Id: <1344015265-6752-1-git-send-email-sacchi@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->get_sb() is no longer used, update documentation to use ->mount(). Also added
  a example for struct file_system_type.

Signed-off-by: Sachidananda Urs <sacchi@gmail.com>
---
 Documentation/filesystems/porting |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 2bef2b3..d6d53fb 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -42,26 +42,32 @@ At some point that will become mandatory.
 ---
 [mandatory]
 
-Change of file_system_type method (->read_super to ->get_sb)
+Change of file_system_type method (->read_super to ->get_sb to ->mount)
 
-->read_super() is no more.  Ditto for DECLARE_FSTYPE and DECLARE_FSTYPE_DEV.
+->read_super() is no more and so is ->get_sb.  Ditto for DECLARE_FSTYPE and
+  DECLARE_FSTYPE_DEV.
 
 Turn your foo_read_super() into a function that would return 0 in case of
 success and negative number in case of error (-EINVAL unless you have more
 informative error value to report).  Call it foo_fill_super().  Now declare
 
-int foo_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+static struct dentry *foo_mount(struct file_system_type *fs_type, int flags,
+                                const char *dev_name, void *data)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, foo_fill_super,
-			   mnt);
+        return mount_bdev(fs_type, flags, dev_name, data, foo_fill_super);
 }
 
 (or similar with s/bdev/nodev/ or s/bdev/single/, depending on the kind of
 filesystem).
 
 Replace DECLARE_FSTYPE... with explicit initializer and have ->get_sb set as
-foo_get_sb.
+foo_mount. For example:
+
+static struct file_system_type foo_fs_type = {
+        .owner  = THIS_MODULE,
+        .name   = "foo",
+        .mount  = foo_mount,
+};
 
 ---
 [mandatory]
-- 
1.7.7.6

