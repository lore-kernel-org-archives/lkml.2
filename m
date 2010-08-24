Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0HXOje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:39:34 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59398 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0HXOjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:39:31 -0400
Date: Tue, 24 Aug 2010 16:39:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/char/agp: Eliminate memory leak
Message-ID: <Pine.LNX.4.64.1008241639130.15172@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

alloc_pci_dev allocates some memory, so that memory should be freed before
leaving the function in an error case.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = alloc_pci_dev(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/agp/parisc-agp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 1c12921..e2372b7 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -357,9 +357,10 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	fake_bridge_dev->device = PCI_DEVICE_ID_HP_PCIX_LBA;
 	bridge->dev = fake_bridge_dev;
 
-	error = agp_add_bridge(bridge);
+	return agp_add_bridge(bridge);
 
 fail:
+	kfree(fake_bridge_dev);
 	return error;
 }
 
