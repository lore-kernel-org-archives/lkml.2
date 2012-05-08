Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2EHMZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:25:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2EHMZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:25:40 -0400
Date: Tue, 8 May 2012 05:25:17 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-9cd75e13de2dcf32ecc21c7f277cff3c0ced059e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        g.trinabh@gmail.com, peterz@infradead.org, benh@kernel.crashing.org,
        arun.r.bharadwaj@gmail.com, tglx@linutronix.de,
        deepthi@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, arun.r.bharadwaj@gmail.com,
        peterz@infradead.org, g.trinabh@gmail.com, tglx@linutronix.de,
        deepthi@linux.vnet.ibm.com
In-Reply-To: <20120507175651.980164748@linutronix.de>
References: <20120507175651.980164748@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] powerpc: Fix broken cpu_idle_wait()
  implementation
Git-Commit-ID: 9cd75e13de2dcf32ecc21c7f277cff3c0ced059e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:25:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cd75e13de2dcf32ecc21c7f277cff3c0ced059e
Gitweb:     http://git.kernel.org/tip/9cd75e13de2dcf32ecc21c7f277cff3c0ced059e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:05 +0200

powerpc: Fix broken cpu_idle_wait() implementation

commit 771dae818 (powerpc/cpuidle: Add cpu_idle_wait() to allow
switching of idle routines) implemented cpu_idle_wait() for powerpc.

The changelog says:
 "The equivalent routine for x86 is in arch/x86/kernel/process.c
  but the powerpc implementation is different.":

Unfortunately the changelog is completely useless as it does not tell
_WHY_ it is different.

Aside of being different the implementation is patently wrong.

The rescheduling IPI is async. That means that there is no guarantee,
that the other cores have executed the IPI when cpu_idle_wait()
returns. But that's the whole purpose of this function: to guarantee
that no CPU uses the old idle handler anymore.

Use the smp_functional_call() based implementation, which fulfils the
requirements.

[ This code is going to replaced by a core version to remove all the
  pointless copies in arch/*, but this one should go to stable ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Trinabh Gupta <g.trinabh@gmail.com>
Cc: Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20120507175651.980164748@linutronix.de
Cc: stable@vger.kernel.org
---
 arch/powerpc/kernel/idle.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 6d2209a..04d7909 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -113,6 +113,9 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
 
 /*
  * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
@@ -123,16 +126,9 @@ void cpu_idle(void)
  */
 void cpu_idle_wait(void)
 {
-	int cpu;
 	smp_mb();
-
-	/* kick all the CPUs so that they exit out of old idle routine */
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		if (cpu != smp_processor_id())
-			smp_send_reschedule(cpu);
-	}
-	put_online_cpus();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
