Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1ACPDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:03:10 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34037 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab1ACPDI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 3 Jan 2011 10:03:08 -0500
Message-Id: <4D21F338020000780002A112@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 03 Jan 2011 15:03:04 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix section mismatch in LAPIC initialization
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing things conditionally upon spm_processor_id() being zero is
generally a bad idea, as this means CPU 0 cannot be offlined and
brought back online later again. While there may be other places where
this is done, I think adding more of those should be avoided so that
some day SMP really becomes "symmetrical".

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/apic/apic.c |    9 +++++++--
 arch/x86/kernel/smpboot.c   |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- 2.6.37-rc8/arch/x86/include/asm/apic.h
+++ 2.6.37-rc8-x86-end-lapic-setup/arch/x86/include/asm/apic.h
@@ -233,6 +233,7 @@ extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
+extern void bsp_end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
--- 2.6.37-rc8/arch/x86/kernel/apic/apic.c
+++ 2.6.37-rc8-x86-end-lapic-setup/arch/x86/kernel/apic/apic.c
@@ -1389,12 +1389,17 @@ void __cpuinit end_local_APIC_setup(void
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
+}
+
+void __init bsp_end_local_APIC_setup(void)
+{
+	end_local_APIC_setup();
 
 	/*
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (!smp_processor_id() && intr_remapping_enabled)
+	if (intr_remapping_enabled)
 		enable_drhd_fault_handling();
 
 }
@@ -1751,7 +1756,7 @@ int __init APIC_init_uniprocessor(void)
 		enable_IO_APIC();
 #endif
 
-	end_local_APIC_setup();
+	bsp_end_local_APIC_setup();
 
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
--- 2.6.37-rc8/arch/x86/kernel/smpboot.c
+++ 2.6.37-rc8-x86-end-lapic-setup/arch/x86/kernel/smpboot.c
@@ -1065,7 +1065,7 @@ static int __init smp_sanity_check(unsig
 
 		connect_bsp_APIC();
 		setup_local_APIC();
-		end_local_APIC_setup();
+		bsp_end_local_APIC_setup();
 		return -1;
 	}
 
@@ -1142,7 +1142,7 @@ void __init native_smp_prepare_cpus(unsi
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
 
-	end_local_APIC_setup();
+	bsp_end_local_APIC_setup();
 
 	map_cpu_to_logical_apicid();
 



