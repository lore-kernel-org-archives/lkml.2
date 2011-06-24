Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1FXDwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 23:52:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37196 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1FXDwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 23:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CyK4fQt/hFfhTihVCaYomoC4c5DhQlw1UcdPPDsxV8Miu6knQgzcnizcaqHDdHV1hF
         HZruifKiKYd8M8IRN77I7LfwVTh6I7qLccNGrEf0U4cS/+klWUVtz7cIu/C5YNJ1jxR0
         FAvw5LxwVhQN1n+boxpqKL4V7PRMHCFWJe1DA=
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04992C07E5@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF04992C067D@HQMAIL01.nvidia.com>
 <BANLkTi==jWGxbiW4QZ7SSfAdyShhEgvMig@mail.gmail.com> <74CDBE0F657A3D45AFBB94109FB122FF04992C07E5@HQMAIL01.nvidia.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 23 Jun 2011 23:51:51 -0400
Message-ID: <BANLkTi=kZAww_t6RrxYaAnYBRUUA3e2yLg@mail.gmail.com>
Subject: Re: More pinmux feedback, and GPIO vs. pinmux interaction
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 15:12, Stephen Warren wrote:
> Linus Walleij wrote at Thursday, June 16, 2011 9:07 AM:
>> On Wed, Jun 15, 2011 at 11:48 PM, Stephen Warren wrote:
>> > Some more thoughts on pinmux:

can you guys start cc-ing uclinux-dist-devel@blackfin.uclinux.org on
future pinmux discussions ?  we already have a thin layer in the
Blackfin tree for handling pin muxing that has served us well for a
few years, so we want to keep tabs on where this is going.  i just
happened to stumble across this today.

arch/blackfin/include/asm/portmux.h:
peripheral_request()
peripheral_request_list()
peripheral_free()
peripheral_free_list()

this lets you pass in an array of pins and it returns success only if
all were available.  we find the array request method gets used the
vast majority of the time, so any proposed API should include that.

> Just one note on the extra stuff for the future:
>
> * Tegra has say 100 muxable pins.
> * GPIO vs. special function is selectable per pin.
> * Muxing of which special function (and some other features, such as
> pullup/down) is only at a granularity of "group of pins".
> * Some other pin features (such as slew rate, drive strength) is also
> only at a granularity of "group of pins" **but** the groups are defined
> differently for these features than for muxing.
>
> I figure the general model is:
>
> * N pins, each perhaps with some per-pin controls.
> * M groups of pins, each allowing muxing, and possibly other controls
> and also an arbitrary number of:
> * P groups of pins, allowing various other controls

some Blackfin parts have ~160 pins, but usually they only have like 16
to 64.  we've got pretty much similar functionality as you describe
for Tegra.

we also handle pins that can only be used in peripheral mode.  this
allows us to write code that requests UART pins without having to know
whether the pin is muxed or dedicated or somewhere in between.

>> >> diff --git a/drivers/Makefile b/drivers/Makefile
>> >>...
>> >> +# GPIO must come after pinctrl as gpios may need to mux pins etc
>> >> +obj-y                                += pinctrl/
>> >
>> > Don't those patches imply that the GPIO controller code is calling into
>> > the pinmux code to perform muxing, not the other way around?
>>
>> Yes.
>>
>> Grant does not seem to like the idea of the gpio subsystem
>> meddeling with all this stuff anyway, so I intend to take all that
>> into pinctrl, and then gpio only deal with, well GPIO. Setting
>> bits quickly and such.

but there has to be resource management between the two subsystems
somewhere.  on the Blackfin side, if you request a pin as a GPIO using
the GPIO api, and then try to request it in peripheral mode, you get
EBUSY back.  you cant have the two blocks stepping on each others
toes.

> In particular, the kind of checks Tegra would need are (although exact
> details of controller names etc, may be wrong):
>
> * I2C controller 0 can be routed out to two different sets of pins. Only
> One set of pins must be connected to the I2C controller at once.

some Blackfin parts have this to ease the conflicts between devices
that customers want.  if UART0 and SPI0 share PF0, PF1, and PF2,
sometimes UART0 can be routed to PG3 and PG4 so that SPI0 can be used.

atm we've made this a Kconfig option.  obviously that wont fly in the
"build one image to run on all platforms", but that isnt a problem for
Blackfin systems today, and customers have been OK with this minor
limitation.

> Internally, each pinmux driver would need a lookup table that maps from
> the tuple (pin, function) to "register value to program into HW", since
> selecting a particular function on pin A might be a different register
> value than selecting that same logical function on pin B.
>
> An example might be:
>
> pin  function   register_value
> A1   UART 0 RX  0
> A1   I2C 0 SDA  1
> A2   UART 0 RX  5
> ...
>
> If pinmux drivers exported this data model, then the pinmux core could
> probably implement some of the error-checking I talked about above, such
> as ensuring that a particular logical function was not activated on
> multiple pins/groups at once.

we implemented this on the Blackfin side by encoding things into the
pin data.  but that's because we had enough space in u16 to cover all
of our parts so far.

for example, the PA1 pin can act as GPIO, or as a timer pin, or as
part of our high speed peripheral SPORT.
#define P_SPORT2_DTSEC (P_DEFINED | P_IDENT(GPIO_PA1) | P_FUNCT(0))
#define P_TMR4 (P_DEFINED | P_IDENT(GPIO_PA1) | P_FUNCT(1))
when someone does peripheral_request(P_TMR4), the code first reserves
itself with the GPIO core, and then configures the pinmux logic to set
this pin as "function 1" (it's a 2 bit field).

we also have pin grouping logic implemented for the parts which dont
have per-pin muxing so you cant request different pins in the same
group for the same mode.
-mike
