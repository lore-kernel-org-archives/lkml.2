Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab2EWQBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:01:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58956 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab2EWQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:01:53 -0400
MIME-Version: 1.0
Date: Wed, 23 May 2012 11:01:50 -0500
Message-ID: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
Subject: New ARM asm/syscall.h incompatible? (commit bf2c9f9866928df60157bc4f1ab39f93a32c754e)
From: Will Drewry <wad@chromium.org>
To: wade_farnsworth@mentor.com, stevenrwalter@gmail.com
Cc: will.deacon@arm.com, rmk+kernel@arm.linux.org.uk, linux@arm.linux.org.uk,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wade and Steven,

I don't believe the syscall_get_arguments/syscall_set_arguments
implementation that landed in 3.4 is correct or safe.  I didn't see it
get pulled in - sorry for not mailing sooner! :(

The current implementation allows for _7_ arguments and allows the 0th
index to be the ARM_ORIG_r0 instead of starting with ARM_r0 == 0.  In
the global description of syscall_*_arguments it says:

 * It's only valid to call this when @task is stopped for tracing on
 * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
 * It's invalid to call this with @i + @n > 6; we only support system calls
 * taking up to 6 arguments.

This means that the current implementation is broken when matching
system call arguments for ftrace (unless there is an arch specific
hack in there) and it breaks internal kernel API for any other
consumers without arch knowledge (like seccomp mode=2).  Is there a
reason to expose ARM_ORIG_r0 this way?  Am I misreading?

My understanding of the arch register usage at syscall time is something like:
- ORIG_r0 gets the syscall number
- r0 becomes the first system call argument
- system call proceeds
- on return, r0 is the return value

Right now, anyone who asks for the first argument will get the system
call number (syscall_get_nr) instead of the first argument.  The
attached patch fixes this, but I'm curious why this is and how it
didn't break ftrace!  Am I missing something?

Even audit_syscall_entry() uses ARM_r0 for the first argument which
means that any future consumers doing syscall_get_arguments(..., 0, 6)
would get the wrong first argument.

I'm also curious why the system call argument getter/setters allow for
invalid requests instead of BUG_ON()ing?  All code that exposes
syscall arguments to userspace should be limiting the number to a
maximum of 6, and any other badness is a definite kernel bug.  Am I
just really confused?

Any insights will be appreciated - thanks!
will

-----
>From af693829bc883b2cb2c2050119839983505a01c3 Mon Sep 17 00:00:00 2001
From: Will Drewry <wad@chromium.org>
Date: Wed, 23 May 2012 10:54:28 -0500
Subject: [PATCH] arm: syscall.h: fix up syscall_set/get_arguments

syscall_{get,set}_arguments currently allow up to 7 arguments and make
the system call number a virtual argument.  This breaks the internal
asm/syscall.h ABI and makes the implementation incompatible with
existing implementations.

This change converts those functions to behave as they do on other
arches: 6 arguments and leave the syscall to syscall_get_nr and
syscall_rollback.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/arm/include/asm/syscall.h |   33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index c334a23..c30035a 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -43,29 +43,14 @@ static inline void syscall_set_return_value(struct
task_struct *task,
 	regs->ARM_r0 = (long) error ? error : val;
 }

-#define SYSCALL_MAX_ARGS 7
+#define SYSCALL_MAX_ARGS 6

 static inline void syscall_get_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 unsigned int i, unsigned int n,
 					 unsigned long *args)
 {
-	if (i + n > SYSCALL_MAX_ARGS) {
-		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
-		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
-		pr_warning("%s called with max args %d, handling only %d\n",
-			   __func__, i + n, SYSCALL_MAX_ARGS);
-		memset(args_bad, 0, n_bad * sizeof(args[0]));
-		n = SYSCALL_MAX_ARGS - i;
-	}
-
-	if (i == 0) {
-		args[0] = regs->ARM_ORIG_r0;
-		args++;
-		i++;
-		n--;
-	}
-
+	BUG_ON(i + n > SYSCALL_MAX_ARGS);
 	memcpy(args, &regs->ARM_r0 + i, n * sizeof(args[0]));
 }

@@ -74,19 +59,7 @@ static inline void syscall_set_arguments(struct
task_struct *task,
 					 unsigned int i, unsigned int n,
 					 const unsigned long *args)
 {
-	if (i + n > SYSCALL_MAX_ARGS) {
-		pr_warning("%s called with max args %d, handling only %d\n",
-			   __func__, i + n, SYSCALL_MAX_ARGS);
-		n = SYSCALL_MAX_ARGS - i;
-	}
-
-	if (i == 0) {
-		regs->ARM_ORIG_r0 = args[0];
-		args++;
-		i++;
-		n--;
-	}
-
+	BUG_ON(i + n > SYSCALL_MAX_ARGS);
 	memcpy(&regs->ARM_r0 + i, args, n * sizeof(args[0]));
 }

-- 
1.7.9.5
