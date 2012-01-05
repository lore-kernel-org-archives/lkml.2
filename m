Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2AEAt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:49:26 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59505 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2AEAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:48:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] xen/pciback: Move the PCI_DEV_FLAGS_ASSIGNED ops to the "[un|]bind"
Date: Wed,  4 Jan 2012 19:46:41 -0500
Message-Id: <1325724403-29642-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F04F353.0045,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

operation instead of doing it per guest creation/disconnection. Without
this we could have potentially unloaded the vf driver from the
xen pciback control even if the driver was binded to the xen-pciback.
This will hold on to it until the user "unbind"s the PCI device using
SysFS.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |    2 ++
 drivers/xen/xen-pciback/xenbus.c   |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 0ce0dc6..d66328e 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -114,6 +114,7 @@ static void pcistub_device_release(struct kref *kref)
 	xen_pcibk_config_free_dyn_fields(psdev->dev);
 	xen_pcibk_config_free_dev(psdev->dev);
 
+	psdev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
 	pci_dev_put(psdev->dev);
 
 	kfree(psdev);
@@ -366,6 +367,7 @@ static int __devinit pcistub_init_device(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "reset device\n");
 	xen_pcibk_reset_device(dev);
 
+	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
 	return 0;
 
 config_release:
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 0755259..474d52e 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -241,7 +241,6 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 		goto out;
 
 	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
-	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
 	if (xen_register_device_domain_owner(dev,
 					     pdev->xdev->otherend_id) != 0) {
 		dev_err(&dev->dev, "device has been assigned to another " \
@@ -281,7 +280,6 @@ static int xen_pcibk_remove_device(struct xen_pcibk_device *pdev,
 	}
 
 	dev_dbg(&dev->dev, "unregistering for %d\n", pdev->xdev->otherend_id);
-	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
 	xen_unregister_device_domain_owner(dev);
 
 	xen_pcibk_release_pci_dev(pdev, dev);
-- 
1.7.7.4

