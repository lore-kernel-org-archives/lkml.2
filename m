Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0JPQiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:38:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:53284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab0JPQiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:38:52 -0400
Date: Sat, 16 Oct 2010 16:38:14 GMT
From: tip-bot for Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linus.walleij@stericsson.com, linux@arm.linux.org.uk, gadiyar@ti.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, linux@arm.linux.org.uk, gadiyar@ti.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
References: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq, ARM: Fix boot on ARM platforms
Message-ID: <tip-05d0ca85c91013d5f73c43fb566bde09a9718019@git.kernel.org>
Git-Commit-ID: 05d0ca85c91013d5f73c43fb566bde09a9718019
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:38:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05d0ca85c91013d5f73c43fb566bde09a9718019
Gitweb:     http://git.kernel.org/tip/05d0ca85c91013d5f73c43fb566bde09a9718019
Author:     Anand Gadiyar <gadiyar@ti.com>
AuthorDate: Thu, 14 Oct 2010 22:59:57 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Oct 2010 18:22:03 +0200

genirq, ARM: Fix boot on ARM platforms

Commit b683de2b3 in linux-next as of 20101014 (genirq: Query
arch for number of early descriptors) seems to have broken
bootup on several ARM boards - my beagleboard gives the
following dump with earlyprintk:

 NR_IRQS:402
 Unable to handle kernel NULL pointer dereference at virtual
 address 00000028 pgd = c0004000
 [00000028] *pgd=00000000
 Internal error: Oops: 5 [#1]
 last sysfs file:
 Modules linked in:
 CPU: 0    Not tainted
 (2.6.36-rc7-next-20101014-linux-next-20101012+ #40) PC is at
 init_IRQ+0x14/0x48 LR is at start_kernel+0x150/0x2c0
 [...]

We seem to be using desc->status without assigning desc to
anything. Fix this by adding back the code that was originally
there.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Tested-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
LKML-Reference: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/irq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 5456d11..0e65d7e 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -157,8 +157,10 @@ void __init init_IRQ(void)
 	struct irq_desc *desc;
 	int irq;
 
-	for (irq = 0; irq < nr_irqs; irq++)
+	for (irq = 0; irq < nr_irqs; irq++) {
+		desc = irq_to_desc_alloc_node(irq, 0);
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
+	}
 
 	init_arch_irq();
 }
