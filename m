Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2ARBv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:51:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60988 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2ARBv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:51:27 -0500
Date: Wed, 18 Jan 2012 01:51:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: JONGMAN HEO <jongman.heo@samsung.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: build failure with current linus tree
Message-ID: <20120118015122.GW23916@ZenIV.linux.org.uk>
References: <27516709.76321326849450926.JavaMail.weblogic@epml05>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27516709.76321326849450926.JavaMail.weblogic@epml05>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 01:17:31AM +0000, JONGMAN HEO wrote:
> 
> With current linus git (commit a25a2b84), I got following build error,
> 
> arch/x86/kernel/vm86_32.c: In function ??do_sys_vm86??:
> arch/x86/kernel/vm86_32.c:340: error: implicit declaration of function ??__audit_syscall_exit??
> make[3]: *** [arch/x86/kernel/vm86_32.o] Error 1
> 
> I do not have CONFIG_AUDITSYSCALL in my .config.

Um...  OK, I can reproduce it (32bit allmodconfig with AUDIT=y, AUDITSYSCALL=n)
Crap...  It's "Audit: push audit success and retcode into arch ptrace.h".

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index af17e1c..b466cab 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -336,8 +336,10 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 		mark_screen_rdonly(tsk->mm);
 
 	/*call __audit_syscall_exit since we do not exit via the normal paths */
+#ifdef CONFIG_AUDITSYSCALL
 	if (unlikely(current->audit_context))
 		__audit_syscall_exit(1, 0);
+#endif
 
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
