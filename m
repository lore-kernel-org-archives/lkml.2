Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab1AXUNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:13:52 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14903 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1AXUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:13:51 -0500
Date: Mon, 24 Jan 2011 21:14:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-pci@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI: Avoid potential NULL pointer dereference in
 pci_scan_bridge
Message-ID: <alpine.LNX.2.00.1101242108220.10252@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_add_new_bus() calls pci_alloc_child_bus() which calls pci_alloc_bus() 
that allocates memory dynamically with kzalloc(). The return value of 
kzalloc() is the pointer that's eventually returned from 
pci_add_new_bus(), so since kzalloc() can fail and return NULL so can 
pci_add_new_bus(). Thus we may end up dereferencing a NULL pointer in 
drivers/pci/probe.c::pci_scan_bridge(). Seems to me we should test for 
this and bail out if it happens rather than crashing.
Also removed some trailing whitespace that bugged me while looking at 
this.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 probe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

  compile tested

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index c84900d..44cbbba 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -764,6 +764,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		if (pci_find_bus(pci_domain_nr(bus), max+1))
 			goto out;
 		child = pci_add_new_bus(bus, dev, ++max);
+		if (!child)
+			goto out;
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
 		      | ((unsigned int)(child->secondary)   <<  8)
@@ -777,7 +779,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			buses &= ~0xff000000;
 			buses |= CARDBUS_LATENCY_TIMER << 24;
 		}
-			
+
 		/*
 		 * We need to blast all three values with a single write.
 		 */


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

