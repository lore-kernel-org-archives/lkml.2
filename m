Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2DNXxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 19:53:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab2DNXxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 19:53:08 -0400
Date: Sun, 15 Apr 2012 01:52:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: ptrace && fpu_lazy_restore
Message-ID: <20120414235238.GA11131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Credits to Jan and Chuck, see

	https://bugzilla.redhat.com/show_bug.cgi?id=810668

with reproducer:

	https://bugzilla.redhat.com/attachment.cgi?id=577270

But afaics the root of the problem is clear. Once PTRACE_SETFPREGS
changes fpu.state->fxsave the task obviously needs restore_fpu_checking()
on context switch.

But I am not sure about the fix, and in any case I need more time
to read this new code.

Oleg.

--- x/arch/x86/kernel/i387.c~	2012-04-09 20:12:12.000000000 +0200
+++ x/arch/x86/kernel/i387.c	2012-04-15 01:34:09.000000000 +0200
@@ -301,6 +301,8 @@ int xfpregs_set(struct task_struct *targ
 
 	sanitize_i387_state(target);
 
+	target->thread.fpu.last_cpu = ~0;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.fpu.state->fxsave, 0, -1);
 
@@ -563,6 +565,8 @@ int fpregs_set(struct task_struct *targe
 
 	sanitize_i387_state(target);
 
+	target->thread.fpu.last_cpu = ~0;
+
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 

