Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0H0Jmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:42:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42732 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0H0Jmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pR/aoUO87YBB/qgoVZMmEcF8l9+XCUvYi0T0xF5tjMvFEuyWXwaQ9MoGg1a5O6r2I4
         oLTE74SUJPyJPTUaeVb9FZ2soHJQpO4n4+ma5pj06DXuFguUbxcQCGj7cvEJK0T/0/24
         aIN0+tvT3FlhIqVRoP9kahslTtuuk1/WPuv4s=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/43] ptrace: change signature of sys_ptrace() and friends
Date: Fri, 27 Aug 2010 18:41:47 +0900
Message-Id: <1282902149-12991-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since user space API of ptrace syscall defines @addr and @data as void
pointers, it would be more appropriate to define them as unsigned long
in kernel. Therefore related functions are changed also.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/ptrace.h   |    9 ++++++---
 include/linux/syscalls.h |    3 ++-
 kernel/ptrace.c          |   16 ++++++++++------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 4272521..67a4cd7 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -108,7 +108,8 @@ extern int ptrace_attach(struct task_struct *tsk);
 extern int ptrace_detach(struct task_struct *, unsigned int);
 extern void ptrace_disable(struct task_struct *);
 extern int ptrace_check_attach(struct task_struct *task, int kill);
-extern int ptrace_request(struct task_struct *child, long request, long addr, long data);
+extern int ptrace_request(struct task_struct *child, long request,
+			  unsigned long addr, unsigned long data);
 extern void ptrace_notify(int exit_code);
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
@@ -132,8 +133,10 @@ static inline void ptrace_unlink(struct task_struct *child)
 		__ptrace_unlink(child);
 }
 
-int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
-int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
+int generic_ptrace_peekdata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data);
+int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data);
 
 /**
  * task_ptrace - return %PT_* flags that apply to a task
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e6319d1..cacc27a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -701,7 +701,8 @@ asmlinkage long sys_nfsservctl(int cmd,
 asmlinkage long sys_syslog(int type, char __user *buf, int len);
 asmlinkage long sys_uselib(const char __user *library);
 asmlinkage long sys_ni_syscall(void);
-asmlinkage long sys_ptrace(long request, long pid, long addr, long data);
+asmlinkage long sys_ptrace(long request, long pid, unsigned long addr,
+			   unsigned long data);
 
 asmlinkage long sys_add_key(const char __user *_type,
 			    const char __user *_description,
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f34d798..f838afe 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -402,7 +402,7 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 	return copied;
 }
 
-static int ptrace_setoptions(struct task_struct *child, long data)
+static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
 	child->ptrace &= ~PT_TRACE_MASK;
 
@@ -481,7 +481,8 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 #define is_sysemu_singlestep(request)	0
 #endif
 
-static int ptrace_resume(struct task_struct *child, long request, long data)
+static int ptrace_resume(struct task_struct *child, long request,
+			 unsigned long data)
 {
 	if (!valid_signal(data))
 		return -EIO;
@@ -558,7 +559,7 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 #endif
 
 int ptrace_request(struct task_struct *child, long request,
-		   long addr, long data)
+		   unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
 	siginfo_t siginfo;
@@ -691,7 +692,8 @@ static struct task_struct *ptrace_get_task_struct(pid_t pid)
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
 
-SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
+SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
+		unsigned long, data)
 {
 	struct task_struct *child;
 	long ret;
@@ -732,7 +734,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
 	return ret;
 }
 
-int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
+int generic_ptrace_peekdata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data)
 {
 	unsigned long tmp;
 	int copied;
@@ -743,7 +746,8 @@ int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
 	return put_user(tmp, (unsigned long __user *)data);
 }
 
-int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
+int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
+			    unsigned long data)
 {
 	int copied;
 
-- 
1.7.2.2

