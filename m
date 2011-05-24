Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab1EXUb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:31:58 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:56049 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1EXUb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:31:57 -0400
Subject: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 16:31:45 -0400
Message-ID: <1306269105.21443.20.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
which the kernel is decompressed at boot as a security feature that
deters exploit attempts relying on knowledge of the location of kernel
internals.  The default values of the kptr_restrict and dmesg_restrict
sysctls are set to (1) when this is enabled, since hiding kernel
pointers is necessary to preserve the secrecy of the randomized base
address.

This feature also uses a fixed mapping to move the IDT (if not already
done as a fix for the F00F bug), to avoid exposing the location of
kernel internals relative to the original IDT.  This has the additional
security benefit of marking the new virtual address of the IDT
read-only.

Entropy is generated using the RDRAND instruction if it is supported. If
not, then RDTSC is used, if supported. If neither RDRAND nor RDTSC are
supported, then no randomness is introduced. Support for the CPUID
instruction is required to check for the availability of these two
instructions.

Thanks to everyone who contributed helpful suggestions and feedback so
far.

Comments/Questions:

* Since RDRAND is relatively new, only the most recent version of
binutils supports assembling it.  To avoid breaking builds for people
who use older toolchains but want this feature, I hardcoded the opcodes.
If anyone has a better approach, please let me know.

* I chose to mimic the F00F bugfix behavior for moving the IDT, since it
required very little code and has the additional benefit of making the
IDT read-only. Ingo Molnar's suggestion of allocating per-cpu IDTs
instead is still on the table, and I'd like to get feedback on this.

* In order to increase the entropy for the randomized base, I changed
the default value of CONFIG_PHYSICAL_ALIGN back to 2mb.  It had
previously been raised to 16mb as a hack so that relocatable kernels
wouldn't load below that minimum.  I address this by changing the
meaning of CONFIG_PHYSICAL_START such that it now represents a minimum
address that relocatable kernels can be loaded at (rather than being
ignored by relocatable kernels).  So, if a relocatable kernel determines
it should be loaded at an address below CONFIG_PHYSICAL_START (which
defaults to 16mb), I just bump it up.

* I would appreciate guidance on safe values for the highest addresses
we can safely load the kernel at, on both 32-bit and 64-bit. This
version uses 64mb (0x4000000) for 32-bit, and worked well in testing.

* CONFIG_RANDOMIZE_BASE automatically sets the default value of
kptr_restrict and dmesg_restrict to 1, since it's nonsensical to use
this without the other two.  I considered removing
CONFIG_SECURITY_DMESG_RESTRICT altogether (it currently sets the default
value for dmesg_restrict), but just in case distros want to keep the
CONFIG as a toggle switch but don't want to use CONFIG_RANDOMIZE_BASE, I
kept it around.  So, now CONFIG_RANDOMIZE_BASE sets the default value
for CONFIG_SECURITY_DMESG_RESTRICT.

* x86-64 is still "to-do". Because it calculates the kernel text address
twice, this may be a little trickier.

* Finding a middle ground instead of the current "all-or-nothing"
behavior of kptr_restrict that allows perf users to use this feature is
future work.

* Tested by repeatedly booting and observing kallsyms output on both
i386.  Passed the "looks random to me" test, and saw no bad behavior.
Tested that changing CONFIG_PHYSICAL_ALIGN to 2mb still boots and runs
fine on amd64.

* Is it worth bothering to look for alternate sources of entropy if
RDTSC isn't available?

* Could use testing of CPU hotplugging and suspend/resume.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 Documentation/sysctl/kernel.txt    |   13 ++++---
 arch/x86/Kconfig                   |   32 ++++++++++++++++--
 arch/x86/boot/compressed/head_32.S |   63 ++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/head_64.S |   16 ++++++++-
 arch/x86/include/asm/fixmap.h      |    4 ++
 arch/x86/kernel/traps.c            |    7 ++++
 kernel/printk.c                    |    4 +-
 lib/vsprintf.c                     |    4 ++
 security/Kconfig                   |    2 +-
 9 files changed, 132 insertions(+), 13 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 36f0075..ed91ae3 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -267,11 +267,14 @@ kptr_restrict:
 This toggle indicates whether restrictions are placed on
 exposing kernel addresses via /proc and other interfaces.  When
 kptr_restrict is set to (0), there are no restrictions.  When
-kptr_restrict is set to (1), the default, kernel pointers
-printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.  When kptr_restrict is set to
-(2), kernel pointers printed using %pK will be replaced with 0's
-regardless of privileges.
+kptr_restrict is set to (1), kernel pointers printed using the
+%pK format specifier will be replaced with 0's unless the user
+has CAP_SYSLOG.  When kptr_restrict is set to (2), kernel
+pointers printed using %pK will be replaced with 0's regardless
+of privileges.
+
+Enabling the CONFIG_RANDOMIZE_BASE kernel config sets the default
+kptr_restrict value to (1).  Otherwise, the default is (0).
 
 ==============================================================
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 880fcb6..999ea82 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1548,8 +1548,8 @@ config PHYSICAL_START
 	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
 	  bzImage will decompress itself to above physical address and
 	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
+	  it has been loaded by the boot loader, using the above physical
+	  address as a lower bound.
 
 	  In normal kdump cases one does not have to set/change this option
 	  as now bzImage can be compiled as a completely relocatable image
@@ -1595,7 +1595,31 @@ config RELOCATABLE
 
 	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
 	  it has been loaded at and the compile time physical address
-	  (CONFIG_PHYSICAL_START) is ignored.
+	  (CONFIG_PHYSICAL_START) is solely used as a lower bound.
+
+config RANDOMIZE_BASE
+	bool "Randomize the address of the kernel image"
+	depends on X86_32 && RELOCATABLE
+	default n
+	---help---
+	  Randomizes the address at which the kernel image is decompressed, as
+	  a security feature that deters exploit attempts relying on knowledge
+	  of the location of kernel internals. The default values of the
+	  kptr_restrict and dmesg_restrict sysctls are set to (1) when this is
+	  enabled, since hiding kernel pointers is necessary to preserve the
+	  secrecy of the randomized base address.
+
+	  This feature also uses a fixed mapping to move the IDT (if not
+	  already done as a fix for the F00F bug), to avoid exposing the
+	  location of kernel internals relative to the original IDT. This has
+	  the additional security benefit of marking the new virtual address of
+	  the IDT read-only.
+
+	  Entropy is generated using the RDRAND instruction if it is supported.
+	  If not, then RDTSC is used, if supported. If neither RDRAND nor RDTSC
+	  are supported, then no randomness is introduced. Support for the
+	  CPUID instruction is required to check for the availability of these
+	  two instructions.
 
 # Relocation on x86-32 needs some additional build support
 config X86_NEED_RELOCS
@@ -1604,7 +1628,7 @@ config X86_NEED_RELOCS
 
 config PHYSICAL_ALIGN
 	hex "Alignment value to which kernel should be aligned" if X86_32
-	default "0x1000000"
+	default "0x200000"
 	range 0x2000 0x1000000
 	---help---
 	  This value puts the alignment restrictions on physical address
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 67a655a..2680db0 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -69,12 +69,75 @@ ENTRY(startup_32)
  */
 
 #ifdef CONFIG_RELOCATABLE
+#ifdef CONFIG_RANDOMIZE_BASE
+
+	/* Standard check for cpuid */
+	pushfl
+	popl	%eax
+	movl	%eax, %ebx
+	xorl	$0x200000, %eax
+	pushl	%eax
+	popfl
+	pushfl
+	popl	%eax
+	cmpl	%eax, %ebx
+	jz	4f
+
+	/* Check for cpuid 1 */
+	movl	$0x0, %eax
+	cpuid
+	cmpl	$0x1, %eax
+	jb	4f
+
+	movl	$0x1, %eax
+	cpuid
+	xor	%eax, %eax
+
+	/* RDRAND is bit 30 */
+	testl	$0x4000000, %ecx
+	jnz	1f
+
+	/* RDTSC is bit 4 */
+	testl	$0x10, %edx
+	jnz	3f
+
+	/* Nothing is supported */
+	jmp	4f
+1:
+	/* RDRAND sets carry bit on success, otherwise we should try
+	 * again. */
+	movl	$0x10, %ecx
+2:
+	/* rdrand %eax */
+	.byte	0x0f, 0xc7, 0xf0
+	jc	4f
+	loop	2b
+
+	/* Fall through: if RDRAND is supported but fails, use RDTSC,
+	 * which is guaranteed to be supported. */
+3:
+	rdtsc
+	shll	$0xc, %eax
+4:
+	/* Maximum offset at 64mb to be safe */
+	andl	$0x3ffffff, %eax
+	movl	%ebp, %ebx
+	addl	%eax, %ebx
+#else
 	movl	%ebp, %ebx
+#endif
 	movl	BP_kernel_alignment(%esi), %eax
 	decl	%eax
 	addl    %eax, %ebx
 	notl	%eax
 	andl    %eax, %ebx
+
+	/* LOAD_PHSYICAL_ADDR is the minimum safe address we can
+	 * decompress at. */
+	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
+	jae	1f
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
+1:
 #else
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 #endif
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 35af09d..6a05219 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -90,6 +90,13 @@ ENTRY(startup_32)
 	addl	%eax, %ebx
 	notl	%eax
 	andl	%eax, %ebx
+
+	/* LOAD_PHYSICAL_ADDR is the minimum safe address we can
+	 * decompress at. */
+	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
+	jae	1f
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
+1:
 #else
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 #endif
@@ -191,7 +198,7 @@ no_longmode:
 	 * it may change in the future.
 	 */
 	.code64
-	.org 0x200
+	.org 0x300
 ENTRY(startup_64)
 	/*
 	 * We come here either from startup_32 or directly from a
@@ -232,6 +239,13 @@ ENTRY(startup_64)
 	addq	%rax, %rbp
 	notq	%rax
 	andq	%rax, %rbp
+
+	/* LOAD_PHYSICAL_ADDR is the minimum safe address we can
+	 * decompress at. */
+	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
+	jae	1f
+	movq	$LOAD_PHYSICAL_ADDR, %rbp
+1:
 #else
 	movq	$LOAD_PHYSICAL_ADDR, %rbp
 #endif
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 4729b2b..d1fabba 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -100,6 +100,10 @@ enum fixed_addresses {
 #endif
 #ifdef CONFIG_X86_F00F_BUG
 	FIX_F00F_IDT,	/* Virtual mapping for IDT */
+#else
+#ifdef CONFIG_RANDOMIZE_BASE
+	FIX_RANDOM_IDT, /* Virtual mapping for IDT */
+#endif
 #endif
 #ifdef CONFIG_X86_CYCLONE_TIMER
 	FIX_CYCLONE_TIMER, /*cyclone timer register*/
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..5672ad0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -872,6 +872,13 @@ void __init trap_init(void)
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 
+#if defined(CONFIG_RANDOMIZE_BASE) && !defined(CONFIG_X86_F00F_BUG)
+	__set_fixmap(FIX_RANDOM_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
+
+	/* Update the IDT descriptor. It will be reloaded in cpu_init() */
+	idt_descr.address = fix_to_virt(FIX_RANDOM_IDT);
+#endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/kernel/printk.c b/kernel/printk.c
index da8ca81..283434f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -262,9 +262,9 @@ static inline void boot_delay_msec(void)
 #endif
 
 #ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
+int dmesg_restrict __read_mostly = 1;
 #else
-int dmesg_restrict;
+int dmesg_restrict __read_mostly;
 #endif
 
 static int syslog_action_restricted(int type)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1d659d7..0d8da65 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -797,7 +797,11 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
+#ifdef CONFIG_RANDOMIZE_BASE
+int kptr_restrict __read_mostly = 1;
+#else
 int kptr_restrict __read_mostly;
+#endif
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
diff --git a/security/Kconfig b/security/Kconfig
index 95accd4..ffabef0 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -72,7 +72,7 @@ config KEYS_DEBUG_PROC_KEYS
 
 config SECURITY_DMESG_RESTRICT
 	bool "Restrict unprivileged access to the kernel syslog"
-	default n
+	default RANDOMIZE_BASE
 	help
 	  This enforces restrictions on unprivileged users reading the kernel
 	  syslog via dmesg(8).


