Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2KSNi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:38:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:41454 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2KSNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:38:24 -0500
Date: Mon, 19 Nov 2012 14:38:04 +0100
From: Alexander Holler <holler@ahsoftware.de>
To: "till@harbaum.org" <till@harbaum.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
Message-ID: <20121119133802.GA5030@krabat.ahsoftware>
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
 <20121113195533.6db71716@endymion.delvare>
 <50A2AC28.7050304@ahsoftware.de>
 <20121113220835.111a178a@endymion.delvare>
 <50A2BAA2.6090009@ahsoftware.de>
 <20121113224246.768bf734@endymion.delvare>
 <50A2DA0C.3090507@ahsoftware.de>
 <20121114104050.79df8cd9@endymion.delvare>
 <50A390CC.9000208@ahsoftware.de>
 <1352920954.19432.2.camel@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352920954.19432.2.camel@Nokia-N900>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after the needed break in the discussion (to calm down), I've decided to make a last try. I don't want to make a thesis about USB RTCs, nor do I want to write a whole new driver (and afterwards trying to get such into the kernel, not to speak about the then necessary explicit device/vendor ID).

On Wed, Nov 14, 2012 at 08:22:34PM +0100, till@harbaum.org wrote:

> i have seen i2c chips going nuts because some probing actually affected the chips state. So i fully agree with Jean here.

I've now changed the device registration from using i2c_new_probed_device() to i2c_new_device(),
even if that would register non-existent RTCs.

> I2C just isn't meant to be used for hot plugging. And so isn't the i2c-tiny-usb. It's more a hacking and testing device and is e.g. very convenient to test i2c client drivers or to test some new i2c hardware. But i have never had a need for this before user land was available. And once it is you can really do any magic you want using e.g. udev and sysfs.

As you've written yourself, i2c-tiny-usb is more a hacking and testing device, so there's hopefully no real argument left against including the few lines to enable devices through module options or the kernel command line. Someone could like to test such too with the "hacking and testing device".

Regards,

Alexander


>From 1aa6bbd0a87ce39f9889f835d12127226ffa9403 Mon Sep 17 00:00:00 2001
From: Alexander Holler <holler@ahsoftware.de>
Date: Tue, 13 Nov 2012 16:28:07 +0100
Subject: [PATCH] i2c: i2c-tiny-usb: Add parameter for optional i2c-devices.

Make it possible to define i2c-devices at the kernel command line
or as a module parameter.

Format is devname1@addr1,devname2@addr2,...

Example for the kernel command line:

   i2c-tiny-usb.devices=ds1307@0x68,pcf8563@0x51

The definition of up to 8 devices is allowed.

Cc: Till Harbaum <till@harbaum.org>
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/i2c/busses/i2c-tiny-usb.c |   44 +++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index 0510636..a3fc711 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -40,6 +40,11 @@ module_param(delay, ushort, 0);
 MODULE_PARM_DESC(delay, "bit delay in microseconds "
 		 "(default is 10us for 100kHz max)");
 
+#define MAX_OPTIONAL_I2C_DEVICES 8
+static char *opt_devices[MAX_OPTIONAL_I2C_DEVICES];
+module_param_array_named(devices, opt_devices, charp, NULL, 0);
+MODULE_PARM_DESC(devices, "devname1@adr1,devname2@adr2,... (e.g. ds1307@0x68)");
+
 static int usb_read(struct i2c_adapter *adapter, int cmd,
 		    int value, int index, void *data, int len);
 
@@ -184,6 +189,42 @@ static void i2c_tiny_usb_free(struct i2c_tiny_usb *dev)
 	kfree(dev);
 }
 
+static void i2c_add_optional_devices(struct i2c_adapter *adapter)
+{
+	int i;
+	struct i2c_board_info i2c_info;
+	uint addr;
+	const char *at;
+
+	for (i = 0; opt_devices[i]; ++i) {
+		at = strchr(opt_devices[i], '@');
+		if (at++ == NULL) {
+			dev_warn(&adapter->dev,
+				"address needed in device definition '%s'\n",
+				opt_devices[i]);
+			continue;
+		}
+		if (kstrtouint(at, 0, &addr) || addr >= I2C_CLIENT_END) {
+			dev_warn(&adapter->dev,
+				"wrong address in device definition '%s'\n",
+				opt_devices[i]);
+			continue;
+		}
+		memset(&i2c_info, 0, sizeof(struct i2c_board_info));
+		strlcpy(i2c_info.type, opt_devices[i],
+			min(I2C_NAME_SIZE, (int)(at-opt_devices[i])));
+		i2c_info.addr = addr;
+		if (i2c_new_device(adapter, &i2c_info) != NULL)
+			dev_info(&adapter->dev,
+				"device %s at address 0x%02x registered\n",
+				i2c_info.type, addr);
+		else
+			dev_warn(&adapter->dev,
+				"device %s at address 0x%02x not found\n",
+				i2c_info.type, addr);
+	}
+}
+
 static int i2c_tiny_usb_probe(struct usb_interface *interface,
 			      const struct usb_device_id *id)
 {
@@ -236,6 +277,9 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 	/* inform user about successful attachment to i2c layer */
 	dev_info(&dev->adapter.dev, "connected i2c-tiny-usb device\n");
 
+	/* add optional devices */
+	i2c_add_optional_devices(&dev->adapter);
+
 	return 0;
 
  error:
-- 
1.7.8.6

