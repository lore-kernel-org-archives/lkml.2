Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2JRDSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:18:37 -0400
Received: from ozlabs.org ([203.10.76.45]:55401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2JRDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:18:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: mtk.manpages@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        "Lucas De Marchi" <lucas.demarchi@profusion.mobi>,
        <jonathon@jonmasters.org>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 13:42:16 +1030
Message-ID: <87ipa8o4mn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> Sure. But my point that started this subthread was: should we take the
> opportunity now to add a 'flags' argument to the new finit_module()
> system call, so as to allow flexibility in extending the behavior in
> future? There have been so many cases of revised system calls in the
> past few years that replaced calls without a 'flags' argument that it
> seems worth at least some thought before the API is cast in stone.

(CC's trimmed, Lucas & Jon added; please include them in module
discussions!)

So I tried to think of why we'd want flags; if I could think of a
plausible reason, obviously we should do it now.

I think it would be neat for the force flags (eg. ignoring modversions
or ignoring kernel version).  These are the only cases where libkmod
needs to mangle the module.

So here's the patch which adds the flags field, but nothing in there
yet.  I'll add the remove flags soon, so libkmod can assume that if the
syscall exists, those flags will work.

Thoughts?
Rusty.

FIX: add flags arg to sys_finit_module()

Thanks to Michael Kerrisk for keeping us honest.

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 32bc035..8cf7b50 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -868,5 +868,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
-asmlinkage long sys_finit_module(int fd, const char __user *uargs);
+asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 261bf82..8b8d986 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3260,7 +3260,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	return load_module(&info, uargs);
 }
 
-SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
+SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs, int, flags)
 {
 	int err;
 	struct load_info info = { };
@@ -3269,7 +3269,11 @@ SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
 	if (err)
 		return err;
 
-	pr_debug("finit_module: fd=%d, uargs=%p\n", fd, uargs);
+	pr_debug("finit_module: fd=%d, uargs=%p, flags=%i\n", fd, uargs, flags);
+
+	/* Coming RSN... */
+	if (flags)
+		return -EINVAL;
 
 	err = copy_module_from_fd(fd, &info);
 	if (err)
