Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0HEE3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:29:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47457 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab0HEE3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:29:21 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, will_schmidt@vnet.ibm.com, tglx@linutronix.de,
        nfont@austin.ibm.com, rcj@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, dvhltc@us.ibm.com
Subject: [PATCH 2/3] powerpc-silence-__cpu_up-under-normal-operation
Date: Wed,  4 Aug 2010 21:28:34 -0700
Message-Id: <1280982515-18231-3-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280982515-18231-1-git-send-email-dvhltc@us.ibm.com>
References: <1280982515-18231-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

During CPU offline/online tests __cpu_up would flood the logs with
the following message:

Processor 0 found.

This provides no useful information to the user as there is no context
provided, and since the operation was a success (to this point) it is expected
that the CPU will come back online, providing all the feedback necessary.

Change the "Processor found" message to DBG() similar to other such messages in
the same function. Also, add an appropriate log level for the "Processor is
stuck" message.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5c196d1..cc05792 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -429,11 +429,11 @@ int __cpuinit __cpu_up(unsigned int cpu)
 #endif
 
 	if (!cpu_callin_map[cpu]) {
-		printk("Processor %u is stuck.\n", cpu);
+		printk(KERN_ERR "Processor %u is stuck.\n", cpu);
 		return -ENOENT;
 	}
 
-	printk("Processor %u found.\n", cpu);
+	DBG("Processor %u found.\n", cpu);
 
 	if (smp_ops->give_timebase)
 		smp_ops->give_timebase();
-- 
1.7.0.4

