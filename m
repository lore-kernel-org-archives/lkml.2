Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1EaNR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:17:29 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:61155 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab1EaNRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:17:25 -0400
X-AuditID: 1209190c-b7c65ae00000117c-a2-4de4ea6b5dcc
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 09/10] x86-64: Randomize int 0xcc magic al values at boot
Date: Tue, 31 May 2011 09:16:03 -0400
Message-Id: <27e6e5ed6205c6473b7fd406345d03e8d71c97ad.1306847455.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsUixCmqrZv96omvwakmHYs569ewWfRdOcpu
	ceTad3aLWdd4LT5v+MdmceDXUzaL91e3s1lc3jWHzeJJ83VGiy2XmlktPkzcwGaxedNUZotH
	fW/ZLX5seMzqwOfxvbWPxePYmcOMHrfa/jB7zN/5kdFj56y77B6bV2h5/H95hM1j06pONo93
	586xe5yY8ZvF4/gZZ4/Pm+QCeKK4bFJSczLLUov07RK4MtZ0ORVskan4fbaPpYGxS7yLkZND
	QsBE4lj3ZxYIW0ziwr31bF2MXBxCAvsYJSZuOc8K4WxglOhp7IVynjFJbD/QxwrSwiagItGx
	9AFTFyMHh4iAvsTVz4wgNcwCk1gkDv89DTZWWMBH4tXjqWA2i4CqxL/ZUxhBbF6BIImNR76z
	QqxWkLhyZR5YDaeAgUTzyjVsILYQ0Mz7T64w4xKfwCiwgJFhFaNsSm6Vbm5iZk5xarJucXJi
	Xl5qka6hXm5miV5qSukmRnDUSPLsYHxzUOkQowAHoxIPb+LBx75CrIllxZW5hxglOZiURHnP
	vnziK8SXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE9xsfUI43JbGyKrUoHyYlzcGiJM47Q1LdV0gg
	PbEkNTs1tSC1CCYrw8GhJMF7GWSoYFFqempFWmZOCUKaiYMTZDgP0PCTIDW8xQWJucWZ6RD5
	U4y6HI1rdxxkFGLJy89LlRLnvQ5SJABSlFGaBzcHluxeMYoDvSXMywBMfUI8wEQJN+kV0BIm
	oCW97x6CLClJREhJNTBOy7Y9nBmxpe/0K+7cxge/Cr702ajPXGm2NyNI+tf3U3/n/J15/NEy
	lrv1h5quHMj13VvtyqSw/+5x713PNpyO7dk/i+fIz1CrI83iDIK6T3ysnn83n7N6JvsKhmMm
	WmL1DxXYj3B1Bl6f9o/z25PgwB0+sbtE5rXLBaZJsqm52eh8yJtS5qKnxFKckWioxVxUnAgA
	bLnsrlEDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a security feature.  It's to prevent the int 0xcc
sequence from becoming ABI.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vsyscall_64.c |   54 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 7c699a9..8b8ad99 100644
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
@@ -54,6 +56,8 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = SEQLOCK_UNLOCKED,
 };
 
+static u8 vsyscall_nr_offset;  /* Cyclic permutation of al. */
+
 void update_vsyscall_tz(void)
 {
 	unsigned long flags;
@@ -95,10 +99,11 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
+	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx offset:%d si:%lx di:%lx",
 	       level, tsk->comm, task_pid_nr(tsk),
 	       message,
-	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	       regs->ip - 2, regs->sp, regs->ax, (int)vsyscall_nr_offset,
+	       regs->si, regs->di);
 	if (!in_vsyscall_page(regs->ip - 2))
 		print_vma_addr(" in ", regs->ip - 2);
 	printk("\n");
@@ -116,6 +121,17 @@ static int al_to_vsyscall_nr(u8 al)
 	return -1;
 }
 
+static inline u8 mangle_al(u8 al)
+{
+	int nr = al_to_vsyscall_nr(al);
+	return vsyscall_nr_to_al[(nr + vsyscall_nr_offset) % 3];
+}
+
+static inline int demangle_vsyscall_nr(int nr)
+{
+	return (nr + 3 - vsyscall_nr_offset) % 3;
+}
+
 #ifdef CONFIG_UNSAFE_VSYSCALLS
 
 /* This will break when the xtime seconds get inaccurate, but that is
@@ -165,6 +181,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 				  "(exploit attempt?)");
 		goto sigsegv;
 	}
+	vsyscall_nr = demangle_vsyscall_nr(vsyscall_nr);
 
 	if (regs->ip - 2 != vsyscall_intcc_addr(vsyscall_nr)) {
 		if (in_vsyscall_page(regs->ip - 2)) {
@@ -312,10 +329,43 @@ void __init map_vsyscall(void)
 		     (unsigned long)VVAR_ADDRESS);
 }
 
+static void __init mangle_vsyscall_movb(void *mapping,
+					unsigned long movb_addr, u8 initial)
+{
+	u8 *imm8;
+	BUG_ON(movb_addr >= 4095);
+
+	imm8 = (char *)(mapping) + movb_addr + 1;
+
+	BUG_ON(*imm8 != initial);
+	*imm8 = mangle_al(*imm8);
+}
+
 static int __init vsyscall_init(void)
 {
+	extern char __vsyscall_0;
+	void *mapping;
+	struct page *vsyscall_page;
+
 	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
 
+	/*
+	 * Randomize the magic al values for int 0xcc invocation.  This
+	 * isn't really a security feature; it's to make sure that
+	 * dynamic binary instrumentation tools don't start to think
+	 * that the int 0xcc magic incantation is ABI.
+	 */
+	vsyscall_nr_offset = get_random_int() % 3;
+	vsyscall_page = pfn_to_page(__pa_symbol(&__vsyscall_0) >> PAGE_SHIFT);
+	mapping = kmap_atomic(vsyscall_page);
+	/* It's easier to hardcode the addresses -- they're ABI. */
+	mangle_vsyscall_movb(mapping, 0, 0xcc);
+#ifndef CONFIG_UNSAFE_VSYSCALLS
+	mangle_vsyscall_movb(mapping, 1024, 0xce);
+#endif
+	mangle_vsyscall_movb(mapping, 2048, 0xf0);
+	kunmap_atomic(mapping);
+
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
-- 
1.7.5.1

