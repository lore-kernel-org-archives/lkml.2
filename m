Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2FSH3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:29:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:35672 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab2FSH3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181966001"
Subject: [PATCH] clear the frame pointer in copy_thread
From: "Su, Xuemin" <xuemin.su@intel.com>
To: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, xuemin.su@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jun 2012 15:29:18 +0800
Message-ID: <1340090958.18760.17.camel@suxuemin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xueminsu <xuemin.su@intel.com>

When creating a userspace thread, kernel copies all parent
thread’s registers to the child thread, including bp register
which is used to create stack frame. At this point, the bp
register is pointing to the parent thread’s last stack frame.

So, after the child thread is created, its bp register points
to the parent thread’s stack area, and the value would be pushed
to its own stack to form its first stack frame when it calls its
first function.

This would not be a problem if the child thread and the parent
thread do not share the VM or if they share the VM and have the
same stack. But if they share the VM and have different stacks,
this would cause an issue: when we try to print the child thread’s
stack trace, we would eventually walk into the parent thread’s
stack area, and sometimes we will occasionally prints out the
parent thread’s stack trace.

Currently some version of libc clears the frame pointer just after
the thread is created, but this is not guaranteed.

Signed-off-by: xueminsu <xuemin.su@intel.com>
---
 arch/x86/kernel/process_32.c |    9 +++++++++
 arch/x86/kernel/process_64.c |    9 +++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 516fa18..b1b6d42 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -139,6 +139,15 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	childregs->ax = 0;
 	childregs->sp = sp;
 
+	/*
+	 * If the child thread and the parent thread share the VM
+	 * but have different stack, the child thread's bp register
+	 * should be set to null, preventing it from pointing to
+	 * the parent thread's stack area.
+	 */
+	if ((sp != regs->sp) && (clone_flags & CLONE_VM))
+		childregs->bp = 0;
+
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 61cdf7f..5acff83 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -163,6 +163,15 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	else
 		childregs->sp = (unsigned long)childregs;
 
+	/*
+	 * If the child thread and the parent thread share the VM
+	 * but have different stack, the child thread's bp register
+	 * should be set to null, preventing it from pointing to
+	 * the parent thread's stack area.
+	 */
+	if ((sp != regs->sp) && (clone_flags & CLONE_VM))
+		childregs->bp = 0;
+
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
 	p->thread.usersp = me->thread.usersp;
-- 
1.7.6



