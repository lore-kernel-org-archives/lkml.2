Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0IAS42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:56:28 -0400
Received: from www.tglx.de ([62.245.132.106]:38290 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0IAS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:56:27 -0400
Date: Wed, 1 Sep 2010 20:56:20 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Armin Steinhoff <armin@steinhoff.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UIO and Fedora 13  (kernel 33.6)
Message-ID: <20100901185620.GA2514@local>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
 <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com>
 <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com>
 <4C7B8CA6.4010504@steinhoff.de>
 <20100830162435.GB2566@local>
 <4C7CA7E4.8010005@steinhoff.de>
 <20100831103523.GA2598@local>
 <4C7E015B.1010506@steinhoff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7E015B.1010506@steinhoff.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 09:31:39AM +0200, Armin Steinhoff wrote:
> 
> Small correction ... I don't mean the "initial platform_data" but
> the initial resource data of the platform driver.
> 
> --Armin
> 
> 
>   Hans J. Koch wrote:
> >After a successfull uio_register_device() there is both a /dev/uioX
> >and a directory /sys/class/uio/uioX/.
> 
> In the attachment is an updated version of uio_jand.
> 
> The module uio_jand.ko can be inserted and removed,  no messages
> visible by dmesg, no kernel oops, no dev/uio*  and no class entries
> available.
> 
> There are only entries of uio_jand in /sys/module,
> /sys/bus/platform/drivers and /sys/uio/holders ... I'm really
> confused =:-/
> 
> It's completely unclear how to write the initial platform_data of
> the platform device in the example uio_smx.c :
> 
>      regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>      if (!regs) {
>          dev_err(&dev->dev, "No memory resource specified\n");
>          goto out_free;
> 
> Same issue in uio_platform_genirq ...

You only seem to be working on x86 ... ;-)

If you register a platform driver, you also need to register a platform
device with the same name, otherwise your driver's probe() function will
never be called. In struct platform_device you can also specify an array
of resources (e.g. memory, interrupts) which can be queried by the driver
in the way you quoted above.

The ARM architecture (for example) uses a specific board support file for
each board that sets up (among other things) these platform devices.
(See arch/arm/mach-xxx/board-yyy.c for examples)

Other archs like PowerPC use the OpenFirmware/DeviceTree interface to set up
such board specific things. On x86, there's no real solution yet since all
such boards used to be more or less "PC compatible". Platform devices exist
only in low level arch code, all special devices (or those added by the user)
announce themselves as PCI devices, are controllable from userspace
(e.g. I2C, SPI) or have another interface that allows auto probing (e.g. USB).

The first version of your driver did the right thing by using
platform_device_register_simple() and driver_register(). That avoids the
need for a separate file which calls platform_device_register().

So, go back to your first version, and fix the real bugs.

Thanks,
Hans

