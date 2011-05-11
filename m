Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1EKQYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:24:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:54372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab1EKQQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:16:48 -0400
Date: Wed, 11 May 2011 13:10:01 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-9bbeacf52f66d165739a4bbe9c018d17493a74b5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, jolsa@redhat.com,
        mingo@elte.hu
In-Reply-To: <20110511110613.GB2390@jolsa.brq.redhat.com>
References: <20110511110613.GB2390@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes, x86: Disable irqs during optimized callback
Git-Commit-ID: 9bbeacf52f66d165739a4bbe9c018d17493a74b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 May 2011 13:10:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bbeacf52f66d165739a4bbe9c018d17493a74b5
Gitweb:     http://git.kernel.org/tip/9bbeacf52f66d165739a4bbe9c018d17493a74b5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 11 May 2011 13:06:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 May 2011 13:21:23 +0200

kprobes, x86: Disable irqs during optimized callback

Disable irqs during optimized callback, so we dont miss any in-irq kprobes.

The following commands:

 # cd /debug/tracing/
 # echo "p mutex_unlock" >> kprobe_events
 # echo "p _raw_spin_lock" >> kprobe_events
 # echo "p smp_apic_timer_interrupt" >> ./kprobe_events
 # echo 1 > events/enable

Cause the optimized kprobes to be missed. None is missed
with the fix applied.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20110511110613.GB2390@jolsa.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c969fd9..f1a6244 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1183,12 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 					 struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long flags;
 
 	/* This is possible if op is under delayed unoptimizing */
 	if (kprobe_disabled(&op->kp))
 		return;
 
-	preempt_disable();
+	local_irq_save(flags);
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(&op->kp);
 	} else {
@@ -1207,7 +1208,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 		opt_pre_handler(&op->kp, regs);
 		__this_cpu_write(current_kprobe, NULL);
 	}
-	preempt_enable_no_resched();
+	local_irq_restore(flags);
 }
 
 static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
