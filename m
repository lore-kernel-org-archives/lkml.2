Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1JWOoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:44:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55970 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab1JWOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:44:29 -0400
Date: Sun, 23 Oct 2011 22:43:33 +0800
From: wangyanqing <udknight@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init:enable usermodehelper as soon as we have a root
 filesystem
Message-ID: <20111023144333.GA2676@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before we have a root filesystem , it is useless to enable usermodehelper,
and it may cause bug if we enable usermodehelper too early.This patch
enable usermodehelper as soon as we have a root filesystem.
---
 init/do_mounts.c |    3 +++
 init/initramfs.c |    2 ++
 init/main.c      |    1 -
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index c0851a8..9575bdd 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -490,4 +490,7 @@ out:
 	devtmpfs_mount("dev");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot((const char __user __force *)".");
+#ifndef CONFIG_BLK_DEV_INITRD
+	usermodehelper_enable();
+#endif
 }
diff --git a/init/initramfs.c b/init/initramfs.c
index 2531811..881fc4b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -581,6 +581,7 @@ static int __init populate_rootfs(void)
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
 		if (!err) {
+			usermodehelper_enable();
 			free_initrd();
 			return 0;
 		} else {
@@ -603,6 +604,7 @@ static int __init populate_rootfs(void)
 			initrd_end - initrd_start);
 		if (err)
 			printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
+		usermodehelper_enable();
 		free_initrd();
 #endif
 	}
diff --git a/init/main.c b/init/main.c
index 03b408d..2e232cb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -730,7 +730,6 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
-	usermodehelper_enable();
 	do_initcalls();
 }
 
-- 
1.7.3.4

