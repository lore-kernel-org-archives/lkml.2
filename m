Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1AJLsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:48:02 -0500
Received: from gateway.heeltoe.com ([66.134.219.32]:54777 "EHLO
	gateway.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1AJLsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:48:00 -0500
X-DKIM: Sendmail DKIM Filter v2.5.4 gateway.heeltoe.com 3B4A6CC05D
Message-ID: <4D2AF1EE.8010105@heeltoe.com>
Date: Mon, 10 Jan 2011 06:47:58 -0500
From: Brad Parker <brad@heeltoe.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: bryan.wu@canonical.com
CC: felipe.balbi@nokia.com, linux-usb@vger.kernel.org, david-b@pacbell.net,
        kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        ricardo.salveti@canonical.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget
 code (v2)
References: <1279895783-7313-1-git-send-email-bryan.wu@canonical.com> <4C600171.5020405@canonical.com> (sfid-20100809_092446_058851_C2E783C7)
In-Reply-To: <4C600171.5020405@canonical.com> (sfid-20100809_092446_058851_C2E783C7)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know this is a top post, and a comment on a post from August, but I'd like
to point out that without this patch I can't get musb host mode to work
on the beagle board xm (3630).

With this patch, host mode works.  If I disconnect and reconnect the port
goes into "a_idle", which is almost right, and will go into host mode if
I "echo >/sys/devices/platform/musb_hdrc/mode".

(my expectation is that the mode should toggle from "b_idle" to "a_host"
when I plug in an a connector with the id pin tied correctly, and back 
to "b_idle"
when I disconnect)

It seems like few people people test host mode on the omap twl otg port,
but I have applications which use it...

should this patch get more attention?  (there was no response to the 
initial post I could find)

-brad

Bryan Wu wrote:
> Felipe,
>
> Any comments on this patch?
>
> Thanks a lot,
> -Bryan
>
>
> On 07/23/2010 10:36 PM, Bryan Wu wrote:
>> BugLink: http://bugs.launchpad.net/bugs/608312
>>
>> v2:
>> fix the building error on latest 2.6.35-rc kernel, since v1 was 
>> generated in
>> 2.6.33 kernel.
>>
>> v1:
>> usb_add_hcd was only called when we insmod the gadget class module or 
>> built-in
>> that gadget class driver. If musb is configured as OTG controller, we 
>> need to
>> insmod or built-in gadget class driver to make our Host mode fucntion 
>> works.
>>
>> In our Ubuntu system, normally we compiled all the gadget class 
>> drivers as
>> modules. Then users can insmod the gadget modules as they want. But 
>> without the
>> gadget class driver running, we needs host function to support common 
>> USB
>> devices.
>>
>> This patch fix this issue and tested on omap3 beagle board and 
>> Gumstix board.
>>
>> Signed-off-by: Bryan Wu<bryan.wu@canonical.com>
>> ---
>>   drivers/usb/musb/musb_core.c   |   13 +++++--------
>>   drivers/usb/musb/musb_gadget.c |   18 ------------------
>>   2 files changed, 5 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
>> index 3b795c5..1b6d74c 100644
>> --- a/drivers/usb/musb/musb_core.c
>> +++ b/drivers/usb/musb/musb_core.c
>> @@ -1583,14 +1583,6 @@ irqreturn_t musb_interrupt(struct musb *musb)
>>           (devctl&  MUSB_DEVCTL_HM) ? "host" : "peripheral",
>>           musb->int_usb, musb->int_tx, musb->int_rx);
>>
>> -#ifdef CONFIG_USB_GADGET_MUSB_HDRC
>> -    if (is_otg_enabled(musb) || is_peripheral_enabled(musb))
>> -        if (!musb->gadget_driver) {
>> -            DBG(5, "No gadget driver loaded\n");
>> -            return IRQ_HANDLED;
>> -        }
>> -#endif
>> -
>>       /* the core can interrupt us for multiple reasons; docs have
>>        * a generic interrupt flowchart to follow
>>        */
>> @@ -2128,6 +2120,11 @@ bad_config:
>>
>>           status = musb_gadget_setup(musb);
>>
>> +        if (is_otg_enabled(musb)) {
>> +            status = usb_add_hcd(musb_to_hcd(musb), -1, 0);
>> +            musb_start(musb);
>> +        }
>> +
>>           DBG(1, "%s mode, status %d, dev%02x\n",
>>               is_otg_enabled(musb) ? "OTG" : "PERIPHERAL",
>>               status,
>> diff --git a/drivers/usb/musb/musb_gadget.c 
>> b/drivers/usb/musb/musb_gadget.c
>> index 6fca870..9e55534 100644
>> --- a/drivers/usb/musb/musb_gadget.c
>> +++ b/drivers/usb/musb/musb_gadget.c
>> @@ -1761,24 +1761,6 @@ int usb_gadget_register_driver(struct 
>> usb_gadget_driver *driver)
>>           otg_set_peripheral(musb->xceiv,&musb->g);
>>
>>           spin_unlock_irqrestore(&musb->lock, flags);
>> -
>> -        if (is_otg_enabled(musb)) {
>> -            DBG(3, "OTG startup...\n");
>> -
>> -            /* REVISIT:  funcall to other code, which also
>> -             * handles power budgeting ... this way also
>> -             * ensures HdrcStart is indirectly called.
>> -             */
>> -            retval = usb_add_hcd(musb_to_hcd(musb), -1, 0);
>> -            if (retval<  0) {
>> -                DBG(1, "add_hcd failed, %d\n", retval);
>> -                spin_lock_irqsave(&musb->lock, flags);
>> -                otg_set_peripheral(musb->xceiv, NULL);
>> -                musb->gadget_driver = NULL;
>> -                musb->g.dev.driver = NULL;
>> -                spin_unlock_irqrestore(&musb->lock, flags);
>> -            }
>> -        }
>>       }
>>
>>       return retval;
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

