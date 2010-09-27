Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab0I0J5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:57:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37601 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab0I0J5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wvRipHEHFCaBUwg6GMnuUzrDko0nggYxbFqxtrZiI67lj9NpZWsbegHAaS0QUDzH6D
         B2DPbBCccJZafaVyL4dKKMDrQC6EeF5MworrAoiTTxUeD7MzCXNJWMT4cClbHEctQFlB
         8tdA2fONMUmYI6BdL/xvFVmCIQN3t8gvgouUM=
MIME-Version: 1.0
In-Reply-To: <20100927061840.GA22913@legolas.emea.dhcp.ti.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
	<20100927061840.GA22913@legolas.emea.dhcp.ti.com>
Date: Mon, 27 Sep 2010 12:57:50 +0300
Message-ID: <AANLkTik8v4B_Y44oJBbkFOtJDMhS5zFbgqysj0xKEu-7@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: balbi@ti.com
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

On Mon, Sep 27, 2010 at 9:18 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Sun, Sep 26, 2010 at 02:35:40PM -0500, Grazvydas Ignotas wrote:
>>
>> TWL4030/TPS65950 is a multi-function device with integrated charger,
>> which allows charging from AC or USB. This driver enables the
>> charger and provides several monitoring functions.
>>
>> Tested on OMAP3 Pandora board.
>>
>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>> ---
>> This is v3 of BCI charger driver I first sent nearly a year ago [1].
>> I've updated it to use the new OTG notifiers for VBUS notifications,
>> however it still is not able to determine charge current to use.
>> For that reason there is now a temporary module param to enable USB
>> charging, until I can figure out how to get that info from the gadget
>> stack (hopefully Felipe can help me here).
>
> You need to send USB_EVENT_ENUMERATED from usb_gadget_vbus_draw(), but
> wait until the UDC class is finished, then we will have a common
> location to do those stuff.

ok, I hope I can get CCed or notified in some way as I might miss that.

<snip>

>> +
>> +       ret = request_threaded_irq(bci->irq_bci, NULL,
>> +               twl4030_bci_interrupt, 0, pdev->name, bci);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "could not request irq %d, status
>> %d\n",
>> +                       bci->irq_bci, ret);
>> +               goto fail_bci_irq;
>> +       }
>
> you should register the power_supply before enabling the IRQ lines,
> otherwise you might call power_supply_changed() to a non-existent
> power_supply.

good catch, will do.

<snip>

>> +
>> +#ifdef CONFIG_USB_OTG_UTILS
>> +       bci->transceiver = otg_get_transceiver();
>> +#endif
>
> this driver should actually depend on that. It won't work without access
> to the transceiver anyway.

Well it can still do AC charging fine without OTG stuff.

> Or you add something like:
>
> #ifdef CONFIG_USB_OTG_UTILS
> extern struct otg_transceiver *otg_get_transceiver(void);
> extern void otg_put_transceiver(struct otg_transceiver *);
> #else
> static inline struct otg_transceiver *otg_get_transceiver(void)
> { return NULL; }
> static inline void otg_put_transceiver(struct otg_transceiver *x)
> { }
> #endif

I much prefer that, will send a patch.

>
> to the otg.h and avoid having to use that ifdef here and on any other
> driver. (should be a separate patch though).
>
>> +static struct platform_driver twl4030_bci_driver = {
>> +       .probe          = twl4030_bci_probe,
>
> drivers should not reference __init sections anymore. If you make this
> statically linked to the kernel, you'll get section mismatches. It's
> better to make probe __init remove it from here and call
> platform_driver_probe() from module_init();

Tried that and did not get any section mismatches, but will switch
anyway to better match trends.

>
>> +       .remove         = __devexit_p(twl4030_bci_remove),
>> +       .driver         = {
>> +               .name   = "twl4030_bci",
>> +               .owner  = THIS_MODULE,
>> +       },
>> +};
>
> --
> balbi
>
