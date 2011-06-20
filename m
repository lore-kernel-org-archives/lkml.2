Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1FTWr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:47:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45787 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1FTWrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:47:53 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, svenkatr@ti.com,
        yinghai@kernel.org, cjb@laptop.org, linux-pci@vger.kernel.org,
        linux-net-drivers@solarflare.com, bhutchings@solarflare.com,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 3/4] PCI: make SRIOV resources nice-to-have
Date: Mon, 20 Jun 2011 15:47:16 -0700
Message-Id: <1308610037-6261-4-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Allocate resources to SRIOV BARs only after all other genuine resources
requests are satisfied. Dont retry if resource allocation for SRIOV BARs fail.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c282c48..4f8873e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -672,6 +672,16 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			if (r->parent || (r->flags & mask) != type)
 				continue;
 			r_size = resource_size(r);
+#ifdef CONFIG_PCI_IOV
+			/* add SRIOV BARs to nice-to-have list */
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

