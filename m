Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2BXDwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:52:23 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37320 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2BXDto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 08/13] x86, irq: Make mp_register_ioapic could handle hotadd ioapic
Date: Thu, 23 Feb 2012 19:48:54 -0800
Message-Id: <1330055339-11662-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F4708C7.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it will reserve irq block in allocated_irqs bit maps
and irq_base will be used to get right irq for ioapic/pin or gsi.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/mpspec.h  |    1 +
 arch/x86/kernel/apic/io_apic.c |   53 ++++++++++++++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 9c7d95f..aca26fa 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -96,6 +96,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 
 void __cpuinit generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hot);
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 57ffa86..2e8497c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4080,7 +4080,7 @@ static __init int bad_ioapic(int idx, unsigned long address)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+int __mp_register_ioapic(int id, u32 address, u32 gsi_base, bool hotadd)
 {
 	int idx;
 	int entries;
@@ -4088,11 +4088,19 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = mp_find_ioapic(gsi_base);
 	if (idx >= 0)
-		return;
+		return -EINVAL;
 
 	idx = nr_ioapics;
+	if (hotadd) {
+		/* find free spot */
+		for (idx = 0; idx < nr_ioapics; idx++)
+			if (!ioapics[idx].nr_registers &&
+			    ioapics[idx].mp_config.apicid == 0xff)
+				break;
+	}
+
 	if (bad_ioapic(idx, address))
-		return;
+		return -EINVAL;
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
@@ -4108,10 +4116,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	entries = io_apic_get_redir_entries(idx);
 
-	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
-	}
+	if (!entries || entries > MP_MAX_IOAPIC_PIN)
+		goto failed;
 
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
@@ -4122,15 +4128,42 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	ioapics[idx].nr_registers = entries;
 
-	if (gsi_cfg->gsi_end >= gsi_top)
-		gsi_top = gsi_cfg->gsi_end + 1;
+	if (!hotadd) {
+		/*
+		 * irqs will be reserved in arch_early_irq_init()
+		 * don't need to update gsi_top for hot add case
+		 */
+		if (gsi_cfg->gsi_end >= gsi_top)
+			gsi_top = gsi_cfg->gsi_end + 1;
+	} else {
+		int irq = reserve_ioapic_gsi_irq_base(idx);
+
+		if (irq < 0)
+			goto failed;
+
+		alloc_ioapic_saved_registers(idx);
+	}
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
 	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
 	       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
-	nr_ioapics++;
+	if (idx == nr_ioapics)
+		nr_ioapics++;
+
+	return 0;
+
+failed:
+	clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+	memset(&ioapics[idx], 0, sizeof(struct ioapic));
+	ioapics[idx].mp_config.apicid = 0xff;
+	return -EINVAL;
+}
+
+void mp_register_ioapic(int id, u32 address, u32 gsi_base)
+{
+	__mp_register_ioapic(id, address, gsi_base, false);
 }
 
 /* Enable IOAPIC early just for system timer */
-- 
1.7.7

