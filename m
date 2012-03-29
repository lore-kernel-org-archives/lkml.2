Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936654Ab2C3Wxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:53:52 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934855Ab2C3VF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:58 -0400
Message-Id: <201203302105.q2UL57lt006300@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:57:18 -0400
Subject: [PATCH] arch/tile: add "nop" after "nap" to help GX idle power draw
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:07.0350 (UTC) FILETIME=[C90DAB60:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids the hardware istream prefetcher doing unnecessary work.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/entry.S |    2 ++
 arch/tile/kernel/smp.c   |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index f8d6155..133c4b5 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -85,6 +85,7 @@ STD_ENTRY(cpu_idle_on_new_stack)
 /* Loop forever on a nap during SMP boot. */
 STD_ENTRY(smp_nap)
 	nap
+	nop       /* avoid provoking the icache prefetch with a jump */
 	j smp_nap /* we are not architecturally guaranteed not to exit nap */
 	jrp lr    /* clue in the backtracer */
 	STD_ENDPROC(smp_nap)
@@ -106,5 +107,6 @@ STD_ENTRY(_cpu_idle)
 	.global _cpu_idle_nap
 _cpu_idle_nap:
 	nap
+	nop       /* avoid provoking the icache prefetch with a jump */
 	jrp lr
 	STD_ENDPROC(_cpu_idle)
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 7579607..f86887a 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -122,7 +122,7 @@ static void smp_stop_cpu_interrupt(void)
 	set_cpu_online(smp_processor_id(), 0);
 	arch_local_irq_disable_all();
 	for (;;)
-		asm("nap");
+		asm("nap; nop");
 }
 
 /* This function calls the 'stop' function on all other CPUs in the system. */
-- 
1.6.5.2

