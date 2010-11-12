Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0KLOv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:51:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0KLOvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:51:25 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] x86: Avoid calling arch_trigger_all_cpu_backtrace() at the same time
Date: Fri, 12 Nov 2010 09:50:55 -0500
Message-Id: <1289573455-3410-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

The spin_lock_debug/rcu_cpu_stall detector uses
trigger_all_cpu_backtrace() to dump cpu backtrace.
Therefore it is possible that trigger_all_cpu_backtrace()
could be called at the same time on different CPUs, which
triggers and 'unknown reason NMI' warning. The following case
illustrates the problem:

      CPU1                    CPU2                     ...   CPU N
                       trigger_all_cpu_backtrace()
                       set "backtrace_mask" to cpu mask
                               |
generate NMI interrupts  generate NMI interrupts       ...
    \                          |                               /
     \                         |                              /

The "backtrace_mask" will be cleaned by the first NMI interrupt
at nmi_watchdog_tick(), then the following NMI interrupts generated
by other cpus's arch_trigger_all_cpu_backtrace() will be taken as
unknown reason NMI interrupts.

This patch uses a test_and_set to avoid the problem, and stop the
arch_trigger_all_cpu_backtrace() from calling to avoid dumping a
double cpu backtrace info when there is already a
trigger_all_cpu_backtrace() in progress.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index f349647..d892896 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -27,9 +27,27 @@ u64 hw_nmi_get_sample_period(void)
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
+/* "in progress" flag of arch_trigger_all_cpu_backtrace */
+static unsigned long backtrace_flag;
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
+	unsigned long flags;
+
+	/*
+	 * Have to disable irq here, as the
+	 * arch_trigger_all_cpu_backtrace() could be
+	 * triggered by "spin_lock()" with irqs on.
+	 */
+	local_irq_save(flags);
+
+	if (test_and_set_bit(0, &backtrace_flag))
+		/*
+		 * If there is already a trigger_all_cpu_backtrace() in progress
+		 * (backtrace_flag == 1), don't output double cpu dump infos.
+		 */
+		goto out_restore_irq;
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
@@ -42,6 +60,12 @@ void arch_trigger_all_cpu_backtrace(void)
 			break;
 		mdelay(1);
 	}
+
+	clear_bit(0, &backtrace_flag);
+	smp_mb__after_clear_bit();
+
+out_restore_irq:
+	local_irq_restore(flags);
 }
 
 static int __kprobes
-- 
1.7.2.3

