Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3AGNqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:46:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3AGNqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:46:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform to ARC UART
Date: Mon, 7 Jan 2013 13:46:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de> <50EAC955.6010109@synopsys.com>
In-Reply-To: <50EAC955.6010109@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301071346.01620.arnd@arndb.de>
X-Provags-ID: V02:K0:rQ6SjChddBYdMk66cpj64u0nTK6vECo0gZuw2eW1UZQ
 XzXstC0rbXSTxnthmr65+DPmya9HAYuqkSnZFchFE+ynqdWqvU
 yukS69jzsSBfPCQmVQMNR3AAbTKLwvqAdAm5lG1hl5CNo/608m
 ZPs2VjWMvxULHLm+wnc668WJ5F3WzQEz0Ce6TAB3G9ksJketZM
 1wR3JQRtRYptU/7I/RdS16AoiUmswmNuqMPiFEvL+F4vFGrBEo
 hg81mTgaq57QdC4UTTPIV9+wrgM+gT/7pzFQ7Vx320iEAM7Vkk
 MfLR7HbCXvxN8AhLE9B+oanvVMefd5qfzQJLTr0Z2vgB4JZuCU
 0NTV5VaUpS6/K9CF8HW4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2013, Vineet Gupta wrote:
> On Wednesday 07 November 2012 07:46 PM, Arnd Bergmann wrote:
> > On Wednesday 07 November 2012, Vineet Gupta wrote:
>
> (1) Although I don't need the container "fpga" I'm forced to - because
> of_platform_populate( ) -> of_match_node( ) expects the @match arg to be NOT NULL.
> So we pass of_default_bus_match_table and have the compat string "simple-bus" in
> the container. Per [1] it seemed it was possible to add the serial device directly
> w/o the container.

You could in theory make the serial port device itself be compatible to 
somthing that is being probed by of_platform_populate, but putting it
under a bus is the preferred way. Usually each system has at least one
bus that devices are connected to and I would recommend to represent all
buses in the device tree like they are in hardware.
 
> (2) I need the following OF_DEV_AUXDATA to be able to "name" the device correctly
> so that the registered driver [4] can bind with device. How do I match the driver
> and devicetree node w/o this glue - it seems compatible="<manuf>,<model>" is not
> enough. This also requires the uart base address to be specified (otherwise
> of_dev_lookup() fails to identify the auxdata) which IMHO defeats the purpose of
> devicetree in first place.
> b
> static struct of_dev_auxdata arcuart_auxdata_lookup[] __initdata = {
> 	OF_DEV_AUXDATA("snps,arc-uart", UART0_BASE, "arc-uart", arc_uart_info),
> 	{}
> };

It should be enough to fill the drv->of_match_table member of the
platform_driver with the match table.

> (3) After above, driver's probe routine is getting called with platform_device->id
> = -1 and it seems of_device_add() is doing that purposely. How do I handle that.

What do you need the id for?

> (4) Is above standalone "interrupts" string OK, or do I have to explicitly
> instantiate the in-core intc as well. Since it is integral part of cpu, I really
> don't need any support code to explicitly instantiate it. Also it is not accessed
> via mem map - but special ARC instructions in aux address space of cpu.

Interrupts are a little tricky. You need to create a bindind for your interrupt
controller first and make the irqchip driver use irq domains in order for the
irq description in the device tree to be mapped into a linux-internal irq number.

In the simple case where you only have one irqchip in the system, you can use
a "legacy" irq domain that simply translates the numbers 1:1. In some cases,
it does make sense though (even with the legacy domain) to include additional
flags in the device tree irq descriptor, e.g. the irq polarity and
edge/level/message indication. Please read up on these and ask again if you have
more questions.

	Arnd
