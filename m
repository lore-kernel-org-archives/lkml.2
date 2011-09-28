Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1I1Sp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1I1Sp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:45:26 -0400
Date: Wed, 28 Sep 2011 20:41:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: [PATCH] x86: replace mm_context_t.ia32_compat by MMF_COMPAT
Message-ID: <20110928184149.GA31060@redhat.com>
References: <20110927170448.GA15977@redhat.com> <20110928020724.GA4524@wicker.gateway.2wire.net> <20110928155655.GB10550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928155655.GB10550@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill mm_context_t.ia32_compat in favour of arch-independent MMF_COMPAT
flag. This saves a word in mm_struct, and the new flag can be probably
use outside of arch/x86/.

Also, remove the "if (current->mm)" check from set_personality_*().
This can only be called after exec_mmap() installs the new mm != NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h        |    5 ++++-
 arch/x86/include/asm/mmu.h   |    5 -----
 arch/x86/kernel/process_64.c |    8 ++------
 arch/x86/mm/init_64.c        |    2 +-
 arch/x86/ia32/ia32_aout.c    |    2 +-
 5 files changed, 8 insertions(+), 14 deletions(-)

--- 3.1/include/linux/sched.h~MMF_C	2011-09-28 19:53:26.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-09-28 19:57:06.000000000 +0200
@@ -436,7 +436,10 @@ extern int get_dumpable(struct mm_struct
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
 
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
+#define MMF_COMPAT		18	/* this task runs in compat mode. */
+
+#define MMF_INIT_MASK	\
+	((1 << MMF_COMPAT) | MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
 	atomic_t		count;
--- 3.1/arch/x86/include/asm/mmu.h~MMF_C	2011-09-28 19:53:26.000000000 +0200
+++ 3.1/arch/x86/include/asm/mmu.h	2011-09-28 19:53:49.000000000 +0200
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
--- 3.1/arch/x86/kernel/process_64.c~MMF_C	2011-09-28 19:53:26.000000000 +0200
+++ 3.1/arch/x86/kernel/process_64.c	2011-09-28 19:59:39.000000000 +0200
@@ -501,10 +501,7 @@ void set_personality_64bit(void)
 
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
-
-	/* Ensure the corresponding mm is not marked. */
-	if (current->mm)
-		current->mm->context.ia32_compat = 0;
+	clear_bit(MMF_COMPAT, &current->mm->flags);
 
 	/* TBD: overwrites user setup. Should have two bits.
 	   But 64bit processes have always behaved this way,
@@ -522,8 +519,7 @@ void set_personality_ia32(void)
 	current->personality |= force_personality32;
 
 	/* Mark the associated mm as containing 32-bit tasks. */
-	if (current->mm)
-		current->mm->context.ia32_compat = 1;
+	set_bit(MMF_COMPAT, &current->mm->flags);
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;
--- 3.1/arch/x86/mm/init_64.c~MMF_C	2011-09-28 19:53:26.000000000 +0200
+++ 3.1/arch/x86/mm/init_64.c	2011-09-28 19:53:49.000000000 +0200
@@ -860,7 +860,7 @@ static struct vm_area_struct gate_vma = 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (!mm || mm->context.ia32_compat)
+	if (!mm || test_bit(MMF_COMPAT, &mm->flags))
 		return NULL;
 #endif
 	return &gate_vma;
--- 3.1/arch/x86/ia32/ia32_aout.c~MMF_C	2011-09-28 19:53:26.000000000 +0200
+++ 3.1/arch/x86/ia32/ia32_aout.c	2011-09-28 19:53:49.000000000 +0200
@@ -298,7 +298,7 @@ static int load_aout_binary(struct linux
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
 	set_thread_flag(TIF_IA32);
-	current->mm->context.ia32_compat = 1;
+	set_bit(MMF_COMPAT, &current->mm->flags);
 
 	setup_new_exec(bprm);
 

