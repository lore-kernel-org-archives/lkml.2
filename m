Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2CUVuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:50:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2CUVuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:50:13 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Wed, 21 Mar 2012 22:50:07 +0100
Message-Id: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.9.4
X-Provags-ID: V02:K0:68B+KXdL2rzcExbzrgP29DESvMR1oeoyM6iOptFWdjp
 UdEUopl7f7qYA1KVAmnLgCG2f0fbhYtg3EN0xq8dPNKUmxObGK
 5hE3VsVtkjkgmjBotXGXszsEzgEKflLpLaPgRDry1yh84p0Ihy
 X1p2q7YR1nBbAkxx40rDiagXJS1+SxJhh9A6TeiseDYekpuWTi
 pt8sE5QMffkcIsOb/Ljx5e4FwmXBN0SlEnfnnqnOnqwEGXQXAn
 RjUNjSEicWJXOtwq6bd8mqaR/9qxTK97veRmMNOo1Z2habUMnd
 FjDZA8lt7c3fPIGL4IXTvQsp4ht4f0v0yjFlko5/aYg7Blx9/S
 1tXjoaZNqgCr2nmR264r+3orFLCDXojiCopwRT1szi43rhBKkw
 fq91gr5jVoht5vQOLDhgE/Q780sW9OxpKrBfgulgisDl9RjIhz
 7TclU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the exported linux/ext2_fs.h header from user space is broken
since commit 0583fcc because the umode_t type is no longer exported.
This happens for example when compiling busybox' tune2fs applet. The
e2fsprogs package does not have this problem because it ships with
its own header and doesn't use the one exported by the Linux kernel.

However, since busybox doesn't use the ext2_mask_flags() function the
easiest fix is to just not export it and as a result the umode_t type
definition is longer needed.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Cc: stable@vger.kernel.org
---
 include/linux/ext2_fs.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 091ab48..20f8f33 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -209,10 +209,7 @@ struct ext2_group_desc
 #define EXT2_OTHER_FLMASK (EXT2_NODUMP_FL | EXT2_NOATIME_FL)
 
 /* Mask out flags that are inappropriate for the given type of inode. */
-#ifndef __KERNEL__
-typedef unsigned short umode_t;
-#endif
-
+#ifdef __KERNEL__
 static inline __u32 ext2_mask_flags(umode_t mode, __u32 flags)
 {
 	if (S_ISDIR(mode))
@@ -222,6 +219,7 @@ static inline __u32 ext2_mask_flags(umode_t mode, __u32 flags)
 	else
 		return flags & EXT2_OTHER_FLMASK;
 }
+#endif
 
 /*
  * ioctl commands
-- 
1.7.9.4

