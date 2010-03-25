Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0CYNSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:18:43 -0400
Received: from vps.mortis.eu ([79.99.135.181]:44865 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0CYNSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:18:10 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Giel van Schijndel <me@mortis.eu>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] hwmon: f71882fg: use a muxed resource lock for the Super I/O port
Date: Thu, 25 Mar 2010 14:17:42 +0100
Message-Id: <1269523063-30346-2-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1269523063-30346-1-git-send-email-me@mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sleep while acquiring a resource lock on the Super I/O port. This should
prevent collisions from causing the hardware probe to fail with -EBUSY.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 7857ed3..e09416d 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -113,7 +113,7 @@ static struct platform_device *f71882fg_pdev;
 /* Super-I/O Function prototypes */
 static inline int superio_inb(int base, int reg);
 static inline int superio_inw(int base, int reg);
-static inline void superio_enter(int base);
+static inline int superio_enter(int base);
 static inline void superio_select(int base, int ld);
 static inline void superio_exit(int base);
 
@@ -883,11 +883,20 @@ static int superio_inw(int base, int reg)
 	return val;
 }
 
-static inline void superio_enter(int base)
+static inline int superio_enter(int base)
 {
+	/* Don't step on other drivers' I/O space by accident */
+	if (!request_muxed_region(base, 2, DRVNAME)) {
+		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
+				(int)base);
+		return -EBUSY;
+	}
+
 	/* according to the datasheet the key must be send twice! */
 	outb(SIO_UNLOCK_KEY, base);
 	outb(SIO_UNLOCK_KEY, base);
+
+	return 0;
 }
 
 static inline void superio_select(int base, int ld)
@@ -899,6 +908,7 @@ static inline void superio_select(int base, int ld)
 static inline void superio_exit(int base)
 {
 	outb(SIO_LOCK_KEY, base);
+	release_region(base, 2);
 }
 
 static inline int fan_from_reg(u16 reg)
@@ -2239,17 +2249,10 @@ static int f71882fg_remove(struct platform_device *pdev)
 static int __init f71882fg_find(int sioaddr, unsigned short *address,
 	struct f71882fg_sio_data *sio_data)
 {
-	int err = -ENODEV;
 	u16 devid;
-
-	/* Don't step on other drivers' I/O space by accident */
-	if (!request_region(sioaddr, 2, DRVNAME)) {
-		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
-				(int)sioaddr);
-		return -EBUSY;
-	}
-
-	superio_enter(sioaddr);
+	int err = superio_enter(sioaddr);
+	if (err)
+		return err;
 
 	devid = superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid != SIO_FINTEK_ID) {
@@ -2306,7 +2309,6 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
 		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
 exit:
 	superio_exit(sioaddr);
-	release_region(sioaddr, 2);
 	return err;
 }
 
-- 
1.6.4.4

