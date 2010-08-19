Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0HSLZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:25:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:43832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0HSLZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:25:28 -0400
Date: Thu, 19 Aug 2010 11:24:52 GMT
From: tip-bot for KUMANO Syuhei <kumano.prog@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, yoshfuji@linux-ipv6.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, kumano.prog@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, yoshfuji@linux-ipv6.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        kumano.prog@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1281853084.3254.11.camel@camp10-laptop>
References: <1281853084.3254.11.camel@camp10-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes/x86: Fix the return address of multiple kretprobes
Message-ID: <tip-737480a0d525dae13306296da08029dff545bc72@git.kernel.org>
Git-Commit-ID: 737480a0d525dae13306296da08029dff545bc72
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 11:24:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  737480a0d525dae13306296da08029dff545bc72
Gitweb:     http://git.kernel.org/tip/737480a0d525dae13306296da08029dff545bc72
Author:     KUMANO Syuhei <kumano.prog@gmail.com>
AuthorDate: Sun, 15 Aug 2010 15:18:04 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Aug 2010 12:49:56 +0200

kprobes/x86: Fix the return address of multiple kretprobes

Fix the return address of subsequent kretprobes when multiple
kretprobes are set on the same function.

For example:

 # cd /sys/kernel/debug/tracing
 # echo "r:event1 sys_symlink" > kprobe_events
 # echo "r:event2 sys_symlink" >> kprobe_events
 # echo 1 > events/kprobes/enable
 # ln -s /tmp/foo /tmp/bar

(without this patch)

 # cat trace
              ln-897   [000] 20404.133727: event1: (kretprobe_trampoline+0x0/0x4c <- sys_symlink)
              ln-897   [000] 20404.133747: event2: (system_call_fastpath+0x16/0x1b <- sys_symlink)

(with this patch)

 # cat trace
              ln-740   [000] 13799.491076: event1: (system_call_fastpath+0x16/0x1b <- sys_symlink)
              ln-740   [000] 13799.491096: event2: (system_call_fastpath+0x16/0x1b <- sys_symlink)

Signed-off-by: KUMANO Syuhei <kumano.prog@gmail.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
LKML-Reference: <1281853084.3254.11.camel@camp10-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1bfb6cf..770ebfb 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -709,6 +709,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	struct hlist_node *node, *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
+	kprobe_opcode_t *correct_ret_addr = NULL;
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -740,14 +741,34 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 			/* another task is sharing our hash bucket */
 			continue;
 
+		orig_ret_address = (unsigned long)ri->ret_addr;
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
+	correct_ret_addr = ri->ret_addr;
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
 		if (ri->rp && ri->rp->handler) {
 			__get_cpu_var(current_kprobe) = &ri->rp->kp;
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->ret_addr = correct_ret_addr;
 			ri->rp->handler(ri, regs);
 			__get_cpu_var(current_kprobe) = NULL;
 		}
 
-		orig_ret_address = (unsigned long)ri->ret_addr;
 		recycle_rp_inst(ri, &empty_rp);
 
 		if (orig_ret_address != trampoline_address)
@@ -759,8 +780,6 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 			break;
 	}
 
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-
 	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
