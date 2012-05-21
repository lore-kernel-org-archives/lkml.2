Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab2EUEh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 00:37:29 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48700 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab2EUEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 00:37:27 -0400
Message-ID: <4FB9C5D3.5070606@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 10:04:27 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND] cpuidle: (POWER) Replace pseries_notify_cpuidle_add
 call with a elegant notifier to fix lockdep problem in start_secondary
References: <4FB64E9A.3060100@linux.vnet.ibm.com> <1337561221.2458.1.camel@pasglop> <1337561378.2458.3.camel@pasglop>
In-Reply-To: <1337561378.2458.3.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052018-5140-0000-0000-0000015EC4D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is to remove the pseries_notify_add_cpu() call
and replace it by a hot plug notifier.
This would prevent cpuidle resources being
released and allocated each time cpu comes online on pseries.
The earlier design was causing a lockdep problem
in start_secondary as reported on this thread
	-https://lkml.org/lkml/2012/5/17/2

This applies on 3.4-rc7

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/processor.h            |    2 --
 arch/powerpc/platforms/pseries/processor_idle.c |   25 +++++++++++++++++------
 arch/powerpc/platforms/pseries/smp.c            |    1 -
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 8e2d037..c6bc22b 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -390,10 +390,8 @@ void cpu_idle_wait(void);
 
 #ifdef CONFIG_PSERIES_IDLE
 extern void update_smt_snooze_delay(int snooze);
-extern int pseries_notify_cpuidle_add_cpu(int cpu);
 #else
 static inline void update_smt_snooze_delay(int snooze) {}
-static inline int pseries_notify_cpuidle_add_cpu(int cpu) { return 0; }
 #endif
 
 extern void flush_instruction_cache(void);
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 41a34bc..d1a7dc0 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -11,6 +11,7 @@
 #include <linux/moduleparam.h>
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
+#include <linux/notifier.h>
 
 #include <asm/paca.h>
 #include <asm/reg.h>
@@ -186,17 +187,28 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
 		.enter = &shared_cede_loop },
 };
 
-int pseries_notify_cpuidle_add_cpu(int cpu)
+static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
+			unsigned long action, void *hcpu)
 {
+	int hotcpu = (unsigned long)hcpu;
 	struct cpuidle_device *dev =
-			per_cpu_ptr(pseries_cpuidle_devices, cpu);
-	if (dev && cpuidle_get_driver()) {
-		cpuidle_disable_device(dev);
-		cpuidle_enable_device(dev);
+			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
+
+	switch (action & 0xf) {
+	case CPU_ONLINE:
+		if (dev && cpuidle_get_driver()) {
+			cpuidle_disable_device(dev);
+			cpuidle_enable_device(dev);
+		}
+		break;
 	}
-	return 0;
+	return NOTIFY_OK;
 }
 
+static struct notifier_block setup_hotplug_notifier = {
+	.notifier_call = pseries_cpuidle_add_cpu_notifier,
+};
+
 /*
  * pseries_cpuidle_driver_init()
  */
@@ -321,6 +333,7 @@ static int __init pseries_processor_idle_init(void)
 		return retval;
 	}
 
+	register_cpu_notifier(&setup_hotplug_notifier);
 	printk(KERN_DEBUG "pseries_idle_driver registered\n");
 
 	return 0;
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index e16bb8d..71706bc 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -147,7 +147,6 @@ static void __devinit smp_xics_setup_cpu(int cpu)
 	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
 	set_default_offline_state(cpu);
 #endif
-	pseries_notify_cpuidle_add_cpu(cpu);
 }
 
 static int __devinit smp_pSeries_kick_cpu(int nr)

