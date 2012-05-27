Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2E0BtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:49:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2E0BHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:07:30 -0400
Message-Id: <20120527010426.881231735@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:45 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 22/94] powerpc: Fix broken cpu_idle_wait() implementation
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 9cd75e13de2dcf32ecc21c7f277cff3c0ced059e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/idle.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -109,6 +109,9 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
 
 /*
  * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
@@ -119,16 +122,9 @@ void cpu_idle(void)
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
 


