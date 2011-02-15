Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1BOBni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:43:38 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50278 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1BOBnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:43:35 -0500
From: Ram Pai <linuxram@us.ibm.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 1/4] PCI: refactor io size calculation code
Date: Mon, 14 Feb 2011 17:43:17 -0800
Message-Id: <1297734200-23327-2-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
References: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refactor  code  that  calculates  the  io  size in pbus_size_io()
and pbus_mem_io() into separate functions.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/pci/setup-bus.c |   66 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 66cb8f4..2121215 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -404,6 +404,43 @@ static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned lon
 	return NULL;
 }
 
+static resource_size_t calculate_iosize(resource_size_t size,
+		resource_size_t min_size,
+		resource_size_t size1,
+		resource_size_t old_size,
+		resource_size_t align)
+{
+	if (size < min_size)
+		size = min_size;
+	if (old_size == 1 )
+		old_size = 0;
+	/* To be fixed in 2.5: we should have sort of HAVE_ISA
+	   flag in the struct pci_bus. */
+#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
+	size = (size & 0xff) + ((size & ~0xffUL) << 2);
+#endif
+	size = ALIGN(size + size1, align);
+	if (size < old_size)
+		size = old_size;
+	return size;
+}
+
+static resource_size_t calculate_memsize(resource_size_t size,
+		resource_size_t min_size,
+		resource_size_t size1,
+		resource_size_t old_size,
+		resource_size_t align)
+{
+	if (size < min_size)
+		size = min_size;
+	if (old_size == 1 )
+		old_size = 0;
+	if (size < old_size)
+		size = old_size;
+	size = ALIGN(size + size1, align);
+	return size;
+}
+
 /* Sizing the IO windows of the PCI-PCI bridge is trivial,
    since these windows have 4K granularity and the IO ranges
    of non-bridge PCI devices are limited to 256 bytes.
@@ -412,7 +449,7 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
-	unsigned long size = 0, size1 = 0, old_size;
+	unsigned long size = 0, size1 = 0;
 
 	if (!b_res)
  		return;
@@ -435,19 +472,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
 				size1 += r_size;
 		}
 	}
-	if (size < min_size)
-		size = min_size;
-	old_size = resource_size(b_res);
-	if (old_size == 1)
-		old_size = 0;
-/* To be fixed in 2.5: we should have sort of HAVE_ISA
-   flag in the struct pci_bus. */
-#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
-	size = (size & 0xff) + ((size & ~0xffUL) << 2);
-#endif
-	size = ALIGN(size + size1, 4096);
-	if (size < old_size)
-		size = old_size;
+	size = calculate_iosize(size, min_size, size1,
+			resource_size(b_res), 4096);
 	if (!size) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
@@ -468,7 +494,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			 unsigned long type, resource_size_t min_size)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, align, size, old_size;
+	resource_size_t min_align, align, size;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
@@ -516,14 +542,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
 		}
 	}
-	if (size < min_size)
-		size = min_size;
-	old_size = resource_size(b_res);
-	if (old_size == 1)
-		old_size = 0;
-	if (size < old_size)
-		size = old_size;
-
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
@@ -537,7 +555,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			min_align = align1 >> 1;
 		align += aligns[order];
 	}
-	size = ALIGN(size, min_align);
+	size = calculate_memsize(size, min_size, 0, resource_size(b_res), align);
 	if (!size) {
 		if (b_res->start || b_res->end)
 			dev_info(&bus->self->dev, "disabling bridge window "
-- 
1.6.5.2

