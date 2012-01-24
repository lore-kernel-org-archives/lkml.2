Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2AXCmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:42:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab2AXCm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:24 2012
Message-Id: <20120124023924.480931152@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Djalal Harouni <tixxdz@opendz.org>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [006/129] ext4: add missing ext4_resize_end on error paths
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2504
Lines: 103

From: Djalal Harouni <tixxdz@opendz.org>

commit 014a1770371a028d22f364718c805f4216911ecd upstream.

Online resize ioctls 'EXT4_IOC_GROUP_EXTEND' and 'EXT4_IOC_GROUP_ADD'
call ext4_resize_begin() to check permissions and to set the
EXT4_RESIZING bit lock, they do their work and they must finish with
ext4_resize_end() which calls clear_bit_unlock() to unlock and to
avoid -EBUSY errors for the next resize operations.

This patch adds the missing ext4_resize_end() calls on error paths.

Patch tested.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ioctl.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

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
 


