Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1JNEbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:31:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab1JNE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=n8ua4HKyzLfvXEAxb3JYPxOYBL+ANrVaq4g0t7+7nw6EGKAief9ONxCpwQeN5Ym0N
	/RFMp76ptyCazy4oZU9Sw==
Subject: [PATCH v2 18/29] parisc/PCI: use pci_create_root_bus() instead of
	pci_scan_bus_parented()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:39 -0600
Message-ID: <20111014042839.23504.62250.stgit@bhelgaas.mtv.corp.google.com>
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

No functional change here; just converting from the deprecated
pci_scan_bus_parented() to pci_create_root_bus() to make a future
patch simpler.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/parisc/dino.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index bcd5d54..fba5636 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -1007,22 +1007,24 @@ static int __init dino_probe(struct parisc_device *dev)
 	** It's not used to avoid chicken/egg problems
 	** with configuration accessor functions.
 	*/
-	dino_dev->hba.hba_bus = bus = pci_scan_bus_parented(&dev->dev,
-			 dino_current_bus, &dino_cfg_ops, NULL);
-
-	if(bus) {
-		/* This code *depends* on scanning being single threaded
-		 * if it isn't, this global bus number count will fail
-		 */
-		dino_current_bus = bus->subordinate + 1;
-		pci_bus_assign_resources(bus);
-		pci_bus_add_devices(bus);
-	} else {
+	dino_dev->hba.hba_bus = bus = pci_create_root_bus(&dev->dev,
+			 dino_current_bus, &dino_cfg_ops, NULL, NULL);
+	if (!bus) {
 		printk(KERN_ERR "ERROR: failed to scan PCI bus on %s (duplicate bus number %d?)\n",
 		       dev_name(&dev->dev), dino_current_bus);
 		/* increment the bus number in case of duplicates */
 		dino_current_bus++;
+		return 0;
 	}
+
+	bus->subordinate = pci_scan_child_bus(bus);
+
+	/* This code *depends* on scanning being single threaded
+	 * if it isn't, this global bus number count will fail
+	 */
+	dino_current_bus = bus->subordinate + 1;
+	pci_bus_assign_resources(bus);
+	pci_bus_add_devices(bus);
 	return 0;
 }
 

