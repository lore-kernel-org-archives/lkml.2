Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1E3Dty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:54 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:43323 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab1E3Dtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:50 -0400
X-AuditID: 12074424-b7bc6ae000005a77-87-4de313dd8333
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 09/10] x86-64: Randomize int 0xcc magic al values at boot
Date: Sun, 29 May 2011 23:48:46 -0400
Message-Id: <8b62323bc1a06b2b3f2cf52dc42a07a374569685.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsUixG6nontX+LGvwasDehZz1q9hs+i7cpTd
	YtY1XovPG/6xWRz49ZTN4v3V7WwWl3fNYbN40nyd0WLLpWZWiw8TN7BZbN40ldniUd9bdosf
	Gx6zOvB6fG/tY/E4duYwo8ettj/MHjtn3WX32LxCy+P/yyNsHptWdbJ5vDt3jt3jxIzfLB7H
	zzh7fN4kF8AdxWWTkpqTWZZapG+XwJXxatpCloKlKhVXbsxga2DcKdvFyMkhIWAiceTuNVYI
	W0ziwr31bF2MXBxCAvsYJT7Nmc0CkhAS2MAo8flzEETiGZPE39/HGUESbAIqEh1LHzB1MXJw
	iAjoS1z9zAhSwyzwnFniwcNdYFOFBXwkGmYvYAOxWQRUJRpmNoEN5RUIkjjxfSYbxGYFiStX
	5oHFOQUMJE7euQe1WF9i3q23bLjEJzAKLGBkWMUom5JbpZubmJlTnJqsW5ycmJeXWqRrrpeb
	WaKXmlK6iREcIS4qOxibDykdYhTgYFTi4TUreuQrxJpYVlyZe4hRkoNJSZT3keBjXyG+pPyU
	yozE4oz4otKc1OJDjBIczEoivOq/gMp5UxIrq1KL8mFS0hwsSuK88yTVfYUE0hNLUrNTUwtS
	i2CyMhwcShK8D4SAhgoWpaanVqRl5pQgpJk4OEGG8wAN1wdZzFtckJhbnJkOkT/FqMvRuHbH
	QUYhlrz8vFQpcd47IIMEQIoySvPg5sAS2ytGcaC3hHmvgFTxAJMi3KRXQEuYgJb0vnsIsqQk
	ESEl1cCoKt8vsbv4yCy9D9qL/j7dJvQ+WOQDc590+XSOgtRz2aouFsZlXO3Fjdc+M9TfDbRh
	YhS9ZZaxL2iJ56bsFwE/5IWEqzdI7VgvH8RSe1Pw5uLFb58nSZv1KBvvFL7mvD1q0/OfM9Nm
	KUfU1N91dV/SahW3cs5NpqST0beWSi478LAiUIefu1uJpTgj0VCLuag4EQBGLH4CRwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a security feature.  It's to prevent the int 0xcc
sequence from becoming ABI.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vsyscall_64.c |   65 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 5b3d62a..f53f490 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -34,6 +34,8 @@
 #include <linux/notifier.h>
 #include <linux/syscalls.h>
 #include <linux/ratelimit.h>
+#include <linux/random.h>
+#include <linux/highmem.h>
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
@@ -54,6 +56,19 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = SEQLOCK_UNLOCKED,
 };
 
+static u8 vsyscall_nr_offset;  /* Cyclic permutation of al. */
+
+static inline u8 mangle_al(u8 al)
+{
+	/* Permute among 0xcc, 0xce, and 0xf0. */
+	return (al - 0xcc + 2*vsyscall_nr_offset) % 6 + 0xcc;
+}
+
+static inline u8 demangle_vsyscall_nr(u8 nr)
+{
+	return (nr + 3 - vsyscall_nr_offset) % 3;
+}
+
 void update_vsyscall_tz(void)
 {
 	unsigned long flags;
@@ -94,11 +109,12 @@ static void warn_bad_vsyscall(struct pt_regs *regs, bool is_warning,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx offset:%d si:%lx di:%lx",
 	       is_warning ? KERN_WARNING : KERN_INFO,
 	       tsk->comm, task_pid_nr(tsk),
 	       message,
-	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	       regs->ip - 2, regs->sp, regs->ax, (int)vsyscall_nr_offset,
+	       regs->si, regs->di);
 	if (!in_vsyscall_page(regs->ip - 2))
 		print_vma_addr(" in ", regs->ip - 2);
 	printk("\n");
@@ -125,7 +141,8 @@ static __always_inline int fallback_gettimeofday(struct timeval *tv)
 	 * Invoke do_emulate_vsyscall.  Intentionally incompatible with
 	 * the CONFIG_UNSAFE_VSYSCALLS=n case.
 	 */
-	asm volatile("mov $0xce, %%al;\n\t"
+	asm volatile("fallback_gtod_movb:\n\t"
+		     "movb $0xce, %%al;\n\t"
 		     "int %[vec]"
 		     : "=a" (ret)
 		     : "D" (tv), [vec] "i" (VSYSCALL_EMU_VECTOR));
@@ -250,7 +267,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
 	local_irq_enable();
 
-	if ((regs->ax & 0xFF) != 0xce) {
+	if ((regs->ax & 0xFF) != mangle_al(0xce)) {
 		warn_bad_vsyscall(regs, false, "illegal int 0xcc "
 				  "(exploit attempt?)");
 		force_sig(SIGSEGV, current);
@@ -316,6 +333,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		force_sig(SIGSEGV, current);
 		goto out;
 	}
+	vsyscall_nr = demangle_vsyscall_nr(vsyscall_nr);
 
 	if (regs->ip - 2 != vsyscall_intcc_addr(vsyscall_nr)) {
 		if (in_vsyscall_page(regs->ip - 2)) {
@@ -438,15 +456,54 @@ void __init map_vsyscall(void)
 		     (unsigned long)VVAR_ADDRESS);
 }
 
+static void __init mangle_vsyscall_movb(void *mapping,
+					unsigned long movb_addr, u8 initial)
+{
+	u8 *imm8;
+	BUG_ON(movb_addr >= 4095);
+
+	imm8 = (char*)(mapping) + movb_addr + 1;
+
+	BUG_ON(*imm8 != initial);
+	*imm8 = mangle_al(*imm8);
+}
+
 static int __init vsyscall_init(void)
 {
+	struct page *vsyscall_page;
+	extern char __vsyscall_0;
+	void *mapping;
+
 #ifdef CONFIG_UNSAFE_VSYSCALLS
+	extern char fallback_gtod_movb;
+
 	BUG_ON(((unsigned long) &vgettimeofday !=
 			VSYSCALL_ADDR(__NR_vgettimeofday)));
 	BUG_ON((unsigned long) &vtime != VSYSCALL_ADDR(__NR_vtime));
 	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
 	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
 #endif
+
+	/*
+	 * Randomize the magic al values for int 0xcc invocation.  This
+	 * isn't really a security feature; it's to make sure that
+	 * dynamic binary instrumentation tools don't start to think
+	 * that the int 0xcc magic incantation is ABI.
+	 */
+	vsyscall_nr_offset = get_random_int() % 3;
+	vsyscall_page = pfn_to_page(__pa_symbol(&__vsyscall_0) >> PAGE_SHIFT);
+	mapping = kmap_atomic(vsyscall_page);
+#ifdef CONFIG_UNSAFE_VSYSCALLS
+	mangle_vsyscall_movb(mapping,
+			     &fallback_gtod_movb - (char*)&vgettimeofday, 0xce);
+#else
+	/* It's easier to hardcode the addresses -- they're ABI. */
+	mangle_vsyscall_movb(mapping, 0, 0xcc);
+	mangle_vsyscall_movb(mapping, 1024, 0xce);
+	mangle_vsyscall_movb(mapping, 2048, 0xf0);
+#endif
+	kunmap_atomic(mapping);
+
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
-- 
1.7.5.1

