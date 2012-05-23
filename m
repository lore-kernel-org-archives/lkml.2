Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2EWCbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:31:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:64989 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2EWCbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170087299"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@amd64.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop CMC storm
Date: Wed, 23 May 2012 10:32:21 +0800
Message-Id: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This idea is inspired from IA64 implementation. It is like
NAPI for network stack. When CMCI is too many to handle,
this interrupt can be disabled and then poll mode will take
over the events handle. When no more events happen in the
system, CMC interrupt can be enabled automatically.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   83 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d086a09..6334f0d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -92,6 +92,7 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 
+static DEFINE_PER_CPU(struct timer_list, mce_timer);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
@@ -100,8 +101,28 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
 
+#define CMC_POLL_INTERVAL	(1 * 30)
+#define CMC_STORM		5
+static DEFINE_PER_CPU(int, cmci_storm_warning);
+static DEFINE_PER_CPU(unsigned long, first_cmci_jiffie);
+static DEFINE_SPINLOCK(cmc_poll_lock);
+
+/*
+ * This variable tells whether we are in cmci-storm-happened mode.
+ * Start with this in the wrong state so we won't play w/ timers
+ * before the system is ready.
+ */
+static int cmci_storm_detected = 1;
+
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
+static void mce_disable_cmci(void *data);
+static void mce_enable_ce(void *all);
+static void cmc_disable_keventd(struct work_struct *dummy);
+static void cmc_enable_keventd(struct work_struct *dummy);
+
+static DECLARE_WORK(cmc_disable_work, cmc_disable_keventd);
+static DECLARE_WORK(cmc_enable_work, cmc_enable_keventd);
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -582,6 +603,37 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
 	int i;
+	unsigned long flag;
+
+	spin_lock_irqsave(&cmc_poll_lock, flag);
+	if (cmci_storm_detected == 0) {
+		unsigned long now = jiffies;
+		int *count = &__get_cpu_var(cmci_storm_warning);
+		unsigned long *history = &__get_cpu_var(first_cmci_jiffie);
+
+		if (time_before_eq(now, *history + HZ))
+			(*count)++;
+		else {
+			*count = 0;
+			*history = now;
+		}
+
+		if (*count >= CMC_STORM) {
+			cmci_storm_detected = 1;
+			/* If we're being hit with CMC interrupts, we won't
+			 * ever execute the schedule_work() below.  Need to
+			 * disable CMC interrupts on this processor now.
+			 */
+			mce_disable_cmci(NULL);
+			if (!work_pending(&cmc_disable_work))
+				schedule_work(&cmc_disable_work);
+			spin_unlock_irqrestore(&cmc_poll_lock, flag);
+			printk(KERN_WARNING "WARNING: Switching to polling "\
+				"CMC handler; error records may be lost\n");
+			goto out;
+		}
+	}
+	spin_unlock_irqrestore(&cmc_poll_lock, flag);
 
 	percpu_inc(mce_poll_count);
 
@@ -628,6 +680,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
 
+out:
 	/*
 	 * Don't clear MCG_STATUS here because it's only defined for
 	 * exceptions.
@@ -1199,6 +1252,20 @@ static void mce_process_work(struct work_struct *dummy)
 		memory_failure(pfn, MCE_VECTOR, 0);
 }
 
+static void cmc_disable_keventd(struct work_struct *dummy)
+{
+	struct timer_list *t = __this_cpu_ptr(&mce_timer);
+
+	on_each_cpu(mce_disable_cmci, NULL, 0);
+	mod_timer(t, jiffies + CMC_POLL_INTERVAL * HZ);
+}
+
+static void cmc_enable_keventd(struct work_struct *dummy)
+{
+	/* don't re-initiate timer */
+	on_each_cpu(mce_enable_ce, NULL, 0);
+}
+
 #ifdef CONFIG_X86_MCE_INTEL
 /***
  * mce_log_therm_throt_event - Logs the thermal throttling event to mcelog
@@ -1232,12 +1299,12 @@ void mce_log_therm_throt_event(__u64 status)
 static int check_interval = 5 * 60; /* 5 minutes */
 
 static DEFINE_PER_CPU(int, mce_next_interval); /* in jiffies */
-static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
 static void mce_start_timer(unsigned long data)
 {
 	struct timer_list *t = &per_cpu(mce_timer, data);
 	int *n;
+	unsigned long flags;
 
 	WARN_ON(smp_processor_id() != data);
 
@@ -1253,8 +1320,19 @@ static void mce_start_timer(unsigned long data)
 	n = &__get_cpu_var(mce_next_interval);
 	if (mce_notify_irq())
 		*n = max(*n/2, HZ/100);
-	else
+	else {
 		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
+		/* if no CMC event, switch out of polling mode */
+		spin_lock_irqsave(&cmc_poll_lock, flags);
+		if (cmci_storm_detected == 1) {
+			printk(KERN_WARNING "Returning to interrupt driven "\
+					"CMC handler\n");
+			if (!work_pending(&cmc_enable_work))
+				schedule_work(&cmc_enable_work);
+			cmci_storm_detected = 0;
+		}
+		spin_unlock_irqrestore(&cmc_poll_lock, flags);
+	}
 
 	t->expires = jiffies + *n;
 	add_timer_on(t, smp_processor_id());
@@ -1547,6 +1625,7 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
+	cmci_storm_detected = 0;
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
 }
-- 
1.7.10

