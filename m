Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2E2HRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:17:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57666 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2E2HRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:17:18 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [RFC PATCH 05/10] tile: smp: remove call to ipi_call_lock()/ipi_call_unlock()
Date: Tue, 29 May 2012 15:16:00 +0800
Message-Id: <1338275765-3217-6-git-send-email-yong.zhang0@gmail.com>
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
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/smpboot.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 84873fb..e686c5a 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -198,17 +198,7 @@ void __cpuinit online_secondary(void)
 
 	notify_cpu_starting(smp_processor_id());
 
-	/*
-	 * We need to hold call_lock, so there is no inconsistency
-	 * between the time smp_call_function() determines number of
-	 * IPI recipients, and the time when the determination is made
-	 * for which cpus receive the IPI. Holding this
-	 * lock helps us to not include this cpu in a currently in progress
-	 * smp_call_function().
-	 */
-	ipi_call_lock();
 	set_cpu_online(smp_processor_id(), 1);
-	ipi_call_unlock();
 	__get_cpu_var(cpu_state) = CPU_ONLINE;
 
 	/* Set up tile-specific state for this cpu. */
-- 
1.7.5.4

