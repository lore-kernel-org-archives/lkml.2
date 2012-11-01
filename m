Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936154Ab2KAXt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:49:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43336 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2KAXtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:49:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121101220518.GE14982@arwen.pp.htv.fi>
References: <50924DA3.1060901@ti.com>
	<F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
	<20121101110418.GF410@arwen.pp.htv.fi>
	<3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
	<20121101124025.GA12489@arwen.pp.htv.fi>
	<A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
	<20121101131609.GC12489@arwen.pp.htv.fi>
	<E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
	<20121101135148.382aec00@pyramind.ukuu.org.uk>
	<9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
	<20121101220518.GE14982@arwen.pp.htv.fi>
Date: Thu, 1 Nov 2012 16:49:23 -0700
X-Google-Sender-Auth: Eo6dNp5JRAvIzHRYkGLVsE75TBw
Message-ID: <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
From: Russ Dill <Russ.Dill@ti.com>
To: balbi@ti.com
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 3:05 PM, Felipe Balbi <balbi@ti.com> wrote:
> HI,
>
> On Thu, Nov 01, 2012 at 03:59:50PM +0200, Pantelis Antoniou wrote:
>> Hi Alan,
>>
>> On Nov 1, 2012, at 3:51 PM, Alan Cox wrote:
>>
>> >> What they want, and what every user wants, is I plug this board in, and
>> >> the driver make sure everything is loaded and ready. No, the end users
>> >> don't want to see any of the implementation details of how the bitfile
>> >> is transported; the driver can handle it.
>> >
>> > That doesn't necessarily make it a bus merely some kind of hotplug
>> > enumeration of devices. That should all work properly both for devices
>> > and busses with spi and i²c as the final bits needed for it got fixed
>> > some time ago.
>> >
>> > In an ideal world you don't want to be writing custom drivers for stuff.
>> > If your cape routes an i²c serial device to the existing system i²c
>> > busses then you want to just create an instance of any existing driver on
>> > the existing i²c bus not create a whole new layer of goop.
>> >
>> > It does need to do the plumbing and resource management for the plumbing
>> > but thats not the same as being a bus.
>> >
>> > Alan
>>
>>
>> Fair enough. But there's no such thing a 'hotplug enumeration
>> construct' in Linux yet, and a bus is the closest thing to it. It does
>> take advantage of the nice way device code matches drivers and devices
>> though.
>>
>> I'm afraid that having the I2C/SPI drivers doing the detection won't
>> work.  The capes can have arbitrary I2C/SPI devices (and even more
>> weird components).  There is no way to assure for example that the I2C
>> device responding to address 'foo' in cape A is the same I2C device
>> responding to the same address in cape B.
>
> your ->detect() method should take care of that.

There isn't some magical serial number in I²C devices that a
->detect() method can read and the implementation of I²C is somewhat
flexible. One devices read may be another devices write. A detect
method that only performs reads could easily toggle a gpio that resets
the board, rewrite and eeprom, or set the printer on fire. If you
browse through various detect functions, yes, some of them key off an
ID, but a lot of them just check various registers to see if certain
bits are zero, or certain bits are one. A lot of I²C devices I've
dealt with have no good way of probing them, especially GPIO chips
(you'll notice none of the I²C GPIO expanders have detect functions)

On top of all this the detect routine does not tell you if the alert
pin is connected to some IRQ, or in the case of a GPIO expander, what
those GPIOs are connected to, etc, etc.
