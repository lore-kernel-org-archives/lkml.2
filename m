Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0CXDgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:36:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab0CXDgh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:36:37 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 03:36:31 +0000
Message-ID: <1269401791.18314.267.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/2] amd64-agp: Probe unknown AGP devices the right way
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current initialisation code probes 'unsupported' AGP devices
simply by calling its own probe function.  It does not lock these
devices or even check whether another driver is already bound to
them.

We must use the device core to manage this.  So if the specific
device id table didn't match anything and agp_try_unsupported=1,
switch the device id table and call driver_attach() again.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is untested as I have no suitable hardware.

Greg, please confirm that the use of driver_attach() is sane.

Ben.

 drivers/char/agp/amd64-agp.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index fd50ead..93f56d6 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -499,6 +499,10 @@ static int __devinit agp_amd64_probe(struct pci_dev *pdev,
 	u8 cap_ptr;
 	int err;
 
+	/* The Highlander principle */
+	if (agp_bridges_found)
+		return -ENODEV;
+
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
@@ -562,6 +566,8 @@ static void __devexit agp_amd64_remove(struct pci_dev *pdev)
 			   amd64_aperture_sizes[bridge->aperture_size_idx].size);
 	agp_remove_bridge(bridge);
 	agp_put_bridge(bridge);
+
+	agp_bridges_found--;
 }
 
 #ifdef CONFIG_PM
@@ -709,6 +715,11 @@ static struct pci_device_id agp_amd64_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, agp_amd64_pci_table);
 
+static DEFINE_PCI_DEVICE_TABLE(agp_amd64_pci_promisc_table) = {
+	{ PCI_DEVICE_CLASS(0, 0) },
+	{ }
+};
+
 static struct pci_driver agp_amd64_pci_driver = {
 	.name		= "agpgart-amd64",
 	.id_table	= agp_amd64_pci_table,
@@ -734,7 +745,6 @@ int __init agp_amd64_init(void)
 		return err;
 
 	if (agp_bridges_found == 0) {
-		struct pci_dev *dev;
 		if (!agp_try_unsupported && !agp_try_unsupported_boot) {
 			printk(KERN_INFO PFX "No supported AGP bridge found.\n");
 #ifdef MODULE
@@ -750,17 +760,10 @@ int __init agp_amd64_init(void)
 			return -ENODEV;
 
 		/* Look for any AGP bridge */
-		dev = NULL;
-		err = -ENODEV;
-		for_each_pci_dev(dev) {
-			if (!pci_find_capability(dev, PCI_CAP_ID_AGP))
-				continue;
-			/* Only one bridge supported right now */
-			if (agp_amd64_probe(dev, NULL) == 0) {
-				err = 0;
-				break;
-			}
-		}
+		agp_amd64_pci_driver.id_table = agp_amd64_pci_promisc_table;
+		err = driver_attach(&agp_amd64_pci_driver.driver);
+		if (err == 0 && agp_bridges_found == 0)
+			err = -ENODEV;
 	}
 	return err;
 }
-- 
1.7.0


