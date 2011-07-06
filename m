Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1GFJZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:25:35 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9537 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1GFJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:25:31 -0400
X-IronPort-AV: E=Sophos;i="4.65,485,1304294400"; 
   d="scan'208";a="6644934"
Subject: Re: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from
 64 bit.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "Brian Gerst" <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, <x86@kernel.org>
In-Reply-To: <20110705132825.GA3900@sun>
References: <20110705111525.GR17941@sun>
	 <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
	 <20110705132825.GA3900@sun>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 6 Jul 2011 10:25:29 +0100
Message-ID: <1309944329.634.161.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 17:28 +0400, Cyrill Gorcunov wrote:
> On Tue, Jul 05, 2011 at 02:00:12PM +0100, Ian Campbell wrote:
> > For no reason that I can determine 64 bit x86 saves the current eflags
> > in cpu_init purely for use in ret_from_fork. The equivalent 32 bit
> > code simply hard codes 0x0202 as the new EFLAGS which seems safer than
> > relying on a potentially arbitrary EFLAGS saved during cpu_init.
> > 
> > Original i386 changeset
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47a5c6fa0e204a2b63309c648bb2fde36836c826
> > Original x86_64 changset
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=658fdbef66e5e9be79b457edc2cbbb3add840aa9
> > 
> > The only comment in the later indicates that it is following the
> > former, but not why it differs in this way.
> > 
> > This change makes 64 bit use the same mechanism to setup the initial
> > EFLAGS on fork. Note that 64 bit resets EFLAGS before calling
> > schedule_tail() as opposed to 32 bit which calls schedule_tail()
> > first. Therefore the correct value for EFLAGS has opposite IF
> > bit. This will be fixed in a subsequent patch.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Cc: x86@kernel.org
> 
> The whole series looks good to me, thanks Ian! I hope I don't
> miss anything, so lets wait for more feedback ;)

Thanks. Actually I missed the extern declaration in asm/processor.h so
this updated patch should be used instead:

8<-----------------------------------------------

>From a450bf9e1c6e3f436c652b3e4d63b50c1f9848d4 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Wed, 6 Jul 2011 10:24:46 +0100
Subject: [PATCH] x86: drop unnecessary kernel_eflags variable from 64 bit.

For no reason that I can determine 64 bit x86 saves the current eflags
in cpu_init purely for use in ret_from_fork. The equivalent 32 bit
code simply hard codes 0x0202 as the new EFLAGS which seems safer than
relying on a potentially arbitrary EFLAGS saved during cpu_init.

Original i386 changeset
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47a5c6fa0e204a2b63309c648bb2fde36836c826
Original x86_64 changset
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=658fdbef66e5e9be79b457edc2cbbb3add840aa9

The only comment in the later indicates that it is following the
former, but not why it differs in this way.

This change makes 64 bit use the same mechanism to setup the initial
EFLAGS on fork. Note that 64 bit resets EFLAGS before calling
schedule_tail() as opposed to 32 bit which calls schedule_tail()
first. Therefore the correct value for EFLAGS has opposite IF
bit. This will be fixed in a subsequent patch.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/processor.h |    1 -
 arch/x86/kernel/cpu/common.c     |    4 ----
 arch/x86/kernel/entry_64.S       |    2 +-
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2193715..698af88 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -398,7 +398,6 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
-extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..178c3b4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1077,8 +1077,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-unsigned long kernel_eflags;
-
 /*
  * Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
@@ -1231,8 +1229,6 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 	xsave_init();
 
-	raw_local_save_flags(kernel_eflags);
-
 	if (is_uv_system())
 		uv_cpu_init();
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..b50d142 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -396,7 +396,7 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	pushq_cfi kernel_eflags(%rip)
+	pushq_cfi $0x0002
 	popfq_cfi				# reset kernel eflags
 
 	call schedule_tail			# rdi: 'prev' task parameter
-- 
1.7.2.5



