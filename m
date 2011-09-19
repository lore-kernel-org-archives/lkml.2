Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1ISJOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:14:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:42245 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1ISJOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,404,1312182000"; 
   d="scan'208";a="53107997"
Message-ID: <4E7707DA.6080504@linux.intel.com>
Date: Mon, 19 Sep 2011 17:14:02 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: ak@linux.intel.com, Huang Ying <ying.huang@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] add IRQ context simulation in mce-inject
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gong <gong.chen@linux.intel.com>

Current mce-inject can simulate some kinds of scenarios, such as
one CPU working in process context, and other CPUs working in NMI
context. To extend the coverage of test range, a new IRQ context
for other CPUs is added.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
  arch/x86/include/asm/mce.h              |    1 +
  arch/x86/kernel/cpu/mcheck/mce-inject.c |   34 +++++++++++++++++++++++++++---
  2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c9321f3..2490e8c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -54,6 +54,7 @@
  #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
  #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
  #define MCJ_EXCEPTION		8    /* raise as exception */
+#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
   /* Fields are zero when not available */
  struct mce {
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c 
b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 0ed633c..8f7a119 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -17,6 +17,7 @@
  #include <linux/kernel.h>
  #include <linux/string.h>
  #include <linux/fs.h>
+#include <linux/preempt.h>
  #include <linux/smp.h>
  #include <linux/notifier.h>
  #include <linux/kdebug.h>
@@ -94,6 +95,18 @@ static int mce_raise_notify(struct notifier_block *self,
  	return NOTIFY_STOP;
  }
  +static void mce_irq_ipi(void *info)
+{
+	int cpu = smp_processor_id();
+	struct mce *m = &__get_cpu_var(injectm);
+
+	if (cpumask_test_cpu(cpu, mce_inject_cpumask) &&
+		m->inject_flags & MCJ_EXCEPTION) {
+		cpumask_clear_cpu(cpu, mce_inject_cpumask);
+		raise_exception(m, NULL);
+	}
+}
+
  static struct notifier_block mce_raise_nb = {
  	.notifier_call = mce_raise_notify,
  	.priority = NMI_LOCAL_NORMAL_PRIOR,
@@ -146,9 +159,10 @@ static void raise_mce(struct mce *m)
  		return;
   #ifdef CONFIG_X86_LOCAL_APIC
-	if (m->inject_flags & MCJ_NMI_BROADCAST) {
+	if (m->inject_flags & (MCJ_IRQ_BRAODCAST | MCJ_NMI_BROADCAST)) {
  		unsigned long start;
  		int cpu;
+
  		get_online_cpus();
  		cpumask_copy(mce_inject_cpumask, cpu_online_mask);
  		cpumask_clear_cpu(get_cpu(), mce_inject_cpumask);
@@ -158,13 +172,25 @@ static void raise_mce(struct mce *m)
  			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
  				cpumask_clear_cpu(cpu, mce_inject_cpumask);
  		}
-		if (!cpumask_empty(mce_inject_cpumask))
-			apic->send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
+		if (!cpumask_empty(mce_inject_cpumask)) {
+			if (m->inject_flags & MCJ_IRQ_BRAODCAST) {
+				/*
+				 * don't wait because mce_irq_ipi is necessary
+				 * to be sync with following raise_local
+				 */
+				preempt_disable();
+				smp_call_function_many(mce_inject_cpumask,
+					mce_irq_ipi, NULL, 0);
+				preempt_enable();
+			} else if (m->inject_flags & MCJ_NMI_BROADCAST)
+				apic->send_IPI_mask(mce_inject_cpumask,
+						NMI_VECTOR);
+		}
  		start = jiffies;
  		while (!cpumask_empty(mce_inject_cpumask)) {
  			if (!time_before(jiffies, start + 2*HZ)) {
  				printk(KERN_ERR
-				"Timeout waiting for mce inject NMI %lx\n",
+				"Timeout waiting for mce inject %lx\n",
  					*cpumask_bits(mce_inject_cpumask));
  				break;
  			}
-- 
1.7.1


