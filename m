Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0HDV71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:59:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36616 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0HDV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:59:20 -0400
Message-ID: <4C59E2A1.4060203@kernel.org>
Date: Wed, 04 Aug 2010 14:58:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH 1/2] x86, acpi: merge two register_lapic_address()
References: <201008031028.57263.tvrtko.ursulin@sophos.com>	<20100804093623.GE10499@redhat.com> <m1fwyuacjs.fsf@fess.ebiederm.org>	<201008041146.56406.tvrtko.ursulin@sophos.com> <m1eiee86jg.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C59E2A8.00B4,ss=1,fgs=0
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

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -234,6 +234,7 @@ extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
+void smp_register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -820,18 +820,6 @@ static int __init acpi_parse_fadt(struct
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
@@ -853,7 +841,7 @@ static int __init early_acpi_parse_madt_
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	smp_register_lapic_address(acpi_lapic_addr);
 
 	return count;
 }
@@ -880,7 +868,7 @@ static int __init acpi_parse_madt_lapic_
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	smp_register_lapic_address(acpi_lapic_addr);
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
 				      acpi_parse_sapic, MAX_APICS);
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1632,6 +1632,18 @@ void __init init_apic_mappings(void)
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
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -274,18 +274,6 @@ static void __init smp_dump_mptable(stru
 
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
