Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2ILNBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:01:30 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab2ILMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511799"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 20/24] Staging: ipack/devices/ipoctal: Get rid of ipoctal_list.
Date: Wed, 12 Sep 2012 14:55:42 +0200
Message-Id: <1347454546-23236-20-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Use tty_dev->dev's drdata to associate struct ipocal_channel to the
respective tty_struct.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   39 +++----------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index a0c1e76..8b2be61 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -49,7 +49,6 @@ struct ipoctal_channel {
 };
 
 struct ipoctal {
-	struct list_head		list;
 	struct ipack_device		*dev;
 	unsigned int			board_id;
 	struct ipoctal_channel		channel[NR_CHANNELS];
@@ -57,34 +56,11 @@ struct ipoctal {
 	struct tty_driver		*tty_drv;
 };
 
-/* Linked list to save the registered devices */
-static LIST_HEAD(ipoctal_list);
-
-static struct ipoctal *ipoctal_find_board(struct tty_struct *tty)
-{
-	struct ipoctal *p;
-
-	list_for_each_entry(p, &ipoctal_list, list) {
-		if (tty->driver->major == p->tty_drv->major)
-			return p;
-	}
-
-	return NULL;
-}
-
 static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 {
-	struct ipoctal *ipoctal;
 	struct ipoctal_channel *channel;
 
-	ipoctal = ipoctal_find_board(tty);
-
-	if (ipoctal == NULL) {
-		dev_err(tty->dev, "Device not found. Major %d\n",
-			tty->driver->major);
-		return -ENODEV;
-	}
-	channel = &ipoctal->channel[tty->index];
+	channel = dev_get_drvdata(tty->dev);
 
 	iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
 	return 0;
@@ -93,17 +69,9 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 static int ipoctal_open(struct tty_struct *tty, struct file *file)
 {
 	int res;
-	struct ipoctal *ipoctal;
 	struct ipoctal_channel *channel;
 
-	ipoctal = ipoctal_find_board(tty);
-
-	if (ipoctal == NULL) {
-		dev_err(tty->dev, "Device not found. Major %d\n",
-			tty->driver->major);
-		return -ENODEV;
-	}
-	channel = &ipoctal->channel[tty->index];
+	channel = dev_get_drvdata(tty->dev);
 
 	if (atomic_read(&channel->open))
 		return -EBUSY;
@@ -457,6 +425,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
 			continue;
 		}
+		dev_set_drvdata(tty_dev, channel);
 
 		/*
 		 * Enable again the RX. TX will be enabled when
@@ -732,7 +701,6 @@ static int ipoctal_probe(struct ipack_device *dev)
 		goto out_uninst;
 
 	dev_set_drvdata(&dev->dev, ipoctal);
-	list_add_tail(&ipoctal->list, &ipoctal_list);
 	return 0;
 
 out_uninst:
@@ -754,7 +722,6 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	tty_unregister_driver(ipoctal->tty_drv);
 	put_tty_driver(ipoctal->tty_drv);
-	list_del(&ipoctal->list);
 	kfree(ipoctal);
 }
 
-- 
1.7.10.4

