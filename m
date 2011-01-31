Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1AaXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab1AaXJT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/11] xen/setup: Skip over 1st gap after System RAM.
Date: Mon, 31 Jan 2011 17:44:31 -0500
Message-Id: <1296513876-31415-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel is booted with dom0_mem=max:512MB and the
machine has more than 512MB of RAM, the E820 we get is:

Xen: 0000000000100000 - 0000000020000000 (usable)
Xen: 00000000b7ee0000 - 00000000b7ee3000 (ACPI NVS)

while in actuality it is:

(XEN)  0000000000100000 - 00000000b7ee0000 (usable)
(XEN)  00000000b7ee0000 - 00000000b7ee3000 (ACPI NVS)

Based on that, we would determine that the "gap" between
0x20000 -> 0xb7ee0 is not System RAM and try to assign it to
1-1 mapping. This meant that later on when we setup the page tables
we would try to assign those regions to DOMID_IO and the
Xen hypervisor would fail such operation. This patch
guards against that and sets the "gap" to be after the first
non-RAM E820 region.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index c2a5b5f..5b2ae49 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -147,6 +147,7 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
 {
 	phys_addr_t last = xen_initial_domain() ? 0 : ISA_END_ADDRESS;
 	phys_addr_t start_pci = last;
+	phys_addr_t ram_end = last;
 	int i;
 	unsigned long identity = 0;
 
@@ -168,11 +169,26 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
 			if (start > start_pci)
 				identity += set_phys_range_identity(
 					PFN_UP(start_pci), PFN_DOWN(start));
-			start_pci = end;
 			/* Without saving 'last' we would gooble RAM too. */
-			last = end;
+			start_pci = last = ram_end = end;
 			continue;
 		}
+		/* Gap found right after the 1st RAM region. Skip over it.
+		 * Why? That is b/c if we pass in dom0_mem=max:512MB and
+		 * have in reality 1GB, the E820 is clipped at 512MB.
+		 * In xen_set_pte_init we end up calling xen_set_domain_pte
+		 * which asks Xen hypervisor to alter the ownership of the MFN
+		 * to DOMID_IO. We would try to set that on PFNs from 512MB
+		 * up to the next System RAM region (likely from 0x20000->
+		 * 0x100000). But changing the ownership on "real" RAM regions
+		 * will infuriate Xen hypervisor and we will fail (WARN).
+		 * So instead of trying to set IDENTITY mapping on the gap
+		 * between the System RAM and the first non-RAM E820 region
+		 * we start at the non-RAM E820 region.*/
+		if (ram_end && start >= ram_end) {
+			start_pci = start;
+			ram_end = 0;
+		}
 		start_pci = min(start, start_pci);
 		last = end;
 	}
-- 
1.7.1

