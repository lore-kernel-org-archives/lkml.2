Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0FSFwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:52:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36580 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0FSFwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:52:39 -0400
Date: Fri, 18 Jun 2010 22:52:25 -0700
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20100619055225.GT24749@outflux.net>
References: <20100619055010.GR24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619055010.GR24749@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX cannot
be inappropriately controlled by the BIOS on Intel CPUs.  If NX actually
needs to be disabled, "noexec=off" can be used.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/verify_cpu.S |   49 +++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 45b6f8a..d6a0be6 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -7,6 +7,7 @@
  *	Copyright (c) 2007  Andi Kleen (ak@suse.de)
  *	Copyright (c) 2007  Eric Biederman (ebiederm@xmission.com)
  *	Copyright (c) 2007  Vivek Goyal (vgoyal@in.ibm.com)
+ *	Copyright (c) 2010  Kees Cook (kees.cook@canonical.com)
  *
  * 	This source code is licensed under the GNU General Public License,
  * 	Version 2.  See the file COPYING for more details.
@@ -14,23 +15,22 @@
  *	This is a common code for verification whether CPU supports
  * 	long mode and SSE or not. It is not called directly instead this
  *	file is included at various places and compiled in that context.
- * 	Following are the current usage.
+ *	This file is expected to run in 32bit code.  Currently:
  *
- * 	This file is included by both 16bit and 32bit code.
+ *	arch/x86_64/boot/compressed/head_64.S: Boot cpu verification
+ *	arch/x86_64/kernel/trampoline_64.S: secondary processor verfication
  *
- *	arch/x86_64/boot/setup.S : Boot cpu verification (16bit)
- *	arch/x86_64/boot/compressed/head.S: Boot cpu verification (32bit)
- *	arch/x86_64/kernel/trampoline.S: secondary processor verfication (16bit)
- *	arch/x86_64/kernel/acpi/wakeup.S:Verfication at resume (16bit)
- *
- *	verify_cpu, returns the status of cpu check in register %eax.
+ *	verify_cpu, returns the status of longmode and SSE in register %eax.
  *		0: Success    1: Failure
  *
+ *	On Intel, the XD_DISABLE flag will be cleared as a side-effect.
+ *
  * 	The caller needs to check for the error code and take the action
  * 	appropriately. Either display a message or halt.
  */
 
 #include <asm/cpufeature.h>
+#include <asm/msr-index.h>
 
 verify_cpu:
 	pushfl				# Save caller passed flags
@@ -61,8 +61,41 @@ verify_cpu:
 	cmpl	$0x444d4163,%ecx
 	jnz	verify_cpu_noamd
 	mov	$1,%di			# cpu is from AMD
+	jmp	verify_cpu_check
 
 verify_cpu_noamd:
+	cmpl	$0x756e6547,%ebx        # GenuineIntel?
+	jnz	verify_cpu_check
+	cmpl	$0x49656e69,%edx
+	jnz	verify_cpu_check
+	cmpl	$0x6c65746e,%ecx
+	jnz	verify_cpu_check
+
+	# only call IA32_MISC_ENABLE when:
+	# family > 6 || (family == 6 && model >= 0xd)
+	movl	$0x1, %eax		# check CPU family and model
+	cpuid
+	movl	%eax, %ecx
+
+	andl	$0x0ff00f00, %eax	# mask family and extended family
+	shrl	$8, %eax
+	cmpl	$6, %eax
+	ja	verify_cpu_clear_xd	# family > 6, ok
+	jb	verify_cpu_check	# family < 6, skip
+
+	andl	$0x000f00f0, %ecx	# mask model and extended model
+	shrl	$4, %ecx
+	cmpl	$0xd, %ecx
+	jb	verify_cpu_check	# family == 6, model < 0xd, skip
+
+verify_cpu_clear_xd:
+	movl	$MSR_IA32_MISC_ENABLE, %ecx
+	rdmsr
+	btrl	$2, %edx		# clear MSR_IA32_MISC_ENABLE_XD_DISABLE
+	jnc	verify_cpu_check	# only write MSR if bit was changed
+	wrmsr
+
+verify_cpu_check:
 	movl    $0x1,%eax		# Does the cpu have what it takes
 	cpuid
 	andl	$REQUIRED_MASK0,%edx
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
