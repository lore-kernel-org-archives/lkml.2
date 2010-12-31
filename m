Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0LaE1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 23:27:38 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:37567 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0LaE1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 23:27:38 -0500
Date: Thu, 30 Dec 2010 20:27:33 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, khali@linux-fr.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH] mfd: i2c: convert SCx200 driver from using raw PCI to
 platform device
Message-ID: <20101230202733.2f01b62d@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this relies on the cs5535-mfd patches that are currently in the
MFD next tree.  It's been tested on CS5536 hardware, but I don't have
access to any old SCx200 hardware to verify that I didn't break the ISA
stuff.


From: Andres Salomon <dilinger@queued.net>

The SCx200 ACB driver supports ISA hardware as well as PCI.  The PCI hardware
is CS5535/CS5536 based, and the device that it grabs is handled by the
cs5535-mfd driver.  This converts the SCx200 driver to use a platform_driver
rather than the previous PCI hackery.

The driver used to manually track the iface list (via linked list); now it
only does this for ISA devices.  PCI ifaces are handled through standard
driver model lists.

It's unclear what happens in case of errors in the old ISA code; rather than
pretending the code actually cares, I've dropped the (implicit) ignorance
of return values and marked it with a comment.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/i2c/busses/scx200_acb.c |  200 ++++++++++++++++-----------------------
 1 files changed, 80 insertions(+), 120 deletions(-)

diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 53fab51..986e5f6 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -40,6 +41,7 @@
 
 MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
 MODULE_DESCRIPTION("NatSemi SCx200 ACCESS.bus Driver");
+MODULE_ALIAS("platform:cs5535-smb");
 MODULE_LICENSE("GPL");
 
 #define MAX_DEVICES 4
@@ -84,10 +86,6 @@ struct scx200_acb_iface {
 	u8 *ptr;
 	char needs_reset;
 	unsigned len;
-
-	/* PCI device info */
-	struct pci_dev *pdev;
-	int bar;
 };
 
 /* Register Definitions */
@@ -391,7 +389,7 @@ static const struct i2c_algorithm scx200_acb_algorithm = {
 static struct scx200_acb_iface *scx200_acb_list;
 static DEFINE_MUTEX(scx200_acb_list_mutex);
 
-static __init int scx200_acb_probe(struct scx200_acb_iface *iface)
+static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 {
 	u8 val;
 
@@ -427,7 +425,7 @@ static __init int scx200_acb_probe(struct scx200_acb_iface *iface)
 	return 0;
 }
 
-static __init struct scx200_acb_iface *scx200_create_iface(const char *text,
+static __devinit struct scx200_acb_iface *scx200_create_iface(const char *text,
 		struct device *dev, int index)
 {
 	struct scx200_acb_iface *iface;
@@ -452,7 +450,7 @@ static __init struct scx200_acb_iface *scx200_create_iface(const char *text,
 	return iface;
 }
 
-static int __init scx200_acb_create(struct scx200_acb_iface *iface)
+static int __devinit scx200_acb_create(struct scx200_acb_iface *iface)
 {
 	struct i2c_adapter *adapter;
 	int rc;
@@ -472,183 +470,145 @@ static int __init scx200_acb_create(struct scx200_acb_iface *iface)
 		return -ENODEV;
 	}
 
-	mutex_lock(&scx200_acb_list_mutex);
-	iface->next = scx200_acb_list;
-	scx200_acb_list = iface;
-	mutex_unlock(&scx200_acb_list_mutex);
+	if (!adapter->dev.parent) {
+		/* If there's no dev, we're tracking (ISA) ifaces manually */
+		mutex_lock(&scx200_acb_list_mutex);
+		iface->next = scx200_acb_list;
+		scx200_acb_list = iface;
+		mutex_unlock(&scx200_acb_list_mutex);
+	}
 
 	return 0;
 }
 
-static __init int scx200_create_pci(const char *text, struct pci_dev *pdev,
-		int bar)
+static struct scx200_acb_iface * __devinit scx200_create_dev(const char *text,
+		unsigned long base, int index, struct device *dev)
 {
 	struct scx200_acb_iface *iface;
 	int rc;
 
-	iface = scx200_create_iface(text, &pdev->dev, 0);
+	iface = scx200_create_iface(text, dev, index);
 
 	if (iface == NULL)
-		return -ENOMEM;
-
-	iface->pdev = pdev;
-	iface->bar = bar;
-
-	rc = pci_enable_device_io(iface->pdev);
-	if (rc)
-		goto errout_free;
+		return NULL;
 
-	rc = pci_request_region(iface->pdev, iface->bar, iface->adapter.name);
-	if (rc) {
-		printk(KERN_ERR NAME ": can't allocate PCI BAR %d\n",
-				iface->bar);
+	if (!request_region(base, 8, iface->adapter.name)) {
+		printk(KERN_ERR NAME ": can't allocate io 0x%lx-0x%lx\n",
+		       base, base + 8 - 1);
 		goto errout_free;
 	}
 
-	iface->base = pci_resource_start(iface->pdev, iface->bar);
+	iface->base = base;
 	rc = scx200_acb_create(iface);
 
 	if (rc == 0)
-		return 0;
+		return iface;
 
-	pci_release_region(iface->pdev, iface->bar);
-	pci_dev_put(iface->pdev);
+	release_region(base, 8);
  errout_free:
 	kfree(iface);
-	return rc;
+	return NULL;
 }
 
-static int __init scx200_create_isa(const char *text, unsigned long base,
-		int index)
+static int __devinit scx200_probe(struct platform_device *pdev)
 {
 	struct scx200_acb_iface *iface;
-	int rc;
-
-	iface = scx200_create_iface(text, NULL, index);
-
-	if (iface == NULL)
-		return -ENOMEM;
+	struct resource *res;
 
-	if (!request_region(base, 8, iface->adapter.name)) {
-		printk(KERN_ERR NAME ": can't allocate io 0x%lx-0x%lx\n",
-		       base, base + 8 - 1);
-		rc = -EBUSY;
-		goto errout_free;
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -ENODEV;
 	}
 
-	iface->base = base;
-	rc = scx200_acb_create(iface);
+	iface = scx200_create_dev("CS5535", res->start, 0, &pdev->dev);
+	if (!iface)
+		return -EIO;
 
-	if (rc == 0)
-		return 0;
+	dev_info(&pdev->dev, "SCx200 device '%s' registered\n",
+			iface->adapter.name);
+	platform_set_drvdata(pdev, iface);
 
-	release_region(base, 8);
- errout_free:
-	kfree(iface);
-	return rc;
+	return 0;
 }
 
-/* Driver data is an index into the scx200_data array that indicates
- * the name and the BAR where the I/O address resource is located.  ISA
- * devices are flagged with a bar value of -1 */
-
-static const struct pci_device_id scx200_pci[] __initconst = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SCx200_BRIDGE),
-	  .driver_data = 0 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE),
-	  .driver_data = 0 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA),
-	  .driver_data = 1 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA),
-	  .driver_data = 2 },
-	{ 0, }
-};
-
-static struct {
-	const char *name;
-	int bar;
-} scx200_data[] = {
-	{ "SCx200", -1 },
-	{ "CS5535",  0 },
-	{ "CS5536",  0 }
-};
+static void __devexit scx200_cleanup_iface(struct scx200_acb_iface *iface)
+{
+	i2c_del_adapter(&iface->adapter);
+	release_region(iface->base, 8);
+	kfree(iface);
+}
 
-static __init int scx200_scan_pci(void)
+static int __devexit scx200_remove(struct platform_device *pdev)
 {
-	int data, dev;
-	int rc = -ENODEV;
-	struct pci_dev *pdev;
+	struct scx200_acb_iface *iface;
 
-	for(dev = 0; dev < ARRAY_SIZE(scx200_pci); dev++) {
-		pdev = pci_get_device(scx200_pci[dev].vendor,
-				scx200_pci[dev].device, NULL);
+	iface = platform_get_drvdata(pdev);
+	platform_set_drvdata(pdev, NULL);
+	scx200_cleanup_iface(iface);
 
-		if (pdev == NULL)
-			continue;
+	return 0;
+}
 
-		data = scx200_pci[dev].driver_data;
+static struct platform_driver scx200_pci_drv = {
+	.driver = {
+		.name = "cs5535-smb",
+		.owner = THIS_MODULE,
+	},
+	.probe = scx200_probe,
+	.remove = __devexit_p(scx200_remove),
+};
 
-		/* if .bar is greater or equal to zero, this is a
-		 * PCI device - otherwise, we assume
-		   that the ports are ISA based
-		*/
+static const struct pci_device_id scx200_isa[] __initconst = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SCx200_BRIDGE) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE) },
+	{ 0, }
+};
 
-		if (scx200_data[data].bar >= 0)
-			rc = scx200_create_pci(scx200_data[data].name, pdev,
-					scx200_data[data].bar);
-		else {
-			int i;
+static __init void scx200_scan_isa(void)
+{
+	int i;
 
-			pci_dev_put(pdev);
-			for (i = 0; i < MAX_DEVICES; ++i) {
-				if (base[i] == 0)
-					continue;
+	if (!pci_dev_present(scx200_isa))
+		return;
 
-				rc = scx200_create_isa(scx200_data[data].name,
-						base[i],
-						i);
-			}
-		}
+	for (i = 0; i < MAX_DEVICES; ++i) {
+		if (base[i] == 0)
+			continue;
 
-		break;
+		/* XXX: should we care about failures? */
+		scx200_create_dev("SCx200", base[i], i, NULL);
 	}
-
-	return rc;
 }
 
 static int __init scx200_acb_init(void)
 {
-	int rc;
-
 	pr_debug(NAME ": NatSemi SCx200 ACCESS.bus Driver\n");
 
-	rc = scx200_scan_pci();
+	/* First scan for ISA-based devices */
+	scx200_scan_isa();	/* XXX: should we care about errors? */
 
 	/* If at least one bus was created, init must succeed */
 	if (scx200_acb_list)
 		return 0;
-	return rc;
+
+	/* No ISA devices; register the platform driver for PCI-based devices */
+	return platform_driver_register(&scx200_pci_drv);
 }
 
 static void __exit scx200_acb_cleanup(void)
 {
 	struct scx200_acb_iface *iface;
 
+	platform_driver_unregister(&scx200_pci_drv);
+
 	mutex_lock(&scx200_acb_list_mutex);
 	while ((iface = scx200_acb_list) != NULL) {
 		scx200_acb_list = iface->next;
 		mutex_unlock(&scx200_acb_list_mutex);
 
-		i2c_del_adapter(&iface->adapter);
-
-		if (iface->pdev) {
-			pci_release_region(iface->pdev, iface->bar);
-			pci_dev_put(iface->pdev);
-		}
-		else
-			release_region(iface->base, 8);
+		scx200_cleanup_iface(iface);
 
-		kfree(iface);
 		mutex_lock(&scx200_acb_list_mutex);
 	}
 	mutex_unlock(&scx200_acb_list_mutex);
-- 
1.7.2.3

