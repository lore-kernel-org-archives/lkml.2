Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381Ab2CSFo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:44:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28228 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180Ab2CSFoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:44:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v11 08/30] PCI: Checking busn_res in pci_scan_root_bus()
Date: Sun, 18 Mar 2012 22:42:39 -0700
Message-Id: <1332135781-13695-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F66C7B0.0031,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some calling may not have end decided yet, and may not pass busn_res in
resources list.

Try to do insert big one and shrink.

Also print out one info about that, so we could find out which path
does not have busn_res in resources list.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3d11836..654c727 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1736,12 +1736,34 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
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

