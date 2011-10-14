Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1JNE3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:29:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21506 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1JNE3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:29:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vJYEeseGBYbEe3aTch1iGRdg3B/LQBQGvBGHaThAFWc80QeKe57WKeSnFCF5r1LX+
	tkFEx8IwD/KPNu2Hg0deQ==
Subject: [PATCH v2 22/29] parisc/PCI: supply root bus resources to
	pci_create_root_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:59 -0600
Message-ID: <20111014042859.23504.62988.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply root bus resources to pci_create_root_bus() so they're correct
immediately.  This fixes the problem of "early" and "header" quirks seeing
incorrect root bus resources.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/parisc/lba_pci.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index d62c268..7dd5699 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -653,7 +653,7 @@ lba_fixup_bus(struct pci_bus *bus)
 		}
 	} else {
 		/* Host-PCI Bridge */
-		int err, i;
+		int err;
 
 		DBG("lba_fixup_bus() %s [%lx/%lx]/%lx\n",
 			ldev->hba.io_space.name,
@@ -669,9 +669,6 @@ lba_fixup_bus(struct pci_bus *bus)
 			lba_dump_res(&ioport_resource, 2);
 			BUG();
 		}
-		/* advertize Host bridge resources to PCI bus */
-		bus->resource[0] = &(ldev->hba.io_space);
-		i = 1;
 
 		if (ldev->hba.elmmio_space.start) {
 			err = request_resource(&iomem_resource,
@@ -685,8 +682,7 @@ lba_fixup_bus(struct pci_bus *bus)
 
 				/* lba_dump_res(&iomem_resource, 2); */
 				/* BUG(); */
-			} else
-				bus->resource[i++] = &(ldev->hba.elmmio_space);
+			}
 		}
 
 		if (ldev->hba.lmmio_space.flags) {
@@ -696,8 +692,7 @@ lba_fixup_bus(struct pci_bus *bus)
 					"lmmio_space [%lx/%lx]\n",
 					(long)ldev->hba.lmmio_space.start,
 					(long)ldev->hba.lmmio_space.end);
-			} else
-				bus->resource[i++] = &(ldev->hba.lmmio_space);
+			}
 		}
 
 #ifdef CONFIG_64BIT
@@ -712,7 +707,6 @@ lba_fixup_bus(struct pci_bus *bus)
 				lba_dump_res(&iomem_resource, 2);
 				BUG();
 			}
-			bus->resource[i++] = &(ldev->hba.gmmio_space);
 		}
 #endif
 
@@ -1388,6 +1382,7 @@ static int __init
 lba_driver_probe(struct parisc_device *dev)
 {
 	struct lba_device *lba_dev;
+	struct list_head resources;
 	struct pci_bus *lba_bus;
 	struct pci_ops *cfg_ops;
 	u32 func_class;
@@ -1519,12 +1514,23 @@ lba_driver_probe(struct parisc_device *dev)
 		lba_dev->hba.lmmio_space.flags = 0;
 	}
 
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &lba_dev->hba.io_space);
+	if (lba_dev->hba.elmmio_space.start)
+		pci_add_resource(&resources, &lba_dev->hba.elmmio_space);
+	if (lba_dev->hba.lmmio_space.flags)
+		pci_add_resource(&resources, &lba_dev->hba.lmmio_space);
+	if (lba_dev->hba.gmmio_space.flags)
+		pci_add_resource(&resources, &lba_dev->hba.gmmio_space);
+
 	dev->dev.platform_data = lba_dev;
 	lba_bus = lba_dev->hba.hba_bus =
 		pci_create_root_bus(&dev->dev, lba_dev->hba.bus_num.start,
-				    cfg_ops, NULL, NULL);
-	if (!lba_bus)
+				    cfg_ops, NULL, &resources);
+	if (!lba_bus) {
+		pci_free_resource_list(&resources);
 		return 0;
+	}
 
 	lba_bus->subordinate = pci_scan_child_bus(lba_bus);
 

