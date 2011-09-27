Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1I0RIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1I0RIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:08:24 -0400
Date: Tue, 27 Sep 2011 19:04:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Q: x86: add context tag to mark mm when running a task in 32-bit
	compatibility mode
Message-ID: <20110927170448.GA15977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c2ef45df3b98a027ec8f9081bd2a19dff520ef9d

    This tag is intended to mirror the thread info TIF_IA32 flag.

OK, but

	+#ifdef CONFIG_X86_64
	+	/* True if mm supports a task running in 32 bit compatibility mode. */
	+	unsigned short ia32_compat;
	+#endif

Stupid question, why we can't add a simple arch-independent MMF_COMPAT
flag instead?

I am asking because we probably want to backport this change and this
ia32_compat looks a bit annoying, why should we waste a word?

Sure, this is very minor, but perhaps the trivial patch below makes
sense?

Oleg.


--- x/include/linux/sched.h
+++ x/include/linux/sched.h
@@ -436,6 +436,8 @@ extern int get_dumpable(struct mm_struct
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
 
+#define MMF_COMPAT		18	/* this task runs in compat mode. */
+
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
--- x/arch/x86/include/asm/mmu.h
+++ x/arch/x86/include/asm/mmu.h
@@ -12,11 +12,6 @@ typedef struct {
 	void *ldt;
 	int size;
 
-#ifdef CONFIG_X86_64
-	/* True if mm supports a task running in 32 bit compatibility mode. */
-	unsigned short ia32_compat;
-#endif
-
 	struct mutex lock;
 	void *vdso;
 } mm_context_t;
--- x/arch/x86/kernel/process_64.c
+++ x/arch/x86/kernel/process_64.c
@@ -502,10 +502,6 @@ void set_personality_64bit(void)
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
 
-	/* Ensure the corresponding mm is not marked. */
-	if (current->mm)
-		current->mm->context.ia32_compat = 0;
-
 	/* TBD: overwrites user setup. Should have two bits.
 	   But 64bit processes have always behaved this way,
 	   so it's not too bad. The main problem is just that
@@ -522,8 +518,7 @@ void set_personality_ia32(void)
 	current->personality |= force_personality32;
 
 	/* Mark the associated mm as containing 32-bit tasks. */
-	if (current->mm)
-		current->mm->context.ia32_compat = 1;
+	set_bit(MMF_COMPAT, &current->mm->flags);
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;
--- x/arch/x86/mm/init_64.c
+++ x/arch/x86/mm/init_64.c
@@ -860,7 +860,7 @@ static struct vm_area_struct gate_vma = 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (!mm || mm->context.ia32_compat)
+	if (!mm || test_bit(MMF_COMPAT, &mm->flags))
 		return NULL;
 #endif
 	return &gate_vma;
--- x/arch/x86/ia32/ia32_aout.c
+++ x/arch/x86/ia32/ia32_aout.c
@@ -298,7 +298,7 @@ static int load_aout_binary(struct linux
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
 	set_thread_flag(TIF_IA32);
-	current->mm->context.ia32_compat = 1;
+	set_bit(MMF_COMPAT, &current->mm->flags);
 
 	setup_new_exec(bprm);
 

