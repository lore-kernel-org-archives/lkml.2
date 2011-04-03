Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1DCOrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 10:47:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39614 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1DCOrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 10:47:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110403140750.GB5670@pulham.picochip.com>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com> <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
 <20110403120344.GA1540@oksana.dev.rtsoft.ru> <20110403140750.GB5670@pulham.picochip.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 3 Apr 2011 08:47:25 -0600
X-Google-Sender-Auth: q-5x7M5D5RwPhuYT6kT6OgUXPio
Message-ID: <BANLkTikoODn75U=DKiqT9xV6kVsjr5T2fA@mail.gmail.com>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
To: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 3, 2011 at 8:07 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> Hi Anton,
>
> On Sun, Apr 03, 2011 at 04:03:44PM +0400, Anton Vorontsov wrote:
>> > > I'm not
>> > > hugely thrilled with the current method that the driver uses to define
>> > > the register locations (using named resources).  My instinct would be
>> > > to use a single register resource region with offsets for each
>> > > register type defined from the base of it, but Anton can probably fill
>> > > us in on the reason that approach was used.
>>
>> Well, I did it that way because you don't have to pass the offsets via
>> platform data (you don't need platform data most of the time, i.e. if
>> you use dynamic bases).
>
> Well I'm happy to give it a go for some more complex chips with multiple
> banks but I'm not sure how to accomplish this without platform data.

I'm rarely accused of being a fan of platform data; however, for
platform_devices the pattern is well established.  Until an viable
alternative is implemented, I don't think you need to avoid it.

> My first idea would be to have something like:
>
> struct mmio_gpio_bank {
>        unsigned int            ngpio;
>        unsigned long           set_offs;
>        unsigned long           clr_offs;
>        unsigned long           dout_offs;
>        unsigned long           din_offs;
>        unsigned long           dir_offs;
> };
>
> struct mmio_gpio_pdata {
>        size_t                  bus_width_bits;
>        int                     gpio_base;
>        unsigned int            nr_banks;
>        struct mmio_gpio_bank   banks[];
> };

As discussed earlier in the thread, you probably don't need to support
multiple banks with this driver.  Instead, create a separate device
instance for each bank.

> and have one iomem resource for the whole controller.  This allows us to
> cope with the controllers where each bank has a different number of GPIO
> pins but I'm not sure how device tree friendly it is.

Device tree is just a data structure.  About the only thing that
cannot be passed by a device tree node is callback function pointers.
Everything else can be described.  I see no worries here.

>  If there's a
> better way then please let me know and I'll give it a go, though
> at first it does need to be able to work without device tree support.
>
> Looking at some of the different IRQ demuxing schemes they seem to vary
> quite a bit so I'm not sure how to handle that in a relatively generic
> way but perhaps that can come later.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
