Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2DQPhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:37:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51818 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2DQPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:37:41 -0400
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
Subject: [PATCH 3/3] Modified generic show_interrupts to display per-CPU interrupts information
Date: Tue, 17 Apr 2012 21:10:05 +0530
Message-Id: <1334677205-2623-3-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
References: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/irq/proc.c |   39 ++++++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4bd4faa..bc5eaeb 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -410,6 +410,10 @@ int __weak arch_show_interrupts(struct seq_file *p, int prec)
 {
 	return 0;
 }
+int __weak arch_show_interrupts_cpu (struct seq_file *p, int prec, int cpu)
+{
+	return 0;
+}
 
 #ifndef ACTUAL_NR_IRQS
 # define ACTUAL_NR_IRQS nr_irqs
@@ -423,12 +427,20 @@ int show_interrupts(struct seq_file *p, void *v)
 	int i = *(loff_t *) v, j;
 	struct irqaction *action;
 	struct irq_desc *desc;
-
+        int cpu = -1;
+	
 	if (i > ACTUAL_NR_IRQS)
 		return 0;
 
-	if (i == ACTUAL_NR_IRQS)
-		return arch_show_interrupts(p, prec);
+	if (p->private)
+		cpu += (int) p->private;
+
+	if (i == ACTUAL_NR_IRQS) {
+		if (cpu < 0)
+			return arch_show_interrupts (p, prec);
+		else
+			return arch_show_interrupts_cpu (p, prec, cpu);
+	}
 
 	/* print header and calculate the width of the first column */
 	if (i == 0) {
@@ -436,8 +448,11 @@ int show_interrupts(struct seq_file *p, void *v)
 			j *= 10;
 
 		seq_printf(p, "%*s", prec + 8, "");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%-8d", j);
+		if (cpu < 0) {
+			for_each_online_cpu(j)
+				seq_printf(p, "CPU%-8d", j);
+		} else
+			seq_printf(p, "CPU%-8d", cpu);
 		seq_putc(p, '\n');
 	}
 
@@ -446,15 +461,21 @@ int show_interrupts(struct seq_file *p, void *v)
 		return 0;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	for_each_online_cpu(j)
-		any_count |= kstat_irqs_cpu(i, j);
+	if (cpu < 0) {
+		for_each_online_cpu(j)
+			any_count |= kstat_irqs_cpu(i, j);
+	} else
+		any_count |= kstat_irqs_cpu(i, cpu);
 	action = desc->action;
 	if (!action && !any_count)
 		goto out;
 
 	seq_printf(p, "%*d: ", prec, i);
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+	if (cpu < 0) {
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+	} else
+		seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 
 	if (desc->irq_data.chip) {
 		if (desc->irq_data.chip->irq_print_chip)
-- 
1.7.3.4

