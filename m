Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0JRPrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:47:06 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:8835 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab0JRPrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:47:04 -0400
X-IronPort-AV: E=Sophos;i="4.57,345,1283745600"; 
   d="scan'208";a="23598322"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Jean Delvare <khali@linux-fr.org>, David Brownell <david-b@pacbell.net>
CC: Mike Frysinger <vapier@gentoo.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Mon, 18 Oct 2010 16:46:59 +0100
Subject: RE: [PATCH] i2c: add irq_flags to board info
Thread-Topic: [PATCH] i2c: add irq_flags to board info
Thread-Index: Actu0YolQ5+LMjeDSwq6RBmSVk18QgAAQrfA
Message-ID: <544AC56F16B56944AEC3BD4E3D59177130945210E4@LIMKCMBX1.ad.analog.com>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org>
	<20101018103610.77b7e605@endymion.delvare>
	<544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com>
	<20101018140136.2b44d29e@endymion.delvare>
	<544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com>
 <20101018163357.659efe25@endymion.delvare>
In-Reply-To: <20101018163357.659efe25@endymion.delvare>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote on 2010-10-18:
> Hi Michael, David,
>
> David, question for you below.
>
> On Mon, 18 Oct 2010 13:31:21 +0100, Hennerich, Michael wrote:
>> Jean Delvare wrote on 2010-10-18:
>>> Hi Michael,
>>>
>>> On Mon, 18 Oct 2010 10:55:57 +0100, Hennerich, Michael wrote:
>>>> Jean Delvare wrote on 2010-10-18:
>>>>> Hi Mike,
>>>>>
>>>>> On Sun, 17 Oct 2010 19:43:39 -0400, Mike Frysinger wrote:
>>>>>> From: Michael Hennerich <michael.hennerich@analog.com>
>>>>>>
>>>>>> These flags can be optionally defined - slave drivers may use
>>>>>> them as flags argument for request_irq().  In case they are
>>>>>> left uninitialized they will default to zero, and therefore
>>>>>> shouldn't cause problems.
>>>>>>
>>>>>> This allows us to avoid having to add dedicated platform init
>>>>>> code just to call set_irq_type()
>>>>>
>>>>> Do you have examples of this? Can we see a preview of the amount
>>>>> of cleanups this patch would allow?
>>>>
>>>> Examples can be found in various board setup files:
>>>>
>>>> One example arch/sh/boards/mach-ecovec24/setup.c:
>>>>
>>>> static struct i2c_board_info ts_i2c_clients = {
>>>>         I2C_BOARD_INFO("tsc2007", 0x48),
>>>>         .type           = "tsc2007",
>>>>         .platform_data  = &tsc2007_info,
>>>>         .irq            = IRQ0,
>>>> };
>>>>
>>>> [--snip--]
>>>>
>>>>                 /* enable TouchScreen */
>>>>                 i2c_register_board_info(0, &ts_i2c_clients, 1);
>>>>                 set_irq_type(IRQ0, IRQ_TYPE_LEVEL_LOW);
>>>
>>> This example doesn't quite match the patch description. There's no
>>> "dedicated platform init code just to call set_irq_type()", as you
>>> already have platform code to call i2c_register_board_info(). It's
>>> really only calling set_irq_type() from platform code vs. from
>>> driver code.
>>
>> In the past I also saw initcalls just doing set_irq_type(), to make
>> drivers happy. That doesn't pass the right irq_flags along with
>> request_irq().
>
> But it's OK to call request_irq() without these flags, as long as
> set_irq_type() is called additionally, isn't it?

Yeah - it is. But fact is, set_irq_type() is typically called in advance.
So if the driver that requires the irq_type setting isn't loaded at all,
nothing calls request_irq().

> Why do we have set_irq_type() if we're not supposed to call it? I am
> not claiming to be an expert in the area, but it seems totally
> reasonable to me that the same piece of code instantiating an I2C
> device is also responsible for setting its IRQ type.

I would leave that up to the driver. The driver author knows which irq types the
device may support and which can be handled by the driver.

If someone passes an IRQF_TRIGGER_FALLING, but the hardware device only supports rising edge
interrupts the driver can error verbose.

Drivers that doesn't set irq_type flags with request_irq() typically avoid it, since
some architectures doesn't support edge or level sensitive interrupts.
So historically seen, it was a way to keep this decision out of the driver file.

>>
>>>>>> -- which doesn't work very well when coupled with module
> drivers.
>>>>>
>>>>> I don't quite get what you mean here.
>>>>
>>>> Since the driver doesn't setup the irq_type itself you need to do it
>>>> manually in advance using set_irq_type(). This happens most likely
>>>> from your paltform setup/configuration file.
>>>>
>>>> Assuming the driver is built as a module, this code gets executed
>>>> unconditionally, no matter if the driver gets finally loaded or not.
>>>>
>>>> Assuming you have several drivers build as modules, using the
>>>> same irq but with different irq types, you run into problems here.
>>>
>>> I do not get why.
>>>
>>> You're not going to register several I2C devices using the same
>>> IRQ but requiring different IRQ flags anyway, as it wouldn't work.
>>> So you'll have to only register the I2C devices which are actually
>>> present on the system. Setting the IRQ type at the same time or
>>> deferring this action to the driver(s) doesn't make any difference
> then, does it?
>>
>> If I remember correctly i2c as well as spi doesn't check for irq
>> conflicts in irqs passed with struct i2c/spi_board_info. So you can
>> have multiple drivers build as modules all using the same irq number
> but with different flags.
>
> Indeed i2c doesn't check the IRQs at all, it passes them transparently
> from platform data to device driver.
>
> But you're mixing devices and drivers. Devices are bound to an IRQ,
> not drivers, and so do IRQ flags.

I know the difference. But I'm talking here about different drivers.
Think about a system where you have different hardware options, all handled by the same
kernel image. Option a) modprobe driver_a, Option b) modprobe driver_b.
Both devices bound to driver_a and driver_b, both use IRQ_XY. However a) requires IRQF_TRIGGER_FALLING,
while b) needs IRQF_LEVEL_LOW.

To me is sounds reasonable to set irq_type only if the request_irq() succeeds.

>>
>> The user decides which add-on module is plugged onto the processor
>> board, by loading the appropriate driver module.
>
> This can't work, sorry. Unless you are using I2C device
> auto-detection, which I seem to understand is NOT used in the embedded
> world at all, loading a driver module doesn't do anything if a device
> it supports hasn't been instantiated first. So the user can't just
> load a driver and see the required I2C devices magically appear for
> the driver to bind to them.

That's not what I'm saying here.

> So the first problem you have to solve is how you instantiate the
> right I2C devices depending on which extension is plugged in. As long
> as this problem isn't solved, there's no point in discussing where the
> IRQ flags should be set.

i2c_register_board_info()/spi_register_board_info() may provide resources for all
devices potentially used with your system.
They doesn't necessarily need to be physically present,
nor does the driver they belong to need to be loaded.

However when loading module a) or b) I would expect that the system uses the right irq_type for
The device bound to a/b).

>>>> There are some development boards featuring extension options,
>>>> which all plug on the same socket but required different
> drivers/irq types.
>>>
>>> How do you figure out which extension option is plugged? You can't
>>> instantiate an I2C device which isn't present, so you must have a
>>> way to know what extension option is used, to instantiate the
>>> right I2C device at the right address.
>>
>> The user decides. The platform code provides resources for all
>> potential boards being used. And here is exactly the conflict.
>
> "Provides", how? It can't possibly instantiate them all. Please
> describe the mechanism.
>
>>>> The ideal way is therefore to pass the irq_flags together with
>>>> the
>>> SPI/I2C board info.
>>>
>>> All I see so far is two data structures made slightly larger, for no
>>> actual benefit.
>>
>> I don't see a reason why i2c/spi bus drivers should be different from
>> other bus drivers. The platform_device bus driver allows you to pass
>> IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL with flags in struct resource.
>
> This is an interesting point. David, you're the one who added irq to
> struct i2c_client, you didn't add irq_flags then, did you have a good
> reason not to?
>
>> There are drivers that work around this deficiency, by adding
>> irq_flags to the bus clients dev.platform_data See
> include/linux/spi/ads7846.h for one example.
>
> Interesting example, better matching the initial comment that came
> along with the patch. But it also seems to be an isolated case, as I
> can't find any other irq_flags in include/linux/{i2c,spi}/.

I think David agrees, that this is an old, and from time to time
reoccurring discussion. And if I remember correctly David is a advocate
of the unconditional set_irq_type() methodology.

Adding these four irq_type bytes, may ultimately stop it, now and forever.

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


