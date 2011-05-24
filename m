Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab1EXSgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:36:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1EXSgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:36:38 -0400
Date: Tue, 24 May 2011 20:36:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [conditional GIT PULL] x86 fixes
Message-ID: <20110524183620.GA24680@elte.hu>
References: <20110523193035.GA9170@elte.hu>
 <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
 <20110524060321.GA20904@elte.hu>
 <20110524061525.GA29815@elte.hu>
 <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2011-05-23 at 23:15 -0700, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Possibly the resume fix in the APIC merge :-/
> > > 
> > > It's these commits:
> > > 
> > >  31dce14a3269: x86, ioapic: Use ioapic_saved_data while enabling intr-remapping
> > >  4c79185cdb14: x86, ioapic: Allocate ioapic_saved_data early
> > >  b64ce24daffb: x86, ioapic: Fix potential resume deadlock
> > > 
> > > The first one fixes the resume bug in an easily backportable way (although 
> > > the GFP_ATOMIC is not nice), the later two do it cleaner.
> > > 
> > > So if b64ce24daffb works for you and 31dce14a3269 breaks this would signal 
> > > that the fix from Suresh is the source of the Atom regression.
> > 
> > In particular the lapic_resume() bit looks suspect. Does 
> > save_ioapic_entries() get called? It's called in enable_IR_x2apic() but 
> > your Atom is probably not x2apic. Non-x2apic system do not get 
> > save_ioapic_entries() called, so there's nothing to restore at resume time 
> > AFAICS ... Suresh?
> 
> Patch appended(I am sorry, should have caught this earlier. Looks like my 
> system does keep the ioapic state intact during suspend/resume.)

Thanks Suresh!

Linus, if the patch from Suresh works on your Atom box then please pull the 
latest x86 fixes tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

I've added your Reported-and-tested-by tag on the assumption that this resolves 
the bug. (If it does not then we'll throw away that commit anyway)

 out-of-topic modifications in x86-urgent-for-linus:
 ---------------------------------------------------
 arch/um/Kconfig.x86                # 3a36790: um: Use RWSEM_GENERIC_SPINLOCK on
 include/linux/linkage.h            # 1b4ac2a: x86: Get rid of asmregparm

Thanks,

	Ingo

------------------>
Richard Weinberger (2):
      um: Use RWSEM_GENERIC_SPINLOCK on x86
      x86: Get rid of asmregparm

Suresh Siddha (1):
      x86, ioapic: Restore ioapic entries during resume properly


 arch/um/Kconfig.x86            |    4 ++--
 arch/x86/include/asm/linkage.h |    5 -----
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 arch/x86/kernel/ptrace.c       |    4 ++--
 include/linux/linkage.h        |    4 ----
 5 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index a9da516..795ea8e 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -29,10 +29,10 @@ config X86_64
 	def_bool 64BIT
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD
+	def_bool X86_XADD && 64BIT
 
 config RWSEM_GENERIC_SPINLOCK
-	def_bool !X86_XADD
+	def_bool !RWSEM_XCHGADD_ALGORITHM
 
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 12d55e7..4814297 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -8,11 +8,6 @@
 
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
-/*
- * For 32-bit UML - mark functions implemented in assembly that use
- * regparm input parameters:
- */
-#define asmregparm __attribute__((regparm(3)))
 
 /*
  * Make sure the compiler doesn't do anything stupid with the
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9488dcf..e529339 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -676,7 +676,7 @@ void mask_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (ioapics[apic].saved_registers)
+		if (!ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
@@ -699,7 +699,7 @@ int restore_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (ioapics[apic].saved_registers)
+		if (!ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f65e5b5..807c2a2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1363,7 +1363,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
  * We must return the syscall number to actually look up in the table.
  * This can be -1L to skip running any syscall at all.
  */
-asmregparm long syscall_trace_enter(struct pt_regs *regs)
+long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
@@ -1408,7 +1408,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	return ret ?: regs->orig_ax;
 }
 
-asmregparm void syscall_trace_leave(struct pt_regs *regs)
+void syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
 
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 7135ebc..3f46aed 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -14,10 +14,6 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
-#ifndef asmregparm
-# define asmregparm
-#endif
-
 #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_SIZE)
 #define __page_aligned_bss	__section(.bss..page_aligned) __aligned(PAGE_SIZE)
 
