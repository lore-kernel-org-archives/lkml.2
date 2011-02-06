Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1BFUE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:04:26 -0500
Received: from moh2-ve3.go2.pl ([193.17.41.208]:53931 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1BFUEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:04:25 -0500
Message-ID: <4D4EFEC3.5030702@o2.pl>
Date: Sun, 06 Feb 2011 21:04:19 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Greg KH <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
References: <4D4D9F37.4010201@o2.pl> <20110205192831.GA334@suse.de> <4D4DC400.2040302@o2.pl> <4D4DDD54.1010905@ru.mvista.com>
In-Reply-To: <4D4DDD54.1010905@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 67
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 06.02.2011 00:29, Sergei Shtylyov pisze:
> Hello.
> 
> On 06.02.2011 0:41, Maciej Szmigiero wrote:
> 
>> New version of patch which autodetects devices with ACM class.
>> Tested on Galaxy Spica.
> 
>> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
>> diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
>> index 15a5d89..e1c4527 100644
>> --- a/drivers/usb/serial/visor.c
>> +++ b/drivers/usb/serial/visor.c
> [...]
>> @@ -479,6 +480,15 @@ static int visor_probe(struct usb_serial *serial,
>>
>>       dbg("%s", __func__);
>>
>> +    /* some Samsung Android phones in modem mode have the same ID */
>> +    /* as SPH-I500, but they are ACM devices, so dont bind to them */
> 
>    The preferred style for the multi-line comments is this:
> 
> /*
>  * bla
>  * bla
>  */
> 
>> +    if ((id->idVendor == SAMSUNG_VENDOR_ID)&&
>> +        (id->idProduct == SAMSUNG_SPH_I500_ID)&&
>> +        (serial->dev->descriptor.bDeviceClass == USB_CLASS_COMM)&&
>> +        (serial->dev->descriptor.bDeviceSubClass ==
>> +            USB_CDC_SUBCLASS_ACM))
> 
>    Parens around == not necessary...
> 
> WBR, Sergei

Thanks for comments, new version of this patch with style fixes follows.

Best regards,
Maciej Szmigiero

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 15a5d89..0f75948 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/usb/cdc.h>
 #include "visor.h"
 
 /*
@@ -479,6 +480,17 @@ static int visor_probe(struct usb_serial *serial,
 
 	dbg("%s", __func__);
 
+	/*
+	 * some Samsung Android phones in modem mode have the same ID
+	 * as SPH-I500, but they are ACM devices, so dont bind to them
+	*/
+	if (id->idVendor == SAMSUNG_VENDOR_ID &&
+		id->idProduct == SAMSUNG_SPH_I500_ID &&
+		serial->dev->descriptor.bDeviceClass == USB_CLASS_COMM &&
+		serial->dev->descriptor.bDeviceSubClass ==
+			USB_CDC_SUBCLASS_ACM)
+		return -ENODEV;
+
 	if (serial->dev->actconfig->desc.bConfigurationValue != 1) {
 		dev_err(&serial->dev->dev, "active config #%d != 1 ??\n",
 			serial->dev->actconfig->desc.bConfigurationValue);


