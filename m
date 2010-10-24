Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab0JXBEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:04:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48137 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab0JXBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:04:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/15] x86, apic: Merge two register_lapic_address()
Date: Sat, 23 Oct 2010 18:02:17 -0700
Message-Id: <1287882149-29275-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the same, move it to apic.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/acpi/boot.c |   16 ++--------------
 arch/x86/kernel/apic/apic.c |   12 ++++++++++++
 arch/x86/kernel/mpparse.c   |   12 ------------
 4 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ad50aaa..dcc5f48 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -234,6 +234,7 @@ extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
+void smp_register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c05872a..f9f1bc5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -820,18 +820,6 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
  * returns 0 on success, < 0 on error
  */
 
-static void __init acpi_register_lapic_address(unsigned long address)
-{
-	mp_lapic_addr = address;
-
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U) {
-		boot_cpu_physical_apicid  = read_apic_id();
-		apic_version[boot_cpu_physical_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
-	}
-}
-
 static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 {
 	int count;
@@ -853,7 +841,7 @@ static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	smp_register_lapic_address(acpi_lapic_addr);
 
 	return count;
 }
@@ -880,7 +868,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	smp_register_lapic_address(acpi_lapic_addr);
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
 				      acpi_parse_sapic, MAX_APICS);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 193e407..4827c17 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1703,6 +1703,18 @@ void __init init_apic_mappings(void)
 	}
 }
 
+void __init smp_register_lapic_address(unsigned long address)
+{
+	mp_lapic_addr = address;
+
+	set_fixmap_nocache(FIX_APIC_BASE, address);
+	if (boot_cpu_physical_apicid == -1U) {
+		boot_cpu_physical_apicid  = read_apic_id();
+		apic_version[boot_cpu_physical_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
+	}
+}
+
 /*
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9af64d9..1fefb7f 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -275,18 +275,6 @@ static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
 
 void __init default_smp_read_mpc_oem(struct mpc_table *mpc) { }
 
-static void __init smp_register_lapic_address(unsigned long address)
-{
-	mp_lapic_addr = address;
-
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U) {
-		boot_cpu_physical_apicid  = read_apic_id();
-		apic_version[boot_cpu_physical_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
-	}
-}
-
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
-- 
1.7.1

