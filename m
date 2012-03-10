Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2CJHDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:03:23 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39457 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2CJHDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:03:16 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 31/37] x86, PCI: add __pci_scan_root_bus_on_node() that can skip bus_add
Date: Fri,  9 Mar 2012 23:00:31 -0800
Message-Id: <1331362837-10740-32-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F5AFCB2.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could insert pus pci_assign_unassigned_bus_resources() before do bus_add.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h |    2 ++
 arch/x86/pci/common.c      |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index df75d07..bb015c7 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -24,6 +24,8 @@ extern int noioapicquirk;
 extern int noioapicreroute;
 
 /* scan a bus after allocating a pci_sysdata for it */
+struct pci_bus * __devinit __pci_scan_bus_on_node(int busno,
+			 struct pci_ops *ops, int node, bool bus_add);
 extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 					    int node);
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 35931f6..2ebdc231 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -625,7 +625,8 @@ static void release_pci_sysdata(struct pci_host_bridge *bridge)
 	kfree(sd);
 }
 
-struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
+struct pci_bus * __devinit __pci_scan_bus_on_node(int busno,
+			 struct pci_ops *ops, int node, bool bus_add)
 {
 	LIST_HEAD(resources);
 	struct pci_bus *bus = NULL;
@@ -639,7 +640,7 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 	sd->node = node;
 	x86_pci_root_bus_resources(busno, &resources);
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busno);
-	bus = pci_scan_root_bus(NULL, busno, ops, sd, &resources);
+	bus = __pci_scan_root_bus(NULL, busno, ops, sd, &resources, bus_add);
 	if (bus)
 		pci_set_host_bridge_release(to_pci_host_bridge(bus->bridge),
 					release_pci_sysdata, sd);
@@ -650,7 +651,11 @@ struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 
 	return bus;
 }
-
+struct pci_bus * __devinit pci_scan_bus_on_node(int busno,
+			 struct pci_ops *ops, int node)
+{
+	return __pci_scan_bus_on_node(busno, ops, node, true);
+}
 struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
 {
 	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
-- 
1.7.7

