Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2ALRIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:08:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21144 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2ALRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:08:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/pciback: Support pci_reset_function, aka FLR or D3 support.
Date: Thu, 12 Jan 2012 12:06:47 -0500
Message-Id: <1326388007-19178-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1326388007-19178-1-git-send-email-konrad.wilk@oracle.com>
References: <1326388007-19178-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F0F139C.011E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the __pci_reset_function_locked to perform the action.
Also on attaching ("bind") and detaching ("unbind") we save and
restore the configuration states. When the device is disconnected
from a guest we use the "pci_reset_function" to also reset the
device before being passed to another guest.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   41 +++++++++++++++++++++++++++++++++--
 drivers/xen/xen-pciback/pciback.h  |    1 +
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 7944a17..6f63b9d 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -85,19 +85,34 @@ static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
 static void pcistub_device_release(struct kref *kref)
 {
 	struct pcistub_device *psdev;
+	struct xen_pcibk_dev_data *dev_data;
 
 	psdev = container_of(kref, struct pcistub_device, kref);
+	dev_data = pci_get_drvdata(psdev->dev);
 
 	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
 
 	xen_unregister_device_domain_owner(psdev->dev);
 
-	/* Clean-up the device */
+	/* Call the reset function which does not take lock as this
+	 * is called from "unbind" which takes a device_lock mutex.
+	 */
+	__pci_reset_function_locked(psdev->dev);
+	if (pci_load_and_free_saved_state(psdev->dev,
+					  &dev_data->pci_saved_state)) {
+		dev_dbg(&psdev->dev->dev, "Could not reload PCI state\n");
+	} else
+		pci_restore_state(psdev->dev);
+
+	/* Disable the device */
 	xen_pcibk_reset_device(psdev->dev);
+
+	kfree(dev_data);
+	pci_set_drvdata(psdev->dev, NULL);
+
+	/* Clean-up the device */
 	xen_pcibk_config_free_dyn_fields(psdev->dev);
 	xen_pcibk_config_free_dev(psdev->dev);
-	kfree(pci_get_drvdata(psdev->dev));
-	pci_set_drvdata(psdev->dev, NULL);
 
 	psdev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
 	pci_dev_put(psdev->dev);
@@ -231,7 +246,17 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	/* Cleanup our device
 	 * (so it's ready for the next domain)
 	 */
+
+	/* This is OK - we are running from workqueue context
+	 * and want to inhibit the user from fiddling with 'reset'
+	 */
+	pci_reset_function(dev);
+	pci_restore_state(psdev->dev);
+
+	/* This disables the device. */
 	xen_pcibk_reset_device(found_psdev->dev);
+
+	/* And cleanup up our emulated fields. */
 	xen_pcibk_config_free_dyn_fields(found_psdev->dev);
 	xen_pcibk_config_reset_dev(found_psdev->dev);
 
@@ -328,6 +353,16 @@ static int __devinit pcistub_init_device(struct pci_dev *dev)
 	if (err)
 		goto config_release;
 
+	dev_dbg(&dev->dev, "reseting (FLR, D3, etc) the device\n");
+	__pci_reset_function_locked(dev);
+
+	/* We need the device active to save the state. */
+	dev_dbg(&dev->dev, "save state of device\n");
+	pci_save_state(dev);
+	dev_data->pci_saved_state = pci_store_saved_state(dev);
+	if (!dev_data->pci_saved_state)
+		dev_err(&dev->dev, "Could not store PCI conf saved state!\n");
+
 	/* Now disable the device (this also ensures some private device
 	 * data is setup before we export)
 	 */
diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
index e9b4011..a7def01 100644
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -41,6 +41,7 @@ struct xen_pcibk_device {
 
 struct xen_pcibk_dev_data {
 	struct list_head config_fields;
+	struct pci_saved_state *pci_saved_state;
 	unsigned int permissive:1;
 	unsigned int warned_on_write:1;
 	unsigned int enable_intx:1;
-- 
1.7.7.4

