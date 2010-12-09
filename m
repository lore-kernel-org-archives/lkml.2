Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab0LIUzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:55:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:51966 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab0LIUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:55:04 -0500
Date: Thu, 9 Dec 2010 20:54:47 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, ebiederm@xmission.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <4CFDF675.4060305@kernel.org>
References: <4CFDF675.4060305@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86, apic: Unify identical register_lapic_address() functions
Message-ID: <tip-c0104d38a740b25662c592c71f6907676510289c@git.kernel.org>
Git-Commit-ID: c0104d38a740b25662c592c71f6907676510289c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:54:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0104d38a740b25662c592c71f6907676510289c
Gitweb:     http://git.kernel.org/tip/c0104d38a740b25662c592c71f6907676510289c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 7 Dec 2010 00:55:17 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:04 +0100

x86, apic: Unify identical register_lapic_address() functions

They are the same, move the common function to apic.c to allow
further cleanups.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4CFDF675.4060305@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/acpi/boot.c |   16 ++--------------
 arch/x86/kernel/apic/apic.c |   12 ++++++++++++
 arch/x86/kernel/mpparse.c   |   14 +-------------
 4 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index cf12007..1cc42cf 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -234,6 +234,7 @@ extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
+void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 71232b9..b3cf01a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -847,18 +847,6 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
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
@@ -880,7 +868,7 @@ static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	register_lapic_address(acpi_lapic_addr);
 
 	return count;
 }
@@ -907,7 +895,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
 		return count;
 	}
 
-	acpi_register_lapic_address(acpi_lapic_addr);
+	register_lapic_address(acpi_lapic_addr);
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
 				      acpi_parse_sapic, MAX_APICS);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c48a645..c02bf13 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1702,6 +1702,18 @@ void __init init_apic_mappings(void)
 	}
 }
 
+void __init register_lapic_address(unsigned long address)
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
index 9af64d9..db0b703 100644
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
@@ -310,7 +298,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 
 	/* Initialize the lapic mapping */
 	if (!acpi_lapic)
-		smp_register_lapic_address(mpc->lapic);
+		register_lapic_address(mpc->lapic);
 
 	if (mpc->oemptr)
 		x86_init.mpparse.smp_read_mpc_oem(mpc);
