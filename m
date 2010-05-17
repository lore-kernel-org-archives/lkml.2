Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0EQFex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:34:53 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37405 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0EQFeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:34:15 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 8/9] x86: Add new syscalls for x86_64
Date: Mon, 17 May 2010 11:03:51 +0530
Message-Id: <1274074432-29695-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
 fs/open.c                        |    4 ++--
 include/linux/fs.h               |    1 +
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e790bc1..74552bc 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -842,4 +842,6 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_name_to_handle_at
+	.quad compat_sys_open_by_handle		/* 339 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index ff4307b..a5c3622 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,10 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_name_to_handle_at			300
+__SYSCALL(__NR_name_to_handle, sys_name_to_handle)
+#define __NR_open_by_handle			301
+__SYSCALL(__NR_open_by_handle, sys_open_by_handle)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/fs/compat.c b/fs/compat.c
index 4b6ed03..5e2f191 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2310,3 +2310,14 @@ asmlinkage long compat_sys_timerfd_gettime(int ufd,
 }
 
 #endif /* CONFIG_TIMERFD */
+
+/*
+ * Exactly like fs/open.c:sys_open_by_handle_at(), except that it
+ * doesn't set the O_LARGEFILE flag.
+ */
+asmlinkage long
+compat_sys_open_by_handle(int mountdirfd,
+			struct file_handle __user *handle, int flags)
+{
+	return do_sys_open_by_handle(mountdirfd, handle, flags);
+}
diff --git a/fs/open.c b/fs/open.c
index 0bd49b3..b21f4e6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1354,8 +1354,8 @@ out_err:
 	return ERR_PTR(retval);
 }
 
-static long do_sys_open_by_handle(int mountdirfd,
-				struct file_handle __user *ufh, int open_flag)
+long do_sys_open_by_handle(int mountdirfd,
+			struct file_handle __user *ufh, int open_flag)
 {
 	int acc_mode;
 	int fd, retval = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c73e1a0..2f63a17 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1933,6 +1933,7 @@ extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
+extern long do_sys_open_by_handle(int, struct file_handle __user *, int);
 
 /* fs/ioctl.c */
 
-- 
1.7.1.78.g212f0

