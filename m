Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab1FWR7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:59:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:35071 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab1FWRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 156/247] powerpc/kdump: Use chip->shutdown to disable IRQs
Date: Thu, 23 Jun 2011 13:33:44 -0400
Message-Id: <1308850515-15242-97-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5d7a87217de48b234b3c8ff8a73059947d822e07 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/crash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index fbe3c1c..0384376 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -381,7 +381,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 			desc->chip->eoi(i);
 
 		if (!(desc->status & IRQ_DISABLED))
-			desc->chip->disable(i);
+			desc->chip->shutdown(i);
 	}
 
 	/*
-- 
1.7.4.4

