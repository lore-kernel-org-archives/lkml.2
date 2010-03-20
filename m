Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0CTONn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:13:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59006 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CTONc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:13:32 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-mtd@lists.infradead.org
Date: Sat, 20 Mar 2010 15:12:42 +0100
Message-Id: <1269094385-16114-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 01/24] mtd/maps/pismo: remove dangling pointer and a leak
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking for drivers which forgot to clear i2c_clientdata before freeing
the data structure it points to, I found that the pismo driver even has a leak
on the probe error path.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/mtd/maps/pismo.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/pismo.c b/drivers/mtd/maps/pismo.c
index 30e12c8..86081bc 100644
--- a/drivers/mtd/maps/pismo.c
+++ b/drivers/mtd/maps/pismo.c
@@ -233,6 +233,7 @@ static int __devexit pismo_remove(struct i2c_client *client)
 	/* FIXME: set_vpp needs saner arguments */
 	pismo_setvpp_remove_fix(pismo);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(pismo);
 
 	return 0;
@@ -271,7 +272,7 @@ static int __devinit pismo_probe(struct i2c_client *client,
 	ret = pismo_eeprom_read(client, &eeprom, 0, sizeof(eeprom));
 	if (ret < 0) {
 		dev_err(&client->dev, "error reading EEPROM: %d\n", ret);
-		return ret;
+		goto exit_free;
 	}
 
 	dev_info(&client->dev, "%.15s board found\n", eeprom.board);
@@ -282,6 +283,11 @@ static int __devinit pismo_probe(struct i2c_client *client,
 				      pdata->cs_addrs[i]);
 
 	return 0;
+
+ exit_free:
+	i2c_set_clientdata(client, NULL);
+	kfree(prismo);
+	return ret;
 }
 
 static const struct i2c_device_id pismo_id[] = {
-- 
1.7.0

