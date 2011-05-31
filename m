Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1EaOPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:15:53 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:54173 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625Ab1EaOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:15:23 -0400
X-AuditID: 12074422-b7b0eae000007f48-74-4de4f7fd351f
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
Subject: [PATCH v4 09/10] x86-64: Randomize int 0xcc magic al values at boot
Date: Tue, 31 May 2011 10:14:07 -0400
Message-Id: <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsUixCmqrPv3+xNfgwXXFC3mrF/DZtF35Si7
	xZFr39ktZl3jtfi84R+bxYFfT9ks3l/dzmZxedccNosnzdcZLbZcama1+DBxA5vF5k1TmS0e
	9b1lt/ix4TGrA5/H99Y+Fo9jZw4zetxq+8PsMX/nR0aPnbPusntsXqHl8f/lETaPTas62Tze
	nTvH7nFixm8Wj+NnnD0+b5IL4InisklJzcksSy3St0vgyjjwJL7gokzFr/1f2BoYl4t3MXJy
	SAiYSJx5coYdwhaTuHBvPVsXIxeHkMA+Ronjm08yQTgbGCW+vv3ODuE8Y5LY0b6EBaSFTUBF
	omPpA6AqDg4RAX2Jq58ZQWqYBSaxSBz+exqsRljAR+Lvt3XMIDaLgKrE18nbWEDqeQWCJO4d
	g7pCQeLKlXlg5ZwCBhLbr65iBCkRAhp5/IMuDuEJjAILGBlWMcqm5Fbp5iZm5hSnJusWJyfm
	5aUW6Zrq5WaW6KWmlG5iBMULu4vSDsafB5UOMQpwMCrx8GYffOwrxJpYVlyZe4hRkoNJSZS3
	4tsTXyG+pPyUyozE4oz4otKc1OJDjBIczEoivN/4gHK8KYmVValF+TApaQ4WJXHeOZLqvkIC
	6YklqdmpqQWpRTBZGQ4OJQleI2BaEBIsSk1PrUjLzClBSDNxcIIM5wEaXgiymLe4IDG3ODMd
	In+KUZejce2Og4xCLHn5ealS4rxWIIMEQIoySvPg5sDS3CtGcaC3hHkVQKp4gCkSbtIroCVM
	QEt63z0EWVKSiJCSamBsui3ELX3GU41VrvxV5UYb4awLp2ek2q2caPvCzdv71nVV5TahDZEV
	Wzye7fz5xvQee2TnMnWTW1PTcwO8dHOmNLuGvE/oK7LrrNVpZfiTUrLAxmFa18x2vx2i8g9l
	dliHftvpfotjVe2u/9ldp+MLxNTXNBmmsUW/3LC2Tneu/sxDlzfHv1ViKc5INNRiLipOBADK
	qPV7TgMAAA==
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
index 52ba392..277c47c 100644
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
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
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

