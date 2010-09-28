Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab0I1I1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:27:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39470 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329Ab0I1I1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZxNSiQxh5STsUis3SlAsVGX14jlNTYelyizyQ995YoWgILGUKhikBPviczayZo1pIE
         Y6iybSI8244WqobF01H9qyQ6y6ddvXs/ENu+5HJlZCAWOGlpLTvsjWY4lH21dn5G83zD
         gnD4etqcUCG2OIO0N6EjKWXYhL0gv9i0Vgnag=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vfs: add __FMODE_EXEC
Date: Tue, 28 Sep 2010 17:27:01 +0900
Message-Id: <1285662421-17095-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285662421-17095-1-git-send-email-namhyung@gmail.com>
References: <1285662421-17095-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FMODE_EXEC is a constant type of fmode_t but was used with normal
integer constants. This results in following warnings from sparse.
Fix it using new macro __FMODE_EXEC.

 fs/exec.c:116:58: warning: restricted fmode_t degrades to integer
 fs/exec.c:689:58: warning: restricted fmode_t degrades to integer
 fs/fcntl.c:777:9: warning: restricted fmode_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/exec.c          |    4 ++--
 fs/fcntl.c         |    2 +-
 include/linux/fs.h |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 828dd24..e88d0f1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -113,7 +113,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 		goto out;
 
 	file = do_filp_open(AT_FDCWD, tmp,
-				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
+				O_LARGEFILE | O_RDONLY | __FMODE_EXEC, 0,
 				MAY_READ | MAY_EXEC | MAY_OPEN);
 	putname(tmp);
 	error = PTR_ERR(file);
@@ -686,7 +686,7 @@ struct file *open_exec(const char *name)
 	int err;
 
 	file = do_filp_open(AT_FDCWD, name,
-				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
+				O_LARGEFILE | O_RDONLY | __FMODE_EXEC, 0,
 				MAY_EXEC | MAY_OPEN);
 	if (IS_ERR(file))
 		goto out;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index f8cc34f..d6e735d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -781,7 +781,7 @@ static int __init fcntl_init(void)
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		FMODE_EXEC
+		__FMODE_EXEC
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e60f9b1..25c0cc1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2477,6 +2477,7 @@ int proc_nr_files(struct ctl_table *table, int write,
 
 int __init get_filesystem_list(char *buf);
 
+#define __FMODE_EXEC		((__force int) FMODE_EXEC)
 #define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
-- 
1.7.2.2

