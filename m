Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab2BOJbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:31:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45492 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2BOJa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:30:59 -0500
MIME-Version: 1.0
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Milton Miller <miltonm@bga.com>,
        x86@kernel.org
Subject: [PATCH] x86: drop false warning of empty cpumask in IPI
Date: Wed, 15 Feb 2012 11:30:04 +0200
Message-Id: <1329298204-5026-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current generic SMP infrastructure, it is feasible
for the target CPUs to begin processing an IPI work item
even before we sent them the actual IPI in the case that
an IPI from another CPU woke them first.

This can lead to generating a false warning in a valid
state of trying to send IPI with an empty cpumask when
multiple concurrent IPIs are being sent.

This patch was triggered by the following LKML discussion:
https://lkml.org/lkml/2012/1/13/308

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Milton Miller <miltonm@bga.com>
CC: x86@kernel.org
---
 arch/x86/kernel/apic/ipi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index cce91bf..00b68a3 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -106,7 +106,10 @@ void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
-	if (WARN_ONCE(!mask, "empty IPI mask"))
+	if (!mask)
+		/* The target CPUs must have already processed the
+		 * work items due to a concurrent IPI
+		 */
 		return;
 
 	local_irq_save(flags);
-- 
1.7.0.4

