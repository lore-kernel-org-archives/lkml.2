Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab0DVU3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:29:11 -0400
Received: from kroah.org ([198.145.64.141]:59508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab0DVT7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:53 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:07 2010
Message-Id: <20100422195407.224347700@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [025/139] sunxvr500: Ignore secondary output PCI devices.
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit bdd32ce95f79fb5cc964cd789d7ae4500bba7c6f ]

These just represent the secondary and further heads attached to the
card, and they have different sets of PCI bar registers to map.

So don't try to drive them in the main driver.

Reported-by: Frans van Berckel <fberckel@xs4all.nl>
Tested-by: Frans van Berckel <fberckel@xs4all.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/sunxvr500.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/video/sunxvr500.c
+++ b/drivers/video/sunxvr500.c
@@ -242,11 +242,27 @@ static int __devinit e3d_set_fbinfo(stru
 static int __devinit e3d_pci_register(struct pci_dev *pdev,
 				      const struct pci_device_id *ent)
 {
+	struct device_node *of_node;
+	const char *device_type;
 	struct fb_info *info;
 	struct e3d_info *ep;
 	unsigned int line_length;
 	int err;
 
+	of_node = pci_device_to_OF_node(pdev);
+	if (!of_node) {
+		printk(KERN_ERR "e3d: Cannot find OF node of %s\n",
+		       pci_name(pdev));
+		return -ENODEV;
+	}
+
+	device_type = of_get_property(of_node, "device_type", NULL);
+	if (!device_type) {
+		printk(KERN_INFO "e3d: Ignoring secondary output device "
+		       "at %s\n", pci_name(pdev));
+		return -ENODEV;
+	}
+
 	err = pci_enable_device(pdev);
 	if (err < 0) {
 		printk(KERN_ERR "e3d: Cannot enable PCI device %s\n",
@@ -265,13 +281,7 @@ static int __devinit e3d_pci_register(st
 	ep->info = info;
 	ep->pdev = pdev;
 	spin_lock_init(&ep->lock);
-	ep->of_node = pci_device_to_OF_node(pdev);
-	if (!ep->of_node) {
-		printk(KERN_ERR "e3d: Cannot find OF node of %s\n",
-		       pci_name(pdev));
-		err = -ENODEV;
-		goto err_release_fb;
-	}
+	ep->of_node = of_node;
 
 	/* Read the PCI base register of the frame buffer, which we
 	 * need in order to interpret the RAMDAC_VID_*FB* values in


