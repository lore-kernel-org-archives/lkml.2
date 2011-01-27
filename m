Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1A0XA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:00:26 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43727 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab1A0XAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:00:25 -0500
Date: Thu, 27 Jan 2011 15:00:13 -0800
From: Kees Cook <kees.cook@canonical.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Message-ID: <20110127230013.GO4981@outflux.net>
References: <4D41E86D.8060205@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D41E86D.8060205@free.fr>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi matthieu,

On Thu, Jan 27, 2011 at 10:49:33PM +0100, matthieu castet wrote:
> ebba638ae723d8a8fc2f7abce5ec18b688b791d7 x86, cpu: Call verify_cpu during 32bit CPU startup look buggy.
> 
> It add a call to verify_cpu, but we never set the stack before (I check with qemu + gdbserver that sp is random
> when doing cpu hotplug).
> This mean do randomly corrupt the memory.

Yikes, good catch.

arch/x86/kernel/trampoline_64.S uses:
        movw    $(trampoline_stack_end - r_base), %sp

arch/x86/boot/compressed/head_64.S uses:
        movl    $boot_stack_end, %eax
        addl    %ebp, %eax
        movl    %eax, %esp

what would be safe for arch/x86/kernel/head_32.S ? It uses "stack_start",
but later after paging set-up. Is the following sane to solve this?


diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fc293dc..8ddd0e4 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -284,6 +284,8 @@ ENTRY(startup_32_smp)
 	movl %eax,%gs
 #endif /* CONFIG_SMP */
 default_entry:
+	/* Set up the stack pointer */
+	lss stack_start,%esp
 
 /*
  *	New page tables may be in 4Mbyte page mode and may
@@ -347,8 +349,6 @@ default_entry:
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
 1:
-	/* Set up the stack pointer */
-	lss stack_start,%esp
 
 /*
  * Initialize eflags.  Some BIOS's leave bits like NT set.  This would

-Kees


-- 
Kees Cook
Ubuntu Security Team
