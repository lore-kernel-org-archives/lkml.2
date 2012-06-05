Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2FEPvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:51:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FEPvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:51:13 -0400
Date: Tue, 5 Jun 2012 08:47:56 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-3b6f70fd7dd4e19fc674ec99e389bf0da5589525@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, jeremy@goop.org, tglx@linutronix.de,
        yong.zhang0@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        jeremy@goop.org, yong.zhang0@gmail.com, tglx@linutronix.de
In-Reply-To: <1338275765-3217-7-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-7-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug]
  x86-smp-remove-call-to-ipi_call_lock-ipi_call_unlock
Git-Commit-ID: 3b6f70fd7dd4e19fc674ec99e389bf0da5589525
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:48:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b6f70fd7dd4e19fc674ec99e389bf0da5589525
Gitweb:     http://git.kernel.org/tip/3b6f70fd7dd4e19fc674ec99e389bf0da5589525
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:16:01 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:12 +0200

x86-smp-remove-call-to-ipi_call_lock-ipi_call_unlock

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
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1338275765-3217-7-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c |    9 ---------
 arch/x86/xen/smp.c        |    2 --
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f56f96d..b2fd28f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -255,22 +255,13 @@ notrace static void __cpuinit start_secondary(void *unused)
 	check_tsc_sync_target();
 
 	/*
-	 * We need to hold call_lock, so there is no inconsistency
-	 * between the time smp_call_function() determines number of
-	 * IPI recipients, and the time when the determination is made
-	 * for which cpus receive the IPI. Holding this
-	 * lock helps us to not include this cpu in a currently in progress
-	 * smp_call_function().
-	 *
 	 * We need to hold vector_lock so there the set of online cpus
 	 * does not change while we are assigning vectors to cpus.  Holding
 	 * this lock ensures we don't half assign or remove an irq from a cpu.
 	 */
-	ipi_call_lock();
 	lock_vector_lock();
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
-	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index afb250d..f58dca7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -80,9 +80,7 @@ static void __cpuinit cpu_bringup(void)
 
 	notify_cpu_starting(cpu);
 
-	ipi_call_lock();
 	set_cpu_online(cpu, true);
-	ipi_call_unlock();
 
 	this_cpu_write(cpu_state, CPU_ONLINE);
 
