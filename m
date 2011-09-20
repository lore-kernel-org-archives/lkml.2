Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1ITOoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1ITOoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:44:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org, Don Zickus <dzickus@redhat.com>
Subject: [V5][PATCH 6/6] x86, nmi: print out NMI stats in /proc/interrupts
Date: Tue, 20 Sep 2011 10:43:12 -0400
Message-Id: <1316529792-6560-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cheap hack to add the stats to the middle of /proc/interrupts.
It is more of a conversation starter than anything as I am not sure
the right letters and place to put this stuff.

The benefit of these stats is a better breakdown of which list the NMIs
get handled in either a normal handler, unknown, or external.  It also
list the number of unknown NMIs swallowed to help check for false
positives or not.  Another benefit is the ability to actually see which
NMI handlers are currently registered in the system.

The output of 'cat /proc/interrupts/ will look like this:

<snip>
 58:        275          0        864          0   PCI-MSI-edge      eth0
NMI:       4161       4155        158       4194   Non-maskable interrupts
SWA:          0          0          0          0   Unknown NMIs swallowed
  0:       4161       4155        158       4194   NMI  PMI, arch_bt
UNK:          0          0          0          0   NMI
EXT:          0          0          0          0   NMI
LOC:      12653      13304      13974      12926   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          6          6          5          6   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:       1839       1897       1821       1854   Rescheduling interrupts
CAL:        524       2714        392        331   Function call interrupts
TLB:        217        146        593        576   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          0
MIS:          0

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    2 +
 arch/x86/kernel/irq.c      |    2 +
 arch/x86/kernel/nmi.c      |   47 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index fc74547..a4f1945 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -24,6 +24,8 @@ void arch_trigger_all_cpu_backtrace(void);
 
 #define NMI_FLAG_FIRST	1
 
+void arch_show_nmi(struct seq_file *p, int prec);
+
 enum {
 	NMI_LOCAL=0,
 	NMI_UNKNOWN,
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..44d1cac 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -16,6 +16,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/nmi.h>
 
 atomic_t irq_err_count;
 
@@ -55,6 +56,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
 	seq_printf(p, "  Non-maskable interrupts\n");
+	arch_show_nmi(p, prec);
 #ifdef CONFIG_X86_LOCAL_APIC
 	seq_printf(p, "%*s: ", prec, "LOC");
 	for_each_online_cpu(j)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index bb8242e..5619ae9 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -424,3 +424,50 @@ void restart_nmi(void)
 {
 	ignore_nmis--;
 }
+
+void arch_show_nmi(struct seq_file *p, int prec)
+{
+	int j;
+	struct nmiaction *action;
+
+	seq_printf(p, "%*s: ", prec, "SWA");
+        for_each_online_cpu(j)
+                seq_printf(p, "%10u ", per_cpu(nmi_stats.swallow, j));
+        seq_printf(p, "  Unknown NMIs swallowed\n");
+
+	seq_printf(p, "%*s: ", prec, "  0");
+        for_each_online_cpu(j)
+                seq_printf(p, "%10u ", per_cpu(nmi_stats.normal, j));
+        seq_printf(p, "  NMI");
+	action = (nmi_to_desc(NMI_LOCAL))->head;
+	if (action) {
+		seq_printf(p, "\t%s", action->name);
+		while ((action = action->next) != NULL)
+			seq_printf(p, ", %s", action->name);
+	}
+	seq_putc(p, '\n');
+
+	seq_printf(p, "%*s: ", prec, "UNK");
+        for_each_online_cpu(j)
+                seq_printf(p, "%10u ", per_cpu(nmi_stats.unknown, j));
+        seq_printf(p, "  NMI");
+	action = (nmi_to_desc(NMI_UNKNOWN))->head;
+	if (action) {
+		seq_printf(p, "\t%s", action->name);
+		while ((action = action->next) != NULL)
+			seq_printf(p, ", %s", action->name);
+	}
+	seq_putc(p, '\n');
+
+	seq_printf(p, "%*s: ", prec, "EXT");
+        for_each_online_cpu(j)
+                seq_printf(p, "%10u ", per_cpu(nmi_stats.external, j));
+        seq_printf(p, "  NMI");
+	action = (nmi_to_desc(NMI_EXTERNAL))->head;
+	if (action) {
+		seq_printf(p, "\t%s", action->name);
+		while ((action = action->next) != NULL)
+			seq_printf(p, ", %s", action->name);
+	}
+	seq_putc(p, '\n');
+}
-- 
1.7.6

