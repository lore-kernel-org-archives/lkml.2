Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1E2HXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 03:23:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab1E2HXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 03:23:10 -0400
Date: Sun, 29 May 2011 09:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-mm@kvack.org
Subject: [PATCH] mm: Fix boot crash in mm_alloc()
Message-ID: <20110529072256.GA20983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


Would be nice to get the fix below into -rc1 as well, it triggers 
rather easily on bootup when CONFIG_CPUMASK_OFFSTACK is turned on.

	Ingo

---------------------->
>From 59b28833ae328e2206865fb25e61917e738d9696 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 28 May 2011 08:22:15 +0200
Subject: [PATCH] mm: Fix boot crash in mm_alloc()

Fix CONFIG_CPUMASK_OFFSTACK=y boot crash:

[   12.598405] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   12.600012] IP: [<c11ae035>] find_next_bit+0x55/0xb0
[   12.600012] *pdpt = 0000000000000000 *pde = f000e81af000e81a
[   12.600012] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   12.600012] Modules linked in:
[   12.600012]
[   12.600012] Pid: 1, comm: swapper Not tainted 2.6.39-05707-gde03c72-dirty #130523 System manufacturer System Product Name/A8N-E
[   12.600012] EIP: 0060:[<c11ae035>] EFLAGS: 00010202 CPU: 0
[   12.600012] EIP is at find_next_bit+0x55/0xb0
[   12.600012] EAX: 00000000 EBX: 00000002 ECX: 00000000 EDX: 00000000
[   12.600012] ESI: 00000000 EDI: f59a4000 EBP: f6479e78 ESP: f6479e70
[   12.600012]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   12.600012] Process swapper (pid: 1, ti=f6478000 task=f6470000 task.ti=f6478000)
[   12.600012] Stack:
[   12.600012]  00000000 00000000 f6479e8c c11addda 00000000 f59a4000 f5939000 f6479e98
[   12.600012]  c102396b 35937001 f6479eac c1022705 00000001 f5939008 f59a4000 f6479ed8
[   12.600012]  c10227ba f5939000 f59a4000 f5939000 f5937000 f5938000 f593c000 f59a4000
[   12.600012] Call Trace:
[   12.600012]  [<c11addda>] cpumask_any_but+0x2a/0x70
[   12.600012]  [<c102396b>] flush_tlb_mm+0x2b/0x80
[   12.600012]  [<c1022705>] pud_populate+0x35/0x50
[   12.600012]  [<c10227ba>] pgd_alloc+0x9a/0xf0
[   12.600012]  [<c103a3fc>] mm_init+0xec/0x120
[   12.600012]  [<c103a7a3>] mm_alloc+0x53/0xd0
[   12.600012]  [<c10f9220>] bprm_mm_init+0x20/0x1b0
[   12.600012]  [<c10370bf>] ? sched_exec+0x7f/0xb0
[   12.600012]  [<c10f96b9>] do_execve+0xb9/0x270
[   12.600012]  [<c100aec7>] sys_execve+0x37/0x70
[   12.600012]  [<c13d60a2>] ptregs_execve+0x12/0x18
[   12.600012]  [<c13d5299>] ? syscall_call+0x7/0xb
[   12.600012]  [<c1006840>] ? kernel_execve+0x20/0x30
[   12.600012]  [<c16086af>] ? start_kernel+0x2de/0x2de
[   12.600012]  [<c13c9ea2>] ? run_init_process+0x1c/0x1e
[   12.600012]  [<c13c9f2d>] ? init_post+0x89/0xb3
[   12.600012]  [<c16087d1>] ? kernel_init+0x122/0x122
[   12.600012]  [<c13d657a>] ? kernel_thread_helper+0x6/0x10

Caused by:

  de03c72: mm: convert mm->cpu_vm_cpumask into cpumask_var_t

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ca406d9..7b0669f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -538,17 +538,13 @@ struct mm_struct * mm_alloc(void)
 		return NULL;
 
 	memset(mm, 0, sizeof(*mm));
-	mm = mm_init(mm, current);
-	if (!mm)
-		return NULL;
 
 	if (mm_init_cpumask(mm, NULL)) {
-		mm_free_pgd(mm);
 		free_mm(mm);
 		return NULL;
 	}
 
-	return mm;
+	return mm_init(mm, current);
 }
 
 /*
