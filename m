Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2E1Rkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 13:40:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36734 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2E1Rkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 13:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaRSE9ixE6qdJK+X_WqFQt7KauiUxZDpjNjng0U9SVacg@mail.gmail.com>
References: <1338187691-32616-1-git-send-email-dbaryshkov@gmail.com>
	<CACRpkdaRSE9ixE6qdJK+X_WqFQt7KauiUxZDpjNjng0U9SVacg@mail.gmail.com>
Date: Mon, 28 May 2012 21:40:44 +0400
Message-ID: <CALT56yN1=J_AgBQg06mngJsEhW+HvUKOCymnXZSJaAf8DSBvKA@mail.gmail.com>
Subject: Re: [PATCH][V2] gpio: add a driver for GPIO pins found on AMD-8111
 south bridge chips
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 28, 2012 at 8:19 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, May 28, 2012 at 2:48 PM, Dmitry Eremin-Solenikov
> <dbaryshkov@gmail.com> wrote:
>
>> Add a driver to use GPIO pins available on several AMD south bridges
>> (currently only AMD 8111 is supported).
>>
>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> ---
>>
>> Changes since V1:
>> * Replaced magic numbers in register access with named values
>
> This is looking a lot better, some nitpicking:

Oh, my, I forgot to change module_init/module_exit function names.
So anyway I'll have to send V3

>
>> +#define AMD_GPIO_MODE_ALTFN    0x08 /* Or 0x09 */
>
> Hm Hm I wonder what this register does... looks a lot like a mux.
> (Just philisophizing...)

As the name says, it is an "alternate function". Some (most) of these pins
can have alternative functions like "clock output", IRQ, SMBus, etc. Setting
this ALTFN mode enables special logic for that pin.

>
>> +static int __init mod_init(void)
>> +{
>> +       int err = -ENODEV;
>> +       struct pci_dev *pdev = NULL;
>> +       const struct pci_device_id *ent;
>> +
>> +       for_each_pci_dev(pdev) {
>> +               ent = pci_match_id(pci_tbl, pdev);
>> +               if (ent)
>> +                       goto found;
>
> It's not like I know how PCI abstractions really work, but what happens
> here if there would be two instances of the device? It looks like you will
> only find the first?

Hmm. I don't know a system with two amd 8111 south bridges in it.
This part is mostly a c&p from amd hw_random driver.

>
>> +       }
>> +       /* Device not found. */
>> +       goto out;
>
> Can't you just return -ENODEV here? Why jump around...

OK.

>
> Now as I said I'm not a PCI expert, but isn't the proper way to do this
> to use this stuff:
>
> static struct pci_driver amd_gpio_driver = {
>        .name =         "amd-gpio",
>        .id_table =     pci_ids,
>        .probe =        amd_gpio_probe,
>        .remove =       __devexit_p(amd_gpio_remove),
> };
>
> static int __init amd_gpio_init(void)
> {
>        return pci_register_driver(&amd_gpio_driver);
> }
>
> static void __exit amd_gpio_exit(void)
> {
>        pci_unregister_driver(&amd_gpio_driver);
> }
>
> module_init(amd_gpio_init);
> module_exit(amd_gpio_exit);
>
> Then start working from the probe function insteaf of go and
> iterate over the PCI bus yourself? I was thinking there was a
> reason for but couldn't find any.

It would be the usual way. There is however a problem with that way.
The System Management devices (that the driver looks for):

1) Is a kind of placeholder. If you check, the driver get's the IO address
    not via usual pci_resource_start()/_end(), which end up with the data
    from BARs from pci device, but does special register access magic

2) Is a multifunction device. The IO space that is provided by the device
   is used for HW random generator, I2C (well, SMBus) controller, now
   the GPIO pins driver. Also it covers some power management/SMI/SCI
   magic, which usually nobody should touch. So, in the ideal world,
   we should register an MFD driver over that PCI device and then
   register all other child sub-devices. However this looks like a
huger overkill
   to me. In the end, it's just a GPIO part of south bridge, which should
   not be touched by normal people :)

-- 
With best wishes
Dmitry
