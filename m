Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0HQMha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:37:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36386 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0HQMh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sH9NpumIcYNuY22kL9NIINMHkLiGUgUOtYTrp7QDDhO6y8y/Wp8lmLC+xZ0TvD4ael
         hRPlgIFP02Xv1Xc2xK+6sBMcdT5gtadMB/fXEwlzJRhCgexNJZjofdZWPpsGly5hC4wg
         lJ0Cka4sSHaJFFLgUkgxXjaVeS+FG0gSRoSt4=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] init/do_mounts.c: replace sys_mount() to do_mount()
Date: Tue, 17 Aug 2010 21:37:23 +0900
Message-Id: <1282048643-2475-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_mount() just copies all (string) arguments from user space to kernel
and calls do_mount(). In this case we have all args in kernel already so
there is no need to call sys_mount(). One thing we should take care is
'data' have to be in a page unless it is NULL. Do it manually.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/do_mounts.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

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
-- 
1.7.0.4

