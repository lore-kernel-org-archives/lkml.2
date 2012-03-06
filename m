Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab2CFHRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:17:08 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17493 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab2CFHRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:17:04 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/23] PCI: add __pci_scan_root_bus() that can skip bus_add
Date: Mon,  5 Mar 2012 23:13:57 -0800
Message-Id: <1331018040-30725-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F55B9EF.00D9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could insert pus pci_assign_unassigned_bus_resources() before do bus_add.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   13 ++++++++++---
 include/linux/pci.h |    3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6240d2c..708412a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1953,8 +1953,9 @@ void pci_bus_release_busn_res(struct pci_bus *b)
 			res, ret ? "can not be" : "is");
 }
 
-struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+struct pci_bus * __devinit __pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources,
+		bool bus_add)
 {
 	struct pci_bus *b;
 	struct pci_host_bridge_window *window, *n;
@@ -1985,9 +1986,15 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 	if (!found)
 		pci_bus_update_busn_res_end(b, b->subordinate);
 
-	pci_bus_add_devices(b);
+	if (bus_add)
+		pci_bus_add_devices(b);
 	return b;
 }
+struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+{
+	return __pci_scan_root_bus(parent, bus, ops, sysdata, resources, true);
+}
 EXPORT_SYMBOL(pci_scan_root_bus);
 
 /* Deprecated; use pci_scan_root_bus() instead */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3d5feda..1efb80d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -675,6 +675,9 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
+struct pci_bus * __devinit __pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources,
+		bool bus_add);
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
-- 
1.7.7

