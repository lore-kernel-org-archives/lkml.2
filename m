Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab0HSDiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:38:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51350 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HSDhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MGIaHOBAC7NAWELzBFt2cMfAlvl1b4d1nRpqPQ2QosHB06IhfI35/RhavUTFjKfl6o
         rd6zEbqI14HDXcNWCEfDngOy1l15C8OvEDRRgeQcEHKdiz4dofuwSd0T6JAq7DJY9JgK
         tRfTKLrH+LS0YzU3X3LVn5LjYYpkLD5FhvdQY=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] initramfs: mark dirp as a __user pointer on clean_rootfs()
Date: Thu, 19 Aug 2010 12:37:42 +0900
Message-Id: <1282189064-3904-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dirp is used for calling syscall routines so it would be better to be a user
pointer unless we want to cast it on every syscalls.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/initramfs.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 75a43c5..d90d1cf 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -526,7 +526,7 @@ static void __init clean_rootfs(void)
 {
 	int fd;
 	void *buf;
-	struct linux_dirent64 *dirp;
+	struct linux_dirent64 __user *dirp;
 	int num;
 
 	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
@@ -540,14 +540,16 @@ static void __init clean_rootfs(void)
 		return;
 	}
 
-	dirp = buf;
+	dirp = (struct linux_dirent64 __user __force *) buf;
 	num = sys_getdents64(fd, dirp, BUF_SIZE);
 	while (num > 0) {
 		while (num > 0) {
 			struct stat st;
 			int ret;
+			unsigned short len;
 
-			ret = sys_newlstat(dirp->d_name, &st);
+			ret = sys_newlstat(dirp->d_name,
+					   (struct stat __user __force *)&st);
 			WARN_ON_ONCE(ret);
 			if (!ret) {
 				if (S_ISDIR(st.st_mode))
@@ -556,10 +558,11 @@ static void __init clean_rootfs(void)
 					sys_unlink(dirp->d_name);
 			}
 
-			num -= dirp->d_reclen;
-			dirp = (void *)dirp + dirp->d_reclen;
+			len = ((struct linux_dirent64 __force *) dirp)->d_reclen;
+			num -= len;
+			dirp = (void __user *)dirp + len;
 		}
-		dirp = buf;
+		dirp = (struct linux_dirent64 __user __force *) buf;
 		memset(buf, 0, BUF_SIZE);
 		num = sys_getdents64(fd, dirp, BUF_SIZE);
 	}
-- 
1.7.0.4

