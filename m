Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0HEE3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:29:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55784 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0HEE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:29:34 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, will_schmidt@vnet.ibm.com, tglx@linutronix.de,
        nfont@austin.ibm.com, rcj@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, dvhltc@us.ibm.com
Subject: [PATCH 3/3] powerpc-silence-xics_migrate_irqs_away-during-cpu-offline
Date: Wed,  4 Aug 2010 21:28:35 -0700
Message-Id: <1280982515-18231-4-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280982515-18231-1-git-send-email-dvhltc@us.ibm.com>
References: <1280982515-18231-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

All IRQs are migrated away from a CPU that is being offlined so the
following messages suggest a problem when the system is behaving as
designed:

IRQ 262 affinity broken off cpu 1
IRQ 17 affinity broken off cpu 0
IRQ 18 affinity broken off cpu 0
IRQ 19 affinity broken off cpu 0
IRQ 256 affinity broken off cpu 0
IRQ 261 affinity broken off cpu 0
IRQ 262 affinity broken off cpu 0

Don't print these messages when the CPU is not online.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/xics.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index f19d194..8d0b0b1 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -930,8 +930,10 @@ void xics_migrate_irqs_away(void)
 		if (xics_status[0] != hw_cpu)
 			goto unlock;
 
-		printk(KERN_WARNING "IRQ %u affinity broken off cpu %u\n",
-		       virq, cpu);
+		/* This is expected during cpu offline. */
+		if (cpu_online(cpu))
+			printk(KERN_WARNING "IRQ %u affinity broken off cpu %u\n",
+			       virq, cpu);
 
 		/* Reset affinity to all cpus */
 		cpumask_setall(irq_to_desc(virq)->affinity);
-- 
1.7.0.4

