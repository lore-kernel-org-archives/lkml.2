Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1CFOqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:46:35 -0500
Received: from ist.d-labs.de ([213.239.218.44]:45007 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab1CFOqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:46:24 -0500
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Florian Mickler <florian@mickler.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Oliver Neukum <oliver@neukum.org>, Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 3/3] [media] dib0700: don't ignore errors in driver probe
Date: Sun,  6 Mar 2011 15:45:16 +0100
Message-Id: <1299422716-29461-3-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1299422716-29461-1-git-send-email-florian@mickler.org>
References: <20110306153805.001011a9@schatten.dmk.lab>
 <1299422716-29461-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Mickler <florian@mickler.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>
CC: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 77a3060..3ad18ce 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -698,6 +698,7 @@ static int dib0700_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	int i;
+	int ret;
 	struct dvb_usb_device *dev;
 
 	for (i = 0; i < dib0700_device_count; i++)
@@ -706,8 +707,10 @@ static int dib0700_probe(struct usb_interface *intf,
 			struct dib0700_state *st = dev->priv;
 			u32 hwversion, romversion, fw_version, fwtype;
 
-			dib0700_get_version(dev, &hwversion, &romversion,
+			ret = dib0700_get_version(dev, &hwversion, &romversion,
 				&fw_version, &fwtype);
+			if (ret < 0)
+				goto out;
 
 			deb_info("Firmware version: %x, %d, 0x%x, %d\n",
 				hwversion, romversion, fw_version, fwtype);
@@ -721,11 +724,15 @@ static int dib0700_probe(struct usb_interface *intf,
 			else
 				dev->props.rc.core.bulk_mode = false;
 
-			dib0700_rc_setup(dev);
+			ret = dib0700_rc_setup(dev);
+			if (ret)
+				goto out;
 
 			return 0;
+out:
+			dvb_usb_device_exit();
+			return ret;
 		}
-
 	return -ENODEV;
 }
 
-- 
1.7.4.rc3

