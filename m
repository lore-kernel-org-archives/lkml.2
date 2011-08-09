Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1HIQrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:47:22 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:44276 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab1HIQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:47:21 -0400
X-AuditID: 12074423-b7b31ae000000a3c-16-4e41649b9380
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Andy Lutomirski <luto@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>
Subject: [RFC] x86-64: Add vsyscall=emulate|native|none option
Date: Tue,  9 Aug 2011 12:47:10 -0400
Message-Id: <62d52fb8ef3225691220070b6d069f9c1838f5d0.1312908294.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
References: <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixG6nojs7xdHP4MhKY4u+K0fZLY5c+85u
	8XnDPzaLaRvFLV79Kbe4vGsOm8WK852sFlsuNbNaPOp7y27xY8NjVgcuj++tfSwet9r+MHvM
	3/mR0WPnrLvsHptWdbJ5nJjxm8Xj8yY5j1mzDjN5nGj5whrAGcVlk5Kak1mWWqRvl8CVMXfi
	BfaCXu2KDfPmsTcwPlLsYuTkkBAwkVi26B8ThC0mceHeerYuRi4OIYF9jBJXbxxigXDWM0ps
	/TMVynnKJNHefQmshU1ARaJj6QMgm4NDREBIYundOpAaZoGNTBJ/9i9hBakRFrCT2D1nHwuI
	zSKgKnFj0w5GkHpegSCJ3rmsEJvlJI5cfg42klMgUOL9raeMILaQQIBE645pjBMY+RYwMqxi
	lE3JrdLNTczMKU5N1i1OTszLSy3SNdPLzSzRS00p3cQIDmAX5R2Mfw4qHWIU4GBU4uHl5Hfw
	E2JNLCuuzD3EKMnBpCTK6wsMfyG+pPyUyozE4oz4otKc1OJDjBIczEoivPPCgHK8KYmVValF
	+TApaQ4WJXFemZ1AkwTSE0tSs1NTC1KLYLIyHBxKErxKIEMFi1LTUyvSMnNKENJMHJwgw3mA
	htuB1PAWFyTmFmemQ+RPMSpKifPqgiQEQBIZpXlwvbAE84pRHOgVYV52kCoeYHKC634FNJgJ
	aHD9HQeQwSWJCCmpBsYtiVbqj8oWF18vvvSE9dX5G0f19TL3ClWsd37w5gzrvg0z3jd+32w0
	O/LtYqYbF29+WpHMufmZ2vnazJhzrCtWnWNYpzcpXaF9t7/UpUA9mQNPdSdq3/L5yrFZUO10
	2euXhYv0diyxOZn9Km67mcbXoN6yDyHr9oXvDP++x+5+6aRXcS4tOW8PKrEUZyQaajEXFScC
	AEHVtgkLAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscall=native makes vsyscalls as fast as syscalls and makes pin
and DynamoRIO work.  vsyscall=emulate (default) preserves current
behavior, and vsyscall=none is good for paranoid people who don't
need their boxes to work reliably.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

This is an alternate fix.  It applies on top of the patch that
wires up getcpu on x86_64.

 Documentation/kernel-parameters.txt |   21 +++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c       |   35 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/vsyscall_emu_64.S   |   37 ++++++++++++++++++++++++++++++++++-
 3 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e279b72..78926aa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2680,6 +2680,27 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vsyscall=	[X86-64]
+			Controls the behavior of vsyscalls (i.e. calls to
+			fixed addresses of 0xffffffffff600x00 from legacy
+			code).  Most statically-linked binaries and older
+			versions of glibc use these calls.  Because these
+			functions are at fixed addresses, they make nice
+			targets for exploits that can control RIP.
+
+			emulate     [default] Vsyscalls turn into traps and are
+			            emulated reasonably safely.
+
+			native      Vsyscalls are native syscall instructions.
+			            This is a little bit faster than trapping
+			            and makes a few dynamic recompilers work
+			            better than they would in emulation mode.
+			            It also makes exploits much easier to write.
+
+			none        Vsyscalls don't work at all.  This makes
+			            them quite hard to use for exploits but
+			            might break your system.
+
 	vt.cur_default=	[VT] Default cursor shape.
 			Format: 0xCCBBAA, where AA, BB, and CC are the same as
 			the parameters of the <Esc>[?A;B;Cc escape sequence;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index bf8e9ff..e06a200 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -56,6 +56,27 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
+
+static int __init vsyscall_setup(char *str)
+{
+        if (str) {
+                if (!strcmp("emulate", str))
+			vsyscall_mode = EMULATE;
+                else if (!strcmp("native", str))
+                        vsyscall_mode = NATIVE;
+                else if (!strcmp("none", str))
+                        vsyscall_mode = NONE;
+		else
+			return -EINVAL;
+
+		return 0;
+        }
+
+        return -EINVAL;
+}
+early_param("vsyscall", vsyscall_setup);
+
 void update_vsyscall_tz(void)
 {
 	unsigned long flags;
@@ -151,7 +172,13 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
 	if (vsyscall_nr < 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc (exploit attempt?)");
+				  "illegal int 0xcc (exploit attempt or buggy program) -- look up the vsyscall kernel parameter if you need a workaround");
+		goto sigsegv;
+	}
+
+	if (vsyscall_mode == NONE) {
+		warn_bad_vsyscall(KERN_INFO, regs,
+				  "vsyscall attempted with vsyscall=none -- sending SIGSEGV");
 		goto sigsegv;
 	}
 
@@ -260,8 +287,12 @@ void __init map_vsyscall(void)
 	extern char __vvar_page;
 	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
-	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
+	extern char __native_vsyscall_page;
+	if (vsyscall_mode == NATIVE)
+		physaddr_page0 = __pa_symbol(&__native_vsyscall_page);
+
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
+
 	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) != (unsigned long)VVAR_ADDRESS);
 }
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index ffa845e..97bb09d 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -7,9 +7,17 @@
  */
 
 #include <linux/linkage.h>
+
 #include <asm/irq_vectors.h>
+#include <asm/page_types.h>
+#include <asm/unistd_64.h>
+
+/*
+ * There are two versions of the vsyscall code. The unused parts of the
+ * pages are filled with 0xcc by the linker script.
+ */
 
-/* The unused parts of the page are filled with 0xcc by the linker script. */
+/* Mostly safe version used for vsyscall=emulate and vsyscall=none */
 
 .section .vsyscall_0, "a"
 ENTRY(vsyscall_0)
@@ -25,3 +33,30 @@ END(vsyscall_1)
 ENTRY(vsyscall_2)
 	int $VSYSCALL_EMU_VECTOR
 END(vsyscall_2)
+
+
+/* Much less safe version used for vsyscall=native */
+
+__PAGE_ALIGNED_DATA
+	.globl __native_vsyscall_page
+	.balign PAGE_SIZE, 0xcc
+	.type __native_syscall_page, @object
+__native_vsyscall_page:
+
+	mov $__NR_gettimeofday, %rax
+	syscall
+	ret
+
+	.balign 1024, 0xcc
+	mov $__NR_time, %rax
+	syscall
+	ret
+
+	.balign 1024, 0xcc
+	mov $__NR_getcpu, %rax
+	syscall
+	ret
+
+	.balign 4096, 0xcc
+
+	.size __native_vsyscall_page, 4096
\ No newline at end of file
-- 
1.7.6

