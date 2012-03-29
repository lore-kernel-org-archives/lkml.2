Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab2C2NtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:49:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2C2NtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:49:08 -0400
Date: Thu, 29 Mar 2012 06:48:53 -0700
From: "tip-bot for Liu, Chuansheng" <chuansheng.liu@intel.com>
Message-ID: <tip-99dd5497e5be4fe4194cad181d45fd6569a930db@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yanmin_zhang@linux.intel.com, tglx@linutronix.de,
        chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com, tglx@linutronix.de,
        chuansheng.liu@intel.com
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Preserve lazy irq disable semantics in fixup_irqs()
Git-Commit-ID: 99dd5497e5be4fe4194cad181d45fd6569a930db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 06:48:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99dd5497e5be4fe4194cad181d45fd6569a930db
Gitweb:     http://git.kernel.org/tip/99dd5497e5be4fe4194cad181d45fd6569a930db
Author:     Liu, Chuansheng <chuansheng.liu@intel.com>
AuthorDate: Mon, 26 Mar 2012 07:11:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Mar 2012 15:28:47 +0200

x86: Preserve lazy irq disable semantics in fixup_irqs()

The default irq_disable() sematics are to mark the interrupt disabled,
but keep it unmasked. If the interrupt is delivered while marked
disabled, the low level interrupt handler masks it and marks it
pending. This is important for detecting wakeup interrupts during
suspend and for edge type interrupts to avoid losing interrupts.

fixup_irqs() moves the interrupts away from an offlined cpu. For
certain interrupt types it needs to mask the interrupt line before
changing the affinity. After affinity has changed the interrupt line
is unmasked again, but only if it is not marked disabled.

This breaks the lazy irq disable semantics and causes problems in
suspend as the interrupt can be lost or wakeup functionality is
broken.

Check irqd_irq_masked() instead of irqd_irq_disabled() because
irqd_irq_masked() is only set, when the core code actually masked the
interrupt line. If it's not set, we unmask the interrupt and let the
lazy irq disable logic deal with an eventually incoming interrupt.

[ tglx: Massaged changelog and added a comment ]

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Link: http://lkml.kernel.org/r/27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/irq.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7943e0c..3dafc60 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -282,8 +282,13 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
+		/*
+		 * We unmask if the irq was not marked masked by the
+		 * core code. That respects the lazy irq disable
+		 * behaviour.
+		 */
 		if (!irqd_can_move_in_process_context(data) &&
-		    !irqd_irq_disabled(data) && chip->irq_unmask)
+		    !irqd_irq_masked(data) && chip->irq_unmask)
 			chip->irq_unmask(data);
 
 		raw_spin_unlock(&desc->lock);
