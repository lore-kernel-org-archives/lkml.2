Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1JNE2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1JNE2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aBWhw9zhQElNsEKZpxMsBFWX8fHoggA2uBYCu9tXC3KEDcTo2NQTXayeFdPXyjQ+W
	OlFHUeLAsV+/AT+bR7F8Q==
Subject: [PATCH v2 19/29] parisc/PCI: supply root bus resources to
	pci_create_root_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:44 -0600
Message-ID: <20111014042844.23504.97139.stgit@bhelgaas.mtv.corp.google.com>
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
 drivers/parisc/dino.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index fba5636..2aca77f 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -562,19 +562,6 @@ dino_fixup_bus(struct pci_bus *bus)
 	/* Firmware doesn't set up card-mode dino, so we have to */
 	if (is_card_dino(&dino_dev->hba.dev->id)) {
 		dino_card_setup(bus, dino_dev->hba.base_addr);
-	} else if(bus->parent == NULL) {
-		/* must have a dino above it, reparent the resources
-		 * into the dino window */
-		int i;
-		struct resource *res = &dino_dev->hba.lmmio_space;
-
-		bus->resource[0] = &(dino_dev->hba.io_space);
-		for(i = 0; i < DINO_MAX_LMMIO_RESOURCES; i++) {
-			if(res[i].flags == 0)
-				break;
-			bus->resource[i+1] = &res[i];
-		}
-
 	} else if (bus->parent) {
 		int i;
 
@@ -927,6 +914,7 @@ static int __init dino_probe(struct parisc_device *dev)
 	const char *version = "unknown";
 	char *name;
 	int is_cujo = 0;
+	struct list_head resources;
 	struct pci_bus *bus;
 	unsigned long hpa = dev->hpa.start;
 
@@ -1003,15 +991,25 @@ static int __init dino_probe(struct parisc_device *dev)
 
 	dev->dev.platform_data = dino_dev;
 
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &dino_dev->hba.io_space);
+	if (dino_dev->hba.lmmio_space.flags)
+		pci_add_resource(&resources, &dino_dev->hba.lmmio_space);
+	if (dino_dev->hba.elmmio_space.flags)
+		pci_add_resource(&resources, &dino_dev->hba.elmmio_space);
+	if (dino_dev->hba.gmmio_space.flags)
+		pci_add_resource(&resources, &dino_dev->hba.gmmio_space);
+
 	/*
 	** It's not used to avoid chicken/egg problems
 	** with configuration accessor functions.
 	*/
 	dino_dev->hba.hba_bus = bus = pci_create_root_bus(&dev->dev,
-			 dino_current_bus, &dino_cfg_ops, NULL, NULL);
+			 dino_current_bus, &dino_cfg_ops, NULL, &resources);
 	if (!bus) {
 		printk(KERN_ERR "ERROR: failed to scan PCI bus on %s (duplicate bus number %d?)\n",
 		       dev_name(&dev->dev), dino_current_bus);
+		pci_free_resource_list(&resources);
 		/* increment the bus number in case of duplicates */
 		dino_current_bus++;
 		return 0;

