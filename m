Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0LPRjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:39:24 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:8227 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab0LPRi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:38:58 -0500
Subject: [PATCH 8/9] x86: avoid E820 regions when allocating address space
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Thu, 16 Dec 2010 10:38:56 -0700
Message-ID: <20101216173856.8185.98094.stgit@bob.kio>
In-Reply-To: <20101216173614.8185.19462.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we allocate address space, e.g., to assign it to a PCI device, don't
allocate anything mentioned in the BIOS E820 memory map.

On recent machines (2008 and newer), we assign PCI resources from the
windows described by the ACPI PCI host bridge _CRS.  On many Dell
machines, these windows overlap some E820 reserved areas, e.g.,

    BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
    pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]

If we put devices at 0xbff00000, they don't work, probably because
that's really RAM, not I/O memory.  This patch prevents that by removing
the 0xbfe4dc00-0xbfffffff area from the "available" resource.

I'm not very happy with this solution because Windows solves the problem
differently (it seems to ignore E820 reserved areas and it allocates
top-down instead of bottom-up; details at comment 45 of the bugzilla
below).  That means we're vulnerable to BIOS defects that Windows would not
trip over.  For example, if BIOS described a device in ACPI but didn't
mention it in E820, Windows would work fine but Linux would fail.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/kernel/resource.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
index 407a900..89638af 100644
--- a/arch/x86/kernel/resource.c
+++ b/arch/x86/kernel/resource.c
@@ -1,11 +1,47 @@
 #include <linux/ioport.h>
 #include <asm/e820.h>
 
+static void resource_clip(struct resource *res, resource_size_t start,
+			  resource_size_t end)
+{
+	resource_size_t low = 0, high = 0;
+
+	if (res->end < start || res->start > end)
+		return;		/* no conflict */
+
+	if (res->start < start)
+		low = start - res->start;
+
+	if (res->end > end)
+		high = res->end - end;
+
+	/* Keep the area above or below the conflict, whichever is larger */
+	if (low > high)
+		res->end = start - 1;
+	else
+		res->start = end + 1;
+}
+
+static void remove_e820_regions(struct resource *avail)
+{
+	int i;
+	struct e820entry *entry;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		entry = &e820.map[i];
+
+		resource_clip(avail, entry->addr,
+			      entry->addr + entry->size - 1);
+	}
+}
+
 void arch_remove_reservations(struct resource *avail)
 {
-	/* Trim out BIOS area (low 1MB) */
+	/* Trim out BIOS area (low 1MB) and E820 regions */
 	if (avail->flags & IORESOURCE_MEM) {
 		if (avail->start < BIOS_END)
 			avail->start = BIOS_END;
+
+		remove_e820_regions(avail);
 	}
 }

