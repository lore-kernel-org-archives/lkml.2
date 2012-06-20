Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2FTB0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:26:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:62298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab2FTB0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:26:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182450652"
Message-ID: <1340155695.7225.6.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] clear the frame pointer in copy_thread
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Su, Xuemin" <xuemin.su@intel.com>, akpm@linux-foundation.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 09:28:15 +0800
In-Reply-To: <eab3ba1a-bcd4-49a7-baab-d44e386e3ed3@email.android.com>
References: <1340090958.18760.17.camel@suxuemin>
	 <eab3ba1a-bcd4-49a7-baab-d44e386e3ed3@email.android.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 06:57 -0700, H. Peter Anvin wrote:
> It isn't clear to me this is the right thing to do this in the kernel.  A frame pointer isn't obligatory and doing this in user space seems more appropriate.
Peter,

Thanks for the kind comments. You are right.

Yanmin

> 
> "Su, Xuemin" <xuemin.su@intel.com> wrote:
> 
> >From: xueminsu <xuemin.su@intel.com>
> >
> >When creating a userspace thread, kernel copies all parent
> >thread’s registers to the child thread, including bp register
> >which is used to create stack frame. At this point, the bp
> >register is pointing to the parent thread’s last stack frame.
> >
> >So, after the child thread is created, its bp register points
> >to the parent thread’s stack area, and the value would be pushed
> >to its own stack to form its first stack frame when it calls its
> >first function.
> >
> >This would not be a problem if the child thread and the parent
> >thread do not share the VM or if they share the VM and have the
> >same stack. But if they share the VM and have different stacks,
> >this would cause an issue: when we try to print the child thread’s
> >stack trace, we would eventually walk into the parent thread’s
> >stack area, and sometimes we will occasionally prints out the
> >parent thread’s stack trace.
> >
> >Currently some version of libc clears the frame pointer just after
> >the thread is created, but this is not guaranteed.
> >
> >Signed-off-by: xueminsu <xuemin.su@intel.com>
> >---
> > arch/x86/kernel/process_32.c |    9 +++++++++
> > arch/x86/kernel/process_64.c |    9 +++++++++
> > 2 files changed, 18 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/kernel/process_32.c
> >b/arch/x86/kernel/process_32.c
> >index 516fa18..b1b6d42 100644
> >--- a/arch/x86/kernel/process_32.c
> >+++ b/arch/x86/kernel/process_32.c
> >@@ -139,6 +139,15 @@ int copy_thread(unsigned long clone_flags,
> >unsigned long sp,
> > 	childregs->ax = 0;
> > 	childregs->sp = sp;
> > 
> >+	/*
> >+	 * If the child thread and the parent thread share the VM
> >+	 * but have different stack, the child thread's bp register
> >+	 * should be set to null, preventing it from pointing to
> >+	 * the parent thread's stack area.
> >+	 */
> >+	if ((sp != regs->sp) && (clone_flags & CLONE_VM))
> >+		childregs->bp = 0;
> >+
> > 	p->thread.sp = (unsigned long) childregs;
> > 	p->thread.sp0 = (unsigned long) (childregs+1);
> > 
> >diff --git a/arch/x86/kernel/process_64.c
> >b/arch/x86/kernel/process_64.c
> >index 61cdf7f..5acff83 100644
> >--- a/arch/x86/kernel/process_64.c
> >+++ b/arch/x86/kernel/process_64.c
> >@@ -163,6 +163,15 @@ int copy_thread(unsigned long clone_flags,
> >unsigned long sp,
> > 	else
> > 		childregs->sp = (unsigned long)childregs;
> > 
> >+	/*
> >+	 * If the child thread and the parent thread share the VM
> >+	 * but have different stack, the child thread's bp register
> >+	 * should be set to null, preventing it from pointing to
> >+	 * the parent thread's stack area.
> >+	 */
> >+	if ((sp != regs->sp) && (clone_flags & CLONE_VM))
> >+		childregs->bp = 0;
> >+
> > 	p->thread.sp = (unsigned long) childregs;
> > 	p->thread.sp0 = (unsigned long) (childregs+1);
> > 	p->thread.usersp = me->thread.usersp;
> >-- 
> >1.7.6
> 


