Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1BGLmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:42:44 -0500
Received: from moh1-ve3.go2.pl ([193.17.41.134]:37455 "EHLO moh1-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab1BGLmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:42:43 -0500
Message-ID: <4D4FDAAC.9020602@o2.pl>
Date: Mon, 07 Feb 2011 12:42:36 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Greg KH <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [USB]Add Samsung SGH-I500/Android modem ID switch to visor driver
References: <4D4D9F37.4010201@o2.pl> <20110205192831.GA334@suse.de> <4D4DC400.2040302@o2.pl> <4D4DDD54.1010905@ru.mvista.com> <4D4EFEC3.5030702@o2.pl> <4D4FD695.5050507@mvista.com>
In-Reply-To: <4D4FD695.5050507@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 68
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 07.02.2011 12:25, Sergei Shtylyov pisze:
> Hello.
> 
> On 06-02-2011 23:04, Maciej Szmigiero wrote:
> 
>>>> New version of patch which autodetects devices with ACM class.
>>>> Tested on Galaxy Spica.
> 
> 
>> diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
>> index 15a5d89..0f75948 100644
>> --- a/drivers/usb/serial/visor.c
>> +++ b/drivers/usb/serial/visor.c
> [...]
>> @@ -479,6 +480,17 @@ static int visor_probe(struct usb_serial *serial,
>>
>>       dbg("%s", __func__);
>>
>> +    /*
>> +     * some Samsung Android phones in modem mode have the same ID
>> +     * as SPH-I500, but they are ACM devices, so dont bind to them
>> +    */
> 
>    Space is missing. You were close. :-)
> 
> WBR, Sergei
> 

Damn :)

Signed-off-by: Maciej Szmigiero<mhej@o2.pl>

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 15a5d89..1c11959 100644
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
+	 */
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
