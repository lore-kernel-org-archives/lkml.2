Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0LHVgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:36:20 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23975 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0LHVgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:15 -0500
Subject: [PATCH 2/5] x86: avoid BIOS area when allocating address space
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Wed, 08 Dec 2010 14:36:11 -0700
Message-ID: <20101208213611.13026.40888.stgit@bob.kio>
In-Reply-To: <20101208213606.13026.47657.stgit@bob.kio>
References: <20101208213606.13026.47657.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This implements arch_remove_reservations() so allocate_resource() can
avoid any arch-specific reserved areas.  This currently just avoids the
BIOS area (the first 1MB), but could be used for E820 reserved areas if
that turns out to be necessary.

We previously avoided this area in pcibios_align_resource().  This patch
moves the test from that PCI-specific path to a generic path, so *all*
resource allocations will avoid this area.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/resource.c |   14 ++++++++++++++
 arch/x86/pci/i386.c        |    3 ---
 3 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/resource.c


diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9e13763..1e99475 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -45,6 +45,7 @@ obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
+obj-y			+= resource.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
new file mode 100644
index 0000000..5dd6473
--- /dev/null
+++ b/arch/x86/kernel/resource.c
@@ -0,0 +1,14 @@
+#include <linux/ioport.h>
+#include <asm/e820.h>
+
+void arch_remove_reservations(struct resource *avail)
+{
+	/*
+	 * Trim out the area reserved for BIOS (low 1MB).  We could also remove
+	 * E820 "reserved" areas here.
+	 */
+	if (avail->flags & IORESOURCE_MEM) {
+		if (avail->start < BIOS_END)
+			avail->start = BIOS_END;
+	}
+}
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index c4bb261..b261011 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -77,9 +77,6 @@ pcibios_align_resource(void *data, const struct resource *res,
 		 */
 		if (!skip_isa_ioresource_align(dev))
 			start &= ~0x300;
-	} else if (res->flags & IORESOURCE_MEM) {
-		if (start < BIOS_END)
-			start = res->end;	/* fail; no space */
 	}
 	return start;
 }

