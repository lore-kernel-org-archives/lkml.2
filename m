Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1HVOxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:53:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42598 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1HVOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:53:42 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/4] usb: Provide usb_device_speed_name() function
References: <cover.1313791722.git.mina86@mina86.com>
 <7e9435f5e8c2e9d6363d79de79f81b4f259e230c.1313791722.git.mina86@mina86.com>
 <20110819231459.GB13317@legolas.emea.dhcp.ti.com>
Date: Mon, 22 Aug 2011 16:53:38 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0mebojk3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110819231459.GB13317@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011 01:15:00 +0200, Felipe Balbi <balbi@ti.com> wrote:

> On Sat, Aug 20, 2011 at 12:32:59AM +0200, Michal Nazarewicz wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>>
>> In a few places kernel wants to print a human-readable USB
>> device speed name (eg. "high") instead of a raw number
>> (eg. 3).  Usually a switch is introduced in those places
>> leading to code repetition.  To mitigate this issue, this
>> commit introduces usb_device_speed_name() function, which
>> returns a human-readable name of provided speed.
>>
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>> ---
>>  drivers/usb/Makefile          |    3 +++
>>  drivers/usb/common.c          |   24 ++++++++++++++++++++++++
>>  drivers/usb/gadget/udc-core.c |   19 ++-----------------
>>  include/linux/usb/ch9.h       |    8 ++++++++
>>  4 files changed, 37 insertions(+), 17 deletions(-)
>>  create mode 100644 drivers/usb/common.c
>>
>> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
>> index 30ddf8d..a3167cc 100644
>> --- a/drivers/usb/Makefile
>> +++ b/drivers/usb/Makefile
>> @@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
>>  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
>>  obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
>>  obj-$(CONFIG_USB_GADGET)	+= gadget/
>> +
>> +obj-$(CONFIG_USB)		+= common.o
>> +obj-$(CONFIG_USB_GADGET)	+= common.o
>> diff --git a/drivers/usb/common.c b/drivers/usb/common.c
>> new file mode 100644
>> index 0000000..e9d7141
>> --- /dev/null
>> +++ b/drivers/usb/common.c
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Provides code common for host and device side USB.
>> + */
>> +
>> +#include <linux/kernel.h>  /* for ARRAY_SIZE() */
>> +#include <linux/module.h>  /* for EXPORT_SYMBOL_GPL() */
>> +#include <linux/usb/ch9.h>
>> +
>> +const char *usb_device_speed_name(enum usb_device_speed speed)
>
> somehow usb_speed_string() sounds better to me.

Done.

>> +{
>> +	static const char *const names[] = {
>> +		"UNKNOWN",
>> +		"low-speed",
>> +		"full-speed",
>> +		"high-speed",
>> +		"wireless",
>> +		"super-speed",
>> +	};
>> +
>> +	if (speed < 0 || speed >= ARRAY_SIZE(names))
>> +		speed = USB_SPEED_UNKNOWN;
>
> I generally dislike depending on a particular ordering of enumerations.
> While's it's highly unlikely that anyone will change that, if someone
> does change, then it'll take a long time to actually find the bug on the
> print here :-)
>
> I woud rather use a switch in this case.

Would a C99 initialisation be fine by you?

I, myself, have this aversion to switch as being slower (which is
disputable) and too verbose.


>> diff --git a/drivers/usb/gadget/udc-core.c  
>> b/drivers/usb/gadget/udc-core.c
>> index 05ba472..e1ecdbc 100644
>> --- a/drivers/usb/gadget/udc-core.c
>> +++ b/drivers/usb/gadget/udc-core.c
>> @@ -375,23 +375,8 @@ static ssize_t usb_udc_speed_show(struct device  
>> *dev,
>>  		struct device_attribute *attr, char *buf)
>>  {
>>  	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
>> -	struct usb_gadget	*gadget = udc->gadget;
>> -
>> -	switch (gadget->speed) {
>> -	case USB_SPEED_LOW:
>> -		return snprintf(buf, PAGE_SIZE, "low-speed\n");
>> -	case USB_SPEED_FULL:
>> -		return snprintf(buf, PAGE_SIZE, "full-speed\n");
>> -	case USB_SPEED_HIGH:
>> -		return snprintf(buf, PAGE_SIZE, "high-speed\n");
>> -	case USB_SPEED_WIRELESS:
>> -		return snprintf(buf, PAGE_SIZE, "wireless\n");
>> -	case USB_SPEED_SUPER:
>> -		return snprintf(buf, PAGE_SIZE, "super-speed\n");
>> -	case USB_SPEED_UNKNOWN:	/* FALLTHROUGH */
>> -	default:
>> -		return snprintf(buf, PAGE_SIZE, "UNKNOWN\n");
>> -	}
>> +	return snprintf(buf, PAGE_SIZE, "%s\n",
>> +			usb_device_speed_name(udc->gadget->speed));
>>  }
>>  static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
>
> you said 'several locations', but there's only one ? No other driver is
> using something similar ?

OK, you caught me on being lazy... ;)  Hunted down a few more instances.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
