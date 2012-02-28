Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2B1Kt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:49:28 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:57399 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964994Ab2B1KtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:49:25 -0500
Message-ID: <4F4CB10C.2000100@st.com>
Date: Tue, 28 Feb 2012 11:48:44 +0100
From: Armando Visconti <armando.visconti@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Viresh KUMAR <viresh.kumar@st.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: linux-next: Tree for Feb 27 (usbtouchscreen)
References: <20120227182029.545a7db32550ce94c9faffb4@canb.auug.org.au> <4F4BC717.1000304@xenotime.net> <4F4BF7E2.3080203@gmx.ch>
In-Reply-To: <4F4BF7E2.3080203@gmx.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

See my replies inline.

> Hi
>
> I had a quick look with gitweb. The following change causes the problem, comments inline:
>
>> From: Armando Visconti<armando.visconti@st.com>
>> Date: Fri, 24 Feb 2012 08:51:37 +0000 (-0800)
>> Subject: Input: usbtouchscreen - add support for Data Modul EasyTouch TP 72037
>> X-Git-Tag: next-20120227~55^2~4
>> X-Git-Url:
> http://git.kernel.org/gitweb.cgi?p=linux%2Fkernel%2Fgit%2Fnext%2Flinux-next.git;a=commitdiff_plain;h=e6307aa07c5a11022f0ccee19a8ff0ba033eeb93
>>
>> Input: usbtouchscreen - add support for Data Modul EasyTouch TP 72037
>>
>> The Data Modul TP 72037 EasyTouch controller is derived from EGALAX
>> controller and is capable of detecting dual contacts. Packets can be 5
>> bytes or 10 bytes long, depending whether one or two contacts are
>> detected. Format is same as EGALAX touch controller, but with x and y
>> coordinates inverted.
>>
>> Signed-off-by: Armando Visconti<armando.visconti@st.com>
>> Signed-off-by: Viresh Kumar<viresh.kumar@st.com>
>> Signed-off-by: Dmitry Torokhov<dtor@mail.ru>
>> ---
>>
>> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
>> index 2b21a70..2acf16f 100644
>> --- a/drivers/input/touchscreen/Kconfig
>> +++ b/drivers/input/touchscreen/Kconfig
>> @@ -607,6 +607,7 @@ config TOUCHSCREEN_USB_COMPOSITE
>>   	  - JASTEC USB Touch Controller/DigiTech DTR-02U
>>   	  - Zytronic controllers
>>   	  - Elo TouchSystems 2700 IntelliTouch
>> +	  - EasyTouch USB Touch Controller from Data Modul
>>
>>   	  Have a look at<http://linux.chapter7.ch/touchkit/>  for
>>   	  a usage description and the required user-space stuff.
>> @@ -711,6 +712,14 @@ config TOUCHSCREEN_USB_NEXIO
>>   	bool "NEXIO/iNexio device support" if EXPERT
>>   	depends on TOUCHSCREEN_USB_COMPOSITE
>>
>> +config TOUCHSCREEN_USB_EASYTOUCH
>> +	default y
>> +	bool "EasyTouch USB Touch controller device support" if EMBEDDED
>> +	depends on TOUCHSCREEN_USB_COMPOSITE
>> +	help
>> +	  Say Y here if you have a EasyTouch USB Touch controller device support.
>> +	  If unsure, say N.
>> +
>>   config TOUCHSCREEN_TOUCHIT213
>>   	tristate "Sahara TouchIT-213 touchscreen"
>>   	select SERIO
>> diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
>> index 9dbd8b4..5813089 100644
>> --- a/drivers/input/touchscreen/usbtouchscreen.c
>> +++ b/drivers/input/touchscreen/usbtouchscreen.c
>> @@ -17,6 +17,7 @@
>>    *  - Zytronic capacitive touchscreen
>>    *  - NEXIO/iNexio
>>    *  - Elo TouchSystems 2700 IntelliTouch
>> + *  - EasyTouch USB Dual/Multi touch controller from Data Modul
>>    *
>>    * Copyright (C) 2004-2007 by Daniel Ritz<daniel.ritz@gmx.ch>
>>    * Copyright (C) by Todd E. Johnson (mtouchusb.c)
>> @@ -140,6 +141,7 @@ enum {
>>   	DEVTYPE_TC45USB,
>>   	DEVTYPE_NEXIO,
>>   	DEVTYPE_ELO,
>> +	DEVTYPE_ETOUCH,
>>   };
>>
>>   #define USB_DEVICE_HID_CLASS(vend, prod) \
>> @@ -245,6 +247,10 @@ static const struct usb_device_id usbtouch_devices[] = {
>>   	{USB_DEVICE(0x04e7, 0x0020), .driver_info = DEVTYPE_ELO},
>>   #endif
>>
>> +#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
>> +	{USB_DEVICE(0x7374, 0x0001), .driver_info = DEVTYPE_ETOUCH},
>> +#endif
>> +
>>   	{}
>>   };
>>
>> @@ -326,6 +332,47 @@ static int egalax_get_pkt_len(unsigned char *buf, int len)
>>   }
>>   #endif
>>
>> +/*****************************************************************************
>> + * EasyTouch part
>> + */
>> +
>> +#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
>
> here, some lines are missing:
>    #ifndef MULTI_PACKET
>    #define MULTI_PACKET
>    #endif
> adding these will fix the compile error.
>

Correct.
Thanks for pointing out this stupid mistake...
We'll change it.

>> +
>> +#define EGALAX_PKT_TYPE_MASK		0xFE
>> +#define EGALAX_PKT_TYPE_REPT		0x80
>> +#define EGALAX_PKT_TYPE_REPT2		0xB0
>> +#define EGALAX_PKT_TYPE_DIAG		0x0A
>
> The names here are wrong. The prefix EGALAX_ is only for eGalax controllers and some
> of them are already defined in the eGalax part of the driver. This will re-define them
> which is not good. Please use ETOUCH_... instead.
>

Yes, it makes sense.

>> +
>> +static int etouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
>> +{
>> +	if ((pkt[0]&  EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT&&
>> +		(pkt[0]&  EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT2)
>> +		return 0;
>> +
>> +	dev->x = ((pkt[1]&  0x1F)<<  7) | (pkt[2]&  0x7F);
>> +	dev->y = ((pkt[3]&  0x1F)<<  7) | (pkt[4]&  0x7F);
>> +	dev->touch = pkt[0]&  0x01;
>> +
>> +	return 1;
>> +}
>> +
>> +static int etouch_get_pkt_len(unsigned char *buf, int len)
>> +{
>> +	switch (buf[0]&  EGALAX_PKT_TYPE_MASK) {
>> +	case EGALAX_PKT_TYPE_REPT:
>> +	case EGALAX_PKT_TYPE_REPT2:
>> +		return 5;
>
> The description states that packets can be 10 bytes long, but this case is not
> handled here. How does the 10 byte packet look like? Is it two five byte packets?
> How is the format? What is contained in the other 5 bytes?
>

It is handled by usbtouch_process_multi() calling the packet processing
twice. The format is '5 bytes' for a single contact and 10 bytes (5 + 5)
for dual contact.

In the 10 bytes packet the info for first contact starts with 0x80 as
for a normal EGALAX, while the info for the second contact starts with
a 0xB0.

So, in case of 10 bytes packet, usbtouch_process_multi() will call the
processing routines twice.


> Anyway: if it's two 5 byte packets, shouldn't the data from both packets be used
> for _one_ input event for increased accuracy or something?
> If it's not two 5 byte packets, the function must return 10 for a 10 byte packet.
> Otherwise the driver will have to sync for each packet (which works fine but is slower).
>

Initially I have done exactly the way you are suggesting.

But then, it seemed to me more appropriate to reuse the capability of
the usbtouch_process_multi() to process more data in the same packet.

And pls note that I'm not using MT protocol to send the info up to the
input device. The contacts info are sent as separate events.

So, what to do here?


>> +
>> +	case EGALAX_PKT_TYPE_DIAG:
>> +		if (len<  2)
>> +			return -1;
>> +
>> +		return buf[1] + 2;
>> +	}
>> +
>> +	return 0;
>> +}
>> +#endif
>>
>>   /*****************************************************************************
>>    * PanJit Part
>> @@ -1175,6 +1222,18 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
>>   		.exit		= nexio_exit,
>>   	},
>>   #endif
>> +#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
>> +	[DEVTYPE_ETOUCH] = {
>> +		.min_xc		= 0x0,
>> +		.max_xc		= 0x07ff,
>> +		.min_yc		= 0x0,
>> +		.max_yc		= 0x07ff,
>> +		.rept_size	= 16,
>> +		.process_pkt	= usbtouch_process_multi,
>> +		.get_pkt_len	= etouch_get_pkt_len,
>> +		.read_data	= etouch_read_data,
>> +	},
>> +#endif
>>   };
>>
>>
>
> Cheers
> -daniel

Thanks for reviewing.

Rgds,
Arm

-- 
-- "Every step appears to be the unavoidable consequence of the
-- preceding one." (A. Einstein)
-- 
Armando Visconti                  Mobile: (+39) 346 8879146
Senior SW Engineer                Fax:    (+39) 02 93519290
CPG                               Work:   (+39) 02 93519683
Computer System Division          e-mail: armando.visconti@st.com
ST Microelectronics               TINA:   051  4683


