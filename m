Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab0G3SpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:45:18 -0400
Received: from kroah.org ([198.145.64.141]:35816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab0G3Re5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:08 2010
Message-Id: <20100730173108.771658390@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Dave Airlie <airlied@redhat.com>
Subject: [067/140] amd64-agp: Probe unknown AGP devices the right way
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6fd024893911dcb51b4a0aa71971db5ba38f7071 upstream.

The current initialisation code probes 'unsupported' AGP devices
simply by calling its own probe function.  It does not lock these
devices or even check whether another driver is already bound to
them.

We must use the device core to manage this.  So if the specific
device id table didn't match anything and agp_try_unsupported=1,
switch the device id table and call driver_attach() again.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/amd64-agp.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -499,6 +499,10 @@ static int __devinit agp_amd64_probe(str
 	u8 cap_ptr;
 	int err;
 
+	/* The Highlander principle */
+	if (agp_bridges_found)
+		return -ENODEV;
+
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
@@ -562,6 +566,8 @@ static void __devexit agp_amd64_remove(s
 			   amd64_aperture_sizes[bridge->aperture_size_idx].size);
 	agp_remove_bridge(bridge);
 	agp_put_bridge(bridge);
+
+	agp_bridges_found--;
 }
 
 #ifdef CONFIG_PM
@@ -709,6 +715,11 @@ static struct pci_device_id agp_amd64_pc
 
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


