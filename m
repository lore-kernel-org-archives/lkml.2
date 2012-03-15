Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032121Ab2COSDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:03:38 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:49268 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032009Ab2COSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:03:34 -0400
From: Steffen Persvold <sp@numascale.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH] Use x2apic_supported() in the default_apic_id_valid() function.
Date: Thu, 15 Mar 2012 19:03:03 +0100
Message-Id: <1331834583-16070-1-git-send-email-sp@numascale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use x2apic_supported() in the default_apic_id_valid() function. If x2apic mode is disabled (via nox2apic for example), x2apic_supported() will return false.

This allows us to substitute the check in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning the x2apic cpu feature in the NumaChip apic code.

Signed-off-by: Steffen Persvold <sp@numascale.com>
Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>

---
 arch/x86/include/asm/apic.h          |    2 +-
 arch/x86/kernel/acpi/boot.c          |    2 +-
 arch/x86/kernel/apic/apic_numachip.c |    1 -
 arch/x86/mm/srat.c                   |    7 +------
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a9371c9..b6d3987 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -535,7 +535,7 @@ static inline unsigned int read_apic_id(void)
 
 static inline int default_apic_id_valid(int apicid)
 {
-	return x2apic_mode || (apicid < 255);
+	return x2apic_supported() || (apicid < 255);
 }
 
 extern void default_setup_apic_routing(void);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 406ed77..0f42c2f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -239,7 +239,7 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
+	if (!apic->apic_id_valid(apic_id) && enabled)
 		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 	else
 		acpi_register_lapic(apic_id, enabled);
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index d9ea5f3..c13fa9f 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -233,7 +233,6 @@ static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_
 {
 	if (!strncmp(oem_id, "NUMASC", 6)) {
 		numachip_system = 1;
-		setup_force_cpu_cap(X86_FEATURE_X2APIC);
 		return 1;
 	}
 
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1c1c4f4..7efd0c6 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -69,12 +69,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
-	apic_id = pa->apic_id;
-	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
-		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
-			 pxm, apic_id);
-		return;
-	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -82,6 +76,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 
+	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
-- 
1.7.4.1

