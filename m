Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1LESCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:02:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1LESCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:02:47 -0500
Date: Mon, 5 Dec 2011 10:02:32 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-f6b2bc847641ea38e2655c8424fef5d2d19f35f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ED4CEEA020000780006407D@nat28.tlf.novell.com>
References: <4ED4CEEA020000780006407D@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Cleanup some assembly entry points
Git-Commit-ID: f6b2bc847641ea38e2655c8424fef5d2d19f35f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:02:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6b2bc847641ea38e2655c8424fef5d2d19f35f9
Gitweb:     http://git.kernel.org/tip/f6b2bc847641ea38e2655c8424fef5d2d19f35f9
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 29 Nov 2011 11:24:10 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 17:24:43 +0100

x86-64: Cleanup some assembly entry points

system_call_after_swapgs doesn't really benefit from forcing
alignment from it - quite the opposite, native code needlessly
so far got a big NOP instruction inserted in front of it. Xen
being the only user of the separate entry point can well live
with the branch going to three bytes into a cache line.

The compatibility mode ptregs entry points for one can make use
of the GLOBAL() macro, and should be suitably aligned. Their
shared continuation point (ia32_ptregs_common) otoh doesn't need
to be global at all, but should continue to be properly aligned.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/4ED4CEEA020000780006407D@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/ia32/ia32entry.S  |    7 ++++---
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 0d5c279..3e27456 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -453,8 +453,8 @@ quiet_ni_syscall:
 	CFI_ENDPROC
 	
 	.macro PTREGSCALL label, func, arg
-	.globl \label
-\label:
+	ALIGN
+GLOBAL(\label)
 	leaq \func(%rip),%rax
 	leaq -ARGOFFSET+8(%rsp),\arg	/* 8 for return address */
 	jmp  ia32_ptregs_common	
@@ -471,7 +471,8 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 
-ENTRY(ia32_ptregs_common)
+	ALIGN
+ia32_ptregs_common:
 	popq %r11
 	CFI_ENDPROC
 	CFI_STARTPROC32	simple
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 75f72a5..cfad7fc 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -465,7 +465,7 @@ ENTRY(system_call)
 	 * after the swapgs, so that it can do the swapgs
 	 * for the guest and jump here on syscall.
 	 */
-ENTRY(system_call_after_swapgs)
+GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
 	movq	PER_CPU_VAR(kernel_stack),%rsp
