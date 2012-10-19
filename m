Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2JSIp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:45:26 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:47222 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab2JSIpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:45:22 -0400
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] unicore32: switch to generic sys_execve()
Date: Fri, 19 Oct 2012 16:43:10 +0800
Message-Id: <1350636190-6303-2-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350636190-6303-1-git-send-email-gxt@mprc.pku.edu.cn>
References: <1350636190-6303-1-git-send-email-gxt@mprc.pku.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-and-Tested-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/uapi/asm/unistd.h |    1 +
 arch/unicore32/kernel/entry.S            |    5 -----
 arch/unicore32/kernel/sys.c              |   21 ---------------------
 3 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/arch/unicore32/include/uapi/asm/unistd.h b/arch/unicore32/include/uapi/asm/unistd.h
index 2abcf61..d18a3be 100644
--- a/arch/unicore32/include/uapi/asm/unistd.h
+++ b/arch/unicore32/include/uapi/asm/unistd.h
@@ -12,3 +12,4 @@
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
+#define __ARCH_WANT_SYS_EXECVE
diff --git a/arch/unicore32/kernel/entry.S b/arch/unicore32/kernel/entry.S
index 32648c9..7049350 100644
--- a/arch/unicore32/kernel/entry.S
+++ b/arch/unicore32/kernel/entry.S
@@ -668,11 +668,6 @@ __cr_alignment:
 #endif
 	.ltorg
 
-ENTRY(sys_execve)
-		add	r3, sp, #S_OFF
-		b	__sys_execve
-ENDPROC(sys_execve)
-
 ENTRY(sys_clone)
 		add	ip, sp, #S_OFF
 		stw	ip, [sp+], #4
diff --git a/arch/unicore32/kernel/sys.c b/arch/unicore32/kernel/sys.c
index 8b6e4cc..9680134 100644
--- a/arch/unicore32/kernel/sys.c
+++ b/arch/unicore32/kernel/sys.c
@@ -42,27 +42,6 @@ asmlinkage long __sys_clone(unsigned long clone_flags, unsigned long newsp,
 			parent_tid, child_tid);
 }
 
-/* sys_execve() executes a new program.
- * This is called indirectly via a small wrapper
- */
-asmlinkage long __sys_execve(const char __user *filename,
-			  const char __user *const __user *argv,
-			  const char __user *const __user *envp,
-			  struct pt_regs *regs)
-{
-	int error;
-	struct filename *fn;
-
-	fn = getname(filename);
-	error = PTR_ERR(fn);
-	if (IS_ERR(fn))
-		goto out;
-	error = do_execve(fn->name, argv, envp, regs);
-	putname(fn);
-out:
-	return error;
-}
-
 /* Note: used by the compat code even in 64-bit Linux. */
 SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
-- 
1.7.0.4

