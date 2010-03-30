Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab0CaAXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:23:33 -0400
Received: from kroah.org ([198.145.64.141]:49074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab0C3XMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:39 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:41 2010
Message-Id: <20100330225840.514170790@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Till Harbaum <till@harbaum.org>,
       Jean Delvare <jdelvare@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [52/89] i2c-tiny-usb: Fix on big-endian systems
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 1c010ff8912cbc08d80e865aab9c32b6b00c527d upstream.

The functionality bit vector is always returned as a little-endian
32-bit number by the device, so it must be byte-swapped to the host
endianness.

On the other hand, the delay value is handled by the USB stack, so no
byte swapping is needed on our side.

This fixes bug #15105:
http://bugzilla.kernel.org/show_bug.cgi?id=15105

Reported-by: Jens Richter <jens@richter-stutensee.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Jens Richter <jens@richter-stutensee.de>
Cc: Till Harbaum <till@harbaum.org>
Cc: stable@kernel.org
Acked-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/i2c/busses/i2c-tiny-usb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/types.h>
 
 /* include interfaces to usb layer */
 #include <linux/usb.h>
@@ -31,8 +32,8 @@
 #define CMD_I2C_IO_END		(1<<1)
 
 /* i2c bit delay, default is 10us -> 100kHz */
-static int delay = 10;
-module_param(delay, int, 0);
+static unsigned short delay = 10;
+module_param(delay, ushort, 0);
 MODULE_PARM_DESC(delay, "bit delay in microseconds, "
 		 "e.g. 10 for 100kHz (default is 100kHz)");
 
@@ -109,7 +110,7 @@ static int usb_xfer(struct i2c_adapter *
 
 static u32 usb_func(struct i2c_adapter *adapter)
 {
-	u32 func;
+	__le32 func;
 
 	/* get functionality from adapter */
 	if (usb_read(adapter, CMD_GET_FUNC, 0, 0, &func, sizeof(func)) !=
@@ -118,7 +119,7 @@ static u32 usb_func(struct i2c_adapter *
 		return 0;
 	}
 
-	return func;
+	return le32_to_cpu(func);
 }
 
 /* This is the actual algorithm we define */
@@ -216,8 +217,7 @@ static int i2c_tiny_usb_probe(struct usb
 		 "i2c-tiny-usb at bus %03d device %03d",
 		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum);
 
-	if (usb_write(&dev->adapter, CMD_SET_DELAY,
-		      cpu_to_le16(delay), 0, NULL, 0) != 0) {
+	if (usb_write(&dev->adapter, CMD_SET_DELAY, delay, 0, NULL, 0) != 0) {
 		dev_err(&dev->adapter.dev,
 			"failure setting delay to %dus\n", delay);
 		retval = -EIO;


