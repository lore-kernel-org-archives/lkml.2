Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab1CCGeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:34:08 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54107 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab1CCGeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=EC1kPtc/1IlzmQ8/6px9Xd/L5Q3vnE8jF9A+DfYzFNQI4HQi
	LqXfd/5m/eDdNAnRacYGWmYskfN9NzO0vl4qqN34q9NSbhrIoPJwK9mM1REZbO6k
	ZKx3WhDK0yXDzn+9MB3RSoa+8+4BQn8b0vLYv++MyCVbuH9APuBtr98U+wE=
Date: Wed, 2 Mar 2011 22:35:57 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, jrnieder@gmail.com
Subject: [RFC] introduce sys_syncat to sync a single file system
Message-ID: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is frequently useful to sync a single file system, instead of all
mounted file systems via sync(2):

 - On machines with many of mounts, it is not at all uncommon for some of
   them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
   those and may never get to the one you do care about (e.g., /).
 - Some applications (Ceph, dpkg) write lots of data to the file system and
   then want to make sure it is flushed to disk.  Calling fsync(2) on each
   file introduces unnecessary ordering constraints that result in a large
   amount of sub-optimal writeback/flush/commit behavior by the file
   system.

There are currently two ways (that I know of) to sync a single super_block:

 - BLKFLSBUF ioctl on the block device: That also invalidates the bdev
   mapping, which isn't usually desirable, and doesn't work for non-block
   file systems.
 - 'mount -o remount,rw' will call sync_filesystem as an artifact of the
   current implemention.  Relying on this little-known side effect for
   something like data safety sounds foolish.

Both of these approaches require root privileges, which some applications
do not have (nor should they need?) given that sync(2) is an unprivileged
operation.

This patch introduces a new system call syncat(2) that mimics the existing 
*at() interfaces by taking an fd and/or path.  The fd can be either an 
open file descriptor or AT_FDCWD, and the pathname can be either a path or 
(unlike the usual *at() style interface) NULL.  Only the file system for 
the referenced file is synced.

The syscall approach is motivated by comments by Al and Christoph at the
last LSF.  A simpler ioctl was also proposed a while back, see
	http://marc.info/?l=linux-fsdevel&m=127970513829285&w=2

Is this a reasonable approach?  (Patch below is compile tested only.  :)


---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 +-
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/sync.c                          |   43 ++++++++++++++++++++++++++++++++++++
 5 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..1d610e4 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,5 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_syncat
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index b766a5e..350bf94 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,11 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_syncat             341
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 342
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..1ea0953 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,8 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_syncat                             303
+__SYSCALL(__NR_syncat, sys_syncat)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index b35786d..12de607 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,4 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_syncat
diff --git a/fs/sync.c b/fs/sync.c
index ba76b96..a57dfe4 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
@@ -128,6 +129,48 @@ void emergency_sync(void)
 	}
 }
 
+/*
+ * sync a single super
+ */
+SYSCALL_DEFINE3(syncat, int, dfd, const char __user *, filename, int, flags)
+{
+	struct path path;
+	struct file *file = 0;
+	struct super_block *sb;
+	int ret = -EINVAL;
+	int lookup_flags = 0;
+	int fput_needed = 0;
+	
+	if ((flags & ~AT_SYMLINK_NOFOLLOW) != 0)
+		goto out;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	if (filename) {
+		ret = user_path_at(dfd, filename, 0, &path);
+		if (ret)
+			goto out;
+		sb = path.dentry->d_sb;
+	} else {
+		file = fget_light(dfd, &fput_needed);
+		ret = -EBADF;
+		if (!file)
+			goto out;
+		sb = file->f_dentry->d_sb;
+	}
+
+	down_read(&sb->s_umount);
+	ret = sync_filesystem(sb);
+	up_read(&sb->s_umount);
+
+	if (filename)
+		path_put(&path);
+	fput_light(file, fput_needed);
+out:
+	return ret;
+}
+
 /**
  * vfs_fsync_range - helper to sync a range of data & metadata to disk
  * @file:		file to sync
-- 
1.7.0.4

