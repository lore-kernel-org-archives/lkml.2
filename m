Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2FZSzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:55:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29988 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab2FZSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:55:00 -0400
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
Subject: [PATCH -v12 05/15] PCI: Probe safe range that we can use for unassigned bridge.
Date: Tue, 26 Jun 2012 11:53:59 -0700
Message-Id: <1340736849-14875-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to allocate from parent bus busn_res. If we can not find any big enough,
will try to extend parent bus top. even the extending is through allocating,
after allocating will pad the range to parent buses top.

When extending happens, We will record the parent_res, so could use it as
stopper for really extend/shrink top later.

-v4: Use generic probe_resource()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 44c42ae..75bca6f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -717,6 +717,34 @@ static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
 	pci_bus_extend_top(parent, -size, parent_res);
 }
 
+static int __devinit pci_bridge_probe_busn_res(struct pci_bus *bus,
+			 struct pci_dev *dev, struct resource *busn_res,
+			 resource_size_t needed_size, struct resource **p)
+{
+	int ret;
+	int old_size = resource_size(&bus->busn_res);
+	int skip_nr = 1;
+	int domain_limit = 0xff;
+	int stop_flags = IORESOURCE_PCI_FIXED;
+
+	ret = probe_resource(&bus->busn_res, busn_res, needed_size,
+			p, skip_nr, domain_limit, stop_flags);
+
+	if (ret)
+		return ret;
+
+	busn_res->flags = IORESOURCE_BUS;
+
+	if (*p) {
+		/* extend parent bus top*/
+		int new_size = resource_size(&bus->busn_res);
+
+		pci_bus_extend_top(bus, new_size - old_size, *p);
+	}
+
+	return ret;
+}
+
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
-- 
1.7.7

