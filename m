Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1LVO63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:58:29 -0500
Received: from numidia.opendz.org ([98.142.220.152]:50781 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1LVO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:03 -0500
Date: Thu, 22 Dec 2011 16:00:57 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] fs/ext4: add missing ext4_resize_end
Message-ID: <20111222150057.GA10845@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Online resize ioctls 'EXT4_IOC_GROUP_EXTEND' and 'EXT4_IOC_GROUP_ADD'
call ext4_resize_begin() to check permissions and to set the
EXT4_RESIZING bit lock, they do their work and they must finish with
ext4_resize_end() which calls clear_bit_unlock() to unlock and to
avoid -EBUSY errors for the next resize operations.

This patch adds the missing ext4_resize_end() calls on error paths.

Patch tested.

Cc: stable@vger.kernel.org
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/ext4/ioctl.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a567968..ab25f57 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -182,19 +182,22 @@ setversion_out:
 		if (err)
 			return err;
 
-		if (get_user(n_blocks_count, (__u32 __user *)arg))
-			return -EFAULT;
+		if (get_user(n_blocks_count, (__u32 __user *)arg)) {
+			err = -EFAULT;
+			goto group_extend_out;
+		}
 
 		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online resizing not supported with bigalloc");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto group_extend_out;
 		}
 
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
-			return err;
+			goto group_extend_out;
 
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		if (EXT4_SB(sb)->s_journal) {
@@ -204,9 +207,10 @@ setversion_out:
 		}
 		if (err == 0)
 			err = err2;
+
 		mnt_drop_write(filp->f_path.mnt);
+group_extend_out:
 		ext4_resize_end(sb);
-
 		return err;
 	}
 
@@ -267,19 +271,22 @@ mext_out:
 			return err;
 
 		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
-				sizeof(input)))
-			return -EFAULT;
+				sizeof(input))) {
+			err = -EFAULT;
+			goto group_add_out;
+		}
 
 		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online resizing not supported with bigalloc");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto group_add_out;
 		}
 
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
-			return err;
+			goto group_add_out;
 
 		err = ext4_group_add(sb, &input);
 		if (EXT4_SB(sb)->s_journal) {
@@ -289,9 +296,10 @@ mext_out:
 		}
 		if (err == 0)
 			err = err2;
+
 		mnt_drop_write(filp->f_path.mnt);
+group_add_out:
 		ext4_resize_end(sb);
-
 		return err;
 	}
 
-- 
1.7.1
