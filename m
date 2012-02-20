Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2BTTr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:47:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35869 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2BTTr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:47:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.73.138 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Mon, 20 Feb 2012 11:47:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] i387: fix up some fpu_counter confusion
In-Reply-To: <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 10:24:09 -0800
Subject: [PATCH v2 1/3] i387: fix up some fpu_counter confusion

This makes sure we clear the FPU usage counter for newly created tasks,
just so that we start off in a known state (for example, don't try to
preload the FPU state on the first task switch etc).

It also fixes a thinko in when we increment the fpu_counter at task
switch time, introduced by commit 34ddc81a230b ("i387: re-introduce FPU
state preloading at context switch time").  We should increment the
*new* task fpu_counter, not the old task, and only if we decide to use
that state (whether lazily or preloaded).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

That nonsensical "old->fpu_counter++" actually got the right result in
most common cases (because in the case of a preload and holding on to
the FPU for the whole timeslice - which is the normal case - it acted
the same way as if we had incremented the count at FPU load time), but
it really makes no sense. 

And the "clear counters at fork time" don't really matter until you do
lazy restore, but it annoyed me that we started out a new process with
basically random fpu_counter values from the old one.

 arch/x86/include/asm/i387.h  |    3 ++-
 arch/x86/kernel/process_32.c |    1 +
 arch/x86/kernel/process_64.c |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a850b4d8d14d..8df95849721d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -348,10 +348,10 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 		if (__save_init_fpu(old))
 			fpu_lazy_state_intact(old);
 		__thread_clear_has_fpu(old);
-		old->fpu_counter++;
 
 		/* Don't change CR0.TS if we just switch! */
 		if (fpu.preload) {
+			new->fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
 		} else
@@ -359,6 +359,7 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 	} else {
 		old->fpu_counter = 0;
 		if (fpu.preload) {
+			new->fpu_counter++;
 			if (fpu_lazy_restore(new))
 				fpu.preload = 0;
 			else
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 80bfe1ab0031..bc32761bc27a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -214,6 +214,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	task_user_gs(p) = get_user_gs(regs);
 
+	p->fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1fd94bc4279d..8ad880b3bc1c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -286,6 +286,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	set_tsk_thread_flag(p, TIF_FORK);
 
+	p->fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
-- 
1.7.9.188.g12766.dirty

