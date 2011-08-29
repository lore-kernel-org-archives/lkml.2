Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1H2Rof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:44:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1H2RoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:44:11 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=205/6=5D=20staging=3A=20et131x=3A=20Remove=20module=5Fparam=20et131x=5Fspeed=5Fset?=
Date: Mon, 29 Aug 2011 18:42:40 +0100
Message-Id: <1314639761-4947-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manual setting of speed/duplex will be achieved using ethtool.
Remove the driver specific module_param that also does this.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |   50 +-----------------------------
 1 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 813a72f..a184ac1 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -1,6 +1,6 @@
 /*
  * Agere Systems Inc.
- * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
+ * 10/100/1000 Base-T Ethernet Driver for the ET1310 and ET131x series MACs
  *
  * Copyright © 2005 Agere Systems Inc.
  * All rights reserved.
@@ -97,30 +97,6 @@
 #define INTERNAL_MEM_SIZE       0x400	/* 1024 of internal memory */
 #define INTERNAL_MEM_RX_OFFSET  0x1FF	/* 50%   Tx, 50%   Rx */
 
-/* Defines for Parameter Default/Min/Max vaules */
-#define PARM_SPEED_DUPLEX_MIN   0
-#define PARM_SPEED_DUPLEX_MAX   5
-
-/* Module parameter for manual speed setting
- * Set Link speed and dublex manually (0-5)  [0]
- *  1 : 10Mb   Half-Duplex
- *  2 : 10Mb   Full-Duplex
- *  3 : 100Mb  Half-Duplex
- *  4 : 100Mb  Full-Duplex
- *  5 : 1000Mb Full-Duplex
- *  0 : Auto Speed Auto Duplex // default
- */
-static u32 et131x_speed_set;
-module_param(et131x_speed_set, uint, 0);
-MODULE_PARM_DESC(et131x_speed_set,
-		"Set Link speed and dublex manually (0-5)  [0]\n"
-		"1 : 10Mb   Half-Duplex\n"
-		"2 : 10Mb   Full-Duplex\n"
-		"3 : 100Mb  Half-Duplex\n"
-		"4 : 100Mb  Full-Duplex\n"
-		"5 : 1000Mb Full-Duplex\n"
-		"0 : Auto Speed Auto Dublex");
-
 /**
  * et131x_hwaddr_init - set up the MAC Address on the ET1310
  * @adapter: pointer to our private adapter structure
@@ -531,29 +507,12 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	spin_lock_init(&adapter->fbr_lock);
 	spin_lock_init(&adapter->phy_lock);
 
-	/* Parse configuration parameters into the private adapter struct */
-	if (et131x_speed_set)
-		dev_info(&adapter->pdev->dev,
-			"Speed set manually to : %d\n", et131x_speed_set);
-
-	adapter->speed_duplex = et131x_speed_set;
+	adapter->speed_duplex = 0; /* Auto Speed Auto Duplex */
 	adapter->registry_jumbo_packet = 1514;	/* 1514-9216 */
 
 	/* Set the MAC address to a default */
 	memcpy(adapter->addr, default_mac, ETH_ALEN);
 
-	/* Decode speed_duplex
-	 *
-	 * Set up as if we are auto negotiating always and then change if we
-	 * go into force mode
-	 *
-	 * If we are the 10/100 device, and gigabit is somehow requested then
-	 * knock it down to 100 full.
-	 */
-	if (adapter->pdev->device == ET131X_PCI_DEVICE_ID_FAST &&
-	    adapter->speed_duplex == 5)
-		adapter->speed_duplex = 4;
-
 	adapter->ai_force_speed = speed[adapter->speed_duplex];
 	adapter->ai_force_duplex = duplex[adapter->speed_duplex];	/* Auto FDX */
 
@@ -790,11 +749,6 @@ static struct pci_driver et131x_driver = {
  */
 static int __init et131x_init_module(void)
 {
-	if (et131x_speed_set < PARM_SPEED_DUPLEX_MIN ||
-	    et131x_speed_set > PARM_SPEED_DUPLEX_MAX) {
-		printk(KERN_WARNING "et131x: invalid speed setting ignored.\n");
-		et131x_speed_set = 0;
-	}
 	return pci_register_driver(&et131x_driver);
 }
 
-- 
1.7.6

