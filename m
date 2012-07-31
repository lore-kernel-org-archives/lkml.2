Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2GaM4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:56:20 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47885 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab2GaM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAMQu2gxXX+4gtKVnAMMK4qr9ihJuP-OwjOYgr=6VrGZ2DWSf2A@mail.gmail.com>
References: <CAKdam54gXixs4F-a07ajj9GNMth46d4NTdoUL3GokzvjuWaGyg@mail.gmail.com>
	<CAC83ZvKnOw+UBOWYtt294k-5Xk8S6Gy1pChSF7aXGmGjLGSeCA@mail.gmail.com>
	<CAKdam56QEXY55SYC7YND4BP=tQmiyAa=avVCADTj3Ym6X9cCvg@mail.gmail.com>
	<87fw89gf4w.fsf@ti.com>
	<CAKdam57xtXnKAgvneqATSTr0ng978T5HbkTB0T3sYp96N=Qfww@mail.gmail.com>
	<20120731065224.GE6004@arwen.pp.htv.fi>
	<CAMQu2gxXX+4gtKVnAMMK4qr9ihJuP-OwjOYgr=6VrGZ2DWSf2A@mail.gmail.com>
Date: Tue, 31 Jul 2012 18:26:11 +0530
Message-ID: <CAKdam55cixHXzEsOQ-1QYr6k-i6Ge1UpULF8jgS5Nq47Ax03rQ@mail.gmail.com>
Subject: Re: [GPIO] Crashed when not using
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: balbi@ti.com, Kevin Hilman <khilman@ti.com>,
        "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
        lo <linux-omap@vger.kernel.org>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Tue, Jul 31, 2012 at 6:02 PM, Shilimkar, Santosh
<santosh.shilimkar@ti.com> wrote:
> On Tue, Jul 31, 2012 at 8:52 AM, Felipe Balbi <balbi@ti.com> wrote:
>>
>> Hi,
>>
>> On Tue, Jul 31, 2012 at 10:23:16AM +0530, Poddar, Sourav wrote:
>> > >>>> The device tree data for acquiring the above GPIO interrupt line
>> > >>>> looks
>> > >>>> like this.
>> > >>>>
>> > >>>> +++ linux-omap-storage/arch/arm/boot/dts/omap5-evm.dts  2012-07-30
>> > >>>> 14:11:08.931694001 +0530
>> > >>>> @@ -42,7 +42,8 @@
>> > >>>>         tsl2771@39 {
>> > >>>>                 compatible = "taos,tsl2771";
>> > >>>>                 reg = <0x39>;
>> > >>>> +                interrupt-parent = <&gpio5>;
>> > >>>> +                interrupts = <21>; /* gpio line 149 */
>> > >>>>         };
>> > >>>>  };
>> > >>>>
>> > >>>> Note: using "gpio_request_one" in the driver solves the issue.
>> > >>>> Is using this api in the driver required?
>> > >>>> Any pointer on the above crash?
>> > >>>
>> > >> Hi Tarun,
>> > >>> Any user/client driver of GPIO is supposed to go through
>> > >>> gpio_request() API so that module clock
>> > >>> is enabled correctly. Overriding of APIs would put the power
>> > >>> management state machine in jeopardy.
>> > >>> --
>> > >> I tried putting "pm_runtime_get_sync" in gpio_irq_type api where the
>> > >> kernel
>> > >> is crashing and the crash is no longer observed. So indeed, its about
>> > >> enabling clocks.
>> > >>
>> > >> One doubt: Can't we put runtime apis in "gpio_irq_type" and eliminate
>> > >> the use of
>> > >> "gpio_request_one"??
>> > >
>> > > No.
>> > >
>> > > You must use the GPIO requiest/free APIs to tell the GPIO core that
>> > > the GPIO line is in use.
>> > >
>> > Thanks for this confirmation.
>> > > Why do you want to avoid using gpio_request/gpio_free?
>> > >
>> > I was assuming that DT based gpio IRQ registration will automatically
>> > take care of
>> > the above APIs. But since that is not the case(as mentioned by
>> > santosh),  we need to use the
>> > gpio_request/free apis.
>>
>> Hang on for a while, let's try to get to the bottom of this debate first
>> ;-)
>>
>> We have a canonical way of passing IRQ numbers to drivers through DT and
>> that is the "interrupts" attribute. It shouldn't matter if that IRQ pin
>> is connected to a real IRQ line or through a GPIO controller. In both
>> cases we should use the "interrupts" attribute.
>>
>> If DT core doesn't allocate the GPIO for us then how does this work:
>>
>> (omap4-sdp.dts)
>>
>> 127 &mcspi1 {
>> 128         eth@0 {
>> 129                 compatible = "ks8851";
>> 130                 spi-max-frequency = <24000000>;
>> 131                 reg = <0>;
>> 132                 interrupt-parent = <&gpio2>;
>> 133                 interrupts = <2>; /* gpio line 34 */
>> 134                 vdd-supply = <&vdd_eth>;
>> 135         };
>> 136 };
>>
>>
>> There's no gpio request on the driver:
>>
>> $ git grep -e gpio_request drivers/net/ethernet/micrel/ks8851.c
>> $
>>
>> Since Benoit was the one who added that to the dts file (commit
>> e7c64db9), I assume he tested his patch before posting, so again I ask -
>> How does that work and why doesn't this work for Sourav's tsl2771
>> controller ?
>>
>> This is either a regression on drivers/of, or commit e7c64db9 is also
>> broken...
>>
>> Benoit, do you know how should this work ?
>>
> I had a discussion with Benoit on this. In fact there is a way to actually
> trigger the GPIO request.
>
>> 132                 interrupt-parent = <&gpio2>;
>> 133                 interrupts = <2>; /* gpio line 34 */
>
> As above you can see, GPIO2 bank and 2nd line.
> And then it will make use of gpio_irq chip properties
> to probe the GPIO line.
>
> Saurabh can try this out for his use case.
>
I am using the above properties only and seeing the issue.
~Sourav
> Regards
> Santosh
