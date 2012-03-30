Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670Ab2C3Unz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:43:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47250 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2C3UmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:42:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/7] xen/setup: Transfer MFNs from non-RAM E820 entries and gaps to E820 RAM
Date: Fri, 30 Mar 2012 16:37:28 -0400
Message-Id: <1333139850-28456-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F761A9C.00B6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the Xen hypervisor boots a PV kernel it hands it two pieces
of information: nr_pages and a made up E820 entry.

The nr_pages value defines the range from zero to nr_pages of PFNs
which have a valid Machine Frame Number (MFN) underneath it. The
E820 mirrors that (with the VGA hole):
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000080800000 (usable)

The fun comes when a PV guest that is run with a system E820 - that
can either be the initial domain or a PCI PV guest, where the E820
looks like the normal thing:

BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 000000000009e000 (usable)
 Xen: 000000000009ec00 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000020000000 (usable)
 Xen: 0000000020000000 - 0000000020200000 (reserved)
 Xen: 0000000020200000 - 0000000040000000 (usable)
 Xen: 0000000040000000 - 0000000040200000 (reserved)
 Xen: 0000000040200000 - 00000000bad80000 (usable)
 Xen: 00000000bad80000 - 00000000badc9000 (ACPI NVS)
..
With that overlaying the nr_pages directly on the E820 does not
work as there are gaps and non-RAM regions that won't be used
by the memory allocator. The 'xen_release_chunk' helps with that
by punching holes in the P2M (PFN to MFN lookup tree) for those
regions and tells us that:

Freeing  20000-20200 pfn range: 512 pages freed
Freeing  40000-40200 pfn range: 512 pages freed
Freeing  bad80-badf4 pfn range: 116 pages freed
Freeing  badf6-bae7f pfn range: 137 pages freed
Freeing  bb000-100000 pfn range: 282624 pages freed
Released 283999 pages of unused memory

Those 283999 pages are subtracted from the nr_pages and are returned
to the hypervisor. The end result is that the initial domain
boots with 1GB less memory as the nr_pages has been subtraced by
the amount of pages residing within the PCI hole. It can balloon up
to that if desired using 'xl mem-set 0 8092', but the balloon driver
is not always compiled in for the initial domain.

The 'xen_exchange_chunk' solves this by transfering the
MFNs that would have been freed to the E820_RAM entries that
are past the nr_pages by using the early_set_phys_to_machine
mechanism that allows the P2M tree to allocate new leafs during
early bootup.

It does that by copying the MFNs to the E820_RAM that has not
been used and setting the old PFNs to INVALID_P2M_ENTRY.

The end result is that the kernel can now boot with the
nr_pages without having to subtract the 283999 pages.

We will now get:

-Released 283999 pages of unused memory
+Exchanged 283999 pages
.. snip..
-Memory: 6487732k/9208688k available (5817k kernel code, 1136060k absent, 1584896k reserved, 2900k data, 692k init)
+Memory: 6503888k/8072692k available (5817k kernel code, 1136060k absent, 432744k reserved, 2900k data, 692k init)

which is more in line with classic XenOLinux.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 1ba8dff..2a12143 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -120,12 +120,89 @@ static unsigned long __init xen_release_chunk(unsigned long start,
 	return len;
 }
 
+static unsigned long __init xen_exchange_chunk(unsigned long start_pfn,
+	unsigned long end_pfn, unsigned long nr_pages, unsigned long exchanged,
+	unsigned long *pages_left, const struct e820entry *list,
+	size_t map_size)
+{
+	const struct e820entry *entry;
+	unsigned int i;
+	unsigned long credits = (end_pfn - start_pfn) + *pages_left;
+	unsigned long done = 0;
+
+	for (i = 0, entry = list; i < map_size; i++, entry++) {
+		unsigned long s_pfn;
+		unsigned long e_pfn;
+		unsigned long pfn;
+		unsigned long dest_pfn;
+		long nr;
+
+		if (credits == 0)
+			break;
+
+		if (entry->type != E820_RAM)
+			continue;
+
+		e_pfn = PFN_UP(entry->addr + entry->size);
+
+		/* We only care about E820 _after_ the xen_start_info->nr_pages */
+		if (e_pfn <= nr_pages)
+			continue;
+
+		s_pfn = PFN_DOWN(entry->addr);
+		/* If the E820 falls within the nr_pages, we want to start
+		 * at the nr_pages PFN (plus whatever we already had exchanged)
+		 * If that would mean going past the E820 entry, skip it
+		 */
+		if (s_pfn <= nr_pages) {
+			nr = e_pfn - exchanged - nr_pages;
+			dest_pfn = nr_pages + exchanged;
+		} else {
+			nr = e_pfn - exchanged - s_pfn;
+			dest_pfn = s_pfn + exchanged;
+		}
+		/* If we had filled this E820_RAM entry, go to the next one. */
+		if (nr <= 0)
+			continue;
+
+		pr_debug("[%lx->%lx] (starting at %lx and have space for %ld pages) will move %ld pages from [%lx->%lx]\n",
+			 s_pfn, e_pfn, dest_pfn, nr, credits, start_pfn, end_pfn);
+
+		for (pfn = start_pfn; pfn < start_pfn + nr; pfn++) {
+			unsigned long mfn = pfn_to_mfn(pfn);
+
+			if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
+				break;
+
+			if (!early_set_phys_to_machine(dest_pfn, mfn))
+				break;
+
+			/* You would think we should do HYPERVISOR_update_va_mapping
+			 * but we don't need to as the hypervisor only sets up the
+			 * initial pagetables up to nr_pages, and we stick the MFNs
+			 * past that.
+			 */
+			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+			++dest_pfn;
+			++done;
+			if (--credits == 0)
+				break;
+		}
+	}
+	if (done)
+		printk(KERN_INFO "Transfered from %lx->%lx range %ld pages\n", start_pfn, end_pfn, done);
+	/* How many left on the next iteration */
+	*pages_left = credits;
+	return done;
+}
 static unsigned long __init xen_set_identity_and_release(
 	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
 {
 	phys_addr_t start = 0;
 	unsigned long released = 0;
 	unsigned long identity = 0;
+	unsigned long exchanged = 0;
+	unsigned long credits = 0;
 	const struct e820entry *entry;
 	int i;
 
@@ -151,17 +228,19 @@ static unsigned long __init xen_set_identity_and_release(
 				end_pfn = PFN_UP(entry->addr);
 
 			if (start_pfn < end_pfn) {
-				if (start_pfn < nr_pages)
+				exchanged += xen_exchange_chunk(start_pfn, end_pfn, nr_pages,
+						exchanged, &credits, list, map_size);
+				if (start_pfn < nr_pages) {
 					released += xen_release_chunk(
 						start_pfn, min(end_pfn, nr_pages));
-
+				}
 				identity += set_phys_range_identity(
 					start_pfn, end_pfn);
 			}
 			start = end;
 		}
 	}
-
+	printk(KERN_INFO "Exchanged %lu pages\n", exchanged);
 	printk(KERN_INFO "Released %lu pages of unused memory\n", released);
 	printk(KERN_INFO "Set %ld page(s) to 1-1 mapping\n", identity);
 
-- 
1.7.7.5

