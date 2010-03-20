Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0CTOSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:18:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59020 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0CTONl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:13:41 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Date: Sat, 20 Mar 2010 15:12:44 +0100
Message-Id: <1269094385-16114-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 03/24] usb/otg/isp1301_omap: Fix dangling pointer
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this i2c-driver which missed setting clientdata to NULL before freeing the
structure it points to. Found by a semantic patch, but fixed by hand.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/otg/isp1301_omap.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index 78a2097..0ad16e3 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -1224,7 +1224,9 @@ static void isp1301_release(struct device *dev)
 	/* ugly -- i2c hijacks our memory hook to wait_for_completion() */
 	if (isp->i2c_release)
 		isp->i2c_release(dev);
-	kfree (isp);
+
+	i2c_set_clientdata(isp->client, NULL);
+	kfree(isp);
 }
 
 static struct isp1301 *the_transceiver;
@@ -1629,6 +1631,7 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	return 0;
 
 fail:
+	i2c_set_clientdata(i2c, NULL);
 	kfree(isp);
 	return -ENODEV;
 }
-- 
1.7.0

