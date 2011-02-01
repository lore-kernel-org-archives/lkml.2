Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1BAMDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:03:09 -0500
Received: from mail.sysgo.com ([195.145.229.155]:47437 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1BAMDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:03:07 -0500
Date: Tue, 1 Feb 2011 13:03:03 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: cko@sysgo.com, rmk+kernel@arm.linux.org.uk, linux@dominikbrodowski.net,
        eric.miao@marvell.com
Subject: pcmcia vs. MECR on pxa25x/sa1111
Message-ID: <20110201120303.GA30464@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After 2.6.34 changes, __pxa2xx_drv_pcmcia_probe() was replaced by
sa1111_pcmcia_add(). That unfortunately means that configure_sockets()
is not called, leading to MECR not being set properly, leading to
strange crashes.

Tested on pxa255+sa1111, I do not have lubbock board nearby. Perhaps
cleaner solution exists?

Signed-off-by: Pavel Machek <pma@sysgo.com>


--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -204,10 +204,10 @@ pxa2xx_pcmcia_frequency_change(struct soc_pcmcia_socket *skt,
 }
 #endif
 
-static void pxa2xx_configure_sockets(struct device *dev)
+void pxa2xx_configure_sockets(struct device *dev)
 {
 	struct pcmcia_low_level *ops = dev->platform_data;
 
 	/*
 	 * We have at least one socket, so set MECR:CIT
 	 * (Card Is There)
diff --git a/drivers/pcmcia/pxa2xx_lubbock.c b/drivers/pcmcia/pxa2xx_lubbock.c
--- a/drivers/pcmcia/pxa2xx_lubbock.c
+++ b/drivers/pcmcia/pxa2xx_lubbock.c
@@ -209,6 +209,8 @@ static struct pcmcia_low_level lubbock_pcmcia_ops = {
 
 #include "pxa2xx_base.h"
 
+extern void pxa2xx_configure_sockets(struct device *dev);
+
 int pcmcia_lubbock_init(struct sa1111_dev *sadev)
 {
 	int ret = -ENODEV;
@@ -228,6 +230,7 @@ int pcmcia_lubbock_init(struct sa1111_dev *sadev)
 		pxa2xx_drv_pcmcia_ops(&lubbock_pcmcia_ops);
 		ret = sa1111_pcmcia_add(sadev, &lubbock_pcmcia_ops,
 				pxa2xx_drv_pcmcia_add_one);
+		pxa2xx_configure_sockets(&(sadev->dev));
 	}
 
 	return ret;
