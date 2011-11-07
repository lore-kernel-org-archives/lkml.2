Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1KGFrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:47:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54614 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1KGFrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:47:46 -0500
X-AuditID: b753bd60-9ea82ba000000655-5e-4eb770ff7147
X-AuditID: b753bd60-9ea82ba000000655-5e-4eb770ff7147
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 4/5] x86: panic on detection of stack overflow
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 07 Nov 2011 14:53:08 +0900
Message-ID: <20111107055308.7928.54878.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, messages are just output on the detection of stack overflow,
which is not sufficient for enterprise systems since it may corrupt data.
To enhance reliability, it is required to stop the systems.

This patch causes a panic according to a sysctl parameter
panic_on_stackoverflow when detecting it. It is disabled by default.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/irq_32.c |    2 ++
 arch/x86/kernel/irq_64.c |   16 +++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7209070..e16e99eb 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -43,6 +43,8 @@ static void print_stack_overflow(void)
 {
 	printk(KERN_WARNING "low stack detected by irq handler\n");
 	dump_stack();
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
 }
 
 #else
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index d720813..f7baedd 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -69,14 +69,20 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 		current->comm, curbase, regs->sp,
 		irq_stack_top, irq_stack_bottom,
 		estack_top, estack_bottom);
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
 #else
-	WARN_ONCE(regs->sp >= curbase &&
-		  regs->sp <= curbase + THREAD_SIZE &&
-		  regs->sp <  curbase + sizeof(struct thread_info) +
-					sizeof(struct pt_regs) + 128,
-
+	if (regs->sp >= curbase &&
+		regs->sp <= curbase + THREAD_SIZE &&
+		regs->sp <  curbase + sizeof(struct thread_info) +
+					sizeof(struct pt_regs) + 128) {
+		WARN_ONCE(1,
 		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
 			current->comm, curbase, regs->sp);
+		if (sysctl_panic_on_stackoverflow)
+			panic("low stack detected by irq handler - check messages\n");
+	}
+
 #endif /* CONFIG_DEBUG_STACKOVERFLOW_DETAIL */
 #endif
 }

