Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1G3Uxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 16:53:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37878 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1G3Ux3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 16:53:29 -0400
From: David Ahern <dsahern@gmail.com>
To: benh@kernel.crashing.org, anton@samba.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf: powerpc: Disable pagefaults during callchain stack read
Date: Sat, 30 Jul 2011 14:53:20 -0600
Message-Id: <1312059200-11563-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panic observed on an older kernel when collecting call chains for
the context-switch software event:

 [<b0180e00>]rb_erase+0x1b4/0x3e8
 [<b00430f4>]__dequeue_entity+0x50/0xe8
 [<b0043304>]set_next_entity+0x178/0x1bc
 [<b0043440>]pick_next_task_fair+0xb0/0x118
 [<b02ada80>]schedule+0x500/0x614
 [<b02afaa8>]rwsem_down_failed_common+0xf0/0x264
 [<b02afca0>]rwsem_down_read_failed+0x34/0x54
 [<b02aed4c>]down_read+0x3c/0x54
 [<b0023b58>]do_page_fault+0x114/0x5e8
 [<b001e350>]handle_page_fault+0xc/0x80
 [<b0022dec>]perf_callchain+0x224/0x31c
 [<b009ba70>]perf_prepare_sample+0x240/0x2fc
 [<b009d760>]__perf_event_overflow+0x280/0x398
 [<b009d914>]perf_swevent_overflow+0x9c/0x10c
 [<b009db54>]perf_swevent_ctx_event+0x1d0/0x230
 [<b009dc38>]do_perf_sw_event+0x84/0xe4
 [<b009dde8>]perf_sw_event_context_switch+0x150/0x1b4
 [<b009de90>]perf_event_task_sched_out+0x44/0x2d4
 [<b02ad840>]schedule+0x2c0/0x614
 [<b0047dc0>]__cond_resched+0x34/0x90
 [<b02adcc8>]_cond_resched+0x4c/0x68
 [<b00bccf8>]move_page_tables+0xb0/0x418
 [<b00d7ee0>]setup_arg_pages+0x184/0x2a0
 [<b0110914>]load_elf_binary+0x394/0x1208
 [<b00d6e28>]search_binary_handler+0xe0/0x2c4
 [<b00d834c>]do_execve+0x1bc/0x268
 [<b0015394>]sys_execve+0x84/0xc8
 [<b001df10>]ret_from_syscall+0x0/0x3c

A page fault occurred walking the callchain while creating a perf
sample for the context-switch event. To handle the page fault the
mmap_sem is needed, but it is currently held by setup_arg_pages.
(setup_arg_pages calls shift_arg_pages with the mmap_sem held.
shift_arg_pages then calls move_page_tables which has a cond_resched
at the top of its for loop - hitting that cond_resched is what caused
the context switch.)

This is an extension of Anton's proposed patch:
https://lkml.org/lkml/2011/7/24/151
adding case for 32-bit ppc.

Tested on the system that first generated the panic and then again
with latest kernel using a PPC VM. I am not able to test the 64-bit
path - I do not have H/W for it and 64-bit PPC VMs (qemu on Intel)
is horribly slow.

Signed-off-by: David Ahern <dsahern@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Anton Blanchard <anton@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linuxppc-dev@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org

---
 arch/powerpc/kernel/perf_callchain.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index d05ae42..564c1d8 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -154,8 +154,12 @@ static int read_user_stack_64(unsigned long __user *ptr, unsigned long *ret)
 	    ((unsigned long)ptr & 7))
 		return -EFAULT;
 
-	if (!__get_user_inatomic(*ret, ptr))
+	pagefault_disable();
+	if (!__get_user_inatomic(*ret, ptr)) {
+		pagefault_enable();
 		return 0;
+	}
+	pagefault_enable();
 
 	return read_user_stack_slow(ptr, ret, 8);
 }
@@ -166,8 +170,12 @@ static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
 	    ((unsigned long)ptr & 3))
 		return -EFAULT;
 
-	if (!__get_user_inatomic(*ret, ptr))
+	pagefault_disable();
+	if (!__get_user_inatomic(*ret, ptr)) {
+		pagefault_enable();
 		return 0;
+	}
+	pagefault_enable();
 
 	return read_user_stack_slow(ptr, ret, 4);
 }
@@ -294,11 +302,17 @@ static inline int current_is_64bit(void)
  */
 static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
 {
+	int rc;
+
 	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned int) ||
 	    ((unsigned long)ptr & 3))
 		return -EFAULT;
 
-	return __get_user_inatomic(*ret, ptr);
+	pagefault_disable();
+	rc = __get_user_inatomic(*ret, ptr);
+	pagefault_enable();
+
+	return rc;
 }
 
 static inline void perf_callchain_user_64(struct perf_callchain_entry *entry,
-- 
1.7.6

