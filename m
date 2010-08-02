Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0HBSZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:25:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44482 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0HBSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:25:30 -0400
Date: Mon, 2 Aug 2010 20:25:21 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>,
        Julia Lawall <julia@diku.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: don't save bind callback in struct
	usb_gadget_driver
Message-ID: <20100802182521.GA4151@pengutronix.de>
References: <op.vgs04dub7p4s8u@pikus> <1280752803-11441-1-git-send-email-u.kleine-koenig@pengutronix.de> <op.vgtecwcq7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vgtecwcq7p4s8u@pikus>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michał,

On Mon, Aug 02, 2010 at 04:25:34PM +0200, Michał Nazarewicz wrote:
> Some random thoughts, one bug and mostly just minor comments:
>
>> @@ -1954,13 +1954,14 @@ static int setup_ep0(struct udc *dev)
>>  }
>> /* Called by gadget driver to register itself */
>> -int usb_gadget_register_driver(struct usb_gadget_driver *driver)
>> +int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
>> +		int (*bind)(struct usb_gadget *))
>>  {
>>  	struct udc		*dev = udc;
>>  	int			retval;
>>  	u32 tmp;
>> -	if (!driver || !driver->bind || !driver->setup
>> +	if (!driver || bind || !driver->setup
>
>
> ** BUG: Should read "!bind".
Yeah, Julia already pointed that out.

>> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
>> @@ -1612,7 +1613,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
>>  	DBG("bound to %s\n", driver->driver.name);
>>  	return 0;
>>  }
>> -EXPORT_SYMBOL (usb_gadget_register_driver);
>> +EXPORT_SYMBOL (usb_gadget_probe_driver);
>
> How about also correcting space before "("?
Fixed.

>> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
>> @@ -1789,7 +1789,8 @@ out:
>>  	return IRQ_HANDLED;
>>  }
>> -int usb_gadget_register_driver(struct usb_gadget_driver *driver)
>> +int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
>> +		int (*bind)(struct usb_gadget *))
>>  {
>>  	struct usba_udc *udc = &the_udc;
>>  	unsigned long flags;
>
> There was no checking here?  How about adding?
Hmmm, I think this should be addressed in a different patch.

>> diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
>> @@ -2340,12 +2340,13 @@ static const struct usb_ep_ops usb_ep_ops = {
>>  static const struct usb_gadget_ops usb_gadget_ops;
>> /**
>> - * usb_gadget_register_driver: register a gadget driver
>> + * usb_gadget_probe_driver: register a gadget driver
>>   *
>> - * Check usb_gadget_register_driver() at "usb_gadget.h" for details
>> - * Interrupts are enabled here
>> + * Check usb_gadget_probe_driver() at "usb_gadget.h" for details.
>> + * Interrupts are enabled here.
>>   */
>
> usb_gadget.h is the old name.  How about correcting it as well?
done.

>
>> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
>> @@ -3583,7 +3582,7 @@ static int __init fsg_init(void)
>>  	if ((rc = fsg_alloc()) != 0)
>>  		return rc;
>>  	fsg = the_fsg;
>> -	if ((rc = usb_gadget_register_driver(&fsg_driver)) != 0)
>> +	if ((rc = usb_gadget_probe_driver(&fsg_driver, fsg_bind)) != 0)
>
> I'm tempted to propose:
>
> + rc = usb_gadget_probe_driver(&fsg_driver, fsg_bind);
> + if (rc != 0)
>
> which is more compatible with coding style but it probably would be inconsistent
> with the rest of the code.
>
>> diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
>> @@ -1807,7 +1807,8 @@ static DEVICE_ATTR(langwell_udc, S_IRUGO, show_langwell_udc, NULL);
>>   * the driver might get unbound.
>>   */
>> -int usb_gadget_register_driver(struct usb_gadget_driver *driver)
>> +int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
>> +		int (*bind)(struct usb_gadget *))
>>  {
>>  	struct langwell_udc	*dev = the_controller;
>>  	unsigned long		flags;
>
> Again, function has no checking, how about adding?
as above, IMHO this should be a seperate patch.

>> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
>> @@ -1698,7 +1698,8 @@ void musb_gadget_cleanup(struct musb *musb)
>>   * @param driver the gadget driver
>>   * @return <0 if error, 0 if everything is fine
>>   */
>
> I've just noticed that it misses @param bind in the comment.  Would be great to update it
> and all other occurrences.
done.

>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>> @@ -798,17 +797,18 @@ struct usb_gadget_driver {
>>   */
>> /**
>> - * usb_gadget_register_driver - register a gadget driver
>> - * @driver:the driver being registered
>> + * usb_gadget_probe_driver - probe a gadget driver
>> + * @driver: the driver being registered
>
> + * @bind: the driver's bind callback.
>
>>   * Context: can sleep
>>   *
>>   * Call this in your gadget driver's module initialization function,
>>   * to tell the underlying usb controller driver about your driver.
>> - * The driver's bind() function will be called to bind it to a
>> - * gadget before this registration call returns.  It's expected that
>> - * the bind() functions will be in init sections.
>> + * The bind() function will be called to bind it to a gadget before this
>> + * registration call returns.  It's expected that the bind() function will
>
> Maybe "the @bind function" in those two places?
>
> So for what it's worth, I haven't noticed any other obvious problems.
>
> I think it still does not fix all the section mismatch warnings -- would have to look
> closer at composite gadgets -- so I think still parts of my patch is legit.
I prepared a patch that removes bind from usb_configuration, too.  Find
it in reply to this mail.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
