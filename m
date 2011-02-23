Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1BWEen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1BWEek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:40 -0500
Subject: [RFC PATCH 12/15] dt/usb: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:37 -0700
Message-ID: <20110223043436.20795.9795.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of users of of_platform_driver in drivers/usb.  The
of_platform_{,un}register_driver functions are going away, so the
users need to be converted to using the platform_bus_type directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/usb/gadget/fsl_qe_udc.c   |   14 ++++++++------
 drivers/usb/host/ehci-hcd.c       |   12 ++++++------
 drivers/usb/host/ehci-ppc-of.c    |    9 +++------
 drivers/usb/host/ehci-xilinx-of.c |    6 ++----
 drivers/usb/host/fhci-hcd.c       |    9 ++++-----
 drivers/usb/host/isp1760-if.c     |    9 ++++-----
 drivers/usb/host/ohci-hcd.c       |    6 +++---
 drivers/usb/host/ohci-ppc-of.c    |    9 +++------
 8 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 792d5ef..aee7e3c 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2523,8 +2523,7 @@ static void qe_udc_release(struct device *dev)
 }
 
 /* Driver probe functions */
-static int __devinit qe_udc_probe(struct platform_device *ofdev,
-			const struct of_device_id *match)
+static int __devinit qe_udc_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct qe_ep *ep;
@@ -2532,6 +2531,9 @@ static int __devinit qe_udc_probe(struct platform_device *ofdev,
 	unsigned int i;
 	const void *prop;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+
 	prop = of_get_property(np, "mode", NULL);
 	if (!prop || strcmp(prop, "peripheral"))
 		return -ENODEV;
@@ -2543,7 +2545,7 @@ static int __devinit qe_udc_probe(struct platform_device *ofdev,
 		return -ENOMEM;
 	}
 
-	udc_controller->soc_type = (unsigned long)match->data;
+	udc_controller->soc_type = (unsigned long)ofdev->dev.of_match->data;
 	udc_controller->usb_regs = of_iomap(np, 0);
 	if (!udc_controller->usb_regs) {
 		ret = -ENOMEM;
@@ -2768,7 +2770,7 @@ static const struct of_device_id qe_udc_match[] __devinitconst = {
 
 MODULE_DEVICE_TABLE(of, qe_udc_match);
 
-static struct of_platform_driver udc_driver = {
+static struct platform_driver udc_driver = {
 	.driver = {
 		.name = (char *)driver_name,
 		.owner = THIS_MODULE,
@@ -2786,12 +2788,12 @@ static int __init qe_udc_init(void)
 {
 	printk(KERN_INFO "%s: %s, %s\n", driver_name, driver_desc,
 			DRIVER_VERSION);
-	return of_register_platform_driver(&udc_driver);
+	return platform_driver_register(&udc_driver);
 }
 
 static void __exit qe_udc_exit(void)
 {
-	of_unregister_platform_driver(&udc_driver);
+	platform_driver_unregister(&udc_driver);
 }
 
 module_init(qe_udc_init);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 74dcf49..c4de2d7 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1306,24 +1306,24 @@ static int __init ehci_hcd_init(void)
 #endif
 
 #ifdef OF_PLATFORM_DRIVER
-	retval = of_register_platform_driver(&OF_PLATFORM_DRIVER);
+	retval = platform_driver_register(&OF_PLATFORM_DRIVER);
 	if (retval < 0)
 		goto clean3;
 #endif
 
 #ifdef XILINX_OF_PLATFORM_DRIVER
-	retval = of_register_platform_driver(&XILINX_OF_PLATFORM_DRIVER);
+	retval = platform_driver_register(&XILINX_OF_PLATFORM_DRIVER);
 	if (retval < 0)
 		goto clean4;
 #endif
 	return retval;
 
 #ifdef XILINX_OF_PLATFORM_DRIVER
-	/* of_unregister_platform_driver(&XILINX_OF_PLATFORM_DRIVER); */
+	/* platform_driver_unregister(&XILINX_OF_PLATFORM_DRIVER); */
 clean4:
 #endif
 #ifdef OF_PLATFORM_DRIVER
-	of_unregister_platform_driver(&OF_PLATFORM_DRIVER);
+	platform_driver_unregister(&OF_PLATFORM_DRIVER);
 clean3:
 #endif
 #ifdef PS3_SYSTEM_BUS_DRIVER
@@ -1351,10 +1351,10 @@ module_init(ehci_hcd_init);
 static void __exit ehci_hcd_cleanup(void)
 {
 #ifdef XILINX_OF_PLATFORM_DRIVER
-	of_unregister_platform_driver(&XILINX_OF_PLATFORM_DRIVER);
+	platform_driver_unregister(&XILINX_OF_PLATFORM_DRIVER);
 #endif
 #ifdef OF_PLATFORM_DRIVER
-	of_unregister_platform_driver(&OF_PLATFORM_DRIVER);
+	platform_driver_unregister(&OF_PLATFORM_DRIVER);
 #endif
 #ifdef PLATFORM_DRIVER
 	platform_driver_unregister(&PLATFORM_DRIVER);
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index ba52be4..1f09f25 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -105,8 +105,7 @@ ppc44x_enable_bmt(struct device_node *dn)
 }
 
 
-static int __devinit
-ehci_hcd_ppc_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit ehci_hcd_ppc_of_probe(struct platform_device *op)
 {
 	struct device_node *dn = op->dev.of_node;
 	struct usb_hcd *hcd;
@@ -255,14 +254,12 @@ static int ehci_hcd_ppc_of_remove(struct platform_device *op)
 }
 
 
-static int ehci_hcd_ppc_of_shutdown(struct platform_device *op)
+static void ehci_hcd_ppc_of_shutdown(struct platform_device *op)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(&op->dev);
 
 	if (hcd->driver->shutdown)
 		hcd->driver->shutdown(hcd);
-
-	return 0;
 }
 
 
@@ -275,7 +272,7 @@ static const struct of_device_id ehci_hcd_ppc_of_match[] = {
 MODULE_DEVICE_TABLE(of, ehci_hcd_ppc_of_match);
 
 
-static struct of_platform_driver ehci_hcd_ppc_of_driver = {
+static struct platform_driver ehci_hcd_ppc_of_driver = {
 	.probe		= ehci_hcd_ppc_of_probe,
 	.remove		= ehci_hcd_ppc_of_remove,
 	.shutdown	= ehci_hcd_ppc_of_shutdown,
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index e8f4f36..17c1b11 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -142,15 +142,13 @@ static const struct hc_driver ehci_xilinx_of_hc_driver = {
 /**
  * ehci_hcd_xilinx_of_probe - Probe method for the USB host controller
  * @op:		pointer to the platform_device bound to the host controller
- * @match:	pointer to of_device_id structure, not used
  *
  * This function requests resources and sets up appropriate properties for the
  * host controller. Because the Xilinx USB host controller can be configured
  * as HS only or HS/FS only, it checks the configuration in the device tree
  * entry, and sets an appropriate value for hcd->has_tt.
  */
-static int __devinit
-ehci_hcd_xilinx_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
 {
 	struct device_node *dn = op->dev.of_node;
 	struct usb_hcd *hcd;
@@ -288,7 +286,7 @@ static const struct of_device_id ehci_hcd_xilinx_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ehci_hcd_xilinx_of_match);
 
-static struct of_platform_driver ehci_hcd_xilinx_of_driver = {
+static struct platform_driver ehci_hcd_xilinx_of_driver = {
 	.probe		= ehci_hcd_xilinx_of_probe,
 	.remove		= ehci_hcd_xilinx_of_remove,
 	.shutdown	= ehci_hcd_xilinx_of_shutdown,
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 12fd184..b84ff7e 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -561,8 +561,7 @@ static const struct hc_driver fhci_driver = {
 	.hub_control = fhci_hub_control,
 };
 
-static int __devinit of_fhci_probe(struct platform_device *ofdev,
-				   const struct of_device_id *ofid)
+static int __devinit of_fhci_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *node = dev->of_node;
@@ -812,7 +811,7 @@ static const struct of_device_id of_fhci_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_fhci_match);
 
-static struct of_platform_driver of_fhci_driver = {
+static struct platform_driver of_fhci_driver = {
 	.driver = {
 		.name = "fsl,usb-fhci",
 		.owner = THIS_MODULE,
@@ -824,13 +823,13 @@ static struct of_platform_driver of_fhci_driver = {
 
 static int __init fhci_module_init(void)
 {
-	return of_register_platform_driver(&of_fhci_driver);
+	return platform_driver_register(&of_fhci_driver);
 }
 module_init(fhci_module_init);
 
 static void __exit fhci_module_exit(void)
 {
-	of_unregister_platform_driver(&of_fhci_driver);
+	platform_driver_unregister(&of_fhci_driver);
 }
 module_exit(fhci_module_exit);
 
diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index 3b28dbf..7ee3005 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -27,8 +27,7 @@
 #endif
 
 #ifdef CONFIG_PPC_OF
-static int of_isp1760_probe(struct platform_device *dev,
-		const struct of_device_id *match)
+static int of_isp1760_probe(struct platform_device *dev)
 {
 	struct usb_hcd *hcd;
 	struct device_node *dp = dev->dev.of_node;
@@ -119,7 +118,7 @@ static const struct of_device_id of_isp1760_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_isp1760_match);
 
-static struct of_platform_driver isp1760_of_driver = {
+static struct platform_driver isp1760_of_driver = {
 	.driver = {
 		.name = "nxp-isp1760",
 		.owner = THIS_MODULE,
@@ -398,7 +397,7 @@ static int __init isp1760_init(void)
 	if (!ret)
 		any_ret = 0;
 #ifdef CONFIG_PPC_OF
-	ret = of_register_platform_driver(&isp1760_of_driver);
+	ret = platform_driver_register(&isp1760_of_driver);
 	if (!ret)
 		any_ret = 0;
 #endif
@@ -418,7 +417,7 @@ static void __exit isp1760_exit(void)
 {
 	platform_driver_unregister(&isp1760_plat_driver);
 #ifdef CONFIG_PPC_OF
-	of_unregister_platform_driver(&isp1760_of_driver);
+	platform_driver_unregister(&isp1760_of_driver);
 #endif
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&isp1761_pci_driver);
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 759a12f..54240f6 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1180,7 +1180,7 @@ static int __init ohci_hcd_mod_init(void)
 #endif
 
 #ifdef OF_PLATFORM_DRIVER
-	retval = of_register_platform_driver(&OF_PLATFORM_DRIVER);
+	retval = platform_driver_register(&OF_PLATFORM_DRIVER);
 	if (retval < 0)
 		goto error_of_platform;
 #endif
@@ -1239,7 +1239,7 @@ static int __init ohci_hcd_mod_init(void)
  error_sa1111:
 #endif
 #ifdef OF_PLATFORM_DRIVER
-	of_unregister_platform_driver(&OF_PLATFORM_DRIVER);
+	platform_driver_unregister(&OF_PLATFORM_DRIVER);
  error_of_platform:
 #endif
 #ifdef PLATFORM_DRIVER
@@ -1287,7 +1287,7 @@ static void __exit ohci_hcd_mod_exit(void)
 	sa1111_driver_unregister(&SA1111_DRIVER);
 #endif
 #ifdef OF_PLATFORM_DRIVER
-	of_unregister_platform_driver(&OF_PLATFORM_DRIVER);
+	platform_driver_unregister(&OF_PLATFORM_DRIVER);
 #endif
 #ifdef PLATFORM_DRIVER
 	platform_driver_unregister(&PLATFORM_DRIVER);
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index b2c2dbf..1ca1821 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -80,8 +80,7 @@ static const struct hc_driver ohci_ppc_of_hc_driver = {
 };
 
 
-static int __devinit
-ohci_hcd_ppc_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit ohci_hcd_ppc_of_probe(struct platform_device *op)
 {
 	struct device_node *dn = op->dev.of_node;
 	struct usb_hcd *hcd;
@@ -201,14 +200,12 @@ static int ohci_hcd_ppc_of_remove(struct platform_device *op)
 	return 0;
 }
 
-static int ohci_hcd_ppc_of_shutdown(struct platform_device *op)
+static void ohci_hcd_ppc_of_shutdown(struct platform_device *op)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(&op->dev);
 
         if (hcd->driver->shutdown)
                 hcd->driver->shutdown(hcd);
-
-	return 0;
 }
 
 
@@ -243,7 +240,7 @@ MODULE_DEVICE_TABLE(of, ohci_hcd_ppc_of_match);
 #endif
 
 
-static struct of_platform_driver ohci_hcd_ppc_of_driver = {
+static struct platform_driver ohci_hcd_ppc_of_driver = {
 	.probe		= ohci_hcd_ppc_of_probe,
 	.remove		= ohci_hcd_ppc_of_remove,
 	.shutdown 	= ohci_hcd_ppc_of_shutdown,

