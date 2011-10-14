Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1JNE27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1JNE24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jXdkwx3Hg3uatUTlpXtc7ZIZZW02hqj1fGLQDFxc5XpdUvQF9G+V3odMXo93/DYxy
	WiW59QFz4rA+TBYySwHfg==
Subject: [PATCH v2 21/29] parisc/PCI: use pci_create_root_bus() instead of
	pci_scan_bus_parented()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:54 -0600
Message-ID: <20111014042854.23504.33428.stgit@bhelgaas.mtv.corp.google.com>
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
 drivers/parisc/lba_pci.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 2c7edf3..d62c268 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1521,8 +1521,12 @@ lba_driver_probe(struct parisc_device *dev)
 
 	dev->dev.platform_data = lba_dev;
 	lba_bus = lba_dev->hba.hba_bus =
-		pci_scan_bus_parented(&dev->dev, lba_dev->hba.bus_num.start,
-				cfg_ops, NULL);
+		pci_create_root_bus(&dev->dev, lba_dev->hba.bus_num.start,
+				    cfg_ops, NULL, NULL);
+	if (!lba_bus)
+		return 0;
+
+	lba_bus->subordinate = pci_scan_child_bus(lba_bus);
 
 	/* This is in lieu of calling pci_assign_unassigned_resources() */
 	if (is_pdc_pat()) {
@@ -1552,10 +1556,8 @@ lba_driver_probe(struct parisc_device *dev)
 		lba_dev->flags |= LBA_FLAG_SKIP_PROBE;
 	}
 
-	if (lba_bus) {
-		lba_next_bus = lba_bus->subordinate + 1;
-		pci_bus_add_devices(lba_bus);
-	}
+	lba_next_bus = lba_bus->subordinate + 1;
+	pci_bus_add_devices(lba_bus);
 
 	/* Whew! Finally done! Tell services we got this one covered. */
 	return 0;

