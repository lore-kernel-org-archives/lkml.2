Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab0FORNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:13:52 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:45975 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0FORNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:13:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V14 08/11] x86: Add new syscalls for x86_64
Date: Tue, 15 Jun 2010 22:42:58 +0530
Message-Id: <1276621981-2774-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.331.ga5080
In-Reply-To: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sys_name_to_handle_at and sys_open_by_handle_at syscalls
for x86_64

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32entry.S        |    2 ++
 arch/x86/include/asm/unistd_64.h |    4 ++++
 fs/compat.c                      |   11 +++++++++++
 fs/open.c                        |   20 ++++++++++----------
 include/linux/fs.h               |    1 +
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e790bc1..99f9623 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -842,4 +842,6 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_name_to_handle_at
+	.quad compat_sys_open_by_handle_at	/* 339 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index ff4307b..6afd818 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,10 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_name_to_handle_at			300
+__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
+#define __NR_open_by_handle_at			301
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/fs/compat.c b/fs/compat.c
index 6490d21..dc662ac 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2332,3 +2332,14 @@ asmlinkage long compat_sys_timerfd_gettime(int ufd,
 }
 
 #endif /* CONFIG_TIMERFD */
+
+/*
+ * Exactly like fs/open.c:sys_open_by_handle_at(), except that it
+ * doesn't set the O_LARGEFILE flag.
+ */
+asmlinkage long
+compat_sys_open_by_handle_at(int mountdirfd,
+			struct file_handle __user *handle, int flags)
+{
+	return do_sys_open_by_handle(mountdirfd, handle, flags);
+}
diff --git a/fs/open.c b/fs/open.c
index 1c5daa3..43093af 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1231,8 +1231,8 @@ out_err:
 	return ERR_PTR(retval);
 }
 
-static long do_sys_open_by_handle(int mountdirfd,
-				struct file_handle __user *ufh, int open_flag)
+long do_sys_open_by_handle(int mountdirfd,
+			struct file_handle __user *ufh, int open_flag)
 {
 	long retval = 0;
 	int fd, acc_mode;
@@ -1334,6 +1334,14 @@ out_handle:
 out_err:
 	return retval;
 }
+#else
+long do_sys_open_by_handle(int mountdirfd,
+			struct file_handle __user *ufh, int open_flag)
+{
+
+	return -ENOSYS;
+}
+#endif
 
 /**
  * sys_open_by_handle_at: Open the file handle
@@ -1358,11 +1366,3 @@ SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
 	ret = do_sys_open_by_handle(mountdirfd, handle, flags);
 	return ret;
 }
-#else
-SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
-		struct file_handle __user *, handle,
-		int, flags)
-{
-	return -ENOSYS;
-}
-#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1415cad..34d4f60 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1930,6 +1930,7 @@ extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
+extern long do_sys_open_by_handle(int, struct file_handle __user *, int);
 
 /* fs/ioctl.c */
 
-- 
1.7.1.331.ga5080

