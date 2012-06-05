Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2FEPra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:47:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2FEPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:47:29 -0400
Date: Tue, 5 Jun 2012 08:47:03 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-8efdfc3a4ed009c978dab6609d15fb958e7cff12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, cmetcalf@tilera.com,
        srivatsa.bhat@linux.vnet.ibm.com, yong.zhang0@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, cmetcalf@tilera.com,
        srivatsa.bhat@linux.vnet.ibm.com, yong.zhang0@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1338275765-3217-6-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-6-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] tile: SMP: Remove call to ipi_call_lock()/
 ipi_call_unlock()
Git-Commit-ID: 8efdfc3a4ed009c978dab6609d15fb958e7cff12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:47:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8efdfc3a4ed009c978dab6609d15fb958e7cff12
Gitweb:     http://git.kernel.org/tip/8efdfc3a4ed009c978dab6609d15fb958e7cff12
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:16:00 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:12 +0200

tile: SMP: Remove call to ipi_call_lock()/ipi_call_unlock()

ipi_call_lock/unlock() lock resp. unlock call_function.lock. This lock
protects only the call_function data structure itself, but it's
completely unrelated to cpu_online_mask. The mask to which the IPIs
are sent is calculated before call_function.lock is taken in
smp_call_function_many(), so the locking around set_cpu_online() is
pointless and can be removed.

[ tglx: Massaged changelog ]

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: ralf@linux-mips.org
Cc: sshtylyov@mvista.com
Cc: david.daney@cavium.com
Cc: nikunj@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: axboe@kernel.dk
Cc: peterz@infradead.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/1338275765-3217-6-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
