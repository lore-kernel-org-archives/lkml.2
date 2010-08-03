Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0HCTug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:50:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45613 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332Ab0HCTuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:50:35 -0400
Date: Tue, 3 Aug 2010 21:50:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/powerpc: Drop unnecessary of_node_put
Message-ID: <Pine.LNX.4.64.1008032149410.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

for_each_node_by_name only exits when its first argument is NULL, and a
subsequent call to of_node_put on that argument is unnecessary.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator name for_each_node_by_name;
expression np,E;
identifier l;
@@

for_each_node_by_name(np,...) {
  ... when != break;
      when != goto l;
}
... when != np = E
- of_node_put(np);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/platforms/powermac/feature.c |    1 -
 arch/powerpc/platforms/powermac/pci.c     |    2 --
 2 files changed, 3 deletions(-)

diff -u -p a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2872,7 +2872,6 @@ set_initial_features(void)
 				core99_airport_enable(np, 0, 0);
 			}
 		}
-		of_node_put(np);
 	}
 
 	/* On all machines that support sound PM, switch sound off */
diff -u -p a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -1155,13 +1155,11 @@ void __init pmac_pcibios_after_init(void
 			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, nd, 0, 0);
 		}
 	}
-	of_node_put(nd);
 	for_each_node_by_name(nd, "ethernet") {
 		if (nd->parent && of_device_is_compatible(nd, "gmac")
 		    && of_device_is_compatible(nd->parent, "uni-north"))
 			pmac_call_feature(PMAC_FTR_GMAC_ENABLE, nd, 0, 0);
 	}
-	of_node_put(nd);
 }
 
 void pmac_pci_fixup_cardbus(struct pci_dev* dev)
