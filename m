Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab2CFHP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:15:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31791 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380Ab2CFHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:15:56 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/23] PCI, x86: Fix non acpi path pci_sysdata leaking with release_fn
Date: Mon,  5 Mar 2012 23:13:47 -0800
Message-Id: <1331018040-30725-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F55B9AB.000B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

non acpi path, or root is not probed from acpi, during root bus removal
will get warning about leaking from pci_scan_bus_on_node.

Fix it with setting pci_host_bridge release function.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 8e04ec5..35931f6 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -618,17 +618,19 @@ int pci_ext_cfg_avail(struct pci_dev *dev)
 		return 0;
 }
 
+static void release_pci_sysdata(struct pci_host_bridge *bridge)
+{
+	struct pci_sysdata *sd = bridge->release_data;
+
+	kfree(sd);
+}
+
 struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
 
-	/*
-	 * Allocate per-root-bus (not per bus) arch-specific data.
-	 * TODO: leak; this memory is never freed.
-	 * It's arguable whether it's worth the trouble to care.
-	 */
 	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
 	if (!sd) {
 		printk(KERN_ERR "PCI: OOM, skipping PCI bus %02x\n", busno);
@@ -638,7 +640,10 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 	x86_pci_root_bus_resources(busno, &resources);
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busno);
 	bus = pci_scan_root_bus(NULL, busno, ops, sd, &resources);
-	if (!bus) {
+	if (bus)
+		pci_set_host_bridge_release(to_pci_host_bridge(bus->bridge),
+					release_pci_sysdata, sd);
+	else {
 		pci_free_resource_list(&resources);
 		kfree(sd);
 	}
-- 
1.7.7

