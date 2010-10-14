Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0JNXSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:18:44 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:34064 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab0JNXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:18:41 -0400
Subject: [PATCH v4 3/6] PCI: allocate bus resources from the top down
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 14 Oct 2010 17:18:37 -0600
Message-ID: <20101014231837.536.62189.stgit@bob.kio>
In-Reply-To: <20101014231804.536.62138.stgit@bob.kio>
References: <20101014231804.536.62138.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocate space from the highest-address PCI bus resource first, then work
downward.

Previously, we looked for space in PCI host bridge windows in the order
we discovered the windows.  For example, given the following windows
(discovered via an ACPI _CRS method):

    pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
    pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
    pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
    pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xf7ffffff]
    pci_root PNP0A03:00: host bridge window [mem 0xff980000-0xff980fff]
    pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
    pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]

we attempted to allocate from [mem 0x000a0000-0x000bffff] first, then
[mem 0x000c0000-0x000effff], and so on.

With this patch, we allocate from [mem 0xff980000-0xff980fff] first, then
[mem 0xff97c000-0xff97ffff], [mem 0xfed20000-0xfed9ffff], etc.

Allocating top-down follows Windows practice, so we're less likely to
trip over BIOS defects in the _CRS description.

On the machine above (a Dell T3500), the [mem 0xbff00000-0xbfffffff] region
doesn't actually work and is likely a BIOS defect.  The symptom is that we
move the AHCI controller to 0xbff00000, which leads to "Boot has failed,
sleeping forever," a BUG in ahci_stop_engine(), or some other boot failure.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c43
Reference: https://bugzilla.redhat.com/show_bug.cgi?id=620313
Reference: https://bugzilla.redhat.com/show_bug.cgi?id=629933
Reported-by: Brian Bloniarz <phunge0@hotmail.com>
Reported-and-tested-by: Stefan Becker <chemobejk@gmail.com>
Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/bus.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 48 insertions(+), 5 deletions(-)


diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 7f0af0e..172bf26 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -64,6 +64,49 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 	}
 }
 
+/*
+ * Find the highest-address bus resource below the cursor "res".  If the
+ * cursor is NULL, return the highest resource.
+ */
+static struct resource *pci_bus_find_resource_prev(struct pci_bus *bus,
+						   unsigned int type,
+						   struct resource *res)
+{
+	struct resource *r, *prev = NULL;
+	int i;
+
+	pci_bus_for_each_resource(bus, r, i) {
+		if (!r)
+			continue;
+
+		if ((r->flags & IORESOURCE_TYPE_BITS) != type)
+			continue;
+
+		/* If this resource is at or past the cursor, skip it */
+		if (res) {
+			if (r == res)
+				continue;
+			if (r->end > res->end)
+				continue;
+			if (r->end == res->end && r->start > res->start)
+				continue;
+		}
+
+		if (!prev)
+			prev = r;
+
+		/*
+		 * A small resource is higher than a large one that ends at
+		 * the same address.
+		 */
+		if (r->end > prev->end ||
+		    (r->end == prev->end && r->start > prev->start))
+			prev = r;
+	}
+
+	return prev;
+}
+
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
  * @bus: PCI bus
@@ -89,9 +132,10 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 					  resource_size_t),
 		void *alignf_data)
 {
-	int i, ret = -ENOMEM;
+	int ret = -ENOMEM;
 	struct resource *r;
 	resource_size_t max = -1;
+	unsigned int type = res->flags & IORESOURCE_TYPE_BITS;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
@@ -99,10 +143,9 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 	if (!(res->flags & IORESOURCE_MEM_64))
 		max = PCIBIOS_MAX_MEM_32;
 
-	pci_bus_for_each_resource(bus, r, i) {
-		if (!r)
-			continue;
-
+	/* Look for space at highest addresses first */
+	r = pci_bus_find_resource_prev(bus, type, NULL);
+	for ( ; r; r = pci_bus_find_resource_prev(bus, type, r)) {
 		/* type_mask must match */
 		if ((res->flags ^ r->flags) & type_mask)
 			continue;

