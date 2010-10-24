Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab0JXBFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:05:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48181 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982Ab0JXBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/15] x86, apic: Remove early_init_lapic_mapping
Date: Sat, 23 Oct 2010 18:02:18 -0700
Message-Id: <1287882149-29275-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is almost the same as smp_register_lapic_addr()

Just need to make smp_read_mpc() call smp_register_lapic_addr when early==1.

also add printing out in smp_register_lapic_address()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/apic.h |    1 -
 arch/x86/kernel/apic/apic.c |   24 ++----------------------
 arch/x86/kernel/mpparse.c   |    8 ++------
 arch/x86/mm/k8topology_64.c |    1 -
 4 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index dcc5f48..69879dd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -245,7 +245,6 @@ extern int apic_force_enable(void);
  * On 32bit this is mach-xxx local
  */
 #ifdef CONFIG_X86_64
-extern void early_init_lapic_mapping(void);
 extern int apic_is_clustered_box(void);
 #else
 static inline int apic_is_clustered_box(void)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4827c17..05b8bf7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1631,28 +1631,6 @@ no_apic:
 }
 #endif
 
-#ifdef CONFIG_X86_64
-void __init early_init_lapic_mapping(void)
-{
-	/*
-	 * If no local APIC can be found then go out
-	 * : it means there is no mpatable and MADT
-	 */
-	if (!smp_found_config)
-		return;
-
-	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, mp_lapic_addr);
-
-	/*
-	 * Fetch the APIC ID of the BSP in case we have a
-	 * default configuration (or the MP table is broken).
-	 */
-	boot_cpu_physical_apicid = read_apic_id();
-}
-#endif
-
 /**
  * init_apic_mappings - initialize APIC mappings
  */
@@ -1708,6 +1686,8 @@ void __init smp_register_lapic_address(unsigned long address)
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+		    APIC_BASE, mp_lapic_addr);
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
 		apic_version[boot_cpu_physical_apicid] =
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 1fefb7f..a550315 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -289,17 +289,13 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 #ifdef CONFIG_X86_32
 	generic_mps_oem_check(mpc, oem, str);
 #endif
-	/* save the local APIC address, it might be non-default */
+	/* Initialize the lapic mapping */
 	if (!acpi_lapic)
-		mp_lapic_addr = mpc->lapic;
+		smp_register_lapic_address(mpc->lapic);
 
 	if (early)
 		return 1;
 
-	/* Initialize the lapic mapping */
-	if (!acpi_lapic)
-		smp_register_lapic_address(mpc->lapic);
-
 	if (mpc->oemptr)
 		x86_init.mpparse.smp_read_mpc_oem(mpc);
 
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 804a3b6..446bae2 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -66,7 +66,6 @@ static __init void early_get_boot_cpu_id(void)
 	if (smp_found_config)
 		early_get_smp_config();
 #endif
-	early_init_lapic_mapping();
 }
 
 int __init k8_get_nodes(struct bootnode *physnodes)
-- 
1.7.1

