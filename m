Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2EOFyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:54:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64058 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2EOFyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:54:06 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Yong Zhang <yong.zhang0@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -rt] mm: protect activate_mm() by preempt_[disable|enable]_rt()
Date: Tue, 15 May 2012 13:53:56 +0800
Message-Id: <1337061236-1766-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Otherwise there will be warning on ARM like below:

WARNING: at build/linux/kernel/smp.c:459 smp_call_function_many+0x98/0x264()
Modules linked in:
[<c0013bb4>] (unwind_backtrace+0x0/0xe4) from [<c001be94>] (warn_slowpath_common+0x4c/0x64)
[<c001be94>] (warn_slowpath_common+0x4c/0x64) from [<c001bec4>] (warn_slowpath_null+0x18/0x1c)
[<c001bec4>] (warn_slowpath_null+0x18/0x1c) from [<c0053ff8>](smp_call_function_many+0x98/0x264)
[<c0053ff8>] (smp_call_function_many+0x98/0x264) from [<c0054364>] (smp_call_function+0x44/0x6c)
[<c0054364>] (smp_call_function+0x44/0x6c) from [<c0017d50>] (__new_context+0xbc/0x124)
[<c0017d50>] (__new_context+0xbc/0x124) from [<c009e49c>] (flush_old_exec+0x460/0x5e4)
[<c009e49c>] (flush_old_exec+0x460/0x5e4) from [<c00d61ac>] (load_elf_binary+0x2e0/0x11ac)
[<c00d61ac>] (load_elf_binary+0x2e0/0x11ac) from [<c009d060>] (search_binary_handler+0x94/0x2a4)
[<c009d060>] (search_binary_handler+0x94/0x2a4) from [<c009e8fc>] (do_execve+0x254/0x364)
[<c009e8fc>] (do_execve+0x254/0x364) from [<c0010e84>] (sys_execve+0x34/0x54)
[<c0010e84>] (sys_execve+0x34/0x54) from [<c000da00>] (ret_fast_syscall+0x0/0x30)
---[ end trace 0000000000000002 ]---

The reason is that ARM need irq enabled when doing activate_mm().
According to mm-protect-activate-switch-mm.patch, actually
preempt_[disable|enable]_rt() is sufficient.

Inspired-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/exec.c        |    4 ++--
 mm/mmu_context.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index db02d76..9384953 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -840,12 +840,12 @@ static int exec_mmap(struct mm_struct *mm)
 		}
 	}
 	task_lock(tsk);
-	local_irq_disable_rt();
+	preempt_disable_rt();
 	active_mm = tsk->active_mm;
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
-	local_irq_enable_rt();
+	preempt_enable_rt();
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index 8ca7e6b..1385e48 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -26,7 +26,7 @@ void use_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
-	local_irq_disable_rt();
+	preempt_disable_rt();
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
 		atomic_inc(&mm->mm_count);
@@ -34,7 +34,7 @@ void use_mm(struct mm_struct *mm)
 	}
 	tsk->mm = mm;
 	switch_mm(active_mm, mm, tsk);
-	local_irq_enable_rt();
+	preempt_enable_rt();
 	task_unlock(tsk);
 
 	if (active_mm != mm)
-- 
1.7.5.4

