Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1AaXK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:10:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22799 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab1AaXJR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/11] x86/setup: Consult the raw E820 for zero sized E820 RAM regions.
Date: Mon, 31 Jan 2011 17:44:32 -0500
Message-Id: <1296513876-31415-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the Xen hypervisor provides us with an E820, it can
contain zero sized RAM regions. Those are entries that have
been trimmed down due to the user utilizing the dom0_mem flag.

What it means is that there is RAM at those regions, and we
should _not_ be considering those regions as 1-1 mapping.

This dom0_mem parameter changes a nice looking E820 like this:

Xen: 0000000000000000 - 000000000009d000 (usable)
Xen: 000000000009d000 - 0000000000100000 (reserved)
Xen: 0000000000100000 - 000000009cf67000 (usable)
Xen: 000000009cf67000 - 000000009d103000 (ACPI NVS)
Xen: 000000009d103000 - 000000009f6bd000 (usable)
Xen: 000000009f6bd000 - 000000009f6bf000 (reserved)
Xen: 000000009f6bf000 - 000000009f714000 (usable)

(wherein we would happily set 9d->100, 9cf67->9d103, and
9f6bd->9f6bf to identity mapping) .. but with a dom0_mem
argument (say dom0_mem=700MB) it looks as so:

Xen: 0000000000000000 - 000000000009d000 (usable)
Xen: 000000000009d000 - 0000000000100000 (reserved)
Xen: 0000000000100000 - 000000002bc00000 (usable)
Xen: 000000009cf67000 - 000000009d103000 (ACPI NVS)
Xen: 000000009f6bd000 - 000000009f6bf000 (reserved)

We would set 9d->100, and 9cf670->9f6bf to identity
mapping. The region from 9d103->9f6bd - which is
System RAM where a guest could be allocated from,
would be considered identity which is incorrect.

[Note: this printout of the E820 is after E820
sanitization, the raw E820 would look like this]:

Xen: 0000000000000000 - 000000000009d000 (usable)
Xen: 000000000009d000 - 0000000000100000 (reserved)
Xen: 0000000000100000 - 000000002bc00000 (usable)
Xen: 000000009cf67000 - 000000009d103000 (ACPI NVS)
Xen: 000000009d103000 - 000000009d103000 (usable)  <===
Xen: 000000009f6bd000 - 000000009f6bf000 (reserved)

[Notice the "usable" zero sized region]

This patch consults the non-sanitized version of the E820
and checks if there are zero-sized RAM regions right before
the non-RAM E820 entry we are currently evaluating.
If so, we utilize the 'ram_end' value to piggyback on the
code introduced by "xen/setup: Pay attention to zero sized
E820_RAM regions" patch. Also we add a printk to help
us determine which region has been set to 1-1 mapping and
add some sanity checking.

We must keep those regions zero-size E820 RAM regions
as is (so missing), otherwise the M2P override code can
malfunction if a guest grant page is present in those regions.

Shifting the "xen_set_identity" to be called earlier (so that
we are using the non-sanitized version of the &e820) does not
work as we need to take into account the E820 after the
initial increase/decrease reservation done and addition of a
new E820 region in 'xen_add_extra_mem').

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c   |    9 +++++++--
 arch/x86/xen/setup.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index fbbd2ab..70bd49b 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -423,6 +423,9 @@ unsigned long set_phys_range_identity(unsigned long pfn_s,
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
 		return pfn_e - pfn_s;
 
+	if (pfn_s > pfn_e)
+		return 0;
+
 	for (pfn = (pfn_s & ~(P2M_MID_PER_PAGE * P2M_PER_PAGE - 1));
 		pfn < ALIGN(pfn_e, (P2M_MID_PER_PAGE * P2M_PER_PAGE));
 		pfn += P2M_MID_PER_PAGE * P2M_PER_PAGE)
@@ -444,9 +447,11 @@ unsigned long set_phys_range_identity(unsigned long pfn_s,
 		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
 			break;
 
-	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
+	if (!WARN((pfn - pfn_s) != (pfn_e - pfn_s),
 		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
-		(pfn_e - pfn_s) - (pfn - pfn_s));
+		(pfn_e - pfn_s) - (pfn - pfn_s)))
+		printk(KERN_DEBUG "1-1 mapping on %lx->%lx\n", pfn_s, pfn);
+
 
 	return pfn - pfn_s;
 }
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 5b2ae49..e7ee04c 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -143,13 +143,16 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 	return released;
 }
 
-static unsigned long __init xen_set_identity(const struct e820map *e820)
+static unsigned long __init xen_set_identity(const struct e820map *e820,
+					     const struct e820entry *list,
+					     ssize_t map_size)
 {
 	phys_addr_t last = xen_initial_domain() ? 0 : ISA_END_ADDRESS;
 	phys_addr_t start_pci = last;
 	phys_addr_t ram_end = last;
-	int i;
+	int i, j;
 	unsigned long identity = 0;
+	const struct e820entry *entry;
 
 	for (i = 0; i < e820->nr_map; i++) {
 		phys_addr_t start = e820->map[i].addr;
@@ -158,6 +161,8 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
 		if (start < last)
 			start = last;
 
+		/* Sadly, we do not get E820 entries with zero size after
+		 * sanitization. */
 		if (end <= start)
 			continue;
 
@@ -173,6 +178,37 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
 			start_pci = last = ram_end = end;
 			continue;
 		}
+		/* Consult the real non-sanitizied version of E820 to see
+		 * if there is a E820_RAM region with zero size right before
+		 * our non-RAM E820 entry. The 'zero size' are real RAM
+		 * regions which the hypervisor has truncated to zero size.
+		 * This is b/c the user supplied a dom0_mem flag to trim how
+		 * much RAM we can use.*/
+		for (j = 0, entry = list; j < map_size; j++, entry++) {
+			/* Found this non-RAM E820 region. If previous entry
+			 * is a zero sized E820 RAM region, then rethink.
+			 */
+			if (start == entry->addr) {
+				const struct e820entry *tmp = entry-1;
+				phys_addr_t ghost_ram = tmp->addr;
+
+				if ((tmp->type != E820_RAM) && (tmp->size != 0))
+					break;
+
+				if (ghost_ram > start_pci) {
+					identity += set_phys_range_identity(
+						PFN_UP(start_pci),
+						PFN_DOWN(ghost_ram));
+				}
+				/* We ought to reset it to the _end_ of the
+				 * E820 RAM region but since it is zero sized,
+				 * that would not work. Instead we reset it to
+				 * the start of non-RAM E820 region and the let
+				 * the code right below fix up the values.*/
+				ram_end = start;
+				break;
+			}
+		}
 		/* Gap found right after the 1st RAM region. Skip over it.
 		 * Why? That is b/c if we pass in dom0_mem=max:512MB and
 		 * have in reality 1GB, the E820 is clipped at 512MB.
@@ -308,9 +344,12 @@ char * __init xen_memory_setup(void)
 
 	/*
 	 * Set P2M for all non-RAM pages and E820 gaps to be identity
-	 * type PFNs.
+	 * type PFNs. We also supply it with the non-sanitized version
+	 * of the E820 - which can have zero size E820 RAM regions
+	 * that we _MUST_ consult so that we do not set 1-1 mapping
+	 * on RAM regions (which might be assigned to guests for example).
 	 */
-	identity_pages = xen_set_identity(&e820);
+	identity_pages = xen_set_identity(&e820, map, memmap.nr_entries);
 	printk(KERN_INFO "Set %ld page(s) to 1-1 mapping.\n", identity_pages);
 	return "Xen";
 }
-- 
1.7.1

