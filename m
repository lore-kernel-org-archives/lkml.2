Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0FKG3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:29:36 -0400
Received: from mail.perches.com ([173.55.12.10]:1047 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0FKG3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:29:35 -0400
Subject: [PATCH] drivers/net/e1000/e1000_main.c: Fix message logging defect
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Emil Tantilov <emil.s.tantilov@intel.com>, netdev <netdev@vger.kernel.org>,
       e1000-devel <e1000-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 23:29:33 -0700
Message-ID: <1276237773.1556.507.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 675ad47375c76a7c3be4ace9554d92cd55518ced
removed the capability to use ethtool.set_msglevel to
control the types of messages emitted by the driver.

That commit should probably be reverted.

If not, then this patch fixes a message logging defect
introduced by converting a printk without KERN_<level>
to e_info.

This also reduces text by about 200 bytes.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index ebdea08..68a8089 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1047,15 +1047,14 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		goto err_register;
 
 	/* print bus type/speed/width info */
-	e_info("(PCI%s:%s:%s) ",
-		((hw->bus_type == e1000_bus_type_pcix) ? "-X" : ""),
-		((hw->bus_speed == e1000_bus_speed_133) ? "133MHz" :
-		 (hw->bus_speed == e1000_bus_speed_120) ? "120MHz" :
-		 (hw->bus_speed == e1000_bus_speed_100) ? "100MHz" :
-		 (hw->bus_speed == e1000_bus_speed_66) ? "66MHz" : "33MHz"),
-		((hw->bus_width == e1000_bus_width_64) ? "64-bit" : "32-bit"));
-
-	e_info("%pM\n", netdev->dev_addr);
+	e_info("(PCI%s:%dMHz:%d-bit) %pM\n",
+	       ((hw->bus_type == e1000_bus_type_pcix) ? "-X" : ""),
+	       ((hw->bus_speed == e1000_bus_speed_133) ? 133 :
+		(hw->bus_speed == e1000_bus_speed_120) ? 120 :
+		(hw->bus_speed == e1000_bus_speed_100) ? 100 :
+		(hw->bus_speed == e1000_bus_speed_66) ? 66 : 33),
+	       ((hw->bus_width == e1000_bus_width_64) ? 64 : 32),
+	       netdev->dev_addr);
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);


