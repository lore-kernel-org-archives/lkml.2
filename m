Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0FSFwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:52:18 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38375 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0FSFwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:52:17 -0400
Date: Fri, 18 Jun 2010 22:51:56 -0700
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
Message-ID: <20100619055156.GS24749@outflux.net>
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

The code is 32bit already, and can be used in 32bit routines.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/kernel/trampoline_64.S    |    2 +-
 arch/x86/kernel/verify_cpu.S       |  105 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/verify_cpu_64.S    |  105 ------------------------------------
 4 files changed, 107 insertions(+), 107 deletions(-)
 create mode 100644 arch/x86/kernel/verify_cpu.S
 delete mode 100644 arch/x86/kernel/verify_cpu_64.S

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index faff0dc..17f9620 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -182,7 +182,7 @@ no_longmode:
 	hlt
 	jmp     1b
 
-#include "../../kernel/verify_cpu_64.S"
+#include "../../kernel/verify_cpu.S"
 
 	/*
 	 * Be careful here startup_64 needs to be at a predictable
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 3af2dff..075d130 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -127,7 +127,7 @@ startup_64:
 no_longmode:
 	hlt
 	jmp no_longmode
-#include "verify_cpu_64.S"
+#include "verify_cpu.S"
 
 	# Careful these need to be in the same 64K segment as the above;
 tidt:
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
new file mode 100644
index 0000000..45b6f8a
--- /dev/null
+++ b/arch/x86/kernel/verify_cpu.S
@@ -0,0 +1,105 @@
+/*
+ *
+ *	verify_cpu.S - Code for cpu long mode and SSE verification. This
+ *	code has been borrowed from boot/setup.S and was introduced by
+ * 	Andi Kleen.
+ *
+ *	Copyright (c) 2007  Andi Kleen (ak@suse.de)
+ *	Copyright (c) 2007  Eric Biederman (ebiederm@xmission.com)
+ *	Copyright (c) 2007  Vivek Goyal (vgoyal@in.ibm.com)
+ *
+ * 	This source code is licensed under the GNU General Public License,
+ * 	Version 2.  See the file COPYING for more details.
+ *
+ *	This is a common code for verification whether CPU supports
+ * 	long mode and SSE or not. It is not called directly instead this
+ *	file is included at various places and compiled in that context.
+ * 	Following are the current usage.
+ *
+ * 	This file is included by both 16bit and 32bit code.
+ *
+ *	arch/x86_64/boot/setup.S : Boot cpu verification (16bit)
+ *	arch/x86_64/boot/compressed/head.S: Boot cpu verification (32bit)
+ *	arch/x86_64/kernel/trampoline.S: secondary processor verfication (16bit)
+ *	arch/x86_64/kernel/acpi/wakeup.S:Verfication at resume (16bit)
+ *
+ *	verify_cpu, returns the status of cpu check in register %eax.
+ *		0: Success    1: Failure
+ *
+ * 	The caller needs to check for the error code and take the action
+ * 	appropriately. Either display a message or halt.
+ */
+
+#include <asm/cpufeature.h>
+
+verify_cpu:
+	pushfl				# Save caller passed flags
+	pushl	$0			# Kill any dangerous flags
+	popfl
+
+	pushfl				# standard way to check for cpuid
+	popl	%eax
+	movl	%eax,%ebx
+	xorl	$0x200000,%eax
+	pushl	%eax
+	popfl
+	pushfl
+	popl	%eax
+	cmpl	%eax,%ebx
+	jz	verify_cpu_no_longmode	# cpu has no cpuid
+
+	movl	$0x0,%eax		# See if cpuid 1 is implemented
+	cpuid
+	cmpl	$0x1,%eax
+	jb	verify_cpu_no_longmode	# no cpuid 1
+
+	xor	%di,%di
+	cmpl	$0x68747541,%ebx	# AuthenticAMD
+	jnz	verify_cpu_noamd
+	cmpl	$0x69746e65,%edx
+	jnz	verify_cpu_noamd
+	cmpl	$0x444d4163,%ecx
+	jnz	verify_cpu_noamd
+	mov	$1,%di			# cpu is from AMD
+
+verify_cpu_noamd:
+	movl    $0x1,%eax		# Does the cpu have what it takes
+	cpuid
+	andl	$REQUIRED_MASK0,%edx
+	xorl	$REQUIRED_MASK0,%edx
+	jnz	verify_cpu_no_longmode
+
+	movl    $0x80000000,%eax	# See if extended cpuid is implemented
+	cpuid
+	cmpl    $0x80000001,%eax
+	jb      verify_cpu_no_longmode	# no extended cpuid
+
+	movl    $0x80000001,%eax	# Does the cpu have what it takes
+	cpuid
+	andl    $REQUIRED_MASK1,%edx
+	xorl    $REQUIRED_MASK1,%edx
+	jnz     verify_cpu_no_longmode
+
+verify_cpu_sse_test:
+	movl	$1,%eax
+	cpuid
+	andl	$SSE_MASK,%edx
+	cmpl	$SSE_MASK,%edx
+	je	verify_cpu_sse_ok
+	test	%di,%di
+	jz	verify_cpu_no_longmode	# only try to force SSE on AMD
+	movl	$0xc0010015,%ecx	# HWCR
+	rdmsr
+	btr	$15,%eax		# enable SSE
+	wrmsr
+	xor	%di,%di			# don't loop
+	jmp	verify_cpu_sse_test	# try again
+
+verify_cpu_no_longmode:
+	popfl				# Restore caller passed flags
+	movl $1,%eax
+	ret
+verify_cpu_sse_ok:
+	popfl				# Restore caller passed flags
+	xorl %eax, %eax
+	ret
diff --git a/arch/x86/kernel/verify_cpu_64.S b/arch/x86/kernel/verify_cpu_64.S
deleted file mode 100644
index 45b6f8a..0000000
--- a/arch/x86/kernel/verify_cpu_64.S
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- *
- *	verify_cpu.S - Code for cpu long mode and SSE verification. This
- *	code has been borrowed from boot/setup.S and was introduced by
- * 	Andi Kleen.
- *
- *	Copyright (c) 2007  Andi Kleen (ak@suse.de)
- *	Copyright (c) 2007  Eric Biederman (ebiederm@xmission.com)
- *	Copyright (c) 2007  Vivek Goyal (vgoyal@in.ibm.com)
- *
- * 	This source code is licensed under the GNU General Public License,
- * 	Version 2.  See the file COPYING for more details.
- *
- *	This is a common code for verification whether CPU supports
- * 	long mode and SSE or not. It is not called directly instead this
- *	file is included at various places and compiled in that context.
- * 	Following are the current usage.
- *
- * 	This file is included by both 16bit and 32bit code.
- *
- *	arch/x86_64/boot/setup.S : Boot cpu verification (16bit)
- *	arch/x86_64/boot/compressed/head.S: Boot cpu verification (32bit)
- *	arch/x86_64/kernel/trampoline.S: secondary processor verfication (16bit)
- *	arch/x86_64/kernel/acpi/wakeup.S:Verfication at resume (16bit)
- *
- *	verify_cpu, returns the status of cpu check in register %eax.
- *		0: Success    1: Failure
- *
- * 	The caller needs to check for the error code and take the action
- * 	appropriately. Either display a message or halt.
- */
-
-#include <asm/cpufeature.h>
-
-verify_cpu:
-	pushfl				# Save caller passed flags
-	pushl	$0			# Kill any dangerous flags
-	popfl
-
-	pushfl				# standard way to check for cpuid
-	popl	%eax
-	movl	%eax,%ebx
-	xorl	$0x200000,%eax
-	pushl	%eax
-	popfl
-	pushfl
-	popl	%eax
-	cmpl	%eax,%ebx
-	jz	verify_cpu_no_longmode	# cpu has no cpuid
-
-	movl	$0x0,%eax		# See if cpuid 1 is implemented
-	cpuid
-	cmpl	$0x1,%eax
-	jb	verify_cpu_no_longmode	# no cpuid 1
-
-	xor	%di,%di
-	cmpl	$0x68747541,%ebx	# AuthenticAMD
-	jnz	verify_cpu_noamd
-	cmpl	$0x69746e65,%edx
-	jnz	verify_cpu_noamd
-	cmpl	$0x444d4163,%ecx
-	jnz	verify_cpu_noamd
-	mov	$1,%di			# cpu is from AMD
-
-verify_cpu_noamd:
-	movl    $0x1,%eax		# Does the cpu have what it takes
-	cpuid
-	andl	$REQUIRED_MASK0,%edx
-	xorl	$REQUIRED_MASK0,%edx
-	jnz	verify_cpu_no_longmode
-
-	movl    $0x80000000,%eax	# See if extended cpuid is implemented
-	cpuid
-	cmpl    $0x80000001,%eax
-	jb      verify_cpu_no_longmode	# no extended cpuid
-
-	movl    $0x80000001,%eax	# Does the cpu have what it takes
-	cpuid
-	andl    $REQUIRED_MASK1,%edx
-	xorl    $REQUIRED_MASK1,%edx
-	jnz     verify_cpu_no_longmode
-
-verify_cpu_sse_test:
-	movl	$1,%eax
-	cpuid
-	andl	$SSE_MASK,%edx
-	cmpl	$SSE_MASK,%edx
-	je	verify_cpu_sse_ok
-	test	%di,%di
-	jz	verify_cpu_no_longmode	# only try to force SSE on AMD
-	movl	$0xc0010015,%ecx	# HWCR
-	rdmsr
-	btr	$15,%eax		# enable SSE
-	wrmsr
-	xor	%di,%di			# don't loop
-	jmp	verify_cpu_sse_test	# try again
-
-verify_cpu_no_longmode:
-	popfl				# Restore caller passed flags
-	movl $1,%eax
-	ret
-verify_cpu_sse_ok:
-	popfl				# Restore caller passed flags
-	xorl %eax, %eax
-	ret
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
