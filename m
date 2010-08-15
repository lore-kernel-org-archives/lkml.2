Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0HOGSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 02:18:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45169 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0HOGSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 02:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GKgalxmlzFH8uTyMoHUhjoo26t+DgzzdK1OJsz7X0XPRuZ5xlkOYS0trxUDD+S+I7r
         49TAzEoCVz1S0gM9LmkxBfYESA9rHY+yGfUFmlf1IoFGbRZgxeUt0UvuQA6/D5+bzUbE
         4XwXlp1DdnCUu/Fup7z5HEtlWcYSA3GvPbUwE=
Subject: [PATCH] kprobes/x86: Fix the return address of multiple kretprobes
From: KUMANO Syuhei <kumano.prog@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Aug 2010 15:18:04 +0900
Message-ID: <1281853084.3254.11.camel@camp10-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: KUMANO Syuhei <kumano.prog@gmail.com>
---
 arch/x86/kernel/kprobes.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 675879b..5220e14 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -707,6 +707,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	struct hlist_node *node, *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
+	kprobe_opcode_t *correct_ret_addr = NULL;
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -738,14 +739,34 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
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
@@ -757,8 +778,6 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 			break;
 	}
 
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-
 	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-- 
1.7.0.4



