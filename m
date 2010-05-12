Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0ELPvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:51:33 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44139 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0ELPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:27 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 8/9] x86: Add new syscalls for x86_64
Date: Wed, 12 May 2010 21:20:43 +0530
Message-Id: <1273679444-14903-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sys_name_to_handle_at, sys_open_by_handle syscall
and sys_freadlink for x86_64

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32entry.S        |    3 +++
 arch/x86/include/asm/unistd_64.h |    6 ++++++
 fs/compat.c                      |   10 ++++++++++
 fs/open.c                        |    2 +-
 include/linux/fs.h               |    1 +
 5 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e790bc1..2f4c979 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -842,4 +842,7 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_name_to_handle_at
+	.quad compat_sys_open_by_handle
+	.quad sys_freadlink			/* 340 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index ff4307b..c32428d 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,12 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_name_to_handle_at			300
+__SYSCALL(__NR_name_to_handle, sys_name_to_handle)
+#define __NR_open_by_handle			301
+__SYSCALL(__NR_open_by_handle, sys_open_by_handle)
+#define __NR_freadlink				302
+__SYSCALL(__NR_freadlink, sys_freadlink)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/fs/compat.c b/fs/compat.c
index 4b6ed03..5c71c98 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2310,3 +2310,13 @@ asmlinkage long compat_sys_timerfd_gettime(int ufd,
 }
 
 #endif /* CONFIG_TIMERFD */
+
+/*
+ * Exactly like fs/open.c:sys_open_by_handle(), except that it doesn't set the
+ * O_LARGEFILE flag.
+ */
+asmlinkage long
+compat_sys_open_by_handle(struct file_handle __user *handle, int flags)
+{
+	return do_sys_open_by_handle(handle, flags);
+}
diff --git a/fs/open.c b/fs/open.c
index 348a1b9..b8924e1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1335,7 +1335,7 @@ static struct dentry *handle_to_dentry(struct vfsmount *mnt,
 	return dentry;
 }
 
-static long do_sys_open_by_handle(struct file_handle __user *ufh, int flags)
+long do_sys_open_by_handle(struct file_handle __user *ufh, int flags)
 {
 	int fd;
 	int retval = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 055734c..6dcf696 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1933,6 +1933,7 @@ extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
+extern long do_sys_open_by_handle(struct file_handle __user *, int);
 
 /* fs/ioctl.c */
 
-- 
1.7.1.78.g212f0

