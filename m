Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559Ab0I0XS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:18:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59065 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759802Ab0I0XSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:18:08 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Mark Nelson <markn@au1.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] pseries/xics: use cpu_possible_mask rather than cpu_all_mask
Date: Mon, 27 Sep 2010 16:17:43 -0700
Message-Id: <1285629463-27699-3-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285629463-27699-1-git-send-email-nacc@us.ibm.com>
References: <1285629463-27699-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current firmware only allows us to send IRQs to the first processor or
all processors. We currently check to see if the passed in mask is equal
to the all_mask, but the firmware is only considering whether the
request is for the equivalent of the possible_mask. Thus, we think the
request is for some subset of CPUs and only assign IRQs to the first CPU
(on systems without irqbalance running) as evidenced by
/proc/interrupts. By using possible_mask instead, we account for this
and proper interleaving of interrupts occurs. Without this change and
"pseries/xics: use cpu_possible_mask rather than cpu_all_mask", IRQs are
all routed to CPU0 on power machines not running irqbalance.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/xics.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 93834b0..7c1e342 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -178,7 +178,7 @@ static int get_irq_server(unsigned int virq, const struct cpumask *cpumask,
 	if (!distribute_irqs)
 		return default_server;
 
-	if (!cpumask_equal(cpumask, cpu_all_mask)) {
+	if (!cpumask_subset(cpu_possible_mask, cpumask)) {
 		int server = cpumask_first_and(cpu_online_mask, cpumask);
 
 		if (server < nr_cpu_ids)
-- 
1.7.0.4

