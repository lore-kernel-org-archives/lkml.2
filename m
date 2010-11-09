Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0KISOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:14:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49945 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab0KISOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:14:37 -0500
Date: Tue, 9 Nov 2010 10:14:34 -0800
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
Message-ID: <20101109181434.GF5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109181157.GE5876@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file does not need the _64 extension since the code is 32bit already,
and can be used in 32bit routines.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/kernel/trampoline_64.S    |    2 +-
 arch/x86/kernel/verify_cpu.S       |  106 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/verify_cpu_64.S    |  106 ------------------------------------
 4 files changed, 108 insertions(+), 108 deletions(-)
 create mode 100644 arch/x86/kernel/verify_cpu.S
 delete mode 100644 arch/x86/kernel/verify_cpu_64.S

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 52f85a1..35af09d 100644
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
index 0000000..56a8c2a
--- /dev/null
+++ b/arch/x86/kernel/verify_cpu.S
@@ -0,0 +1,106 @@
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
+#include <asm/msr-index.h>
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
+	movl	$MSR_K7_HWCR,%ecx
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
index 56a8c2a..0000000
--- a/arch/x86/kernel/verify_cpu_64.S
+++ /dev/null
@@ -1,106 +0,0 @@
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
-#include <asm/msr-index.h>
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
-	movl	$MSR_K7_HWCR,%ecx
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
1.7.2.3


-- 
Kees Cook
Ubuntu Security Team
