Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab0HSDiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:38:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51350 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0HSDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kvyg6lk6y9rHgs/+jPaUs/9/613qfqFhKqSM6hC8ZFYotmSl18OGpVuMKtManyCEwI
         eHHvLXOt81wjFGAt5hSzbXSsAWSohZrtgq1HD8r/2eLYfUGby0Zk1EWVe1t52dDUAjjX
         BKqEtX8yUsj/8hwZwCpyBhEGs76FPoPUnF+Yw=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] initramfs: mark collect buffers as __user pointers
Date: Thu, 19 Aug 2010 12:37:43 +0900
Message-Id: <1282189064-3904-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

collected, vcollected, collect are used for syscall routines so it would be
better to be __user pointers. We can add __user/__force markup on every calls
but marking them as user pointers requires less change.

Impact: remove sparse warnings, no functional change
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/initramfs.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index d90d1cf..2aa8c96 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -174,19 +174,19 @@ static inline void __init eat(unsigned n)
 	count -= n;
 }
 
-static __initdata char *vcollected;
-static __initdata char *collected;
+static __initdata char __user *vcollected;
+static __initdata char __user *collected;
 static __initdata int remains;
-static __initdata char *collect;
+static __initdata char __user *collect;
 
 static void __init read_into(char *buf, unsigned size, enum state next)
 {
 	if (count >= size) {
-		collected = victim;
+		collected = (char __user __force *) victim;
 		eat(size);
 		state = next;
 	} else {
-		collect = collected = buf;
+		collect = collected = (char __user __force *) buf;
 		remains = size;
 		next_state = next;
 		state = Collect;
@@ -206,7 +206,7 @@ static int __init do_collect(void)
 	unsigned n = remains;
 	if (count < n)
 		n = count;
-	memcpy(collect, victim, n);
+	copy_to_user(collect, victim, n);
 	eat(n);
 	collect += n;
 	if ((remains -= n) != 0)
@@ -217,15 +217,15 @@ static int __init do_collect(void)
 
 static int __init do_header(void)
 {
-	if (memcmp(collected, "070707", 6)==0) {
+	if (memcmp((char __force *)collected, "070707", 6)==0) {
 		error("incorrect cpio method used: use -H newc option");
 		return 1;
 	}
-	if (memcmp(collected, "070701", 6)) {
+	if (memcmp((char __force *)collected, "070701", 6)) {
 		error("no cpio magic");
 		return 1;
 	}
-	parse_header(collected);
+	parse_header((char __force *)collected);
 	next_header = this_header + N_ALIGN(name_len) + body_len;
 	next_header = (next_header + 3) & ~3;
 	state = SkipIt;
@@ -234,7 +234,7 @@ static int __init do_header(void)
 	if (S_ISLNK(mode)) {
 		if (body_len > PATH_MAX)
 			return 0;
-		collect = collected = symlink_buf;
+		collect = collected = (char __user __force *) symlink_buf;
 		remains = N_ALIGN(name_len) + body_len;
 		next_state = GotSymlink;
 		state = Collect;
@@ -269,9 +269,12 @@ static int __init do_reset(void)
 static int __init maybe_link(void)
 {
 	if (nlink >= 2) {
-		char *old = find_link(major, minor, ino, mode, collected);
-		if (old)
-			return (sys_link(old, collected) < 0) ? -1 : 1;
+		char *old = find_link(major, minor, ino, mode,
+				      (char __force *) collected);
+		if (old) {
+			char __user *uold = (char __user __force *) old;
+			return (sys_link(uold, collected) < 0) ? -1 : 1;
+		}
 	}
 	return 0;
 }
@@ -295,7 +298,7 @@ static int __init do_name(void)
 {
 	state = SkipIt;
 	next_state = Reset;
-	if (strcmp(collected, "TRAILER!!!") == 0) {
+	if (strcmp((char __force *)collected, "TRAILER!!!") == 0) {
 		free_hash();
 		return 0;
 	}
@@ -313,7 +316,9 @@ static int __init do_name(void)
 				sys_fchmod(wfd, mode);
 				if (body_len)
 					sys_ftruncate(wfd, body_len);
-				vcollected = kstrdup(collected, GFP_KERNEL);
+				vcollected = (char __user __force *)
+					kstrdup((char __force *)collected,
+						GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
@@ -321,7 +326,7 @@ static int __init do_name(void)
 		sys_mkdir(collected, mode);
 		sys_chown(collected, uid, gid);
 		sys_chmod(collected, mode);
-		dir_add(collected, mtime);
+		dir_add((char __force *)collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
@@ -337,15 +342,15 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
+		sys_write(wfd, (char __user __force *)victim, body_len);
 		sys_close(wfd);
 		do_utime(vcollected, mtime);
-		kfree(vcollected);
+		kfree((void __force *)vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		sys_write(wfd, (char __user __force *)victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -354,7 +359,7 @@ static int __init do_copy(void)
 
 static int __init do_symlink(void)
 {
-	collected[N_ALIGN(name_len) + body_len] = '\0';
+	put_user('\0', collected + N_ALIGN(name_len) + body_len);
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
-- 
1.7.0.4

