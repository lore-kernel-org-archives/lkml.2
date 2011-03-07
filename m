Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1CGLqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:46:47 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44003 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1CGLqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:46:43 -0500
Date: Mon, 7 Mar 2011 17:16:37 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, anton@samba.org,
        benh@kernel.crashing.org
Subject: [PATCH 2/7] powerpc/kdump: Use chip->shutdown to disable IRQs
Message-ID: <20110307114637.GD8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc/kdump: Use chip->shutdown to disable IRQs

    Commit: 5d7a87217de48b234b3c8ff8a73059947d822e07 upstream

    I saw this in a kdump kernel:

    IOMMU table initialized, virtual merging enabled
    Interrupt 155954 (real) is invalid, disabling it.
    Interrupt 155953 (real) is invalid, disabling it.

    ie we took some spurious interrupts. default_machine_crash_shutdown tries
    to disable all interrupt sources but uses chip->disable which maps to
    the default action of:

    static void default_disable(unsigned int irq)
    {
    }

    If we use chip->shutdown, then we actually mask the IRQ:

    static void default_shutdown(unsigned int irq)
    {
            struct irq_desc *desc = irq_to_desc(irq);

            desc->chip->mask(irq);
            desc->status |= IRQ_MASKED;
    }

    Not sure why we don't implement a ->disable action for xics.c, or why
    default_disable doesn't mask the interrupt.

    Signed-off-by: Anton Blanchard <anton@samba.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/powerpc/kernel/crash.c
===================================================================
--- a/arch/powerpc/kernel/crash.c	2011-03-07 00:27:22.703086492 -0800
+++ b/arch/powerpc/kernel/crash.c	2011-03-07 00:27:49.659105563 -0800
@@ -382,7 +382,7 @@
			desc->chip->eoi(i);

		if (!(desc->status & IRQ_DISABLED))
-			desc->chip->disable(i);
+			desc->chip->shutdown(i);
	}

	/*

