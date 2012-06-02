Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965733Ab2FBTRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 15:17:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965683Ab2FBTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 15:17:31 -0400
Date: Sat, 2 Jun 2012 12:16:49 -0700
Message-Id: <201206021916.q52JGnug001870@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 straggler fixes for 3.5
Cc: <stable@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Keshav P R <the.ridikulus.rat@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 02 Jun 2012 12:17:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Straggler fixes for the x86 tree.

Three groups of patches:

- EFI boot stub documentation and the ability to print error messages;
- Removal for PTRACE_ARCH_PRCTL for x32 (obsolete interface which should
  never have been ported, and the port is broken and potentially dangerous.)
- ftrace stack corruption fixes.  I'm not super-happy about the technical
  implementation, but it is probably the least invasive in the short term.
  In the future I would like a single method for nesting the debug stack,
  however.

The following changes since commit fb21affa49204acd409328415b49bfe90136653c:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal (2012-05-31 18:47:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is 40b46a7d2938589a5abab132a7824fd17ae18f62.

H. Peter Anvin (1):
      Merge remote-tracking branch 'rostedt/tip/perf/urgent-2' into x86-urgent-for-linus

H.J. Lu (1):
      x86, x32, ptrace: Remove PTRACE_ARCH_PRCTL for x32

Matt Fleming (3):
      x86, efi: Only close open files in error path
      x86, efi; Add EFI boot stub console support
      x86, efi: Add EFI boot stub documentation

Steven Rostedt (5):
      ftrace: Synchronize variable setting with breakpoints
      ftrace: Use breakpoint method to update ftrace caller
      x86: Reset the debug_stack update counter
      x86: Allow nesting of the debug stack IDT setting
      ftrace/x86: Do not change stacks in DEBUG when calling lockdep

 Documentation/x86/efi-stub.txt   |   65 ++++++++++++++++++++++++
 arch/x86/Kconfig                 |    2 +
 arch/x86/boot/compressed/eboot.c |   87 ++++++++++++++++++++++++++------
 arch/x86/boot/compressed/eboot.h |    6 ++
 arch/x86/include/asm/ftrace.h    |    2 +-
 arch/x86/kernel/cpu/common.c     |    8 +++-
 arch/x86/kernel/entry_64.S       |   44 +++++++++++++++-
 arch/x86/kernel/ftrace.c         |  102 +++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/nmi.c            |    6 ++-
 arch/x86/kernel/ptrace.c         |    6 --
 arch/x86/kernel/traps.c          |    8 ++-
 11 files changed, 297 insertions(+), 39 deletions(-)

diff --git a/Documentation/x86/efi-stub.txt b/Documentation/x86/efi-stub.txt
new file mode 100644
index 0000000..44e6bb6
--- /dev/null
+++ b/Documentation/x86/efi-stub.txt
@@ -0,0 +1,65 @@
+			  The EFI Boot Stub
+		     ---------------------------
+
+On the x86 platform, a bzImage can masquerade as a PE/COFF image,
+thereby convincing EFI firmware loaders to load it as an EFI
+executable. The code that modifies the bzImage header, along with the
+EFI-specific entry point that the firmware loader jumps to are
+collectively known as the "EFI boot stub", and live in
+arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
+respectively.
+
+By using the EFI boot stub it's possible to boot a Linux kernel
+without the use of a conventional EFI boot loader, such as grub or
+elilo. Since the EFI boot stub performs the jobs of a boot loader, in
+a certain sense it *IS* the boot loader.
+
+The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
+
+
+**** How to install bzImage.efi
+
+The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
+System Partiion (ESP) and renamed with the extension ".efi". Without
+the extension the EFI firmware loader will refuse to execute it. It's
+not possible to execute bzImage.efi from the usual Linux file systems
+because EFI firmware doesn't have support for them.
+
+
+**** Passing kernel parameters from the EFI shell
+
+Arguments to the kernel can be passed after bzImage.efi, e.g.
+
+	fs0:> bzImage.efi console=ttyS0 root=/dev/sda4
+
+
+**** The "initrd=" option
+
+Like most boot loaders, the EFI stub allows the user to specify
+multiple initrd files using the "initrd=" option. This is the only EFI
+stub-specific command line parameter, everything else is passed to the
+kernel when it boots.
+
+The path to the initrd file must be an absolute path from the
+beginning of the ESP, relative path names do not work. Also, the path
+is an EFI-style path and directory elements must be separated with
+backslashes (\). For example, given the following directory layout,
+
+fs0:>
+	Kernels\
+			bzImage.efi
+			initrd-large.img
+
+	Ramdisks\
+			initrd-small.img
+			initrd-medium.img
+
+to boot with the initrd-large.img file if the current working
+directory is fs0:\Kernels, the following command must be used,
+
+	fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
+
+Notice how bzImage.efi can be specified with a relative path. That's
+because the image we're executing is interpreted by the EFI shell,
+which understands relative paths, whereas the rest of the command line
+is passed to bzImage.efi.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d700811..c70684f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1506,6 +1506,8 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
+	  See Documentation/x86/efi-stub.txt for more information.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2c14e76..4e85f5f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -16,6 +16,26 @@
 
 static efi_system_table_t *sys_table;
 
+static void efi_printk(char *str)
+{
+	char *s8;
+
+	for (s8 = str; *s8; s8++) {
+		struct efi_simple_text_output_protocol *out;
+		efi_char16_t ch[2] = { 0 };
+
+		ch[0] = *s8;
+		out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
+
+		if (*s8 == '\n') {
+			efi_char16_t nl[2] = { '\r', 0 };
+			efi_call_phys2(out->output_string, out, nl);
+		}
+
+		efi_call_phys2(out->output_string, out, ch);
+	}
+}
+
 static efi_status_t __get_map(efi_memory_desc_t **map, unsigned long *map_size,
 			      unsigned long *desc_size)
 {
@@ -531,8 +551,10 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 				EFI_LOADER_DATA,
 				nr_initrds * sizeof(*initrds),
 				&initrds);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for initrds\n");
 		goto fail;
+	}
 
 	str = (char *)(unsigned long)hdr->cmd_line_ptr;
 	for (i = 0; i < nr_initrds; i++) {
@@ -575,32 +597,42 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 
 			status = efi_call_phys3(boottime->handle_protocol,
 					image->device_handle, &fs_proto, &io);
-			if (status != EFI_SUCCESS)
+			if (status != EFI_SUCCESS) {
+				efi_printk("Failed to handle fs_proto\n");
 				goto free_initrds;
+			}
 
 			status = efi_call_phys2(io->open_volume, io, &fh);
-			if (status != EFI_SUCCESS)
+			if (status != EFI_SUCCESS) {
+				efi_printk("Failed to open volume\n");
 				goto free_initrds;
+			}
 		}
 
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to open initrd file\n");
 			goto close_handles;
+		}
 
 		initrd->handle = h;
 
 		info_sz = 0;
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, NULL);
-		if (status != EFI_BUFFER_TOO_SMALL)
+		if (status != EFI_BUFFER_TOO_SMALL) {
+			efi_printk("Failed to get initrd info size\n");
 			goto close_handles;
+		}
 
 grow:
 		status = efi_call_phys3(sys_table->boottime->allocate_pool,
 					EFI_LOADER_DATA, info_sz, &info);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to alloc mem for initrd info\n");
 			goto close_handles;
+		}
 
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, info);
@@ -612,8 +644,10 @@ grow:
 		file_sz = info->file_size;
 		efi_call_phys1(sys_table->boottime->free_pool, info);
 
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to get initrd info\n");
 			goto close_handles;
+		}
 
 		initrd->size = file_sz;
 		initrd_total += file_sz;
@@ -629,11 +663,14 @@ grow:
 		 */
 		status = high_alloc(initrd_total, 0x1000,
 				   &initrd_addr, hdr->initrd_addr_max);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to alloc highmem for initrds\n");
 			goto close_handles;
+		}
 
 		/* We've run out of free low memory. */
 		if (initrd_addr > hdr->initrd_addr_max) {
+			efi_printk("We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_initrd_total;
 		}
@@ -652,8 +689,10 @@ grow:
 				status = efi_call_phys3(fh->read,
 							initrds[j].handle,
 							&chunksize, addr);
-				if (status != EFI_SUCCESS)
+				if (status != EFI_SUCCESS) {
+					efi_printk("Failed to read initrd\n");
 					goto free_initrd_total;
+				}
 				addr += chunksize;
 				size -= chunksize;
 			}
@@ -674,7 +713,7 @@ free_initrd_total:
 	low_free(initrd_total, initrd_addr);
 
 close_handles:
-	for (k = j; k < nr_initrds; k++)
+	for (k = j; k < i; k++)
 		efi_call_phys1(fh->close, initrds[k].handle);
 free_initrds:
 	efi_call_phys1(sys_table->boottime->free_pool, initrds);
@@ -732,8 +771,10 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
 			options_size++;	/* NUL termination */
 
 			status = low_alloc(options_size, 1, &cmdline);
-			if (status != EFI_SUCCESS)
+			if (status != EFI_SUCCESS) {
+				efi_printk("Failed to alloc mem for cmdline\n");
 				goto fail;
+			}
 
 			s1 = (u8 *)(unsigned long)cmdline;
 			s2 = (u16 *)options;
@@ -895,12 +936,16 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 
 	status = efi_call_phys3(sys_table->boottime->handle_protocol,
 				handle, &proto, (void *)&image);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		goto fail;
+	}
 
 	status = low_alloc(0x4000, 1, (unsigned long *)&boot_params);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc lowmem for boot params\n");
 		goto fail;
+	}
 
 	memset(boot_params, 0x0, 0x4000);
 
@@ -933,8 +978,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 	if (status != EFI_SUCCESS) {
 		status = low_alloc(hdr->init_size, hdr->kernel_alignment,
 				   &start);
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk("Failed to alloc mem for kernel\n");
 			goto fail;
+		}
 	}
 
 	hdr->code32_start = (__u32)start;
@@ -945,19 +992,25 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for gdt structure\n");
 		goto fail;
+	}
 
 	gdt->size = 0x800;
 	status = low_alloc(gdt->size, 8, (unsigned long *)&gdt->address);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for gdt\n");
 		goto fail;
+	}
 
 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
 				EFI_LOADER_DATA, sizeof(*idt),
 				(void **)&idt);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk("Failed to alloc mem for idt structure\n");
 		goto fail;
+	}
 
 	idt->size = 0;
 	idt->address = 0;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index 3925166..3b6e156 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -58,4 +58,10 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
+struct efi_simple_text_output_protocol {
+	void *reset;
+	void *output_string;
+	void *test_string;
+};
+
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 18d9005..b0767bc 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -34,7 +34,7 @@
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
-extern int modifying_ftrace_code;
+extern atomic_t modifying_ftrace_code;
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 82f29e7..6b9333b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1101,14 +1101,20 @@ int is_debug_stack(unsigned long addr)
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
 
+static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
+
 void debug_stack_set_zero(void)
 {
+	this_cpu_inc(debug_stack_use_ctr);
 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
 }
 
 void debug_stack_reset(void)
 {
-	load_idt((const struct desc_ptr *)&idt_descr);
+	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
+		return;
+	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
+		load_idt((const struct desc_ptr *)&idt_descr);
 }
 
 #else	/* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 320852d..7d65133 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -191,6 +191,44 @@ ENDPROC(native_usergs_sysret64)
 .endm
 
 /*
+ * When dynamic function tracer is enabled it will add a breakpoint
+ * to all locations that it is about to modify, sync CPUs, update
+ * all the code, sync CPUs, then remove the breakpoints. In this time
+ * if lockdep is enabled, it might jump back into the debug handler
+ * outside the updating of the IST protection. (TRACE_IRQS_ON/OFF).
+ *
+ * We need to change the IDT table before calling TRACE_IRQS_ON/OFF to
+ * make sure the stack pointer does not get reset back to the top
+ * of the debug stack, and instead just reuses the current stack.
+ */
+#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_TRACE_IRQFLAGS)
+
+.macro TRACE_IRQS_OFF_DEBUG
+	call debug_stack_set_zero
+	TRACE_IRQS_OFF
+	call debug_stack_reset
+.endm
+
+.macro TRACE_IRQS_ON_DEBUG
+	call debug_stack_set_zero
+	TRACE_IRQS_ON
+	call debug_stack_reset
+.endm
+
+.macro TRACE_IRQS_IRETQ_DEBUG offset=ARGOFFSET
+	bt   $9,EFLAGS-\offset(%rsp)	/* interrupts off? */
+	jnc  1f
+	TRACE_IRQS_ON_DEBUG
+1:
+.endm
+
+#else
+# define TRACE_IRQS_OFF_DEBUG		TRACE_IRQS_OFF
+# define TRACE_IRQS_ON_DEBUG		TRACE_IRQS_ON
+# define TRACE_IRQS_IRETQ_DEBUG		TRACE_IRQS_IRETQ
+#endif
+
+/*
  * C code is not supposed to know about undefined top of stack. Every time
  * a C function with an pt_regs argument is called from the SYSCALL based
  * fast path FIXUP_TOP_OF_STACK is needed.
@@ -1098,7 +1136,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
-	TRACE_IRQS_OFF
+	TRACE_IRQS_OFF_DEBUG
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
@@ -1393,7 +1431,7 @@ paranoidzeroentry machine_check *machine_check_vector(%rip)
 ENTRY(paranoid_exit)
 	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
+	TRACE_IRQS_OFF_DEBUG
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore
 	testl $3,CS(%rsp)
@@ -1404,7 +1442,7 @@ paranoid_swapgs:
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_restore:
-	TRACE_IRQS_IRETQ 0
+	TRACE_IRQS_IRETQ_DEBUG 0
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace:
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 32ff365..c3a7cb4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -100,7 +100,7 @@ static const unsigned char *ftrace_nop_replace(void)
 }
 
 static int
-ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
 		   unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
@@ -141,7 +141,20 @@ int ftrace_make_nop(struct module *mod,
 	old = ftrace_call_replace(ip, addr);
 	new = ftrace_nop_replace();
 
-	return ftrace_modify_code(rec->ip, old, new);
+	/*
+	 * On boot up, and when modules are loaded, the MCOUNT_ADDR
+	 * is converted to a nop, and will never become MCOUNT_ADDR
+	 * again. This code is either running before SMP (on boot up)
+	 * or before the code will ever be executed (module load).
+	 * We do not want to use the breakpoint version in this case,
+	 * just modify the code directly.
+	 */
+	if (addr == MCOUNT_ADDR)
+		return ftrace_modify_code_direct(rec->ip, old, new);
+
+	/* Normal cases use add_brk_on_nop */
+	WARN_ONCE(1, "invalid use of ftrace_make_nop");
+	return -EINVAL;
 }
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -152,9 +165,47 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	old = ftrace_nop_replace();
 	new = ftrace_call_replace(ip, addr);
 
-	return ftrace_modify_code(rec->ip, old, new);
+	/* Should only be called when module is loaded */
+	return ftrace_modify_code_direct(rec->ip, old, new);
 }
 
+/*
+ * The modifying_ftrace_code is used to tell the breakpoint
+ * handler to call ftrace_int3_handler(). If it fails to
+ * call this handler for a breakpoint added by ftrace, then
+ * the kernel may crash.
+ *
+ * As atomic_writes on x86 do not need a barrier, we do not
+ * need to add smp_mb()s for this to work. It is also considered
+ * that we can not read the modifying_ftrace_code before
+ * executing the breakpoint. That would be quite remarkable if
+ * it could do that. Here's the flow that is required:
+ *
+ *   CPU-0                          CPU-1
+ *
+ * atomic_inc(mfc);
+ * write int3s
+ *				<trap-int3> // implicit (r)mb
+ *				if (atomic_read(mfc))
+ *					call ftrace_int3_handler()
+ *
+ * Then when we are finished:
+ *
+ * atomic_dec(mfc);
+ *
+ * If we hit a breakpoint that was not set by ftrace, it does not
+ * matter if ftrace_int3_handler() is called or not. It will
+ * simply be ignored. But it is crucial that a ftrace nop/caller
+ * breakpoint is handled. No other user should ever place a
+ * breakpoint on an ftrace nop/caller location. It must only
+ * be done by this code.
+ */
+atomic_t modifying_ftrace_code __read_mostly;
+
+static int
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code);
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
@@ -163,13 +214,17 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, (unsigned long)func);
+
+	/* See comment above by declaration of modifying_ftrace_code */
+	atomic_inc(&modifying_ftrace_code);
+
 	ret = ftrace_modify_code(ip, old, new);
 
+	atomic_dec(&modifying_ftrace_code);
+
 	return ret;
 }
 
-int modifying_ftrace_code __read_mostly;
-
 /*
  * A breakpoint was added to the code address we are about to
  * modify, and this is the handle that will just skip over it.
@@ -489,13 +544,46 @@ void ftrace_replace_code(int enable)
 	}
 }
 
+static int
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code)
+{
+	int ret;
+
+	ret = add_break(ip, old_code);
+	if (ret)
+		goto out;
+
+	run_sync();
+
+	ret = add_update_code(ip, new_code);
+	if (ret)
+		goto fail_update;
+
+	run_sync();
+
+	ret = ftrace_write(ip, new_code, 1);
+	if (ret) {
+		ret = -EPERM;
+		goto out;
+	}
+	run_sync();
+ out:
+	return ret;
+
+ fail_update:
+	probe_kernel_write((void *)ip, &old_code[0], 1);
+	goto out;
+}
+
 void arch_ftrace_update_code(int command)
 {
-	modifying_ftrace_code++;
+	/* See comment above by declaration of modifying_ftrace_code */
+	atomic_inc(&modifying_ftrace_code);
 
 	ftrace_modify_all_code(command);
 
-	modifying_ftrace_code--;
+	atomic_dec(&modifying_ftrace_code);
 }
 
 int __init ftrace_dyn_arch_init(void *data)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 9087527..a0b2f84 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -444,14 +444,16 @@ static inline void nmi_nesting_preprocess(struct pt_regs *regs)
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
 		debug_stack_set_zero();
-		__get_cpu_var(update_debug_stack) = 1;
+		this_cpu_write(update_debug_stack, 1);
 	}
 }
 
 static inline void nmi_nesting_postprocess(void)
 {
-	if (unlikely(__get_cpu_var(update_debug_stack)))
+	if (unlikely(this_cpu_read(update_debug_stack))) {
 		debug_stack_reset();
+		this_cpu_write(update_debug_stack, 0);
+	}
 }
 #endif
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 13b1990..c4c6a5c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1211,12 +1211,6 @@ static long x32_arch_ptrace(struct task_struct *child,
 					     0, sizeof(struct user_i387_struct),
 					     datap);
 
-		/* normal 64bit interface to access TLS data.
-		   Works just like arch_prctl, except that the arguments
-		   are reversed. */
-	case PTRACE_ARCH_PRCTL:
-		return do_arch_prctl(child, data, addr);
-
 	default:
 		return compat_ptrace_request(child, request, addr, data);
 	}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ff08457..05b31d9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -303,8 +303,12 @@ gp_in_kernel:
 dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
-	/* ftrace must be first, everything else may cause a recursive crash */
-	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
+	/*
+	 * ftrace must be first, everything else may cause a recursive crash.
+	 * See note by declaration of modifying_ftrace_code in ftrace.c
+	 */
+	if (unlikely(atomic_read(&modifying_ftrace_code)) &&
+	    ftrace_int3_handler(regs))
 		return;
 #endif
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
