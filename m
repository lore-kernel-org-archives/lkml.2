Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1CGXPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:15:54 -0500
Received: from cobra.newdream.net ([66.33.216.30]:58176 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1CGXPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:15:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=SjBroluAQZWLMiKMo+VQh/xg3
	Mh4nMimLoVRh/199PQmzUbjiq4SfwYFfxNJ8pbpUMhHXZ3cFWGU/yGsGWeJ80345
	PuAAuAtAevI1bjqQYgAKlHGKwjKtd4g9Z5+IHpAOcBKtNKJVS5Ud7mQamO5guFtr
	hhrqaWfYXtVEp4tNT4=
Date: Mon, 7 Mar 2011 15:17:57 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org
Subject: [RFC] introduce sys_syncfs to sync a single file system (v2)
In-Reply-To: <87bp1sziqn.fsf@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <20110303072223.GA28133@elie> <87bp1sziqn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
 v1->v2: Rename, simplify to just take an fd.

It is frequently useful to sync a single file system, instead of all
mounted file systems via sync(2):

 - On machines with many mounts, it is not at all uncommon for some of
   them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
   those and may never get to the one you do care about (e.g., /).
 - Some applications write lots of data to the file system and then
   want to make sure it is flushed to disk.  Calling fsync(2) on each
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

This patch introduces a new system call syncfs(2) that takes an fd and
syncs only the file system it references.  Maybe someday we can even

 $ sync /some/path

and not get

 sync: ignoring all arguments

The syscall is motivated by comments by Al and Christoph at the last LSF.
syncfs(2) seems like an appropriate name given statfs(2).

A similar ioctl was also proposed a while back, see
	http://marc.info/?l=linux-fsdevel&m=127970513829285&w=2

Signed-off-by: Sage Weil <sage@newdream.net>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/sync.c                          |   24 ++++++++++++++++++++++++
 5 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..24082b8 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,5 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_syncfs
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index b766a5e..da3903f 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,11 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_syncfs             341
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 342
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..a2e7516 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,8 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_syncfs                             303
+__SYSCALL(__NR_syncfs, sys_syncfs)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index b35786d..d40bd16 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,4 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_syncfs
diff --git a/fs/sync.c b/fs/sync.c
index ba76b96..92ca208 100644
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
@@ -128,6 +129,29 @@ void emergency_sync(void)
 	}
 }
 
+/*
+ * sync a single super
+ */
+SYSCALL_DEFINE1(syncfs, int, fd)
+{
+	struct file *file;
+	struct super_block *sb;
+	int ret;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return -EBADF;
+	sb = file->f_dentry->d_sb;
+
+	down_read(&sb->s_umount);
+	ret = sync_filesystem(sb);
+	up_read(&sb->s_umount);
+
+	fput_light(file, fput_needed);
+	return ret;
+}
+
 /**
  * vfs_fsync_range - helper to sync a range of data & metadata to disk
  * @file:		file to sync
-- 
1.7.0

