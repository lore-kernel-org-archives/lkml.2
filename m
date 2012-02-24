Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2BXDuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:50:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37590 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2BXDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:50:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 10/13] x86, irq: Make ioapics loop code skip blank slot
Date: Thu, 23 Feb 2012 19:48:56 -0800
Message-Id: <1330055339-11662-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F4708C9.008B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple ioapics get added and removed, we could have blank slot in ioapics
array.

Add skip code in this case by check nr_registers.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4517713..da02320 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -819,7 +819,8 @@ int save_ioapic_entries(void)
 	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapics[apic].saved_registers) {
+		if (!ioapics[apic].saved_registers &&
+		    ioapics[apic].nr_registers) {
 			err = -ENOMEM;
 			continue;
 		}
@@ -925,9 +926,12 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int ioapic_idx;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+			if (!ioapics[ioapic_idx].nr_registers)
+				continue;
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
 				return ioapic_idx;
+		}
 	}
 
 	return -1;
@@ -1158,10 +1162,13 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+			if (!ioapics[ioapic_idx].nr_registers)
+				continue;
 			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
+		}
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
 		    !mp_irqs[i].irqtype &&
@@ -2188,6 +2195,9 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
 	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+		if (!ioapics[ioapic_idx].nr_registers)
+			continue;
+
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(ioapic_idx, 0);
@@ -3153,8 +3163,12 @@ static void ioapic_resume(void)
 {
 	int ioapic_idx;
 
-	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--) {
+		if (!ioapics[ioapic_idx].nr_registers)
+			continue;
+
 		resume_ioapic_id(ioapic_idx);
+	}
 
 	restore_ioapic_entries();
 }
@@ -4065,8 +4079,11 @@ int mp_find_ioapic(u32 gsi)
 	/* Find the IOAPIC that manages this GSI. */
 	for (i = 0; i < nr_ioapics; i++) {
 		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
-		if ((gsi >= gsi_cfg->gsi_base)
-		    && (gsi <= gsi_cfg->gsi_end))
+
+		if (!ioapics[i].nr_registers)
+			continue;
+
+		if ((gsi >= gsi_cfg->gsi_base) && (gsi <= gsi_cfg->gsi_end))
 			return i;
 	}
 
-- 
1.7.7

