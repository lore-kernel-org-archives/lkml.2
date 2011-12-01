Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1LASST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:18:19 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14999 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab1LASSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:18:18 -0500
Message-Id: <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 12:59:19 -0500
Subject: [PATCH] lib/devres.c: allow specifying NO_IOPORT while using PCI
To: linux-kernel@vger.kernel.org, <linux-pci@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Lucas De Marchi" <lucas.demarchi@profusion.mobi>,
        "Paul Mundt" <lethal@linux-sh.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1322592494.git.mst@redhat.com> <201111301404.41544.arnd@arndb.de> <20111130143122.GC21413@redhat.com> <201111301549.57430.arnd@arndb.de>
In-Reply-To: <201111301549.57430.arnd@arndb.de>
X-OriginalArrivalTime: 01 Dec 2011 18:15:32.0315 (UTC) FILETIME=[36B08AB0:01CCB055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tile architecture does not support IOPORT, but it does support
PCI and IOMEM.  We were not specifying NO_IOPORT, though, because it
was causing a couple of functions (pcim_iomap_regions and pcim_iomap_table)
that are needed to not get provided.  Moving the #ifdef fixes this
so that those functions and some related ones are now always provided
if CONFIG_PCI is true.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
This commit was inspired by the recent linux-arch discussion about
what to do with ioport_map on architectures that can't do it, so I went
back to figure out why I hadn't set NO_IOPORT in the first place.
I'm willing to take this into the tile tree if the PCI folks are OK
with it, or if someone else can pick it up, that's fine too.

 arch/tile/Kconfig |    2 +-
 lib/devres.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 70a0de4..e7b1e07 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -333,7 +333,7 @@ config NO_IOMEM
 	def_bool !PCI
 
 config NO_IOPORT
-	def_bool !PCI
+	def_bool y
 
 source "drivers/pci/Kconfig"
 
diff --git a/lib/devres.c b/lib/devres.c
index 7c0e953..5f36cfd 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -144,6 +144,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
+#endif
 
 #ifdef CONFIG_PCI
 /*
@@ -349,4 +350,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask)
 }
 EXPORT_SYMBOL(pcim_iounmap_regions);
 #endif
-#endif
-- 
1.6.5.2

