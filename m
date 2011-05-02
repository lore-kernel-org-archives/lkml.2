Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1EBXJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:45 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1EBXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:36 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsDib030320@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 16:52:19 -0400
Subject: [PATCH] audit: support the "standard" <asm-generic/unistd.h>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 02 May 2011 22:54:14.0096 (UTC) FILETIME=[DBA91500:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the syscalls mentioned in the audit code are not present
for architectures that implement only the "standard" set of
Linux syscalls (e.g. openat, but not open, etc.).  This change
adds proper #ifdefs for all those syscalls.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
Arnd, if you can ack this change, I'll push it through the tile tree.

 include/asm-generic/audit_change_attr.h |    4 ++++
 include/asm-generic/audit_dir_write.h   |   14 ++++++++++++++
 include/asm-generic/audit_read.h        |    5 +++++
 include/asm-generic/audit_write.h       |    2 ++
 lib/audit.c                             |    2 ++
 5 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
index bcbab3e..89b73e5 100644
--- a/include/asm-generic/audit_change_attr.h
+++ b/include/asm-generic/audit_change_attr.h
@@ -1,4 +1,6 @@
+#ifdef __NR_chmod
 __NR_chmod,
+#endif
 __NR_fchmod,
 #ifdef __NR_chown
 __NR_chown,
@@ -20,7 +22,9 @@ __NR_chown32,
 __NR_fchown32,
 __NR_lchown32,
 #endif
+#ifdef __NR_link
 __NR_link,
+#endif
 #ifdef __NR_linkat
 __NR_linkat,
 #endif
diff --git a/include/asm-generic/audit_dir_write.h b/include/asm-generic/audit_dir_write.h
index 6621bd8..7b61db4 100644
--- a/include/asm-generic/audit_dir_write.h
+++ b/include/asm-generic/audit_dir_write.h
@@ -1,13 +1,27 @@
+#ifdef __NR_rename
 __NR_rename,
+#endif
+#ifdef __NR_mkdir
 __NR_mkdir,
+#endif
+#ifdef __NR_rmdir
 __NR_rmdir,
+#endif
 #ifdef __NR_creat
 __NR_creat,
 #endif
+#ifdef __NR_link
 __NR_link,
+#endif
+#ifdef __NR_unlink
 __NR_unlink,
+#endif
+#ifdef __NR_symlink
 __NR_symlink,
+#endif
+#ifdef __NR_mknod
 __NR_mknod,
+#endif
 #ifdef __NR_mkdirat
 __NR_mkdirat,
 __NR_mknodat,
diff --git a/include/asm-generic/audit_read.h b/include/asm-generic/audit_read.h
index 0e87464..3b249cb 100644
--- a/include/asm-generic/audit_read.h
+++ b/include/asm-generic/audit_read.h
@@ -1,4 +1,6 @@
+#ifdef __NR_readlink
 __NR_readlink,
+#endif
 __NR_quotactl,
 __NR_listxattr,
 __NR_llistxattr,
@@ -6,3 +8,6 @@ __NR_flistxattr,
 __NR_getxattr,
 __NR_lgetxattr,
 __NR_fgetxattr,
+#ifdef __NR_readlinkat
+__NR_readlinkat,
+#endif
diff --git a/include/asm-generic/audit_write.h b/include/asm-generic/audit_write.h
index c5f1c2c..e7020c5 100644
--- a/include/asm-generic/audit_write.h
+++ b/include/asm-generic/audit_write.h
@@ -4,7 +4,9 @@ __NR_acct,
 __NR_swapon,
 #endif
 __NR_quotactl,
+#ifdef __NR_truncate
 __NR_truncate,
+#endif
 #ifdef __NR_truncate64
 __NR_truncate64,
 #endif
diff --git a/lib/audit.c b/lib/audit.c
index 8e7dc1c..76bbed4 100644
--- a/lib/audit.c
+++ b/lib/audit.c
@@ -36,8 +36,10 @@ int audit_classify_arch(int arch)
 int audit_classify_syscall(int abi, unsigned syscall)
 {
 	switch(syscall) {
+#ifdef __NR_open
 	case __NR_open:
 		return 2;
+#endif
 #ifdef __NR_openat
 	case __NR_openat:
 		return 3;
-- 
1.6.5.2

