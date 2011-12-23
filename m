Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab1LWULl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:11:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab1LWULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:11:40 -0500
Date: Fri, 23 Dec 2011 12:11:28 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-a35fd28256e7736cc84af8931a16224f0bfaaf6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20111222014632.540896503@sbsiddha-desk.sc.intel.com>
References: <20111222014632.540896503@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, acpi:
  Skip acpi x2apic entries if the x2apic feature is not present
Git-Commit-ID: a35fd28256e7736cc84af8931a16224f0bfaaf6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 12:11:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a35fd28256e7736cc84af8931a16224f0bfaaf6c
Gitweb:     http://git.kernel.org/tip/a35fd28256e7736cc84af8931a16224f0bfaaf6c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 21 Dec 2011 17:45:16 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 23 Dec 2011 11:00:50 -0800

x86, acpi: Skip acpi x2apic entries if the x2apic feature is not present

If the x2apic feature is not present (either the cpu is not capable of it
or the user has disabled the feature using boot-parameter etc), ignore the
x2apic MADT and SRAT entries provided by the ACPI tables.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20111222014632.540896503@sbsiddha-desk.sc.intel.com
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   10 ++++++++--
 arch/x86/mm/srat.c          |    7 ++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4558f0d..ce664f3 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -219,6 +219,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -227,6 +229,8 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
-			    processor->lapic_flags & ACPI_MADT_ENABLED);
+	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
+		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+	else
+		acpi_register_lapic(apic_id, enabled);
 #else
 	printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 #endif
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 81dbfde..fd61b3f 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
+	apic_id = pa->apic_id;
+	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
+		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+			 pxm, apic_id);
+		return;
+	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -76,7 +82,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
