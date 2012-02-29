Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966149Ab2B2XVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:21:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26097 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964983Ab2B2XIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        linux-parisc@vger.kernel.org
Subject: [PATCH 29/39] PCI, parisc: Register busn_res for root buses
Date: Wed, 29 Feb 2012 15:07:28 -0800
Message-Id: <1330556858-11768-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F4EAFEE.00EB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 drivers/parisc/dino.c    |    5 +++++
 drivers/parisc/lba_pci.c |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 0610e91..def94af 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -984,6 +984,10 @@ static int __init dino_probe(struct parisc_device *dev)
 	if (dino_dev->hba.gmmio_space.flags)
 		pci_add_resource(&resources, &dino_dev->hba.gmmio_space);
 
+	dino_dev->hba.bus_num.start = dino_current_bus;
+	dino_dev->hba.bus_num.end = 255;
+	dino_dev->hba.bus_num.flags |= IORESOURCE_BUS;
+	pci_add_resource(&resources, &dino_dev->hba.bus_num);
 	/*
 	** It's not used to avoid chicken/egg problems
 	** with configuration accessor functions.
@@ -999,6 +1003,7 @@ static int __init dino_probe(struct parisc_device *dev)
 		return 0;
 	}
 
+	pci_bus_update_busn_res_end(bus, bus->subordinate);
 	bus->subordinate = pci_scan_child_bus(bus);
 
 	/* This code *depends* on scanning being single threaded
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index e885764..df1e9f9 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1503,6 +1503,9 @@ lba_driver_probe(struct parisc_device *dev)
 	if (lba_dev->hba.gmmio_space.flags)
 		pci_add_resource(&resources, &lba_dev->hba.gmmio_space);
 
+	lba_dev->hba.bus_num.flags |= IORESOURCE_BUS;
+	pci_add_resource(&resources, &lba_dev->hba.bus_num);
+
 	dev->dev.platform_data = lba_dev;
 	lba_bus = lba_dev->hba.hba_bus =
 		pci_create_root_bus(&dev->dev, lba_dev->hba.bus_num.start,
-- 
1.7.7

