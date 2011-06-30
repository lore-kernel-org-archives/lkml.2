Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1F3Xs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:48:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52280 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1F3XsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:48:23 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, socketcan@hartkopp.net,
        bhelgaas@google.com, linux@dominikbrodowski.net,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 3/5 v2] PCI: make SRIOV resources optional
Date: Thu, 30 Jun 2011 16:47:40 -0700
Message-Id: <1309477662-18680-4-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

From: Yinghai Lu <yinghai@kernel.org>

Allocate resources to SRIOV BARs only after all other required
resource-requests are satisfied. Dont retry if resource allocation for SRIOV
BARs fail.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 9f2f15f..a0555cb 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -669,6 +669,16 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			if (r->parent || (r->flags & mask) != type)
 				continue;
 			r_size = resource_size(r);
+#ifdef CONFIG_PCI_IOV
+			/* put SRIOV requested res to the optional list */
+			if (add_head && i >= PCI_IOV_RESOURCES &&
+					i <= PCI_IOV_RESOURCE_END) {
+				r->end = r->start - 1;
+				add_to_list(add_head, dev, r, r_size, 1);
+				children_add_size += r_size;
+				continue;
+			}
+#endif
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
-- 
1.7.0.4

