Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0HQOiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:38:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61139 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0HQOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=affAzkGlWpGY67anObMmoABIYnujnly1B+t7r1voyWCuRkxeVPKPWvwO3h5wHuEA8i
         z6/LrQD/TW+MIYe4v1ZxQDJ2VDFvgHwMV2OSYr7sFrJtDF3bWV4pXiux7EFNaf1njuW4
         8RqCqIs3NBA5EWx+AF/BWk3V1x+XyduYo+umA=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] init: replace sys_mount() to do_mount()
Date: Tue, 17 Aug 2010 23:38:09 +0900
Message-Id: <1282055889-6135-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201008171541.47078.arnd@arndb.de>
References: <201008171541.47078.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_mount() just copies all (string) arguments from user space to kernel
and calls do_mount(). In this case we have all args in kernel already so
there is no need to call sys_mount(). One thing we should take care is
'data' have to be in a page unless it is NULL. Do it manually.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---

I found 3 more calls in init/do_mounts_initrd.c and merged them. Please
apply this instead.

2010-08-17 (Tue), 15:41 +0200, Arnd Bergmann:
> Maybe you can fix that as well in the same patch and move this safeguard
> into the copy_mount_options() function? I guess ideally we'd even mark
> the arguments to do_mount() as pointers to const, but that might create
> an excessive amount of churn.

Arnd, thanks for reviewing and the suggestion but I think that should be
in a different patch (set).

 init/do_mounts.c        |   18 ++++++++++++++++--
 init/do_mounts_initrd.c |    6 +++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 02e3ca4..8eabff6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -217,7 +217,21 @@ static void __init get_fs_names(char *page)

 static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 {
-	int err = sys_mount(name, "/root", fs, flags, data);
+	int err;
+	unsigned long data_page = 0;
+
+	if (data) {
+		/* data should be in a page */
+		data_page = __get_free_page(GFP_KERNEL);
+		if (!data_page)
+			return -ENOMEM;
+		strlcpy((char *) data_page, data, PAGE_SIZE);
+	}
+
+	err = do_mount(name, "/root", fs, flags, (void *) data_page);
+
+	if (data_page)
+		free_page(data_page);
 	if (err)
 		return err;

@@ -417,6 +431,6 @@ void __init prepare_namespace(void)
 	mount_root();
 out:
 	devtmpfs_mount("dev");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	do_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 }
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 2b10853..8355501 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -48,7 +48,7 @@ static void __init handle_initrd(void)
 	old_fd = sys_open("/old", 0, 0);
 	/* move initrd over / and chdir/chroot in initrd root */
 	sys_chdir("/root");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	do_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");

 	/*
@@ -66,7 +66,7 @@ static void __init handle_initrd(void)

 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
-	sys_mount("/", ".", NULL, MS_MOVE, NULL);
+	do_mount("/", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
 	sys_fchdir(root_fd);
 	sys_chroot(".");
@@ -82,7 +82,7 @@ static void __init handle_initrd(void)
 	mount_root();

 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = do_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
--
1.7.0.4

