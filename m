Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab1GAVWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:22:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43471 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab1GAVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:22:18 -0400
Date: Fri, 1 Jul 2011 14:19:43 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, Brian Gerst <brgerst@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: add missing verify_cpu to 32bit wakeup
Message-ID: <20110701211943.GA7042@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes will reset the Intel XD_DISABLE MSR bit when resuming from S3,
which can interact poorly with ebba638ae723d8a8fc2f7abce5ec18b688b791d7.
In 32bit PAE mode, this can lead to a fault when EFER is restored by
the kernel wakeup routines, due to it setting the NX bit for a CPU
that (thanks to the BIOS reset) now incorrectly thinks it lacks the NX
feature. 64bit wakeup already handled this through its common call path
that would hit verify_cpu(). 32bit has a separate path for restoring
CPU state on S3 wakeup, and needed to call verify_cpu() to handle this
situation.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: stable@kernel.org
---
 arch/x86/kernel/acpi/realmode/wakeup.S |    4 ++++
 arch/x86/kernel/verify_cpu.S           |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index ead21b6..19698da 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -94,6 +94,9 @@ wakeup_code:
 	/* Do any other stuff... */
 
 #ifndef CONFIG_64BIT
+	/* Recheck NX bit overrides (64bit path does this in trampoline) */
+	call	verify_cpu
+
 	/* This could also be done in C code... */
 	movl	pmode_cr3, %eax
 	movl	%eax, %cr3
@@ -117,6 +120,7 @@ wakeup_code:
 	movl	pmode_cr0, %eax
 	movl	%eax, %cr0
 	jmp	pmode_return
+# include "../../verify_cpu.S"
 #else
 	pushw	$0
 	pushw	trampoline_segment
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index b9242ba..50c5edd 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -20,6 +20,7 @@
  *	arch/x86/boot/compressed/head_64.S: Boot cpu verification
  *	arch/x86/kernel/trampoline_64.S: secondary processor verification
  *	arch/x86/kernel/head_32.S: processor startup
+ *	arch/x86/kernel/acpi/realmode/wakeup.S: 32bit processor resume
  *
  *	verify_cpu, returns the status of longmode and SSE in register %eax.
  *		0: Success    1: Failure
-- 
1.7.4.1

-- 
Kees Cook
Ubuntu Security Team
