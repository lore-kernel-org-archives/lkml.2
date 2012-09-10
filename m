Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2IJJ5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:57:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65405 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab2IJJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:57:09 -0400
Date: Mon, 10 Sep 2012 10:56:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/31] arm64: System calls handling
Message-ID: <20120910095619.GA27042@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-18-git-send-email-catalin.marinas@arm.com>
 <201209071943.37184.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209071943.37184.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 08:43:36PM +0100, Arnd Bergmann wrote:
> On Friday 07 September 2012, Catalin Marinas wrote:
> > +/*
> > + * sys_execve() executes a new program.
> > + */
> > +asmlinkage long sys_execve(const char __user *filenamei,
> > +                          const char __user *const __user *argv,
> > +                          const char __user *const __user *envp,
> > +                          struct pt_regs *regs)
...
> > +int kernel_execve(const char *filename,
> > +                 const char *const argv[],
> > +                 const char *const envp[])
...
> Al Viro is currently reworking this code across all architectures, please have a look
> at https://git.kernel.org/?p=linux/kernel/git/viro/signal.git;a=shortlog;h=refs/heads/execve2

Yes, I've seen these but since Al's patches are not in mainline, I don't
want to add additional dependencies to the arm64 patches (currently
based on 3.6-rc4). Once they get into mainline, I'll add a patch that
converts arm64 to the generic functions above.

For kernel_execve(), I think I can simplify it further and not rely on
Al's patches (similar to other architectures doing an SVC from kernel):


diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ed2e58f..e712abe 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -241,10 +241,12 @@ ENDPROC(el1_error_invalid)
 	.align	6
 el1_sync:
 	kernel_entry 1
-	mrs	x1, esr_el1			// read the syndrome register
-	lsr	x24, x1, #26			// exception class
+	mrs	x25, esr_el1			// read the syndrome register
+	lsr	x24, x25, #26			// exception class
 	cmp	x24, #0x25			// data abort in EL1
 	b.eq	el1_da
+	cmp	x24, #0x15			// SVC in 64-bit state
+	b.eq	el0_svc
 	cmp	x24, #0x18			// configurable trap
 	b.eq	el1_undef
 	cmp	x24, #0x26			// stack alignment exception
@@ -266,6 +268,7 @@ el1_da:
 	tbnz	x23, #7, 1f			// PSR_I_BIT
 	enable_irq
 1:
+	mov	x1, x25
 	mov	x2, sp				// struct pt_regs
 	bl	do_mem_abort
 
@@ -592,7 +595,7 @@ work_resched:
 /*
  * "slow" syscall return path.
  */
-ENTRY(ret_to_user)
+ret_to_user:
 	disable_irq				// disable interrupts
 	ldr	x1, [tsk, #TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
@@ -605,6 +608,15 @@ no_work_pending:
 ENDPROC(ret_to_user)
 
 /*
+ * kernel_execve() - just issue a __NR_execve syscall
+ */
+ENTRY(kernel_execve)
+	mov	x8, #__NR_execve
+	svc	#0
+	ret
+ENDPROC(kernel_execve)
+
+/*
  * This is how we return from a fork.
  */
 ENTRY(ret_from_fork)
diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 905fcfb..dfad7b1 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -62,49 +62,6 @@ out:
 	return error;
 }
 
-int kernel_execve(const char *filename,
-		  const char *const argv[],
-		  const char *const envp[])
-{
-	struct pt_regs regs;
-	int ret;
-
-	memset(&regs, 0, sizeof(struct pt_regs));
-	ret = do_execve(filename,
-			(const char __user *const __user *)argv,
-			(const char __user *const __user *)envp, &regs);
-	if (ret < 0)
-		goto out;
-
-	/*
-	 * Save argc to the register structure for userspace.
-	 */
-	regs.regs[0] = ret;
-
-	/*
-	 * We were successful.  We won't be returning to our caller, but
-	 * instead to user space by manipulating the kernel stack.
-	 */
-	asm(	"add	x0, %0, %1\n\t"
-		"mov	x1, %2\n\t"
-		"mov	x2, %3\n\t"
-		"bl	memmove\n\t"	/* copy regs to top of stack */
-		"mov	x27, #0\n\t"	/* not a syscall */
-		"mov	x28, %0\n\t"	/* thread structure */
-		"mov	sp, x0\n\t"	/* reposition stack pointer */
-		"b	ret_to_user"
-		:
-		: "r" (current_thread_info()),
-		  "Ir" (THREAD_START_SP - sizeof(regs)),
-		  "r" (&regs),
-		  "Ir" (sizeof(regs))
-		: "x0", "x1", "x2", "x27", "x28", "x30", "memory");
-
- out:
-	return ret;
-}
-EXPORT_SYMBOL(kernel_execve);
-
 asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 			 unsigned long prot, unsigned long flags,
 			 unsigned long fd, off_t off)

-- 
Catalin
