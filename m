Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1DZNBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab1DZNBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:01:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] kprobes,x86: disable irq durinr optimized callback
Date: Tue, 26 Apr 2011 15:01:31 +0200
Message-Id: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

attached patch is disabling irqs during optimized callback,
so we dont miss any in-irq kprobes as missed.

Also I think there's small window where current_kprobe variable
could be touched in non-safe way, but I was not able to hit
any issue.

I'm not sure wether this is a bug or if it was intentional to have
irqs enabled during the pre_handler callback.

wbr,
jirka

---
Disabling irqs during optimized callback, so we dont miss
any in-irq kprobes as missed.

Interrupts are also disabled during non-optimized kprobes callbacks.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/kprobes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c969fd9..917cb31 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1183,11 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 					 struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long flags;
 
 	/* This is possible if op is under delayed unoptimizing */
 	if (kprobe_disabled(&op->kp))
 		return;
 
+	local_irq_save(flags);
 	preempt_disable();
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(&op->kp);
@@ -1208,6 +1210,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 		__this_cpu_write(current_kprobe, NULL);
 	}
 	preempt_enable_no_resched();
+	local_irq_restore(flags);
 }
 
 static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
-- 
1.7.1

