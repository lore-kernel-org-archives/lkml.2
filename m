Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2FSN6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:58:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab2FSN6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:58:41 -0400
References: <1340090958.18760.17.camel@suxuemin>
User-Agent: K-9 Mail for Android
In-Reply-To: <1340090958.18760.17.camel@suxuemin>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] clear the frame pointer in copy_thread
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 19 Jun 2012 06:57:09 -0700
To: "Su, Xuemin" <xuemin.su@intel.com>, akpm@linux-foundation.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
CC: yanmin_zhang@linux.intel.com
Message-ID: <eab3ba1a-bcd4-49a7-baab-d44e386e3ed3@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't clear to me this is the right thing to do this in the kernel.  A frame pointer isn't obligatory and doing this in user space seems more appropriate.

"Su, Xuemin" <xuemin.su@intel.com> wrote:

>From: xueminsu <xuemin.su@intel.com>
>
>When creating a userspace thread, kernel copies all parent
>thread’s registers to the child thread, including bp register
>which is used to create stack frame. At this point, the bp
>register is pointing to the parent thread’s last stack frame.
>
>So, after the child thread is created, its bp register points
>to the parent thread’s stack area, and the value would be pushed
>to its own stack to form its first stack frame when it calls its
>first function.
>
>This would not be a problem if the child thread and the parent
>thread do not share the VM or if they share the VM and have the
>same stack. But if they share the VM and have different stacks,
>this would cause an issue: when we try to print the child thread’s
>stack trace, we would eventually walk into the parent thread’s
>stack area, and sometimes we will occasionally prints out the
>parent thread’s stack trace.
>
>Currently some version of libc clears the frame pointer just after
>the thread is created, but this is not guaranteed.
>
>Signed-off-by: xueminsu <xuemin.su@intel.com>
>---
> arch/x86/kernel/process_32.c |    9 +++++++++
> arch/x86/kernel/process_64.c |    9 +++++++++
> 2 files changed, 18 insertions(+), 0 deletions(-)
>
>diff --git a/arch/x86/kernel/process_32.c
>b/arch/x86/kernel/process_32.c
>index 516fa18..b1b6d42 100644
>--- a/arch/x86/kernel/process_32.c
>+++ b/arch/x86/kernel/process_32.c
>@@ -139,6 +139,15 @@ int copy_thread(unsigned long clone_flags,
>unsigned long sp,
> 	childregs->ax = 0;
> 	childregs->sp = sp;
> 
>+	/*
>+	 * If the child thread and the parent thread share the VM
>+	 * but have different stack, the child thread's bp register
>+	 * should be set to null, preventing it from pointing to
>+	 * the parent thread's stack area.
>+	 */
>+	if ((sp != regs->sp) && (clone_flags & CLONE_VM))
>+		childregs->bp = 0;
>+
> 	p->thread.sp = (unsigned long) childregs;
> 	p->thread.sp0 = (unsigned long) (childregs+1);
> 
>diff --git a/arch/x86/kernel/process_64.c
>b/arch/x86/kernel/process_64.c
>index 61cdf7f..5acff83 100644
>--- a/arch/x86/kernel/process_64.c
>+++ b/arch/x86/kernel/process_64.c
>@@ -163,6 +163,15 @@ int copy_thread(unsigned long clone_flags,
>unsigned long sp,
> 	else
> 		childregs->sp = (unsigned long)childregs;
> 
>+	/*
>+	 * If the child thread and the parent thread share the VM
>+	 * but have different stack, the child thread's bp register
>+	 * should be set to null, preventing it from pointing to
>+	 * the parent thread's stack area.
>+	 */
>+	if ((sp != regs->sp) && (clone_flags & CLONE_VM))
>+		childregs->bp = 0;
>+
> 	p->thread.sp = (unsigned long) childregs;
> 	p->thread.sp0 = (unsigned long) (childregs+1);
> 	p->thread.usersp = me->thread.usersp;
>-- 
>1.7.6

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
