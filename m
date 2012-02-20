Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab2BTAQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:16:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2BTAQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:16:12 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 16/30] x86-64, ia32: Drop sys32_rt_sigprocmask
Date: Sun, 19 Feb 2012 16:07:54 -0800
Message-Id: <1329696488-16970-17-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:16:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

On x86, the only difference between sys_rt_sigprocmask and
sys32_rt_sigprocmask is the alignment of the data structures.
However, x86 allows data accesses with arbitrary alignment, and
therefore there is no reason for this code to be different.

Reported-by: Gregory M. Lueck <gregory.m.lueck@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/sys_ia32.c         |   40 --------------------------------------
 arch/x86/include/asm/sys_ia32.h  |    2 -
 arch/x86/syscalls/syscall_32.tbl |    2 +-
 3 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index f6f5c53..aec2202 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -287,46 +287,6 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
-				     compat_sigset_t __user *oset,
-				     unsigned int sigsetsize)
-{
-	sigset_t s;
-	compat_sigset_t s32;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	if (set) {
-		if (copy_from_user(&s32, set, sizeof(compat_sigset_t)))
-			return -EFAULT;
-		switch (_NSIG_WORDS) {
-		case 4: s.sig[3] = s32.sig[6] | (((long)s32.sig[7]) << 32);
-		case 3: s.sig[2] = s32.sig[4] | (((long)s32.sig[5]) << 32);
-		case 2: s.sig[1] = s32.sig[2] | (((long)s32.sig[3]) << 32);
-		case 1: s.sig[0] = s32.sig[0] | (((long)s32.sig[1]) << 32);
-		}
-	}
-	set_fs(KERNEL_DS);
-	ret = sys_rt_sigprocmask(how,
-				 set ? (sigset_t __user *)&s : NULL,
-				 oset ? (sigset_t __user *)&s : NULL,
-				 sigsetsize);
-	set_fs(old_fs);
-	if (ret)
-		return ret;
-	if (oset) {
-		switch (_NSIG_WORDS) {
-		case 4: s32.sig[7] = (s.sig[3] >> 32); s32.sig[6] = s.sig[3];
-		case 3: s32.sig[5] = (s.sig[2] >> 32); s32.sig[4] = s.sig[2];
-		case 2: s32.sig[3] = (s.sig[1] >> 32); s32.sig[2] = s.sig[1];
-		case 1: s32.sig[1] = (s.sig[0] >> 32); s32.sig[0] = s.sig[0];
-		}
-		if (copy_to_user(oset, &s32, sizeof(compat_sigset_t)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
 asmlinkage long sys32_alarm(unsigned int seconds)
 {
 	return alarm_setitimer(seconds);
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index cb23852..68da87b 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -36,8 +36,6 @@ asmlinkage long sys32_rt_sigaction(int, struct sigaction32 __user *,
 				   struct sigaction32 __user *, unsigned int);
 asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
 				struct old_sigaction32 __user *);
-asmlinkage long sys32_rt_sigprocmask(int, compat_sigset_t __user *,
-				     compat_sigset_t __user *, unsigned int);
 asmlinkage long sys32_alarm(unsigned int);
 
 asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index ce98e28..031cef8 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -181,7 +181,7 @@
 172	i386	prctl			sys_prctl
 173	i386	rt_sigreturn		ptregs_rt_sigreturn		stub32_rt_sigreturn
 174	i386	rt_sigaction		sys_rt_sigaction		sys32_rt_sigaction
-175	i386	rt_sigprocmask		sys_rt_sigprocmask		sys32_rt_sigprocmask
+175	i386	rt_sigprocmask		sys_rt_sigprocmask
 176	i386	rt_sigpending		sys_rt_sigpending		sys32_rt_sigpending
 177	i386	rt_sigtimedwait		sys_rt_sigtimedwait		compat_sys_rt_sigtimedwait
 178	i386	rt_sigqueueinfo		sys_rt_sigqueueinfo		sys32_rt_sigqueueinfo
-- 
1.7.6.5

