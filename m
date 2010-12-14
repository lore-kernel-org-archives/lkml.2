Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100Ab0LNVQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:16:22 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:55628 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760007Ab0LNVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:16:22 -0500
Message-Id: <201012142116.oBELGK1D026229@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 14 Dec 2010 15:57:49 -0500
Subject: [PATCH] arch/tile: handle CLONE_SETTLS in copy_thread(), not user space
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 14 Dec 2010 21:16:21.0067 (UTC) FILETIME=[27A4B9B0:01CB9BD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we were just setting up the "tp" register in the
new task as started by clone() in libc.  However, this is not
quite right, since in principle a signal might be delivered to
the new task before it had its TLS set up.  (Of course, this race
window still exists for resetting the libc getpid() cached value
in the new task, in principle.  But in any case, we are now doing
this exactly the way all other architectures do it.)

This change is important for 2.6.37 since the tile glibc we will
be submitting upstream will not set TLS in user space any more,
so it will only work on a kernel that has this fix.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 8430f45..e90eb53 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -212,6 +212,13 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	childregs->sp = sp;  /* override with new user stack pointer */
 
 	/*
+	 * If CLONE_SETTLS is set, set "tp" in the new task to "r4",
+	 * which is passed in as arg #5 to sys_clone().
+	 */
+	if (clone_flags & CLONE_SETTLS)
+		childregs->tp = regs->regs[4];
+
+	/*
 	 * Copy the callee-saved registers from the passed pt_regs struct
 	 * into the context-switch callee-saved registers area.
 	 * This way when we start the interrupt-return sequence, the
@@ -539,6 +546,7 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	return __switch_to(prev, next, next_current_ksp0(next));
 }
 
+/* Note there is an implicit fifth argument if (clone_flags & CLONE_SETTLS). */
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		void __user *, parent_tidptr, void __user *, child_tidptr,
 		struct pt_regs *, regs)
-- 
1.6.5.2

