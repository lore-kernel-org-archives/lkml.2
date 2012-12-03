Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2LCPH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:07:58 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44683 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2LCPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:07:57 -0500
Subject: [PATCH v2 1/4] kprobes/powerpc: Do not disable External interrupts
 during single step
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, anton@redhat.com, mingo@elte.hu
Date: Mon, 03 Dec 2012 20:37:42 +0530
Message-ID: <20121203150720.7727.91582.stgit@suzukikp>
In-Reply-To: <20121203150438.7727.74924.stgit@suzukikp>
References: <20121203150438.7727.74924.stgit@suzukikp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120315-4790-0000-0000-000005D9664A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

External/Decrement exceptions have lower priority than the Debug Exception.
So, we don't have to disable the External interrupts before a single step.
However, on BookE, Critical Input Exception(CE) has higher priority than a
Debug Exception. Hence we mask them.

Signed-off-by: 	Suzuki K. Poulose <suzuki@in.ibm.com>
Cc:		Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:		Ananth N Mavinakaynahalli <ananth@in.ibm.com>
Cc:		Kumar Gala <galak@kernel.crashing.org>
Cc:		linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/kprobes.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index e88c643..4901b34 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -104,13 +104,13 @@ void __kprobes arch_remove_kprobe(struct kprobe *p)
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
-	/* We turn off async exceptions to ensure that the single step will
-	 * be for the instruction we have the kprobe on, if we dont its
-	 * possible we'd get the single step reported for an exception handler
-	 * like Decrementer or External Interrupt */
-	regs->msr &= ~MSR_EE;
 	regs->msr |= MSR_SINGLESTEP;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	/* 
+	 * We turn off Critical Input Exception(CE) to ensure that the single
+	 * step will be for the instruction we have the probe on; if we don't,
+	 * it is possible we'd get the single step reported for CE.
+	 */
 	regs->msr &= ~MSR_CE;
 	mtspr(SPRN_DBCR0, mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
 #ifdef CONFIG_PPC_47x

