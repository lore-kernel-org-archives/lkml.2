Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0KIWSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:18:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54442 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab0KIWST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:18:19 -0500
Date: Tue, 9 Nov 2010 14:18:17 -0800
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20101109221817.GZ5876@outflux.net>
References: <20101109221704.GX5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109221704.GX5876@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel CPUs have an additional MSR bit to indicate if the BIOS was
configured to disable the NX cpu feature. This bit was traditionally
used for operating systems that did not understand how to handle the
NX bit. Since Linux understands this, this BIOS flag should be ignored
by default.

In a review[1] of reported hardware being used by Ubuntu bug reporters,
almost 10% of systems had an incorrectly configured BIOS, leaving their
systems unable to use the NX features of their CPU.

This change will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
cannot be inappropriately controlled by the BIOS on Intel CPUs. If, under
very strange hardware configurations, NX actually needs to be disabled,
"noexec=off" can be used to restore the prior behavior.

[1] http://www.outflux.net/blog/archives/2010/02/18/data-mining-for-nx-bit/

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/kernel/verify_cpu.S |   48 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 56a8c2a..ccb4136 100644
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
@@ -14,18 +15,16 @@
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
@@ -62,8 +61,41 @@ verify_cpu:
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
1.7.2.3

-- 
Kees Cook
Ubuntu Security Team
