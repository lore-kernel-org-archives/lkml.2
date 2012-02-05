Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2BEHAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 02:00:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24611 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2BEHAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 02:00:01 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/24] PCI: Add pci_bus_extend/shrink_top()
Date: Sat,  4 Feb 2012 22:57:55 -0800
Message-Id: <1328425088-6562-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F2E28E6.0086,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extend or shrink bus and parent buses top (subordinate)

extended range is verified safe range, and stop at recorded parent_res.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cdd6e83..d2519df 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -624,6 +624,42 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
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
+		res->end += size;
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

