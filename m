Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1K2GDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:03:15 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43486 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1K2GDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:03:11 -0500
X-AuditID: b753bd60-a2688ba000000655-f9-4ed4759da794
X-AuditID: b753bd60-a2688ba000000655-f9-4ed4759da794
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 4/4] x86: cleanup the range of stack overflow checking
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 29 Nov 2011 15:08:45 +0900
Message-ID: <20111129060845.11076.40916.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overflow checking of kernel stack checks if the stack pointer
points to the available kernel stack range, which is derived from
the original overflow checking.

It is clear that curbase address is always less than low boundary of
available kernel stack. So, this patch removes the first condition
that checks if the pointer is higher than curbase.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/irq_64.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 5448bf6..c8c9a78 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -46,10 +46,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 	if (user_mode_vm(regs))
 		return;
 
-	if (regs->sp >= curbase &&
-	    regs->sp <= curbase + THREAD_SIZE &&
-	    regs->sp >= curbase + sizeof(struct thread_info) +
-				  sizeof(struct pt_regs) + 128)
+	if (regs->sp >= curbase + sizeof(struct thread_info) +
+				  sizeof(struct pt_regs) + 128 &&
+	    regs->sp <= curbase + THREAD_SIZE)
 		return;
 
 	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack);

