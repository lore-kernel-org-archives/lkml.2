Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0CWXNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:13:13 -0400
Received: from vps.mortis.eu ([79.99.135.181]:43870 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0CWXNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:13:07 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Giel van Schijndel <me@mortis.eu>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] hwmon: f71882fg: add watchdog detection code
Date: Wed, 24 Mar 2010 00:12:15 +0100
Message-Id: <1269385936-3440-3-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1269385936-3440-2-git-send-email-me@mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for detecting the hardware monitor into a separate
function. Then add a function for detecting the watchdog.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |   74 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 7b31e14..8006271 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2233,6 +2233,54 @@ static int f71882fg_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int __init f71882fg_find_watchdog(int sioaddr,
+	const struct f71882fg_sio_data *sio_data)
+{
+	switch (sio_data->type) {
+	case f71808fg:
+		break;
+
+	case f71862fg:
+	case f71882fg:
+	case f71889fg:
+		/* These have a watchdog, though it isn't implemented (yet). */
+		return -ENOSYS;
+
+	case f71858fg:
+	default:
+		/*
+		 * Confirmed (by datasheet) not to have a watchdog. That is,
+		 * except for chips matched by the 'default' label of course.
+		 */
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int __init f71882fg_find_hwmon(int sioaddr, unsigned short *hwmon_addr,
+	struct f71882fg_sio_data *sio_data)
+{
+	if (sio_data->type == f71858fg)
+		superio_select(sioaddr, SIO_F71858FG_LD_HWM);
+	else
+		superio_select(sioaddr, SIO_F71882FG_LD_HWM);
+
+	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
+		printk(KERN_WARNING DRVNAME ": Device not activated\n");
+		return -ENODEV;
+	}
+
+	*hwmon_addr = superio_inw(sioaddr, SIO_REG_ADDR);
+	if (*hwmon_addr == 0) {
+		printk(KERN_WARNING DRVNAME ": Base address not set\n");
+		return -ENODEV;
+	}
+	*hwmon_addr &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
+
+	return 0;
+}
+
 static int __init f71882fg_find(int sioaddr, unsigned short *hwmon_addr,
 	struct f71882fg_sio_data *sio_data)
 {
@@ -2280,27 +2328,21 @@ static int __init f71882fg_find(int sioaddr, unsigned short *hwmon_addr,
 		goto exit;
 	}
 
-	if (sio_data->type == f71858fg)
-		superio_select(sioaddr, SIO_F71858FG_LD_HWM);
-	else
-		superio_select(sioaddr, SIO_F71882FG_LD_HWM);
-
-	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
-		printk(KERN_WARNING DRVNAME ": Device not activated\n");
-		goto exit;
-	}
-
-	*hwmon_addr = superio_inw(sioaddr, SIO_REG_ADDR);
-	if (*hwmon_addr == 0) {
-		printk(KERN_WARNING DRVNAME ": Base address not set\n");
+	err = f71882fg_find_hwmon(sioaddr, hwmon_addr, sio_data);
+	if (err)
 		goto exit;
-	}
-	*hwmon_addr &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
-	err = 0;
 	printk(KERN_INFO DRVNAME ": Found %s chip at %#x, revision %d\n",
 		f71882fg_names[sio_data->type],	(unsigned int)*hwmon_addr,
 		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
+
+	err = f71882fg_find_watchdog(sioaddr, sio_data);
+	if (err == 0)
+		printk(KERN_INFO DRVNAME ": has supported watchdog\n");
+	else if (err != -ENODEV && err != -ENOSYS)
+		goto exit;
+
+	err = 0;
 exit:
 	superio_exit(sioaddr);
 	release_region(sioaddr, 2);
-- 
1.6.4.4

