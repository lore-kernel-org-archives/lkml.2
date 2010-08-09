Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0HIPfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:35:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64361 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0HIPfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:35:12 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 09 Aug 2010 17:36:47 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/3] usb gadget: don't save bind callback in struct
 usb_composite_driver
In-reply-to: <20100809152010.GE27747@pengutronix.de>
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <op.vg6gblz87p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <3decda614c6d8732c018417558d74ed942e76c82.1281359651.git.m.nazarewicz@samsung.com>
 <e465429de034460cdc6eff4e3502d2be83264f82.1281359651.git.m.nazarewicz@samsung.com>
 <20100809152010.GE27747@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Aug 09, 2010 at 03:33:49PM +0200, Michal Nazarewicz wrote:
>> The bind function is most of the time only called at init time so there
>> is no need to save a pointer to it in the composite driver structure.
>>
>> This fixes many section mismatches reported by modpost.

>> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>> --- a/drivers/usb/gadget/composite.c
>> +++ b/drivers/usb/gadget/composite.c
>> @@ -39,6 +39,7 @@
>>  #define USB_BUFSIZ	1024
>>
>>  static struct usb_composite_driver *composite;
>> +static int (*composite_gadget_bind)(struct usb_composite_dev *cdev);

On Mon, 09 Aug 2010 17:20:10 +0200, Uwe Kleine-König wrote:
> This can be __initdata, can't it?

No.  g_ffs.c uses usb_composite_probe() not only in init so neither
usb_composite_probe() nor this new variable can be in init section.

> I thought about usb_composite_drivers, too, and wondered if it would be
> sensible to change the additional argument of usb_gadget_probe_driver to
> struct usb_gadget_probe_data *probe_data.  Then you could do the
> following
>
> 	struct usb_composite_probe_data {
> 		struct usb_gadget_probe_data usb_probe_data;
> 		int (*composite_gadget_bind)(struct usb_composite_dev *);
> 	}
>
> and in composite_bind use container_of to get the gadget_bind function.

Yes, this seems sensible, however I'm not sure if it's worth the effort.
Note that the whole gadget API is designed in a way that there can be
only one gadget registered so that passing private data with
usb_gadget_probe_driver() as well as with usb_composite_probe() is not
really crucial and we can manage with global variables.

> Maybe that's overengineered though.  As there is already a dependency on
> a global variable (i.e. composite) your patch doesn't make it much
> worse.  Just my 0.02€.

Yep, that was my reasoning as well.

I guess we'll have to worry about it when (if) boards with many UDCs
became common. ;)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
