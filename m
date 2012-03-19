Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030906Ab2CSGIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:08:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29900 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030702Ab2CSFpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:45:35 -0400
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
Subject: [PATCH -v11 19/30] PCI: Add pci_bus_extend/shrink_top()
Date: Sun, 18 Mar 2012 22:42:50 -0700
Message-Id: <1332135781-13695-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F66C7F6.0056,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend or shrink bus and parent buses top (subordinate)

Extended range is verified safe range, and stop at recorded parent_res.

-v2: Remove busn_res change, it is updated in other function.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8a77b8b..3e32b34 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -655,6 +655,41 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 	}
 }
 
+static void __devinit pci_bus_update_top(struct pci_bus *parent,
+		 long size, struct resource *parent_res)
+{
+	struct resource *res;
+
+	if (!size)
+		return;
+
+	while (parent) {
+		res = &parent->busn_res;
+		if (res == parent_res)
+			break;
+		parent->subordinate += size;
+		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
+					 parent->subordinate);
+		dev_printk(KERN_DEBUG, &parent->dev,
+				"busn_res: %s %02lx to %pR\n",
+				(size > 0) ? "extended" : "shrunk",
+				abs(size), res);
+		parent = parent->parent;
+	}
+}
+
+static void __devinit pci_bus_extend_top(struct pci_bus *parent,
+		 long size, struct resource *parent_res)
+{
+	pci_bus_update_top(parent, size, parent_res);
+}
+
+static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
+		 long size, struct resource *parent_res)
+{
+	pci_bus_update_top(parent, -size, parent_res);
+}
+
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
-- 
1.7.7

