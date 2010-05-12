Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0ELUke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:40:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0ELUka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:40:30 -0400
Date: Wed, 12 May 2010 13:39:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mmotm] backlight: fix adp8860_bl build errors
Message-Id: <20100512133919.016d6286.randy.dunlap@oracle.com>
In-Reply-To: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BEB121A.013A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add slab.h to fix part of build.
Add a parameter in backlight_device_register() call to fix part of build.

drivers/video/backlight/adp8860_bl.c:215: error: implicit declaration of function 'kzalloc'
drivers/video/backlight/adp8860_bl.c:215: warning: assignment makes pointer from integer without a cast
drivers/video/backlight/adp8860_bl.c:285: error: implicit declaration of function 'kfree'
drivers/video/backlight/adp8860_bl.c:673: warning: assignment makes pointer from integer without a cast
drivers/video/backlight/adp8860_bl.c:689: error: too few arguments to function 'backlight_device_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/video/backlight/adp8860_bl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- mmotm-2010-0511-1820.orig/drivers/video/backlight/adp8860_bl.c
+++ mmotm-2010-0511-1820/drivers/video/backlight/adp8860_bl.c
@@ -16,6 +16,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include <linux/workqueue.h>
 
 #include <linux/i2c/adp8860.h>
@@ -647,6 +648,7 @@ static int __devinit adp8860_probe(struc
 	struct adp8860_bl *data;
 	struct adp8860_backlight_platform_data *pdata =
 		client->dev.platform_data;
+	struct backlight_properties props;
 	uint8_t reg_val;
 	int ret;
 
@@ -683,10 +685,13 @@ static int __devinit adp8860_probe(struc
 	data->current_brightness = 0;
 	i2c_set_clientdata(client, data);
 
+	memset(&props, 0, sizeof(props));
+	props.max_brightness = ADP8860_MAX_BRIGHTNESS;
+
 	mutex_init(&data->lock);
 
 	bl = backlight_device_register(dev_driver_string(&client->dev),
-			&client->dev, data, &adp8860_bl_ops);
+			&client->dev, data, &adp8860_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
