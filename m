Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1JNE32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:29:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21661 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1JNE3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:29:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=DDYmS8+hEzr9nC/lt9J0zlV/iOawNlPTRAqBKuLD2cYI0w2wM6J7JWmpqhuYOjJx9
	PUdtAU7o6cj0c7ns3lmuw==
Subject: [PATCH v2 26/29] frv/PCI: convert to pci_scan_root_bus() for correct
	root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:29:20 -0600
Message-ID: <20111014042920.23504.73959.stgit@bhelgaas.mtv.corp.google.com>
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

Convert from pci_scan_bus() to pci_scan_root_bus() and remove root bus
resource fixups.  This fixes the problem of "early" and "header" quirks
seeing incorrect root bus resources.

CC: David Howells <dhowells@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/frv/mb93090-mb00/pci-vdk.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index f8dd37e..a27c5db 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -226,6 +226,7 @@ static struct pci_ops * __init pci_check_direct(void)
  */
 static void __init pcibios_fixup_peer_bridges(void)
 {
+	struct list_head resources;
 	struct pci_bus bus;
 	struct pci_dev dev;
 	int n;
@@ -245,7 +246,17 @@ static void __init pcibios_fixup_peer_bridges(void)
 			    l != 0x0000 && l != 0xffff) {
 				printk("Found device at %02x:%02x [%04x]\n", n, dev.devfn, l);
 				printk("PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus(n, pci_root_ops, NULL);
+				/*
+				 * It's wrong to give peer root buses the same
+				 * resources as the first one, but that's what
+				 * we did before via pcibios_fixup_bus(), so
+				 * this doesn't change it.
+				 */
+				INIT_LIST_HEAD(&resources);
+				pci_add_resource(&resources, &pci_ioport_resource);
+				pci_add_resource(&resources, &pci_iomem_resource);
+				pci_scan_root_bus(NULL, n, pci_root_ops, NULL,
+						  &resources);
 				break;
 			}
 	}
@@ -327,11 +338,6 @@ void __init pcibios_fixup_bus(struct pci_bus *bus)
 	printk("### PCIBIOS_FIXUP_BUS(%d)\n",bus->number);
 #endif
 
-	if (bus->number == 0) {
-		bus->resource[0] = &pci_ioport_resource;
-		bus->resource[1] = &pci_iomem_resource;
-	}
-
 	pci_read_bridge_bases(bus);
 
 	if (bus->number == 0) {
@@ -357,6 +363,7 @@ void __init pcibios_fixup_bus(struct pci_bus *bus)
 int __init pcibios_init(void)
 {
 	struct pci_ops *dir = NULL;
+	struct list_head resources;
 
 	if (!mb93090_mb00_detected)
 		return -ENXIO;
@@ -419,8 +426,13 @@ int __init pcibios_init(void)
 		return -ENXIO;
 	}
 
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &pci_ioport_resource);
+	pci_add_resource(&resources, &pci_iomem_resource);
+
 	printk("PCI: Probing PCI hardware\n");
-	pci_root_bus = pci_scan_bus(0, pci_root_ops, NULL);
+	pci_root_bus = pci_scan_root_bus(NULL, 0, pci_root_ops, NULL,
+					 &resources);
 
 	pcibios_irq_init();
 	pcibios_fixup_peer_bridges();

