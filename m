Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1JNE3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:29:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab1JNE3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:29:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eTPaCaPICh/7upIi9AlmDStg/ejZQNcXiz/crNDfnVC72V9I18komEbg5k7dj/83q
	yBqK6nkLs5pGNrrr0tFbQ==
Subject: [PATCH v2 28/29] sh/PCI: convert to pci_scan_root_bus() for correct
	root bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:29:30 -0600
Message-ID: <20111014042930.23504.60734.stgit@bhelgaas.mtv.corp.google.com>
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

CC: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sh/drivers/pci/pci.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 194231c..d8dc68b 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -35,9 +35,16 @@ static void __devinit pcibios_scanbus(struct pci_channel *hose)
 {
 	static int next_busno;
 	static int need_domain_info;
+	struct list_head resources;
+	int i;
 	struct pci_bus *bus;
 
-	bus = pci_scan_bus(next_busno, hose->pci_ops, hose);
+	INIT_LIST_HEAD(&resources);
+	for (i = 0; i < hose->nr_resources; i++)
+		pci_add_resource(&resources, hose->resources + i);
+
+	bus = pci_scan_root_bus(NULL, next_busno, hose->pci_ops, hose,
+				&resources);
 	hose->bus = bus;
 
 	need_domain_info = need_domain_info || hose->index;
@@ -54,6 +61,8 @@ static void __devinit pcibios_scanbus(struct pci_channel *hose)
 		pci_bus_size_bridges(bus);
 		pci_bus_assign_resources(bus);
 		pci_enable_bridges(bus);
+	} else {
+		pci_free_resource_list(&resources);
 	}
 }
 
@@ -163,14 +172,6 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
 {
 	struct pci_dev *dev = bus->self;
 	struct list_head *ln;
-	struct pci_channel *hose = bus->sysdata;
-
-	if (!dev) {
-		int i;
-
-		for (i = 0; i < hose->nr_resources; i++)
-			bus->resource[i] = hose->resources + i;
-	}
 
 	for (ln = bus->devices.next; ln != &bus->devices; ln = ln->next) {
 		dev = pci_dev_b(ln);

