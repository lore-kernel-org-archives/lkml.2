Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2EGUed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:34:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18481 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab2EGUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/21] PCI: checking busn_res in pci_scan_root_bus()
Date: Mon,  7 May 2012 13:29:55 -0700
Message-Id: <1336422606-4244-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some callers do not supply the bus number aperture, usually because they do
not know the end.  In this case, we assume the aperture extends from the
root bus number to bus 255, scan the bus, and shrink the bus number
resource so it ends at the largest bus number we found.

This is obviously not correct because the actual end of the aperture may
well be larger than the largest bus number we found.  But I guess it's all
we have for now.

Also print out one info about that, so we could find out which path
does not have busn_res in resources list.

-v4: set found initial value to false.

[bhelgaas: changelog, list _safe iterator unnecessary, use %pR format for bus]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 59011ce..6258f6f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1788,13 +1788,33 @@ void pci_bus_release_busn_res(struct pci_bus *b)
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
+	struct pci_host_bridge_window *window;
+	bool found = false;
 	struct pci_bus *b;
+	int max;
+
+	list_for_each_entry(window, resources, list)
+		if (window->res->flags & IORESOURCE_BUS) {
+			found = true;
+			break;
+		}
 
 	b = pci_create_root_bus(parent, bus, ops, sysdata, resources);
 	if (!b)
 		return NULL;
 
-	b->busn_res.end = pci_scan_child_bus(b);
+	if (!found) {
+		dev_info(&b->dev,
+		 "No busn resource found for root bus, will use [bus %02x-ff]\n",
+			bus);
+		pci_bus_insert_busn_res(b, bus, 255);
+	}
+
+	max = pci_scan_child_bus(b);
+
+	if (!found)
+		pci_bus_update_busn_res_end(b, max);
+
 	pci_bus_add_devices(b);
 	return b;
 }
-- 
1.7.7

