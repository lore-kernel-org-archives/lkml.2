Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2DQPhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:37:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2DQPhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:37:35 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Kevin Tian <kevin.tian@intel.com>, Fengzhe Zhang <fengzhe.zhang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 2/3] Added arch_show_interrupts_cpu to display CPU specific interrupts for Proc Fs
Date: Tue, 17 Apr 2012 21:10:04 +0530
Message-Id: <1334677205-2623-2-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
References: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 arch/x86/kernel/irq.c     |   70 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/interrupt.h |    1 +
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3dafc60..cf64546 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -128,6 +128,76 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	return 0;
 }
 
+
+/*
+ * /proc/cpu/<node>/interrupts printing for CPU and arch  specific interrupts
+ * XXX: Could not figure out a way to re-use arch_show_interrupts
+ */
+int arch_show_interrupts_cpu (struct seq_file *p, int prec, int cpu)
+{
+	int j = cpu;
+
+	seq_printf(p, "%*s: ", prec, "NMI");
+	seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
+	seq_printf(p, "  Non-maskable interrupts\n");
+#ifdef CONFIG_X86_LOCAL_APIC
+	seq_printf(p, "%*s: ", prec, "LOC");
+	seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
+	seq_printf(p, "  Local timer interrupts\n");
+
+	seq_printf(p, "%*s: ", prec, "SPU");
+	seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
+	seq_printf(p, "  Spurious interrupts\n");
+	seq_printf(p, "%*s: ", prec, "PMI");
+	seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
+	seq_printf(p, "  Performance monitoring interrupts\n");
+	seq_printf(p, "%*s: ", prec, "IWI");
+	seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
+	seq_printf(p, "  IRQ work interrupts\n");
+	seq_printf(p, "%*s: ", prec, "RTR");
+	seq_printf(p, "%10u ", irq_stats(j)->icr_read_retry_count);
+	seq_printf(p, "  APIC ICR read retries\n");
+#endif
+	if (x86_platform_ipi_callback) {
+		seq_printf(p, "%*s: ", prec, "PLT");
+		seq_printf(p, "%10u ", irq_stats(j)->x86_platform_ipis);
+		seq_printf(p, "  Platform interrupts\n");
+	}
+#ifdef CONFIG_SMP
+	seq_printf(p, "%*s: ", prec, "RES");
+	seq_printf(p, "%10u ", irq_stats(j)->irq_resched_count);
+	seq_printf(p, "  Rescheduling interrupts\n");
+	seq_printf(p, "%*s: ", prec, "CAL");
+	seq_printf(p, "%10u ", irq_stats(j)->irq_call_count);
+	seq_printf(p, "  Function call interrupts\n");
+	seq_printf(p, "%*s: ", prec, "TLB");
+	seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
+	seq_printf(p, "  TLB shootdowns\n");
+#endif
+#ifdef CONFIG_X86_THERMAL_VECTOR
+	seq_printf(p, "%*s: ", prec, "TRM");
+	seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
+	seq_printf(p, "  Thermal event interrupts\n");
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	seq_printf(p, "%*s: ", prec, "THR");
+	seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
+	seq_printf(p, "  Threshold APIC interrupts\n");
+#endif
+#ifdef CONFIG_X86_MCE
+	seq_printf(p, "%*s: ", prec, "MCE");
+	seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
+	seq_printf(p, "  Machine check exceptions\n");
+	seq_printf(p, "%*s: ", prec, "MCP");
+	seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
+	seq_printf(p, "  Machine check polls\n");
+#endif
+	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
+#if defined(CONFIG_X86_IO_APIC)
+	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
+#endif
+	return 0;
+}
 /*
  * /proc/stat helpers
  */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2aea5d2..27e15cc 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -695,6 +695,7 @@ static inline void init_irq_proc(void)
 struct seq_file;
 int show_interrupts(struct seq_file *p, void *v);
 int arch_show_interrupts(struct seq_file *p, int prec);
+int arch_show_interrupts_cpu(struct seq_file *p, int prec, int cpu);
 
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
-- 
1.7.3.4

