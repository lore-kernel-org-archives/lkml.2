Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2DJKIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:08:02 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41035 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2DJKIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:08:00 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.117.88]
In-Reply-To: <20120407031306.B24D03E1F86@localhost>
References: <CAORVsuWw1rwcsMUrSqZJCeSY_vjJDwakF27kfb6=utN8nBqvag@mail.gmail.com>
	<CAORVsuUQbtC=SF9RP2g04mN-ksE8BU40ACfZvoyGUju=LRbwqg@mail.gmail.com>
	<20120407031306.B24D03E1F86@localhost>
Date: Tue, 10 Apr 2012 12:07:59 +0200
Message-ID: <CAORVsuWVZMFpjtvNFxKWtCp4Jn2mAQiVRmWGiyqGdJCGxo4QPQ@mail.gmail.com>
Subject: Re: gpiolib: per-gpio edges count
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Sat, Apr 7, 2012 at 5:13 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, 4 Apr 2012 16:49:03 +0200, Jean Pihet <jean.pihet@newoldbits.com> wrote:
>> Hi,
>>
>> On Wed, Apr 4, 2012 at 10:53 AM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
>> > Hi Grant, Linus,
>> >
>> > I would like to know if it is possible to get the edges count on a GPIO pin.
>> > I was hoping to get it by configuring the pin as input with an edge
>> > trigger but on OMAP there is only one irq line per controller (which
>> > controls 32 pins).
>> > Btw I am using a Beaglebone with OMAP AM3358.
>>
>> I figured it out, with the help from Kevin on IRC (thx!).
>>
>> Indeed there is a per-pin IRQ count available in /proc/interrupts.
>> Sorry for the unconvenience.
>>
>> Thanks & regards,
>> Jean
>
> Great, I'm glad you got it sorted out.  For the benefit of anyone
> coming across this thread, would you mind replying with a summary of
> how you solved the problem?

Yes sure!

This summary is from the experiments on the Beaglebone board but is
applicable to all platforms due to the generic nature of the GPIO
framework ;p

The pin in use is gpio1_6, which is also known as gpmc_ad6.

First the mux must be set correctly by writing '7' to
/sys/kernel/debug/omap_mux/gpmc_ad6':

  root@beaglebone:/sys/class/gpio# cat /sys/kernel/debug/omap_mux/gpmc_ad6
  name: gpmc_ad6.gpio1_6 (0x44e10818/0x818 = 0x0037), b NA, t NA
  mode: OMAP_PIN_OUTPUT | OMAP_MUX_MODE7
  signals: gpmc_ad6 | mmc1_dat6 | NA | NA | NA | NA | NA | gpio1_6

Then the GPIO pin is exported to userspace:

  root@beaglebone:/sys/class/gpio# echo 38 > export
  root@beaglebone:/sys/class/gpio# cd gpio38
  root@beaglebone:/sys/class/gpio/gpio38# ls
  active_low  direction  edge  power  subsystem  uevent  value

The pin is then setup as a input and to generate an IRQ on the falling edge:

  root@beaglebone:/sys/class/gpio/gpio38# echo in > direction
  root@beaglebone:/sys/class/gpio/gpio38# echo falling > edge

A new entry has appeared in /proc/interrupts for the pin. The name is 'gpiolib'.
Check that everything is OK from the GPIO point of view:
  root@beaglebone:/sys/class/gpio/gpio38# cat /sys/kernel/debug/gpio
  ...
  GPIOs 32-63, gpio:
   gpio-34  (sysfs               ) in  lo
   gpio-35  (w1                  ) in  hi
   gpio-38  (sysfs               ) in  hi
   gpio-53  (beaglebone::usr0    ) out lo
  ...

After playing with the HW (connect the pin to GND a few times or
through a sensor) the IRQ count is displayed for the pin:

  root@beaglebone:/sys/class/gpio/gpio38# cat /proc/interrupts
           CPU0
  ...
  194:          0      GPIO  gpiolib
  198:         19      GPIO  gpiolib
  Err:          0

The procedure is pretty simple actually.
The only catch is to figure out the mapping between the pin in the
mux, the gpio and the IRQ subsystems. For this particular setup the HW
pin GPIO1_6 is known as gpmc_ad6 in the mux, also known as gpio38 in
GPIO and has IRQ 198 assigned.

Thanks & regards,
Jean

>
> Thanks,
> g.
>
> --
> Grant Likely, B.Sc, P.Eng.
> Secret Lab Technologies,Ltd.
