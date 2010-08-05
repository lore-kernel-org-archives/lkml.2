Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab0HECcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:32:19 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56028 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0HECcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T3r5KdOHzQPxEYa/7HZ2POYmShhD9i/rvhh59kqAe1cqzrQFX0xDS6/0Aozspix11k
         uf1nHk9bsPnedhIZaVLrvEiVYqe8hS9gp8uw1tG7L28e5k07SfWnN733XN5HuVVh0nGy
         fs54Zqk22KuYjL3PaYkR3opkTL00qhC/DPBWM=
MIME-Version: 1.0
In-Reply-To: <4C59E654.1090403@codeaurora.org>
References: <4C59E654.1090403@codeaurora.org>
Date: Thu, 5 Aug 2010 11:32:16 +0900
Message-ID: <AANLkTimkMy6_201XNGb41e7LivkvVHMkFZWVoA-7UmBo@mail.gmail.com>
Subject: Re: [PATCH] platform: Facilitate the creation of pseduo-platform 
	busses
From: Magnus Damm <magnus.damm@gmail.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alan@lxorguk.ukuu.org.uk,
        zt.tmzt@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 7:14 AM, Patrick Pannuto <ppannuto@codeaurora.org> wrote:
> Inspiration for this comes from:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg31161.html
>
> RFC: http://lkml.org/lkml/2010/8/3/496
> Patch is unchanged from the RFC. Reviews seemed generally positive
> and it seemed this was desired functionality.

Thanks for your patch, it's really nice to see work done in this area!
I'd like to see something like this merged in the not so distant
future. At this point I'm not so concerned about the details, so I'll
restrict myself to this:

> /drivers/my_driver.c
>        static struct platform_driver my_driver = {
>                .driver = {
>                        .name   = "my-driver",
>                        .owner  = THIS_MODULE,
>                        .bus    = &my_bus_type,
>                },
>        };

I would really prefer not to have the bus type in the here. I
understand it's needed at this point, but I wonder if it's possible to
adjust the device<->driver matching for platform devices to allow any
type of pseudo-platform bus_type.

The reason why I'd like to avoid having the bus type in the driver is
that I'd like to reuse the platform driver across multiple
architectures and buses. For instance, on the SH architecture and
SH-Mobile ARM we have SoCs with SCIF hardware blocks driven by the
sh-sci.c serial driver. The sh-sci.c platform driver supports a wide
range of different SCI(F)(A)(B) hardware blocks, and on any given SoC
there is a mix of SCIF blocks spread out on different buses.

At this point our SH platform drivers are unaware where their driver
instanced are located on the SoC. The I/O address and IRQs are
assigned via struct resource and clocks are managed through clkdev. I
believe that adding the bus type in the driver will violate this
abstraction and make it more difficult to just instantiate a driver
somewhere on the SoC.

> /somewhere/my_device.c
>        static struct platform_device my_device = {
>                .name           = "my-device",
>                .id             = -1,
>                .dev.bus        = &my_bus_type,
>                .dev.parent     = &sub_bus_1.dev,
>        };

This I don't mind at all. Actually, this is the place where the
topology should be defined IMO.

Cheers,

/ magnus
