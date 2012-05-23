Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab2EWGe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:34:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32458 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2EWGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
Date: Tue, 22 May 2012 23:34:28 -0700
Message-Id: <1337754877-19759-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and will fall back to below 4g if it can not find any above 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4ce5ef2..2429f1f 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -122,13 +122,17 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 	int i, ret = -ENOMEM;
 	struct resource *r;
 	resource_size_t max = -1;
+	resource_size_t bottom = PCIBIOS_MAX_MEM_32 + 1ULL;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
 	/* don't allocate too high if the pref mem doesn't support 64bit*/
-	if (!(res->flags & IORESOURCE_MEM_64))
+	if (!(res->flags & IORESOURCE_MEM_64)) {
 		max = PCIBIOS_MAX_MEM_32;
+		bottom = 0;
+	}
 
+again:
 	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
@@ -145,12 +149,18 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
-					r->start ? : min,
+					max(bottom, r->start ? : min),
 					max, align,
 					alignf, alignf_data);
 		if (ret == 0)
-			break;
+			return 0;
 	}
+
+	if (bottom != 0) {
+		bottom = 0;
+		goto again;
+	}
+
 	return ret;
 }
 
-- 
1.7.7

