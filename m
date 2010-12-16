Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0LPRi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:38:29 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:14083 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0LPRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:38:24 -0500
Subject: [PATCH 1/9] Revert "PCI: fix pci_bus_alloc_resource() hang,
	prefer positive decode"
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Thu, 16 Dec 2010 10:38:20 -0700
Message-ID: <20101216173820.8185.8804.stgit@bob.kio>
In-Reply-To: <20101216173614.8185.19462.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit 82e3e767c21fef2b1b38868e20eb4e470a1e38e3.

We're going back to considering bus resources in the order we found
them (in _CRS order, when we're using _CRS), so we don't need to
define any ordering.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/bus.c |   70 ++++++++++++++++-------------------------------------
 1 files changed, 21 insertions(+), 49 deletions(-)


diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 003170e..5624db8 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -64,57 +64,17 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 	}
 }
 
-static bool pci_bus_resource_better(struct resource *res1, bool pos1,
-				    struct resource *res2, bool pos2)
-{
-	/* If exactly one is positive decode, always prefer that one */
-	if (pos1 != pos2)
-		return pos1 ? true : false;
-
-	/* Prefer the one that contains the highest address */
-	if (res1->end != res2->end)
-		return (res1->end > res2->end) ? true : false;
-
-	/* Otherwise, prefer the one with highest "center of gravity" */
-	if (res1->start != res2->start)
-		return (res1->start > res2->start) ? true : false;
-
-	/* Otherwise, choose one arbitrarily (but consistently) */
-	return (res1 > res2) ? true : false;
-}
-
-static bool pci_bus_resource_positive(struct pci_bus *bus, struct resource *res)
-{
-	struct pci_bus_resource *bus_res;
-
-	/*
-	 * This relies on the fact that pci_bus.resource[] refers to P2P or
-	 * CardBus bridge base/limit registers, which are always positively
-	 * decoded.  The pci_bus.resources list contains host bridge or
-	 * subtractively decoded resources.
-	 */
-	list_for_each_entry(bus_res, &bus->resources, list) {
-		if (bus_res->res == res)
-			return (bus_res->flags & PCI_SUBTRACTIVE_DECODE) ?
-				false : true;
-	}
-	return true;
-}
-
 /*
- * Find the next-best bus resource after the cursor "res".  If the cursor is
- * NULL, return the best resource.  "Best" means that we prefer positive
- * decode regions over subtractive decode, then those at higher addresses.
+ * Find the highest-address bus resource below the cursor "res".  If the
+ * cursor is NULL, return the highest resource.
  */
 static struct resource *pci_bus_find_resource_prev(struct pci_bus *bus,
 						   unsigned int type,
 						   struct resource *res)
 {
-	bool res_pos, r_pos, prev_pos = false;
 	struct resource *r, *prev = NULL;
 	int i;
 
-	res_pos = pci_bus_resource_positive(bus, res);
 	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
@@ -122,14 +82,26 @@ static struct resource *pci_bus_find_resource_prev(struct pci_bus *bus,
 		if ((r->flags & IORESOURCE_TYPE_BITS) != type)
 			continue;
 
-		r_pos = pci_bus_resource_positive(bus, r);
-		if (!res || pci_bus_resource_better(res, res_pos, r, r_pos)) {
-			if (!prev || pci_bus_resource_better(r, r_pos,
-							     prev, prev_pos)) {
-				prev = r;
-				prev_pos = r_pos;
-			}
+		/* If this resource is at or past the cursor, skip it */
+		if (res) {
+			if (r == res)
+				continue;
+			if (r->end > res->end)
+				continue;
+			if (r->end == res->end && r->start > res->start)
+				continue;
 		}
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
 	}
 
 	return prev;

