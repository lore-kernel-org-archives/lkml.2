Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2K2JNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:13:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50337 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab2K2JNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:13:21 -0500
Date: Thu, 29 Nov 2012 10:13:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
Message-ID: <20121129091317.GA21084@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
 <20121128204158.GC14635@liondog.tnic>
 <50B6A8F3.5000407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50B6A8F3.5000407@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 04:14:43PM -0800, H. Peter Anvin wrote:
> Wrong barrier semantics.

Let me try to understand what you mean by that :)

Now, your version's asm output looks like this:

----
	.loc 2 95 0
	movl	$139, %esi	#, tmp140
	xorl	%eax, %eax	# tmp141
	movl	%esi, %ecx	# tmp140,
	movl	%eax, %edx	# tmp141,
#APP
# 95 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/msr.h" 1
	wrmsr
# 0 "" 2
#NO_APP
	.loc 3 694 0
	movb	$1, %al	#,
#APP
# 694 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/processor.h" 1
	cpuid
# 0 "" 2
.LVL15:
#NO_APP
----

This is the sync_core() call from early_init_intel(). Now look like 139
remains in %ecx after the WRMSR and CPUID actually gets called with
RAX=1 and RCX=139 (btw, 139 is MSR_IA32_UCODE_REV). Even if this works
I'd say, we don't want to have any stray values in RCX when doing CPUID,
no?

Now here's the version with the change I proposed:

----
	.loc 2 95 0
	xorl	%esi, %esi	# tmp144
	movl	$139, %edi	#, tmp143
	movl	%edi, %ecx	# tmp143,
	movl	%esi, %eax	# tmp144,
	movl	%esi, %edx	# tmp144,
#APP
# 95 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/msr.h" 1
	wrmsr
# 0 "" 2
.LVL15:
#NO_APP
	.loc 3 199 0
	movb	$1, %al	#,
	movl	%esi, %ecx	# tmp144, ecx
#APP
# 199 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/processor.h" 1
	cpuid
# 0 "" 2
.LVL16:
#NO_APP
----

RCX gets correctly cleaned to 0 and *then* we call CPUID.

And the asm output is the same except that RCX gets correctly cleaned up
before calling CPUID.

So what am I missing?

Thanks.

-- 
Regards/Gruss,
    Boris.
