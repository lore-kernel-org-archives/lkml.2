Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2E2HSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:18:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50086 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2E2HSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:18:08 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 09/10] POWERPC: smp: remove call to ipi_call_lock()/ipi_call_unlock()
Date: Tue, 29 May 2012 15:16:04 +0800
Message-Id: <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

1) call_function.lock used in smp_call_function_many() is just to protect
   call_function.queue and &data->refs, cpu_online_mask is outside of the
   lock. And it's not necessary to protect cpu_online_mask,
   because data->cpumask is pre-calculate and even if a cpu is brougt up
   when calling arch_send_call_function_ipi_mask(), it's harmless because
   validation test in generic_smp_call_function_interrupt() will take care
   of it.

2) For cpu down issue, stop_machine() will guarantee that no concurrent
   smp_call_fuction() is processing.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/smp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index e4cb343..e1417c4 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -571,7 +571,6 @@ void __devinit start_secondary(void *unused)
 	if (system_state == SYSTEM_RUNNING)
 		vdso_data->processorCount++;
 #endif
-	ipi_call_lock();
 	notify_cpu_starting(cpu);
 	set_cpu_online(cpu, true);
 	/* Update sibling maps */
@@ -601,7 +600,6 @@ void __devinit start_secondary(void *unused)
 		of_node_put(np);
 	}
 	of_node_put(l2_cache);
-	ipi_call_unlock();
 
 	local_irq_enable();
 
-- 
1.7.5.4

