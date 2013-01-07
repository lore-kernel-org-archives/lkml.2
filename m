Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3AGOFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:05:07 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:44027 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3AGOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:05:05 -0500
Message-ID: <50EAD5F3.7030204@synopsys.com>
Date: Mon, 7 Jan 2013 19:34:35 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform
 to ARC UART
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de> <50EAC955.6010109@synopsys.com> <201301071346.01620.arnd@arndb.de>
In-Reply-To: <201301071346.01620.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2013 07:16 PM, Arnd Bergmann wrote:
> On Monday 07 January 2013, Vineet Gupta wrote:
>> On Wednesday 07 November 2012 07:46 PM, Arnd Bergmann wrote:
>>> On Wednesday 07 November 2012, Vineet Gupta wrote:
>> (1) Although I don't need the container "fpga" I'm forced to - because
>> of_platform_populate( ) -> of_match_node( ) expects the @match arg to be NOT NULL.
>> So we pass of_default_bus_match_table and have the compat string "simple-bus" in
>> the container. Per [1] it seemed it was possible to add the serial device directly
>> w/o the container.
> You could in theory make the serial port device itself be compatible to 
> somthing that is being probed by of_platform_populate, but putting it
> under a bus is the preferred way. Usually each system has at least one
> bus that devices are connected to and I would recommend to represent all
> buses in the device tree like they are in hardware.

OK.

>> (2) I need the following OF_DEV_AUXDATA to be able to "name" the device correctly
>> so that the registered driver [4] can bind with device. How do I match the driver
>> and devicetree node w/o this glue - it seems compatible="<manuf>,<model>" is not
>> enough. This also requires the uart base address to be specified (otherwise
>> of_dev_lookup() fails to identify the auxdata) which IMHO defeats the purpose of
>> devicetree in first place.
>> b
>> static struct of_dev_auxdata arcuart_auxdata_lookup[] __initdata = {
>> 	OF_DEV_AUXDATA("snps,arc-uart", UART0_BASE, "arc-uart", arc_uart_info),
>> 	{}
>> };
> It should be enough to fill the drv->of_match_table member of the
> platform_driver with the match table.

Not sure if I understand. My concern is the #define UART0_BASE (=0xc0fc1000) which
needs to be defined in code despite that value being present in the device tree.
And this is needed so that framework could match the device against the driver. I
would have thought that some device property (in device tree) could enable the
matching with Linux name (actually DRIVER_NAME defined in the uart driver).  Am I
missing something ?

>> (3) After above, driver's probe routine is getting called with platform_device->id
>> = -1 and it seems of_device_add() is doing that purposely. How do I handle that.
> What do you need the id for?

In case of multiple instances of UART, driver uses this value to index into struct
arc_uart_port [ ]

struct arc_uart_port {
    struct uart_port port;
    unsigned long baud;
    int is_emulated;
};

static struct arc_uart_port arc_uart_ports[CONFIG_SERIAL_ARC_NR_PORTS];

arc_serial_probe(struct platform_device *pdev)
    uart = &arc_uart_ports[pdev->id];
    arc_uart_init_one(pdev, ..)
          if (pdev->id < 0 ...)
                  return -ENOENT;
 
Although the current driver is flawed in that it checks for -ve value after
already indexing into the array :-(
I'll send a patch to serial list to fix that.

>> (4) Is above standalone "interrupts" string OK, or do I have to explicitly
>> instantiate the in-core intc as well. Since it is integral part of cpu, I really
>> don't need any support code to explicitly instantiate it. Also it is not accessed
>> via mem map - but special ARC instructions in aux address space of cpu.
> Interrupts are a little tricky. You need to create a bindind for your interrupt
> controller first and make the irqchip driver use irq domains in order for the
> irq description in the device tree to be mapped into a linux-internal irq number.
>
> In the simple case where you only have one irqchip in the system, you can use
> a "legacy" irq domain that simply translates the numbers 1:1. In some cases,
> it does make sense though (even with the legacy domain) to include additional
> flags in the device tree irq descriptor, e.g. the irq polarity and
> edge/level/message indication. Please read up on these and ask again if you have
> more questions.

Will do.

Thx,
-Vineet


>
> 	Arnd

