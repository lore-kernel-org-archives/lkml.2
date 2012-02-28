Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395Ab2B1WIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:08:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25891 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030312Ab2B1WIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:08:38 -0500
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
Subject: [PATCH 17/24] PCI: Probe safe range that we can use for unassigned bridge.
Date: Tue, 28 Feb 2012 14:07:36 -0800
Message-Id: <1330466863-28469-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
References: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F4D505B.005D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to allocate from parent bus busn_res. if can not find any big enough, will try
to extend parent bus top. even the extending is through allocating, after allocating
will pad the range to parent buses top.

When extending happens, We will record the parent_res, so could use it as stopper
for really extend/shrink top later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 96259f8..c540022 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -691,6 +691,116 @@ static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
 	pci_bus_update_top(parent, -size, parent_res);
 }
 
+static resource_size_t __devinit find_res_top_free_size(struct resource *res)
+{
+	resource_size_t n_size;
+	struct resource tmp_res;
+
+	/*
+	 *   find out number below res->end, that we can use at first
+	 *	res->start can not be used.
+	 */
+	n_size = resource_size(res) - 1;
+	memset(&tmp_res, 0, sizeof(struct resource));
+	while (n_size > 0) {
+		int ret;
+
+		ret = allocate_resource(res, &tmp_res, n_size,
+			res->end - n_size + 1, res->end,
+			1, NULL, NULL);
+		if (ret == 0) {
+			release_resource(&tmp_res);
+			break;
+		}
+		n_size--;
+	}
+
+	return n_size;
+}
+
+static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus,
+			 struct pci_dev *dev, struct resource *busn_res,
+			 resource_size_t needed_size, struct resource **p)
+{
+	int ret = -ENOMEM;
+	resource_size_t n_size;
+	struct pci_bus *parent;
+	struct resource *parent_res = NULL;
+	resource_size_t tmp = bus->busn_res.end + 1;
+	int free_sz = -1;
+
+again:
+	/*
+	 * find bigest range in bus->busn_res that we can use in the middle
+	 *  and we can not use bus->busn_res.start.
+	 */
+	n_size = resource_size(&bus->busn_res) - 1;
+	memset(busn_res, 0, sizeof(struct resource));
+	dev_printk(KERN_DEBUG, &dev->dev,
+			"find free busn in busn_res: %pR\n", &bus->busn_res);
+	while (n_size >= needed_size) {
+		ret = allocate_resource(&bus->busn_res, busn_res, n_size,
+				bus->busn_res.start + 1, bus->busn_res.end,
+				1, NULL, NULL);
+		if (ret == 0) {
+			/* found one, prepare to return */
+			release_resource(busn_res);
+
+			return ret;
+		}
+		n_size--;
+	}
+
+	/* try extend the top of parent bus, find free under top af first */
+	if (free_sz < 0) {
+		free_sz = find_res_top_free_size(&bus->busn_res);
+		dev_printk(KERN_DEBUG, &dev->dev,
+			"found free busn %d in busn_res: %pR top\n",
+				free_sz, &bus->busn_res);
+	}
+	n_size = free_sz;
+
+	/* can not extend cross domain boundary */
+	if ((0xff - bus->busn_res.end) < (needed_size - n_size))
+		goto reduce_needed_size;
+
+	/* find exteded range */
+	memset(busn_res, 0, sizeof(struct resource));
+	parent = bus->parent;
+	while (parent) {
+		ret = allocate_resource(&parent->busn_res, busn_res,
+			 needed_size - n_size,
+			 tmp, tmp + needed_size - n_size - 1,
+			 1, NULL, NULL);
+		if (ret == 0)
+			break;
+		parent = parent->parent;
+	}
+
+reduce_needed_size:
+	if (ret != 0) {
+		needed_size--;
+		if (!needed_size)
+			return ret;
+
+		goto again;
+	}
+
+	/* save parent_res, we need it as stopper later */
+	parent_res = busn_res->parent;
+
+	/* prepare busn_res for return */
+	release_resource(busn_res);
+	busn_res->start -= n_size;
+
+	/* extend parent bus top*/
+	pci_bus_extend_top(bus, needed_size - n_size, parent_res);
+
+	*p = parent_res;
+
+	return ret;
+}
+
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
-- 
1.7.7

