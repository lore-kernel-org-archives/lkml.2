Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2A0H0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:26:35 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35375 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab2A0H0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 3/7] x86, irq: Let msi-x to shown as MSI-X in /proc/interrupt
Date: Thu, 26 Jan 2012 23:25:49 -0800
Message-Id: <1327649153-16477-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
References: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F225194.000E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new added irq_print_chip() to append -X after MSI for msi-x.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f5c77ff..52618ad 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2628,7 +2628,10 @@ static void ir_ack_apic_level(struct irq_data *data)
 
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 {
-	seq_printf(p, " IR-%s", data->chip->name);
+	seq_printf(p, " IR-%s%s", data->chip->name,
+			data->msi_desc ?
+			 (data->msi_desc->msi_attrib.is_msix ? "-X" : "")
+			 : "");
 }
 
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
@@ -3214,6 +3217,14 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 }
 #endif /* CONFIG_SMP */
 
+static void msi_irq_print_chip(struct irq_data *data, struct seq_file *p)
+{
+	seq_printf(p, " %s%s", data->chip->name,
+			data->msi_desc ?
+			 (data->msi_desc->msi_attrib.is_msix ? "-X" : "")
+			 : "");
+}
+
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -3227,6 +3238,7 @@ static struct irq_chip msi_chip = {
 	.irq_set_affinity	= msi_set_affinity,
 #endif
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_print_chip		= msi_irq_print_chip,
 };
 
 /*
-- 
1.7.7

