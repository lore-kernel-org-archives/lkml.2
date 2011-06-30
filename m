Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1F3WGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:25 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:32939 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387Ab1F3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/28] staging: ft1000-pcmcia: delete local_info_t typedef
Date: Fri,  1 Jul 2011 00:03:44 +0200
Message-Id: <1309471437-12633-16-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete local_info_t typedef along with the struct as its "link" member was
not used. Use link->priv to store net_device directly.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |   29 ++++------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 798b92c..f1d6e4a 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -93,11 +93,6 @@ static void ft1000_release(struct pcmcia_device *link);
 static void ft1000_detach(struct pcmcia_device *link);
 static int  ft1000_attach(struct pcmcia_device *link);
 
-typedef struct local_info_t {
-	struct pcmcia_device *link;
-	struct net_device *dev;
-} local_info_t;
-
 #define MAX_ASIC_RESET_CNT     10
 #define COR_DEFAULT            0x55
 
@@ -115,20 +110,9 @@ static void ft1000_reset(struct pcmcia_device * link)
 
 static int ft1000_attach(struct pcmcia_device *link)
 {
-
-	local_info_t *local;
-
 	DEBUG(0, "ft1000_cs: ft1000_attach()\n");
 
-	local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
-	if (!local) {
-		return -ENOMEM;
-	}
-	local->link = link;
-
-	link->priv = local;
-	local->dev = NULL;
-
+	link->priv = NULL;
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
 	return ft1000_config(link);
@@ -146,7 +130,7 @@ static int ft1000_attach(struct pcmcia_device *link)
 
 static void ft1000_detach(struct pcmcia_device *link)
 {
-	struct net_device *dev = ((local_info_t *) link->priv)->dev;
+	struct net_device *dev = link->priv;
 
 	DEBUG(0, "ft1000_cs: ft1000_detach(0x%p)\n", link);
 
@@ -161,7 +145,6 @@ static void ft1000_detach(struct pcmcia_device *link)
 
 	pcmcia_disable_device(link);
 
-	/* This points to the parent local_info_t struct */
 	free_netdev(dev);
 
 }				/* ft1000_detach */
@@ -205,9 +188,8 @@ static int ft1000_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	((local_info_t *) link->priv)->dev = init_ft1000_card(link,
-								&ft1000_reset);
-	if (((local_info_t *) link->priv)->dev == NULL) {
+	link->priv = init_ft1000_card(link, &ft1000_reset);
+	if (link->priv == NULL) {
 		printk(KERN_INFO "ft1000: Could not register as network device\n");
 		goto failed;
 	}
@@ -244,7 +226,6 @@ static void ft1000_release(struct pcmcia_device * link)
 	   In a normal driver, additional code may be needed to release
 	   other kernel data structures associated with this device.
 	 */
-	kfree((local_info_t *) link->priv);
 	/* Don't bother checking to see if these succeed or not */
 
 	 pcmcia_disable_device(link);
@@ -264,7 +245,7 @@ static void ft1000_release(struct pcmcia_device * link)
 
 static int ft1000_suspend(struct pcmcia_device *link)
 {
-	struct net_device *dev = ((local_info_t *) link->priv)->dev;
+	struct net_device *dev = link->priv;
 
 	if (link->open)
 		netif_device_detach(dev);
-- 
Ondrej Zary

