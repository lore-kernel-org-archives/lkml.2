Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1JNEd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:33:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49811 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab1JNE1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:27:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Jh4MMlDbeAbBEavtxUkJZY2pTKf6TMJf3KAlTIxV8WyJ+tOVv+xTAaXdIWQPHquJJ
	Qb/eFYuJcCV5IZ3smQqxg==
Subject: [PATCH v2 05/29] x86/PCI: use pci_scan_bus() instead of
	pci_scan_bus_parented()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:32 -0600
Message-ID: <20111014042732.23504.87730.stgit@bhelgaas.mtv.corp.google.com>
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

This doesn't change any functionality, but it makes a subsequent patch
slightly simpler.

pci_scan_bus(NULL, ...) and pci_scan_bus_parented() are identical except
that pci_scan_bus() also calls pci_bus_add_devices():

  pci_scan_bus_parented
    pci_create_bus
    pci_scan_child_bus

  pci_scan_bus
    pci_create_bus
    pci_scan_child_bus
    pci_bus_add_devices

All callers of pcibios_scan_root() call pci_bus_add_devices() explicitly,
and we don't pass a parent device, so we might as well use pci_scan_bus().

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/common.c   |    2 +-
 arch/x86/pci/legacy.c   |    3 ---
 arch/x86/pci/numaq_32.c |    2 --
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 92df322..b389a2d 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -456,7 +456,7 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 	sd->node = get_mp_bus_to_node(busnum);
 
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
-	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	bus = pci_scan_bus(busnum, &pci_root_ops, sd);
 	if (!bus)
 		kfree(sd);
 
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index c89266b..6e3f26a 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -30,9 +30,6 @@ int __init pci_legacy_init(void)
 
 	printk("PCI: Probing PCI hardware\n");
 	pci_root_bus = pcibios_scan_root(0);
-	if (pci_root_bus)
-		pci_bus_add_devices(pci_root_bus);
-
 	return 0;
 }
 
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 512a88c..2b94aa9 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -153,8 +153,6 @@ int __init pci_numaq_init(void)
 	raw_pci_ops = &pci_direct_conf1_mq;
 
 	pci_root_bus = pcibios_scan_root(0);
-	if (pci_root_bus)
-		pci_bus_add_devices(pci_root_bus);
 	if (num_online_nodes() > 1)
 		for_each_online_node(quad) {
 			if (quad == 0)

