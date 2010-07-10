Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0GJXPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 19:15:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50476 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0GJXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 19:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=pQcV49tJT5lFBGEIsFFs4c6zmXI9ZGI/Ot4vlR5RMVgyDZOlp0b4H60q3LfeqrEead
         yHWqQ4CENFHrZapkwkSEzPhJAem8ew4y8BgdKtxsM4h8KSQ4xbrorkDk7R/6+3rlkUId
         Qs/R7YBxJgw5nPglsAUx9UBEiaeciVd5OURDo=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Fix warning: 'dirent' is used uninitialized in this function
Date: Sat, 10 Jul 2010 20:15:00 -0300
Message-Id: <1278803700-1473-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Alexander Viro <viro@zeniv.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using:

	gcc (GCC) 4.5.0 20100610 (prerelease)

The following warnings appear:

	fs/readdir.c: In function ‘filldir64’:
	fs/readdir.c:240:15: warning: ‘dirent’ is used uninitialized in this function
	fs/readdir.c: In function ‘filldir’:
	fs/readdir.c:155:15: warning: ‘dirent’ is used uninitialized in this function
	fs/compat.c: In function ‘compat_filldir64’:
	fs/compat.c:1071:11: warning: ‘dirent’ is used uninitialized in this function
	fs/compat.c: In function ‘compat_filldir’:
	fs/compat.c:984:15: warning: ‘dirent’ is used uninitialized in this function

The warnings are related to the use of the NAME_OFFSET() macro.
Luckily, it appears as though the standard offsetof() macro is what
is being implemented by NAME_OFFSET(), thus we can fix the warning
and use a more standard code construct at the same time.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 fs/compat.c  |   10 +++++-----
 fs/readdir.c |    8 +++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6490d21..0c399bd 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -15,6 +15,7 @@
  *  published by the Free Software Foundation.
  */
 
+#include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
@@ -891,8 +892,6 @@ asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
 	return retval;
 }
 
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
 	compat_ulong_t	d_offset;
@@ -981,7 +980,8 @@ static int compat_filldir(void *__buf, const char *name, int namlen,
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(compat_long_t));
+	int reclen = ALIGN(offsetof(struct compat_linux_dirent, d_name) +
+		namlen + 2, sizeof(compat_long_t));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -1068,8 +1068,8 @@ static int compat_filldir64(void * __buf, const char * name, int namlen, loff_t
 {
 	struct linux_dirent64 __user *dirent;
 	struct compat_getdents_callback64 *buf = __buf;
-	int jj = NAME_OFFSET(dirent);
-	int reclen = ALIGN(jj + namlen + 1, sizeof(u64));
+	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
+		sizeof(u64));
 	u64 off;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
diff --git a/fs/readdir.c b/fs/readdir.c
index 7723401..356f715 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1995  Linus Torvalds
  */
 
+#include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -54,7 +55,6 @@ EXPORT_SYMBOL(vfs_readdir);
  * anyway. Thus the special "fillonedir()" function for that
  * case (the low-level handlers don't need to care about this).
  */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
 
 #ifdef __ARCH_WANT_OLD_READDIR
 
@@ -152,7 +152,8 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 	struct linux_dirent __user * dirent;
 	struct getdents_callback * buf = (struct getdents_callback *) __buf;
 	unsigned long d_ino;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
+	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
+		sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -237,7 +238,8 @@ static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
 {
 	struct linux_dirent64 __user *dirent;
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
-	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
+	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
+		sizeof(u64));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
-- 
1.7.1

