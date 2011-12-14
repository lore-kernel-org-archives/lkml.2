Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1LNKWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:22:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1LNKWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:22:43 -0500
Date: Wed, 14 Dec 2011 02:22:24 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgRmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=" 
	<fernando@oss.ntt.co.jp>
Message-ID: <tip-vzsp20lo2xdzh5f70g0eis2s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joern@logfs.org, suresh.b.siddha@intel.com, fernando@oss.ntt.co.jp,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joern@logfs.org, fernando@oss.ntt.co.jp, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86:
  Add per-cpu stat counter for APIC ICR read tries
Git-Commit-ID: 346b46be5f10e4d247160ea94ac34450be60ce1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Dec 2011 02:22:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  346b46be5f10e4d247160ea94ac34450be60ce1e
Gitweb:     http://git.kernel.org/tip/346b46be5f10e4d247160ea94ac34450be60ce1e
Author:     Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
AuthorDate: Tue, 13 Dec 2011 11:51:53 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Dec 2011 09:32:05 +0100

x86: Add per-cpu stat counter for APIC ICR read tries

In the IPI delivery slow path (NMI delivery) we retry the ICR
read to check for delivery completion a limited number of times.

[ The reason for the limited retries is that some of the places
  where it is used (cpu boot, kdump, etc) IPI delivery might not
  succeed (due to a firmware bug or system crash, for example)
  and in such a case it is better to give up and resume
  execution of other code. ]

This patch adds a new entry to /proc/interrupts, RTR, which
tells user space the number of times we retried the ICR read in
the IPI delivery slow path.

This should give some insight into how well the APIC
message delivery hardware is working - if the counts are way
too large then we are hitting a (very-) slow path way too
often.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Jörn Engel <joern@logfs.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/n/tip-vzsp20lo2xdzh5f70g0eis2s@git.kernel.org
[ extended the changelog ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h |    3 +++
 arch/x86/kernel/apic/apic.c |    6 ++++++
 arch/x86/kernel/irq.c       |    5 +++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1a6c09a..5fe0bd5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -410,6 +410,9 @@ extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
+
+DECLARE_PER_CPU(unsigned, icr_read_retry_count);
+
 static inline u32 apic_read(u32 reg)
 {
 	return apic->read(reg);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f98d84c..2942794 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -79,6 +79,11 @@ DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
+/*
+ * ICR read retry counter
+ */
+DEFINE_PER_CPU(unsigned, icr_read_retry_count);
+
 #ifdef CONFIG_X86_32
 
 /*
@@ -250,6 +255,7 @@ u32 native_safe_apic_wait_icr_idle(void)
 		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
 		if (!send_status)
 			break;
+		percpu_inc(icr_read_retry_count);
 		udelay(100);
 	} while (timeout++ < 1000);
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 429e0c9..4bbf162 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -74,6 +74,10 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
 	seq_printf(p, "  IRQ work interrupts\n");
+	seq_printf(p, "%*s: ", prec, "RTR");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", per_cpu(icr_read_retry_count, j));
+	seq_printf(p, "  APIC ICR read retries\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
@@ -136,6 +140,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_spurious_count;
 	sum += irq_stats(cpu)->apic_perf_irqs;
 	sum += irq_stats(cpu)->apic_irq_work_irqs;
+	sum += per_cpu(icr_read_retry_count, cpu);
 #endif
 	if (x86_platform_ipi_callback)
 		sum += irq_stats(cpu)->x86_platform_ipis;
