Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0JAV0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:26:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42575 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab0JAV0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:26:31 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than online_mask in setup_affinity
Date: Fri,  1 Oct 2010 14:26:17 -0700
Message-Id: <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of online_mask requires architecture code to be hotplug-aware to
account for IRQ round-robin'ing. With user-driven dynamic SMT, this
could commonly occur even without physical hotplug. Without this change
and "pseries/xics: use cpu_possible_mask rather than cpu_all_mask", IRQs
are all routed to CPU0 on power machines with XICS not running
irqbalance.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
I have boot-tested this on ppc64, but not yet on x86/x86_64. This is
generic-code, and perhaps an audit of all .set_affinity functions should
occur before upstream acceptance?
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c3003e9..ef85b95 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -175,7 +175,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
+	cpumask_and(desc->affinity, cpu_possible_mask, irq_default_affinity);
 set_affinity:
 	desc->chip->set_affinity(irq, desc->affinity);
 
-- 
1.7.0.4

