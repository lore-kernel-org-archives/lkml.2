Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1FFIce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:32:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1FFIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:32:32 -0400
Date: Mon, 6 Jun 2011 08:31:41 GMT
From: tip-bot for Andy Lutomirski <luto@MIT.EDU>
Message-ID: <tip-8b4777a4b50cb0c84c1152eac85d24415fb6ff7d@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        luto@MIT.EDU, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, luto@MIT.EDU,
        Louis.Rilling@kerlabs.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
In-Reply-To: <fc134867cc550977cc996866129e11a16ba0f9ea.1307292171.git.luto@mit.edu>
References: <fc134867cc550977cc996866129e11a16ba0f9ea.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Document some of entry_64.S
Git-Commit-ID: 8b4777a4b50cb0c84c1152eac85d24415fb6ff7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:31:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b4777a4b50cb0c84c1152eac85d24415fb6ff7d
Gitweb:     http://git.kernel.org/tip/8b4777a4b50cb0c84c1152eac85d24415fb6ff7d
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Sun, 5 Jun 2011 13:50:18 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jun 2011 21:30:32 +0200

x86-64: Document some of entry_64.S

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/fc134867cc550977cc996866129e11a16ba0f9ea.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/x86/entry_64.txt |   98 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_64.S     |    2 +
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
new file mode 100644
index 0000000..7869f14
--- /dev/null
+++ b/Documentation/x86/entry_64.txt
@@ -0,0 +1,98 @@
+This file documents some of the kernel entries in
+arch/x86/kernel/entry_64.S.  A lot of this explanation is adapted from
+an email from Ingo Molnar:
+
+http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
+
+The x86 architecture has quite a few different ways to jump into
+kernel code.  Most of these entry points are registered in
+arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
+and arch/x86/ia32/ia32entry.S.
+
+The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
+
+Some of these entries are:
+
+ - system_call: syscall instruction from 64-bit code.
+
+ - ia32_syscall: int 0x80 from 32-bit or 64-bit code; compat syscall
+   either way.
+
+ - ia32_syscall, ia32_sysenter: syscall and sysenter from 32-bit
+   code
+
+ - interrupt: An array of entries.  Every IDT vector that doesn't
+   explicitly point somewhere else gets set to the corresponding
+   value in interrupts.  These point to a whole array of
+   magically-generated functions that make their way to do_IRQ with
+   the interrupt number as a parameter.
+
+ - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
+   vsyscall emulation.
+
+ - APIC interrupts: Various special-purpose interrupts for things
+   like TLB shootdown.
+
+ - Architecturally-defined exceptions like divide_error.
+
+There are a few complexities here.  The different x86-64 entries
+have different calling conventions.  The syscall and sysenter
+instructions have their own peculiar calling conventions.  Some of
+the IDT entries push an error code onto the stack; others don't.
+IDT entries using the IST alternative stack mechanism need their own
+magic to get the stack frames right.  (You can find some
+documentation in the AMD APM, Volume 2, Chapter 8 and the Intel SDM,
+Volume 3, Chapter 6.)
+
+Dealing with the swapgs instruction is especially tricky.  Swapgs
+toggles whether gs is the kernel gs or the user gs.  The swapgs
+instruction is rather fragile: it must nest perfectly and only in
+single depth, it should only be used if entering from user mode to
+kernel mode and then when returning to user-space, and precisely
+so. If we mess that up even slightly, we crash.
+
+So when we have a secondary entry, already in kernel mode, we *must
+not* use SWAPGS blindly - nor must we forget doing a SWAPGS when it's
+not switched/swapped yet.
+
+Now, there's a secondary complication: there's a cheap way to test
+which mode the CPU is in and an expensive way.
+
+The cheap way is to pick this info off the entry frame on the kernel
+stack, from the CS of the ptregs area of the kernel stack:
+
+	xorl %ebx,%ebx
+	testl $3,CS+8(%rsp)
+	je error_kernelspace
+	SWAPGS
+
+The expensive (paranoid) way is to read back the MSR_GS_BASE value
+(which is what SWAPGS modifies):
+
+	movl $1,%ebx
+	movl $MSR_GS_BASE,%ecx
+	rdmsr
+	testl %edx,%edx
+	js 1f   /* negative -> in kernel */
+	SWAPGS
+	xorl %ebx,%ebx
+1:	ret
+
+and the whole paranoid non-paranoid macro complexity is about whether
+to suffer that RDMSR cost.
+
+If we are at an interrupt or user-trap/gate-alike boundary then we can
+use the faster check: the stack will be a reliable indicator of
+whether SWAPGS was already done: if we see that we are a secondary
+entry interrupting kernel mode execution, then we know that the GS
+base has already been switched. If it says that we interrupted
+user-space execution then we must do the SWAPGS.
+
+But if we are in an NMI/MCE/DEBUG/whatever super-atomic entry context,
+which might have triggered right after a normal entry wrote CS to the
+stack but before we executed SWAPGS, then the only safe way to check
+for GS is the slower method: the RDMSR.
+
+So we try only to mark those entry methods 'paranoid' that absolutely
+need the more expensive check for the GS base - and we generate all
+'normal' entry points with the regular (faster) entry macros.
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..72c4a77 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -9,6 +9,8 @@
 /*
  * entry.S contains the system-call and fault low-level handling routines.
  *
+ * Some of this is documented in Documentation/x86/entry_64.txt
+ *
  * NOTE: This code handles signal-recognition, which happens every time
  * after an interrupt and after each system call.
  *
