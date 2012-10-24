Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab2JXRqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:46:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44738 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab2JXRqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:46:32 -0400
Message-ID: <50882967.6040800@ti.com>
Date: Wed, 24 Oct 2012 19:46:15 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com> <20121022155028.GA13791@core.coreip.homeip.net> <508660D4.9030507@ti.com> <20121023200249.GA2712@core.coreip.homeip.net> <20121024083704.GF5665@arwen.pp.htv.fi> <20121024161429.GA16350@core.coreip.homeip.net>
In-Reply-To: <20121024161429.GA16350@core.coreip.homeip.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 10/24/2012 06:14 PM, Dmitry Torokhov wrote:
> On Wed, Oct 24, 2012 at 11:37:04AM +0300, Felipe Balbi wrote:
>> Hi,
>>
>> On Tue, Oct 23, 2012 at 01:02:49PM -0700, Dmitry Torokhov wrote:
>>> On Tue, Oct 23, 2012 at 11:18:12AM +0200, Benoit Cousson wrote:
>>>> Hi Dimitry,
>>>>
>>>> On 10/22/2012 05:50 PM, Dmitry Torokhov wrote:
>>>>> Hi Sourav,
>>>>>
>>>>> On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
>>>>>> Adapt keypad to use pinctrl framework.
>>>>>>
>>>>>> Tested on omap4430 sdp with 3.7-rc1 kernel.
>>>>>
>>>>> I do not see anything in the driver that would directly use pinctrl. Is
>>>>> there a better place to select default pin configuration; maybe when
>>>>> instantiating platform device?
>>>>
>>>> Why?
>>>> The devm_pinctrl_get_select_default is using the pinctrl.
>>>
>>> No, I guess we ihave different understanding of what "directly use" means.
>>> This particular driver does directly use interrupts: it requests it and
>>> performs some actions when interrupt arrives. Same goes for IO memory -
>>> it gets requested, then we access it. With pinctrl we do not do anything
>>> - we just ask another layer to configure it and that is it.
>>
>> this is true for almost anything we do:
>>
>> - we ask another layer to allocate memory for us
>> - we ask another layer to call our ISR once the IRQ line is asserted
>> - we ask another layer to handle the input events we just received
>> - we ask another layer to transfer data through DMA for us
>> - we ask another layer to turn regulators on and off.
> 
> But we are _directly_ _using_ all of these. You allocate memory and you
> (the driver) stuff data into that memory. You ask for DMA and you take
> the DMAed data and work with it. Not so with pinctrl in omap keypad and
> other drivers I have seen so far.

That's not really true. You select a pin mode and thanks to that you get
the signal from an external pin that goes to your IP.
And thanks to that the IP is doing what your are expecting it to do.

Without that your IP will not get any input signal, which will make it a
little bit useless, isn't it?

>> and so on. This is just how abstractions work, we group common parts in
>> a framework so that users don't need to know the details, but still need
>> to tell the framework when to fiddle with those resources.
>>
>>> I have seen just in a few days 3 or 4 drivers having exactly the same
>>> change - call to devm_pinctrl_get_select_default(), and I guess I will
>>> receive the same patches for the rest of input drivers shortly.
>>> This suggests that the operation is done at the wrong level. Do the
>>> pin configuration as you parse DT data, the same way you set up i2c
>>> devices registers in of_i2c.c, and leave the individual drivers that do
>>> not care about specifics alone.
>>
>> Makes no sense to hide that from drivers. The idea here is that driver
>> should know when it needs its pins to muxed correctly.
> 
> The driver also needs memory controller to be initialized, gpio chip be
> ready and registered, DMA subsystem ready, input core reade, etc, etc,
> etc. You however do not have every driver explicitly initialize any of
> that; you expect certain working environment to be already operable. The
> driver does manage resources it controls, it has ultimate knowledge
> about, pin configuration is normally is not it. We just need to know
> that we wired/muxed properly, otherwise we won't work. So please let
> parent layers deal with it.
> 
>> 95% of the time
>> it will be done during probe() but then again, so what ?
>>
>> doing that when parsing DT, or on bus notifiers is just plain wrong.
>> Drivers should be required to handle all of their resources.
> 
> All of _their_ resources, exactly. They do not own nor control pins so
> they should not be bothered with them either. Look, when you see that
> potentially _every_ driver in the system needs to set up the same object
> that it doe snot use otherwise you should realize that individual driver
> is not the proper place to do that.

What your are missing as well in that case is the explicit dependency
that this API is creating with the pinctrl driver that we are going to
miss otherwise.

Hence the following code.

+		if (PTR_ERR(keypad_data->pins) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;

If the pinctrl is not already there you defer the probe until it is there.

Moreover, as already said, we are probably at some point going to handle
as well the low power mode and thus change the pin mode upon idle/suspend.

And again, selecting a pin mode during probe is doing something with the
pins when and only when it is useful. It is not different than getting
an IRQ or DMA request at probe time.

You get it, use it for registration and that all you are doing with it.
It is no different here.

Doing that during device creation does not make sense, since that device
might never be used.

Is it like allocating the memory by default for every devices at boot
time just in case a driver will probe it at some time or registering
every IRQs at boot time just in case a driver will use it...

That's just pointless. We are wasting resources for nothing and thus
potentially power and that will not help the Earth getting any better.

Regards,
Benoit

