Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2H2Skn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:40:43 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:7756 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2H2Skl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:40:41 -0400
Date: Wed, 29 Aug 2012 20:40:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Message-ID: <20120829204031.648a73e1@endymion.delvare>
In-Reply-To: <20120823162852.29243e9c@feng-i7>
References: <4401854.hVfHzgeqjT@ws-stein>
	<3514180.RWySLZuOJm@ws-stein>
	<20120822160439.62c619bf@feng-i7>
	<24029861.U7thTLuEmC@ws-stein>
	<20120823162852.29243e9c@feng-i7>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Sorry for joining the discussion a little late, I was on vacation.

On Thu, 23 Aug 2012 16:28:52 +0800, Feng Tang wrote:
> On Wed, 22 Aug 2012 11:17:51 +0200
> Alexander Stein <alexander.stein@systec-electronic.com> wrote:
> > Am Mittwoch, 22. August 2012, 16:04:39 schrieb Feng Tang:
> > > > Why use a fixed one? Give the driver (and maybe every i2c bus driver) a parameter which sets the base bus number it should use.
> > > > E.g. i2c-eg20t.base-bus-num=2 so it will register the bus numbers starting from 2. If this parameter is unset. It would use the first free one, thus simply using i2c_add_adapter.

Looks like what media and sound drivers are/were doing to assign fixed
numbers to their devices. But my understanding is that this is a legacy
thing and nobody should need to use that any longer. Adding this to all
or even some i2c bus drivers looks like the wrong example to follow. If
your system has more than one device supported by the driver, it
doesn't even reliably guarantee fixed I2C bus numbers (especially if
some can be hot-plugged.)

> > > The reason we need a fixed number is it is easier for platform code
> > > which needs to register dozens of i2c devices to different controllers
> > > with i2c_register_board_info, and they need provide a bus number for
> > > each i2c device, this _binding_ info is not detectable but have to
> > > be fixed.

Whenever you call i2c_register_board_info(), every I2C bus number
referenced in the I2C device list passed as a parameter is reserved for
static I2C bus numbers, dynamic I2C bus numbers will never overlap.

So in the quoted example, if i2c-isch is able to dynamically pick I2C
bus number 0 while i2c-eg20t want it statically, it means that either
no device was declared on bus 0 with i2c_register_board_info(), or
i2c_register_board_info() was called too late in the game.

Note that there was an assumption at the time the code was written,
that there was no need or reason to reserve a static I2C bus number if
no slave device was declared on said I2C bus. I never much liked it but
it never caused problems so far. This means that either:
* you call i2c_register_board_info() to register your slave I2C devices
  and all the affected I2C bus drivers call i2c_add_numbered_adapter();
  or
* you don't call i2c_register_board_info() and all I2C bus drivers call
  i2c_add_adapter().
You can't mix, i.e. if you don't register any slave device on a bus but
the bus driver still calls i2c_add_numbered_adapter(), it may fail.

If this is a problem now on some systems, it should be easy enough to
work around by adding a specific function to reserve an I2C bus number
for static allocation, even without declaring any slave device on it.
This function would be called at the same time
i2c_register_board_info() typically is.

> > Yes, I'm aware of that. With "Why use a fixed one?" I meant why hard-code it into the driver. I should be changeable.
> > Because this is/was not possible in general to use i2c_register_board_info, so we used an echo to /sys/bus/i2c/devices/i2c-0/new_device or /sys/bus/i2c/devices/i2c-1/new_device.

Please elaborate on "this is/was not possible in general to use
i2c_register_board_info." You are supposed to call it as part of your
platform setup, so if it is not possible for you, whatever the problem
is needs to be addressed.

> Yeah, our EG20T kernel used to use the same "echo /sys/bus/i2c/devices/i2c-x/new_device"
> way, but we found out it is not convenient for:
> 1. needs extra user space script, why not make it just work in kernel after
> boot? We have several i2c devices like touchscreen/radio which we wants them
> just work without depending user space action.

It should indeed be handled all in kernel space, using
i2c_register_board_info().

> 2. The i2c bus number is not fixed, which make the user space script even
> harder, as that number depends whether we compile into kernel all the i2c
> controllers (eg20t and isch) and whether these driver are compiled as
> modules and their loading order.

You can always look-up the right I2C bus number based on its name,
assuming your driver properly names them. There is some code doing that
at:
http://www.lm-sensors.org/browser/i2c-tools/trunk/tools/i2cbusses.c#L297

Ideally this code should move to libi2c and/or i2cdetect should offer
an interface to it, so it can easily be called from custom tools and
scripts.

> Thus we come out with this fixed bus number registering.
> 
> As I said before, either your module parameter "base_bus_num" solution
> or my fixed bus number offset are ok to me. Will you cook a patch?

I think the real problem you have here is that your platform setup code
doesn't (or is not able to) allocate the bus IDs globally. It really
should. If you have an embedded system using both i2c-eg20t and
i2c-isch, the platform setup code should decide upfront who gets what
I2C bus IDs, otherwise it's impossible to declare slave devices on
these I2C buses. And these bus drivers should have a way to look-up
that decision and ask for the proper bus numbers.

At the moment it seems that i2c-ge20t assumes it always gets i2c-0 (and
sometimes i2c-1 too) for itself. This is wrong. The actual bus numbers
should come from a device tree of some sort. If you look at other i2c
bus drivers for other embedded platforms (for example i2c-pxa), you'll
see they do exactly that, i.e. the I2C bus number is part of device
platform data (often the platform device ID but it could be anything
else), it's not hard-coded in the driver. It may be a little more
difficult to get right for a PCI driver like i2c-eg20t, but you'll have
to find a way. Relying on boot parameters to get things to work is just
too fragile.

-- 
Jean Delvare
