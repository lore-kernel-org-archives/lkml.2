Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab1GLHSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:18:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39392 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1GLHSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:18:37 -0400
Date: Tue, 12 Jul 2011 09:18:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v2 1/8] x86-64: Improve vsyscall emulation CS and RIP
 handling
Message-ID: <20110712071832.GA17616@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>
References: <cover.1310267866.git.luto@mit.edu>
 <2215c119e580b40f243c37d284e7bced309d975f.1310267866.git.luto@mit.edu>
 <20110711221432.GA10164@liondog.tnic>
 <CAObL_7ERJ4D_R5k1C7OHLz1etZzxcaTA7rzFmtRu0-gpq_YpMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7ERJ4D_R5k1C7OHLz1etZzxcaTA7rzFmtRu0-gpq_YpMQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 06:20:50PM -0400, Andrew Lutomirski wrote:
> > I'm wondering: why don't you make this function return negative value on
> > error, i.e. -EINVAL and the vsyscall number on success so that you can
> > get rid of returning it through the arg pointer?
> >
> > Then at the callsite you can do:
> >
> >        vsyscall_nr = addr_to_vsyscall_nr(addr);
> >        if (vsyscall_nr < 0)
> >                warn_bad_vsyscall(...)
> 
> Because I don't want a warning about ret being used without being initialized.

not if you preinit it...

> With the code in this patch, the compiler is smart enough to figure
> out that either vsyscall_nr is 0, 1, or 2 or that the EINVAL branch is
> taken.  I'll see if it works the other way.

here's what i mean, I changed your patch a bit:
--

>From 2bb6c706cd6cf49ce5baec670bd01b53d2ea6f19 Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@MIT.EDU>
Date: Sat, 9 Jul 2011 23:22:08 -0400
Subject: [PATCH] x86-64: Improve vsyscall emulation CS and RIP handling

Two fixes here:
 - Send SIGSEGV if called from compat code or with a funny CS.
 - Don't BUG on impossible addresses.

This patch also removes an unused variable.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vsyscall.h |   12 -------
 arch/x86/kernel/vsyscall_64.c   |   62 +++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index bb710cb..d555973 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -31,18 +31,6 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
-/* Emulation */
-
-static inline bool is_vsyscall_entry(unsigned long addr)
-{
-	return (addr & ~0xC00UL) == VSYSCALL_START;
-}
-
-static inline int vsyscall_entry_nr(unsigned long addr)
-{
-	return (addr & 0xC00UL) >> 10;
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 10cd8ac..2110cf2 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -38,6 +38,7 @@
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
+#include <asm/compat.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/fixmap.h>
@@ -97,33 +98,63 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
 	       level, tsk->comm, task_pid_nr(tsk),
-	       message, regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
+	       message, regs->ip - 2, regs->cs,
+	       regs->sp, regs->ax, regs->si, regs->di);
+}
+
+static int addr_to_vsyscall_nr(unsigned long addr)
+{
+	int vsyscall = -EINVAL;
+
+	if ((addr & ~0xC00UL) != VSYSCALL_START)
+		return -EINVAL;
+
+	vsyscall = (addr & 0xC00UL) >> 10;
+	if (vsyscall < 0 || vsyscall >= 3)
+		return -EINVAL;
+
+	return vsyscall;
 }
 
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
-	const char *vsyscall_name;
 	struct task_struct *tsk;
 	unsigned long caller;
 	int vsyscall_nr;
-	long ret;
-
-	/* Kernel code must never get here. */
-	BUG_ON(!user_mode(regs));
+	long ret = -EFAULT;
 
 	local_irq_enable();
 
 	/*
+	 * Real 64-bit user mode code has cs == __USER_CS.  Anything else
+	 * is bogus.
+	 */
+	if (regs->cs != __USER_CS) {
+		/*
+		 * If we trapped from kernel mode, we might as well OOPS now
+		 * instead of returning to some random address and OOPSing
+		 * then.
+		 */
+		BUG_ON(!user_mode(regs));
+
+		/* Compat mode and non-compat 32-bit CS should both segfault. */
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc from 32-bit mode");
+		goto sigsegv;
+	}
+
+	/*
 	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
 	 * and int 0xcc is two bytes long.
 	 */
-	if (!is_vsyscall_entry(regs->ip - 2)) {
-		warn_bad_vsyscall(KERN_WARNING, regs, "illegal int 0xcc (exploit attempt?)");
+	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
+	if (vsyscall_nr < 0) {
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "illegal int 0xcc (exploit attempt?)");
 		goto sigsegv;
 	}
-	vsyscall_nr = vsyscall_entry_nr(regs->ip - 2);
 
 	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
@@ -136,31 +167,20 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
 	switch (vsyscall_nr) {
 	case 0:
-		vsyscall_name = "gettimeofday";
 		ret = sys_gettimeofday(
 			(struct timeval __user *)regs->di,
 			(struct timezone __user *)regs->si);
 		break;
 
 	case 1:
-		vsyscall_name = "time";
 		ret = sys_time((time_t __user *)regs->di);
 		break;
 
 	case 2:
-		vsyscall_name = "getcpu";
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
 				 0);
 		break;
-
-	default:
-		/*
-		 * If we get here, then vsyscall_nr indicates that int 0xcc
-		 * happened at an address in the vsyscall page that doesn't
-		 * contain int 0xcc.  That can't happen.
-		 */
-		BUG();
 	}
 
 	if (ret == -EFAULT) {
-- 
1.7.5.3.401.gfb674




-- 
Regards/Gruss,
    Boris.
