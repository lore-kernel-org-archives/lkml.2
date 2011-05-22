Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1EVKoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:44:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1EVKoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:44:08 -0400
Date: Sun, 22 May 2011 10:43:52 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-69c252ffce77f4e38347d536ee4eab4aa162dc67@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110521005526.252703851@sbsiddha-MOBL3.sc.intel.com>
References: <20110521005526.252703851@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Clean up bigsmp apic selection code
Git-Commit-ID: 69c252ffce77f4e38347d536ee4eab4aa162dc67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 22 May 2011 10:43:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69c252ffce77f4e38347d536ee4eab4aa162dc67
Gitweb:     http://git.kernel.org/tip/69c252ffce77f4e38347d536ee4eab4aa162dc67
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 20 May 2011 17:51:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 May 2011 11:48:03 +0200

x86, apic: Clean up bigsmp apic selection code

Make generic_bigsmp_probe() return struct apic *. This will
avoid exporting apic_bigsmp, which will be consistent with
others.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: steiner@sgi.com
Cc: gorcunov@openvz.org
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110521005526.252703851@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h      |    2 +-
 arch/x86/kernel/apic/bigsmp_32.c |    8 ++++++
 arch/x86/kernel/apic/probe_32.c  |   52 ++++++++++++++++---------------------
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 80b243c..f37703d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -500,7 +500,7 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-extern void generic_bigsmp_probe(void);
+extern struct apic *generic_bigsmp_probe(void);
 
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index cfb13c3..479a06c 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -255,4 +255,12 @@ struct apic apic_bigsmp = {
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
 
+struct apic * __init generic_bigsmp_probe(void)
+{
+	if (probe_bigsmp())
+		return &apic_bigsmp;
+
+	return NULL;
+}
+
 apic_driver(apic_bigsmp);
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 8796e1d..c81756d 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -52,31 +52,6 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-void __init default_setup_apic_routing(void)
-{
-	int version = apic_version[boot_cpu_physical_apicid];
-
-	if (num_possible_cpus() > 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-
-#ifdef CONFIG_X86_BIGSMP
-	generic_bigsmp_probe();
-#endif
-
-	if (apic->setup_apic_routing)
-		apic->setup_apic_routing();
-}
-
 static int default_x86_32_early_logical_apicid(int cpu)
 {
 	return 1 << cpu;
@@ -224,24 +199,43 @@ static int __init parse_apic(char *arg)
 }
 early_param("apic", parse_apic);
 
-void __init generic_bigsmp_probe(void)
+void __init default_setup_apic_routing(void)
 {
+	int version = apic_version[boot_cpu_physical_apicid];
+
+	if (num_possible_cpus() > 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+
 #ifdef CONFIG_X86_BIGSMP
 	/*
-	 * This routine is used to switch to bigsmp mode when
+	 * This is used to switch to bigsmp mode when
 	 * - There is no apic= option specified by the user
 	 * - generic_apic_probe() has chosen apic_default as the sub_arch
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
 	if (!cmdline_apic && apic == &apic_default) {
-		if (apic_bigsmp.probe()) {
-			apic = &apic_bigsmp;
+		struct apic *bigsmp = generic_bigsmp_probe();
+		if (bigsmp) {
+			apic = bigsmp;
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
 			       apic->name);
 		}
 	}
 #endif
+
+	if (apic->setup_apic_routing)
+		apic->setup_apic_routing();
 }
 
 void __init generic_apic_probe(void)
