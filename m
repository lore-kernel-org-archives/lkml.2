Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0H0SNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:13:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:35824 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab0H0SNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,279,1280732400"; 
   d="scan'208";a="832548440"
Message-Id: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 27 Aug 2010 11:09:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Weidong Han <weidong.han@intel.com>, stable@kernel.org
Subject: [patch 1/3] x86, intr-remap: set redirection hint in the IRTE
Content-Disposition: inline; filename=set_redir_hint_for_irte.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the redirection hint in the interrupt-remapping table entry
is set to 0, which means the remapped interrupt is directed to the
processors listed in the destination. So in logical flat mode
in the presence of intr-remapping, this results in a single
interrupt multi-casted to multiple cpu's as specified by the destination
bit mask. But what we really want is to send that interrupt to one of the cpus
based on the lowest priority delivery mode.

Set the redirection hint in the IRTE to '1' to indicate that we want
the remapped interrupt to be directed to only one of the processors
listed in the destination.

This fixes the issue of same interrupt getting delivered to multiple cpu's
in the logical flat mode in the presence of interrupt-remapping. While
there is no functional issue observed with this behavior, this will
impact performance of such configurations (<=8 cpu's using logical flat
mode in the presence of interrupt-remapping)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
Cc: <stable@kernel.org> # [v2.6.32+]
---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f1efeba..90f8a75 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1392,6 +1392,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3343,6 +3344,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		if (pdev)


