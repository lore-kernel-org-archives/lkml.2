Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429Ab2B2XJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25870 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab2B2XIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 24/39] PCI: checking busn_res in pci_scan_root_bus
Date: Wed, 29 Feb 2012 15:07:23 -0800
Message-Id: <1330556858-11768-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090208.4F4EAFE8.0059,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some calling may not have end decided yet, and may not pass busn_res in
resources list.

try to do insert big one and shrink.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e32f1b7..1149109 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1742,12 +1742,34 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
 	struct pci_bus *b;
+	struct pci_host_bridge_window *window, *n;
+	struct resource *res;
+	bool found;
+
+	list_for_each_entry_safe(window, n, resources, list) {
+		res = window->res;
+		if (res->flags & IORESOURCE_BUS) {
+			found = true;
+			break;
+		}
+	}
 
 	b = pci_create_root_bus(parent, bus, ops, sysdata, resources);
 	if (!b)
 		return NULL;
 
+	if (!found) {
+		dev_info(&b->dev,
+		 "No busn resource found for root bus, will use [%02x, ff]\n",
+			bus);
+		pci_bus_insert_busn_res(b, bus, 255);
+	}
+
 	b->subordinate = pci_scan_child_bus(b);
+
+	if (!found)
+		pci_bus_update_busn_res_end(b, b->subordinate);
+
 	pci_bus_add_devices(b);
 	return b;
 }
-- 
1.7.7

